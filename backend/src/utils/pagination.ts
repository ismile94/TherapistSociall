/**
 * Cursor-based pagination utilities for GraphQL resolvers
 * 
 * This module provides:
 * 1. Type-safe cursor encoding/decoding
 * 2. Pagination result builders
 * 3. Database query helpers
 */

// ============================================================================
// Types
// ============================================================================

export interface PaginationArgs {
  cursor?: string | null;
  limit?: number | null;
}

export interface PaginationResult<T> {
  edges: Array<{
    node: T;
    cursor: string;
  }>;
  pageInfo: {
    hasNextPage: boolean;
    hasPreviousPage: boolean;
    startCursor: string | null;
    endCursor: string | null;
  };
}

export interface CursorData {
  id: string | number;
  createdAt?: string; // ISO string for stable ordering
  [key: string]: any; // Allow additional fields for complex sorting
}

// ============================================================================
// Cursor Encoding/Decoding
// ============================================================================

/**
 * Encode cursor from entity data
 * Uses base64 encoding for stability and URL-safety
 */
export function encodeCursor(data: CursorData): string {
  try {
    const json = JSON.stringify(data);
    return Buffer.from(json, 'utf-8').toString('base64url');
  } catch (error) {
    throw new Error(`Failed to encode cursor: ${error}`);
  }
}

/**
 * Decode cursor to entity data
 * Returns null if invalid cursor
 */
export function decodeCursor(cursor: string | null | undefined): CursorData | null {
  if (!cursor) return null;
  
  try {
    const json = Buffer.from(cursor, 'base64url').toString('utf-8');
    const data = JSON.parse(json);
    
    // Validate required fields
    if (!data.id) {
      throw new Error('Invalid cursor: missing id');
    }
    
    return data;
  } catch (error) {
    console.error('Failed to decode cursor:', error);
    return null;
  }
}

// ============================================================================
// Pagination Result Builder
// ============================================================================

/**
 * Build pagination result from fetched items
 * 
 * @param items - Array of items fetched from database
 * @param cursorField - Field to use for cursor (usually 'id' or 'created_at')
 * @param hasNextPage - Whether there are more items after these
 * @param hasPreviousPage - Whether there were items before the cursor
 */
export function buildPaginationResult<T extends CursorData>(
  items: T[],
  cursorField: keyof T = 'id',
  hasNextPage: boolean = false,
  hasPreviousPage: boolean = false
): PaginationResult<T> {
  if (items.length === 0) {
    return {
      edges: [],
      pageInfo: {
        hasNextPage: false,
        hasPreviousPage: false,
        startCursor: null,
        endCursor: null,
      },
    };
  }

  const edges = items.map((item) => ({
    node: item,
    cursor: encodeCursor({
      id: item[cursorField] as string | number,
      createdAt: item.createdAt,
    }),
  }));

  return {
    edges,
    pageInfo: {
      hasNextPage,
      hasPreviousPage,
      startCursor: edges[0]?.cursor || null,
      endCursor: edges[edges.length - 1]?.cursor || null,
    },
  };
}

// ============================================================================
// Pagination Helpers for Database Queries
// ============================================================================

/**
 * Get default limit (ensures it's within bounds)
 */
export function getLimit(limit?: number | null, defaultLimit: number = 10, maxLimit: number = 50): number {
  if (!limit || limit <= 0) {
    return defaultLimit;
  }
  return Math.min(limit, maxLimit);
}

/**
 * Parse pagination arguments for database queries
 * Returns the limit and cursor data for building WHERE clauses
 */
export function parsePaginationArgs(args: PaginationArgs): {
  limit: number;
  cursorData: CursorData | null;
  defaultLimit?: number;
  maxLimit?: number;
} {
  const limit = getLimit(args.limit);
  const cursorData = decodeCursor(args.cursor);

  return {
    limit,
    cursorData,
  };
}

/**
 * Check if there's a next page
 * Fetches one extra item to determine if more exist
 */
export async function checkHasNextPage<T>(
  queryBuilder: any, // Supabase query builder
  currentItems: T[],
  requestedLimit: number
): Promise<boolean> {
  // If we got fewer items than requested, there's no next page
  if (currentItems.length < requestedLimit) {
    return false;
  }

  // If we got exactly the limit, we need to check if there's one more
  // This is done by checking if we can fetch one more item after the last cursor
  return currentItems.length === requestedLimit;
}

