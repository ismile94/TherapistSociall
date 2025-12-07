// Combine all resolvers
import { IResolvers } from '@graphql-tools/utils';
import { authResolvers } from './auth.resolver';
import { profileResolvers } from './profile.resolver';
import { feedResolvers } from './feed.resolver';
import { discoverResolvers } from './discover.resolver';
import { mapResolvers } from './map.resolver';
import { storageResolvers } from './storage.resolver';

export function createResolvers(): IResolvers {
  return {
    // Scalar resolvers
    Cursor: {
      parseValue: (value: string) => value,
      serialize: (value: string) => value,
      parseLiteral: (ast: any) => {
        if (ast.kind === 'StringValue') {
          return ast.value;
        }
        return null;
      },
    },
    DateTime: {
      parseValue: (value: string) => new Date(value),
      serialize: (value: Date | string) => {
        if (value instanceof Date) {
          return value.toISOString();
        }
        return value;
      },
      parseLiteral: (ast: any) => {
        if (ast.kind === 'StringValue') {
          return new Date(ast.value);
        }
        return null;
      },
    },
    Query: {
      ...authResolvers.Query,
      ...profileResolvers.Query,
      ...feedResolvers.Query,
      ...discoverResolvers.Query,
      ...mapResolvers.Query,
    },
    Mutation: {
      ...authResolvers.Mutation,
      ...profileResolvers.Mutation,
      ...feedResolvers.Mutation,
      ...discoverResolvers.Mutation,
      ...storageResolvers.Mutation,
    },
    // Type resolvers
    User: {
      profile: async (parent, _, { db }) => {
        // TODO: Fetch user's profile
        return null;
      },
    },
    Profile: {
      user: async (parent, _, { db }) => {
        // TODO: Fetch profile's user
        return null;
      },
    },
    Post: {
      author: async (parent, _, { db }) => {
        // TODO: Fetch post author profile
        return null;
      },
      comments: async (parent, { cursor, limit }, context) => {
        const { buildPaginationResult, parsePaginationArgs } = await import('../utils/pagination');
        const { supabase } = await import('../../config/database.config');
        
        try {
          const { limit: queryLimit, cursorData } = parsePaginationArgs({ cursor, limit });
          
          let query = supabase
            .from('comments')
            .select('*')
            .eq('post_id', parent.id)
            .order('created_at', { ascending: false })
            .order('id', { ascending: false })
            .limit(queryLimit + 1);
          
          if (cursorData?.id && cursorData.createdAt) {
            query = query.or(
              `created_at.lt.${cursorData.createdAt},and(created_at.eq.${cursorData.createdAt},id.lt.${cursorData.id})`
            );
          }
          
          const { data: comments, error } = await query;
          
          if (error) {
            console.error('Error fetching comments:', error);
            return buildPaginationResult([], 'id', false, false);
          }
          
          if (!comments || comments.length === 0) {
            return buildPaginationResult([], 'id', false, !!cursor);
          }
          
          const hasNextPage = comments.length > queryLimit;
          const items = hasNextPage ? comments.slice(0, queryLimit) : comments;
          
          const itemsWithCursor = items.map((comment: any) => ({
            ...comment,
            createdAt: comment.created_at || comment.createdAt,
          }));
          
          return buildPaginationResult(
            itemsWithCursor,
            'id',
            hasNextPage,
            !!cursor
          );
        } catch (error: any) {
          console.error('Comments resolver error:', error);
          return buildPaginationResult([], 'id', false, false);
        }
      },
    },
  };
}

