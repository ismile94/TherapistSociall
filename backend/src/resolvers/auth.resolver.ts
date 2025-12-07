// Authentication resolvers
import { AuthService } from '../services/auth/auth.service';

export const authResolvers = {
  Query: {
    me: async (parent: any, args: any, context: any) => {
      // TODO: Get current user from context
      return null;
    },
    refreshToken: async (parent: any, args: any, context: any) => {
      // TODO: Refresh access token
      return null;
    },
  },
  Mutation: {
    signUp: async (parent: any, { input }: any, context: any) => {
      console.log('🔵 [AUTH_RESOLVER] SignUp mutation called');
      console.log('🔵 [AUTH_RESOLVER] Input received:', {
        email: input.email,
        name: input.name,
        surname: input.surname,
        profession: input.profession,
        city: input.city,
        hasPassword: !!input.password,
        hasPhone: !!input.phone,
      });
      
      try {
        console.log('🔵 [AUTH_RESOLVER] Calling AuthService.signUp...');
        const result = await AuthService.signUp(input);
        console.log('🟢 [AUTH_RESOLVER] SignUp successful');
        console.log('🟢 [AUTH_RESOLVER] Result:', {
          userId: result.user?.id,
          email: result.user?.email,
          hasAccessToken: !!result.accessToken,
          hasRefreshToken: !!result.refreshToken,
          expiresIn: result.expiresIn,
        });
        return result;
      } catch (error: any) {
        console.error('🔴 [AUTH_RESOLVER] SignUp error:', error);
        console.error('🔴 [AUTH_RESOLVER] Error message:', error.message);
        console.error('🔴 [AUTH_RESOLVER] Error stack:', error.stack);
        throw new Error(error.message || 'Sign up failed');
      }
    },
    login: async (parent: any, { input }: any, context: any) => {
      try {
        const result = await AuthService.login(input.email, input.password);
        return result;
      } catch (error: any) {
        throw new Error(error.message || 'Login failed');
      }
    },
    logout: async (parent: any, args: any, context: any) => {
      // TODO: Implement logout - invalidate refresh token
      return true;
    },
    requestVerification: async (parent: any, args: any, context: any) => {
      // TODO: Request verification
      return true;
    },
  },
};

