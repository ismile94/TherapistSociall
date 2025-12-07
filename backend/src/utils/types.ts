/**
 * TypeScript types for GraphQL resolvers
 * Provides type safety for resolver arguments and return types
 */

import { GraphQLResolveInfo } from 'graphql';
import { PaginationResult, PaginationArgs } from './pagination';

// ============================================================================
// GraphQL Context Type
// ============================================================================

export interface GraphQLContext {
  user: {
    id: string;
    email: string;
    role: string;
  } | null;
  db?: any; // Supabase client or database connection
}

// ============================================================================
// Resolver Argument Types
// ============================================================================

export interface DiscoverArgs extends PaginationArgs {
  profession?: string | null;
  city?: string | null;
  specialties?: string[] | null;
}

export interface SearchProfilesByLocationArgs extends PaginationArgs {
  location: {
    latitude: number;
    longitude: number;
  };
  radius: number;
  profession?: string | null;
  specialties?: string[] | null;
}

export interface FeedArgs extends PaginationArgs {
  authorId?: string | null;
}

// ============================================================================
// Resolver Return Types
// ============================================================================

export type ProfileConnection = PaginationResult<any>; // Replace 'any' with your Profile type
export type PostConnection = PaginationResult<any>; // Replace 'any' with your Post type
export type CommentConnection = PaginationResult<any>; // Replace 'any' with your Comment type

// ============================================================================
// Resolver Function Type
// ============================================================================

export type ResolverFn<TSource = any, TArgs = any, TContext = GraphQLContext, TReturn = any> = (
  parent: TSource,
  args: TArgs,
  context: TContext,
  info: GraphQLResolveInfo
) => Promise<TReturn> | TReturn;

// ============================================================================
// Database Entity Types (Examples - adjust to your schema)
// ============================================================================

export interface Profile {
  id: string;
  user_id: string;
  profession?: string | null;
  city?: string | null;
  specialties?: string[] | null;
  verified: boolean;
  created_at: string;
  updated_at: string;
  location?: {
    latitude: number;
    longitude: number;
  } | null;
}

export interface Post {
  id: string;
  author_id: string;
  content: string;
  created_at: string;
  updated_at: string;
}

export interface Comment {
  id: string;
  post_id: string;
  author_id: string;
  content: string;
  created_at: string;
}

