// Discover resolvers with proper cursor-based pagination
import { ResolverFn, DiscoverArgs, SearchProfilesByLocationArgs, ProfileConnection, GraphQLContext } from '../utils/types';
import { buildPaginationResult, parsePaginationArgs, getLimit, encodeCursor } from '../utils/pagination';
import { supabase } from '../../config/database.config';

export const discoverResolvers = {
  Query: {
    discover: async (
      parent: any,
      args: DiscoverArgs,
      context: GraphQLContext
    ): Promise<ProfileConnection> => {
      try {
        const { profession, city, specialties, cursor, limit } = args;
        const { limit: queryLimit, cursorData } = parsePaginationArgs({ cursor, limit });

        // Build Supabase query
        let query = supabase
          .from('profiles')
          .select('*', { count: 'exact' });

        // Apply filters
        if (profession) {
          query = query.eq('profession', profession);
        }

        if (city) {
          query = query.eq('city', city);
        }

        if (specialties && specialties.length > 0) {
          query = query.contains('specialties', specialties);
        }

        // Only show verified profiles
        query = query.eq('verified', true);

        // Apply cursor-based pagination
        // IMPORTANT: Order by a stable field (id or created_at) for consistent pagination
        query = query.order('created_at', { ascending: false })
          .order('id', { ascending: false }); // Secondary sort for stability

        // If cursor exists, get items after the cursor
        if (cursorData?.id && cursorData.createdAt) {
          // Use cursor to paginate - get profiles created before the cursor date
          // or same date but id less than cursor id (for stability)
          const cursorDate = cursorData.createdAt;
          const cursorId = cursorData.id;
          
          // Supabase PostgREST filter: created_at < cursorDate OR (created_at = cursorDate AND id < cursorId)
          query = query.or(
            `created_at.lt.${cursorDate},and(created_at.eq.${cursorDate},id.lt.${cursorId})`
          ).limit(queryLimit + 1);
        } else {
          // First page - fetch limit + 1 to check for next page
          query = query.limit(queryLimit + 1);
        }

        const { data: profiles, error, count } = await query;

        if (error) {
          console.error('Error fetching profiles:', error);
          throw new Error(`Failed to fetch profiles: ${error.message}`);
        }

        if (!profiles || profiles.length === 0) {
          return buildPaginationResult([], 'id', false, !!cursor);
        }

        // Check if we have a next page (we fetched limit + 1)
        const hasNextPage = profiles.length > queryLimit;
        const hasPreviousPage = !!cursor;

        // Remove the extra item if we fetched it
        const items = hasNextPage ? profiles.slice(0, queryLimit) : profiles;

        // Map to include createdAt for cursor encoding
        const itemsWithCursor = items.map((profile: any) => ({
          ...profile,
          createdAt: profile.created_at || profile.createdAt,
        }));

        return buildPaginationResult(
          itemsWithCursor,
          'id',
          hasNextPage,
          hasPreviousPage
        );
      } catch (error: any) {
        console.error('Discover resolver error:', error);
        throw new Error(error.message || 'Failed to discover profiles');
      }
    },

    searchProfilesByLocation: async (
      parent: any,
      args: SearchProfilesByLocationArgs,
      context: GraphQLContext
    ): Promise<ProfileConnection> => {
      try {
        const { location, radius, profession, specialties, cursor, limit } = args;
        const { limit: queryLimit, cursorData } = parsePaginationArgs({ cursor, limit });

        // Build PostGIS query for location-based search
        // Using Supabase RPC function for spatial queries
        const { data: profiles, error } = await supabase.rpc('search_profiles_by_location', {
          lat: location.latitude,
          lng: location.longitude,
          radius_km: radius,
          profession_filter: profession || null,
          specialties_filter: specialties || null,
          cursor_id: cursorData?.id || null,
          limit_count: queryLimit + 1, // Fetch one extra for hasNextPage check
        });

        if (error) {
          console.error('Error searching profiles by location:', error);
          throw new Error(`Failed to search profiles: ${error.message}`);
        }

        if (!profiles || profiles.length === 0) {
          return buildPaginationResult([], 'id', false, !!cursor);
        }

        // Check if we have a next page
        const hasNextPage = profiles.length > queryLimit;
        const hasPreviousPage = !!cursor;

        // Remove the extra item if we fetched it
        const items = hasNextPage ? profiles.slice(0, queryLimit) : profiles;

        // Map to include createdAt for cursor encoding
        const itemsWithCursor = items.map((profile: any) => ({
          ...profile,
          createdAt: profile.created_at || profile.createdAt,
        }));

        return buildPaginationResult(
          itemsWithCursor,
          'id',
          hasNextPage,
          hasPreviousPage
        );
      } catch (error: any) {
        console.error('Search profiles by location error:', error);
        throw new Error(error.message || 'Failed to search profiles by location');
      }
    },
  },
};
