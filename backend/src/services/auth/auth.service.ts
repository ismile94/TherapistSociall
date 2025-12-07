// Authentication service using Supabase
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { supabase } from '../../../config/database.config';
import { config } from '../../../config/env.config';
import { MapboxGeocodingService } from '../geocoding/mapbox.service';

export interface SignUpInput {
  email: string;
  password: string;
  name: string;
  surname: string;
  profession: string;
  city: string;
  phone?: string;
}

export interface AuthPayload {
  user: any;
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
}

export class AuthService {
  /**
   * Sign up a new user
   */
  static async signUp(input: SignUpInput): Promise<AuthPayload> {
    console.log('🔵 [AUTH_SERVICE] SignUp started');
    console.log('🔵 [AUTH_SERVICE] Input:', {
      email: input.email,
      name: input.name,
      surname: input.surname,
      profession: input.profession,
      city: input.city,
      hasPassword: !!input.password,
      hasPhone: !!input.phone,
    });
    
    // Check if user already exists
    console.log('🔵 [AUTH_SERVICE] Checking if user exists...');
    const { data: existingUser, error: existingUserError } = await supabase
      .from('users')
      .select('id')
      .eq('email', input.email)
      .maybeSingle();

    // If error is not "not found" error, throw it
    if (existingUserError && existingUserError.code !== 'PGRST116') {
      console.error('🔴 [AUTH_SERVICE] Error checking existing user:', existingUserError);
      throw new Error(`Database error: ${existingUserError.message}`);
    }

    if (existingUser) {
      console.log('🔴 [AUTH_SERVICE] User already exists');
      throw new Error('User with this email already exists');
    }

    console.log('🟢 [AUTH_SERVICE] User does not exist, proceeding...');

    // Hash password
    console.log('🔵 [AUTH_SERVICE] Hashing password...');
    const passwordHash = await bcrypt.hash(input.password, 10);
    console.log('🟢 [AUTH_SERVICE] Password hashed');

    // Create user
    console.log('🔵 [AUTH_SERVICE] Creating user in database...');
    const { data: user, error: userError } = await supabase
      .from('users')
      .insert({
        email: input.email,
        password_hash: passwordHash,
        role: 'USER',
        email_verified: false,
      })
      .select()
      .single();

    if (userError) {
      console.error('🔴 [AUTH_SERVICE] Error creating user:', userError);
      throw new Error(`Failed to create user: ${userError.message}`);
    }

    if (!user) {
      console.error('🔴 [AUTH_SERVICE] No user data returned');
      throw new Error('Failed to create user: No user data returned');
    }

    console.log('🟢 [AUTH_SERVICE] User created successfully:', user.id);

    // Get city coordinates from Mapbox
    let locationWkt = null;
    if (input.city) {
      console.log('🔵 [AUTH_SERVICE] Geocoding city:', input.city);
      const geocodeResult = await MapboxGeocodingService.geocodeCity(input.city);
      if (geocodeResult) {
        // Format as PostGIS POINT WKT: "POINT(longitude latitude)"
        locationWkt = `POINT(${geocodeResult.longitude} ${geocodeResult.latitude})`;
        console.log('🟢 [AUTH_SERVICE] City geocoded:', locationWkt);
      } else {
        console.log('🟡 [AUTH_SERVICE] City geocoding failed, continuing without location');
      }
    }

    // Create profile (location will be set via RPC if coordinates available)
    console.log('🔵 [AUTH_SERVICE] Creating profile...');
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .insert({
        user_id: user.id,
        name: input.name,
        surname: input.surname,
        profession: input.profession,
        city: input.city,
        phone: input.phone || null,
        email: input.email,
        is_verified: false,
        is_public: true,
      })
      .select()
      .single();

    if (profileError) {
      console.error('🔴 [AUTH_SERVICE] Error creating profile:', profileError);
      // Rollback: delete user if profile creation fails
      console.log('🔵 [AUTH_SERVICE] Rolling back user creation...');
      await supabase.from('users').delete().eq('id', user.id);
      throw new Error(`Failed to create profile: ${profileError.message}`);
    }

    if (!profile) {
      console.error('🔴 [AUTH_SERVICE] No profile data returned');
      // Rollback: delete user if profile creation fails
      console.log('🔵 [AUTH_SERVICE] Rolling back user creation...');
      await supabase.from('users').delete().eq('id', user.id);
      throw new Error('Failed to create profile: No profile data returned');
    }

    console.log('🟢 [AUTH_SERVICE] Profile created successfully:', profile.id);

    // Update location using raw SQL if coordinates are available
    // Supabase PostgREST doesn't directly support PostGIS, so we use RPC
    if (locationWkt && profile.id) {
      try {
        // Try to update location using RPC function
        // The RPC function should be created via migration 004_add_location_rpc.sql
        const { error: locationError } = await supabase.rpc('set_profile_location', {
          p_profile_id: profile.id,
          p_location: locationWkt,
        });

        if (locationError) {
          console.warn('Could not set location, RPC function may not exist:', locationError.message);
          console.warn('Please run migration 004_add_location_rpc.sql in Supabase');
          // Location will remain null, can be updated later
        }
      } catch (error) {
        console.warn('Error setting location:', error);
        // Continue without location - can be updated later
      }
    }

    // Generate JWT tokens
    console.log('🔵 [AUTH_SERVICE] Generating JWT tokens...');
    const jwtSecret: string = String(config.jwt.secret || 'your-jwt-secret-change-in-production');
    const signOptions = {
      expiresIn: config.jwt.expiresIn || '1h',
    } as any;
    const refreshSignOptions = {
      expiresIn: config.jwt.refreshExpiresIn || '7d',
    } as any;
    
    const accessToken = jwt.sign(
      { userId: user.id, email: user.email, role: user.role },
      jwtSecret,
      signOptions
    );
    console.log('🟢 [AUTH_SERVICE] Access token generated');

    const refreshToken = jwt.sign(
      { userId: user.id },
      jwtSecret,
      refreshSignOptions
    );
    console.log('🟢 [AUTH_SERVICE] Refresh token generated');

    // Store refresh token
    console.log('🔵 [AUTH_SERVICE] Storing refresh token in database...');
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7); // 7 days

