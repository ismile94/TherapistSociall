// Feed resolvers with proper cursor-based pagination
import { ResolverFn, FeedArgs, PostConnection, GraphQLContext } from '../utils/types';
import { buildPaginationResult, parsePaginationArgs } from '../utils/pagination';
import { supabase } from '../../config/database.config';

export const feedResolvers = {
  Query: {
    feed: async (
      parent: any,
      args: FeedArgs,
      context: GraphQLContext
    ): Promise<PostConnection> => {
      try {
        const { cursor, limit, authorId } = args;
        const { limit: queryLimit, cursorData } = parsePaginationArgs({ cursor, limit });

        // Build Supabase query
        let query = supabase
          .from('posts')
          .select('*', { count: 'exact' });

        // Apply filters
        if (authorId) {
          query = query.eq('author_id', authorId);
        }

        // Apply cursor-based pagination
        // Order by created_at (newest first) with id as secondary sort for stability
        query = query.order('created_at', { ascending: false })
          .order('id', { ascending: false });

        // If cursor exists, get items after the cursor
        if (cursorData?.id && cursorData.createdAt) {
          // Use cursor to paginate - get posts created before the cursor date
          // or same date but id less than cursor id
          query = query.or(
            `created_at.lt.${cursorData.createdAt},and(created_at.eq.${cursorData.createdAt},id.lt.${cursorData.id})`
          ).limit(queryLimit + 1);
        } else {
          // First page
          query = query.limit(queryLimit + 1);
        }

        const { data: posts, error } = await query;

        if (error) {
          console.error('Error fetching feed:', error);
          throw new Error(`Failed to fetch feed: ${error.message}`);
        }

        if (!posts || posts.length === 0) {
          return buildPaginationResult([], 'id', false, !!cursor);
        }

        // Check if we have a next page
        const hasNextPage = posts.length > queryLimit;
        const hasPreviousPage = !!cursor;

        // Remove the extra item if we fetched it
        const items = hasNextPage ? posts.slice(0, queryLimit) : posts;

        // Map to include createdAt for cursor encoding
        const itemsWithCursor = items.map((post: any) => ({
          ...post,
          createdAt: post.created_at || post.createdAt,
        }));

        return buildPaginationResult(
          itemsWithCursor,
          'id',
          hasNextPage,
          hasPreviousPage
        );
      } catch (error: any) {
        console.error('Feed resolver error:', error);
        throw new Error(error.message || 'Failed to fetch feed');
      }
    },

    savedPosts: async (
      parent: any,
      args: { cursor?: string | null; limit?: number | null },
      context: GraphQLContext
    ): Promise<PostConnection> => {
      try {
        if (!context.user) {
          throw new Error('Authentication required');
        }

        const { cursor, limit } = args;
        const { limit: queryLimit, cursorData } = parsePaginationArgs({ cursor, limit });

        // Join saved_posts with posts table
        let query = supabase
          .from('saved_posts')
          .select(`
            posts (*)
          `)
          .eq('user_id', context.user.id)
          .order('created_at', { ascending: false })
          .limit(queryLimit + 1);

        if (cursorData?.id) {
          query = query.lt('id', cursorData.id);
        }

        const { data: savedPosts, error } = await query;

        if (error) {
          console.error('Error fetching saved posts:', error);
          throw new Error(`Failed to fetch saved posts: ${error.message}`);
        }

        if (!savedPosts || savedPosts.length === 0) {
          return buildPaginationResult([], 'id', false, !!cursor);
        }

        // Extract posts from saved_posts join
        const posts = savedPosts
          .map((sp: any) => sp.posts)
          .filter((p: any) => p !== null);

        const hasNextPage = savedPosts.length > queryLimit;
        const hasPreviousPage = !!cursor;

        const items = hasNextPage ? posts.slice(0, queryLimit) : posts;

        const itemsWithCursor = items.map((post: any) => ({
          ...post,
          createdAt: post.created_at || post.createdAt,
        }));

        return buildPaginationResult(
          itemsWithCursor,
          'id',
          hasNextPage,
          hasPreviousPage
        );
      } catch (error: any) {
        console.error('Saved posts resolver error:', error);
        throw new Error(error.message || 'Failed to fetch saved posts');
      }
    },
  },
  Mutation: {
    createPost: async (parent: any, { input }: any, context: any) => {
      // TODO: Create post
      throw new Error('Not implemented');
    },
    likePost: async (parent: any, { postId }: any, context: any) => {
      // TODO: Like post
      throw new Error('Not implemented');
    },
    unlikePost: async (parent: any, { postId }: any, context: any) => {
      // TODO: Unlike post
      throw new Error('Not implemented');
    },
  },
};