    const { error: tokenError } = await supabase.from('refresh_tokens').insert({
      user_id: user.id,
      token: refreshToken,
      expires_at: expiresAt.toISOString(),
    });

    if (tokenError) {
      console.warn('🟡 [AUTH_SERVICE] Error storing refresh token:', tokenError);
      // Don't fail signup if token storage fails, but log it
    } else {
      console.log('🟢 [AUTH_SERVICE] Refresh token stored successfully');
    }

    const result = {
      user: {
        id: user.id,
        email: user.email,
        role: user.role,
        createdAt: user.created_at,
        updatedAt: user.updated_at,
        profile: {
          id: profile.id,
          name: profile.name,
          surname: profile.surname,
          profession: profile.profession,
          city: profile.city,
        },
      },
      accessToken,
      refreshToken,
      expiresIn: 3600, // 1 hour in seconds
    };

    console.log('🟢 [AUTH_SERVICE] SignUp completed successfully');
    console.log('🟢 [AUTH_SERVICE] Returning result with userId:', result.user.id);
    
    return result;
  }

  /**
   * Login user
   */
  static async login(email: string, password: string): Promise<AuthPayload> {
    // Find user
    const { data: user, error: userError } = await supabase
      .from('users')
      .select('*')
      .eq('email', email)
      .maybeSingle();

    if (userError) {
      console.error('Error finding user:', userError);
      throw new Error('Invalid email or password');
    }

    if (!user) {
      throw new Error('Invalid email or password');
    }

    // Verify password
    const isValidPassword = await bcrypt.compare(password, user.password_hash);
    if (!isValidPassword) {
      throw new Error('Invalid email or password');
    }

    // Get user profile
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('*')
      .eq('user_id', user.id)
      .maybeSingle();

    if (profileError) {
      console.warn('Error fetching profile:', profileError);
      // Continue without profile - user can update it later
    }

    // Generate JWT tokens
    const jwtSecret: string = String(config.jwt.secret || 'your-jwt-secret-change-in-production');
    const signOptions = {
      expiresIn: config.jwt.expiresIn || '1h',
    } as any;
    const refreshSignOptions = {
      expiresIn: config.jwt.refreshExpiresIn || '7d',
    } as any;
    
    const accessToken = jwt.sign(
      { userId: user.id, email: user.email, role: user.role },
      jwtSecret,
      signOptions
    );

    const refreshToken = jwt.sign(
      { userId: user.id },
      jwtSecret,
      refreshSignOptions
    );

    // Store refresh token
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7); // 7 days

    const { error: tokenError } = await supabase.from('refresh_tokens').insert({
      user_id: user.id,
      token: refreshToken,
      expires_at: expiresAt.toISOString(),
    });

    if (tokenError) {
      console.warn('Error storing refresh token:', tokenError);
      // Don't fail login if token storage fails, but log it
    }

    return {
      user: {
        id: user.id,
        email: user.email,
        role: user.role,
        createdAt: user.created_at,
        updatedAt: user.updated_at,
        profile: profile ? {
          id: profile.id,
          name: profile.name,
          surname: profile.surname,
          profession: profile.profession,
          city: profile.city,
        } : null,
      },
      accessToken,
      refreshToken,
      expiresIn: 3600, // 1 hour in seconds
    };
  }
}

