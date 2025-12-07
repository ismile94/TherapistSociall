# Cursor-Based Pagination Implementation Guide

## 📋 Overview

This guide explains the cursor-based pagination implementation for the TherapistSocial GraphQL API. It addresses common issues, provides best practices, and shows correct resolver patterns.

## 🔍 Common Issues & Solutions

### Issue 1: Missing or Invalid Cursor Encoding

**Problem:** Cursors are returned as plain strings or fail to decode, causing pagination to break.

**Solution:** Always use the `encodeCursor()` and `decodeCursor()` utilities:

```typescript
import { encodeCursor, decodeCursor } from '../utils/pagination';

// ✅ Correct
const cursor = encodeCursor({ id: profile.id, createdAt: profile.created_at });
const data = decodeCursor(cursor); // Returns { id: string, createdAt?: string }

// ❌ Wrong
const cursor = profile.id; // Missing encoding
const cursor = JSON.stringify({ id: profile.id }); // Not URL-safe
```

### Issue 2: Incorrect hasNextPage Calculation

**Problem:** `hasNextPage` is always false or incorrectly calculated.

**Solution:** Fetch `limit + 1` items to check if there's a next page:

```typescript
// ✅ Correct
const { limit: queryLimit } = parsePaginationArgs({ cursor, limit });
const items = await query.limit(queryLimit + 1).execute();
const hasNextPage = items.length > queryLimit;
const result = hasNextPage ? items.slice(0, queryLimit) : items;

// ❌ Wrong
const items = await query.limit(limit).execute();
const hasNextPage = items.length === limit; // Not reliable!
```

### Issue 3: Unstable Sorting Causes Duplicate/Missing Items

**Problem:** Items appear multiple times or are skipped when new items are added during pagination.

**Solution:** Always use a stable sort with a unique secondary key:

```typescript
// ✅ Correct - Stable sorting
query = query
  .order('created_at', { ascending: false })
  .order('id', { ascending: false }); // Secondary sort ensures stability

// ❌ Wrong - Unstable sorting
query = query.order('created_at', { ascending: false }); // Can cause duplicates
```

### Issue 4: Missing startCursor and endCursor in pageInfo

**Problem:** `pageInfo.startCursor` and `endCursor` are null.

**Solution:** Always include cursors in the result using `buildPaginationResult()`:

```typescript
// ✅ Correct
return buildPaginationResult(items, 'id', hasNextPage, hasPreviousPage);
// Automatically includes startCursor and endCursor

// ❌ Wrong
return {
  edges: items.map(item => ({ node: item, cursor: item.id })),
  pageInfo: {
    hasNextPage,
    hasPreviousPage,
    startCursor: null, // Missing!
    endCursor: null,   // Missing!
  },
};
```

### Issue 5: TypeScript Type Errors

**Problem:** Resolver arguments and return types are `any`, causing type errors.

**Solution:** Use proper TypeScript types from `utils/types.ts`:

```typescript
// ✅ Correct
import { ResolverFn, DiscoverArgs, ProfileConnection } from '../utils/types';

export const discoverResolvers = {
  Query: {
    discover: async (
      parent: any,
      args: DiscoverArgs,
      context: GraphQLContext
    ): Promise<ProfileConnection> => {
      // Type-safe implementation
    },
  },
};

// ❌ Wrong
discover: async (parent: any, args: any, context: any): Promise<any> => {
  // No type safety
};
```

## 📚 Implementation Patterns

### Pattern 1: Basic Pagination

```typescript
import { buildPaginationResult, parsePaginationArgs } from '../utils/pagination';

export const myResolver = {
  Query: {
    myQuery: async (parent: any, args: { cursor?: string; limit?: number }, context: any) => {
      const { limit: queryLimit, cursorData } = parsePaginationArgs({
        cursor: args.cursor,
        limit: args.limit,
      });

      // Build query
      let query = supabase.from('table').select('*');

      // Apply cursor
      if (cursorData?.id) {
        query = query.lt('id', cursorData.id);
      }

      // Stable sorting
      query = query
        .order('created_at', { ascending: false })
        .order('id', { ascending: false })
        .limit(queryLimit + 1); // Fetch one extra

      const { data: items, error } = await query;

      if (error) throw new Error(error.message);
      if (!items || items.length === 0) {
        return buildPaginationResult([], 'id', false, !!args.cursor);
      }

      // Check for next page
      const hasNextPage = items.length > queryLimit;
      const itemsToReturn = hasNextPage ? items.slice(0, queryLimit) : items;

      // Map for cursor encoding
      const itemsWithCursor = itemsToReturn.map((item: any) => ({
        ...item,
        createdAt: item.created_at || item.createdAt,
      }));

      return buildPaginationResult(
        itemsWithCursor,
        'id',
        hasNextPage,
        !!args.cursor
      );
    },
  },
};
```

### Pattern 2: Filtered Pagination

```typescript
discover: async (parent: any, args: DiscoverArgs, context: GraphQLContext) => {
  const { profession, city, cursor, limit } = args;
  const { limit: queryLimit, cursorData } = parsePaginationArgs({ cursor, limit });

  let query = supabase.from('profiles').select('*');

  // Apply filters
  if (profession) query = query.eq('profession', profession);
  if (city) query = query.eq('city', city);

  // Apply cursor (after filters!)
  if (cursorData?.id && cursorData.createdAt) {
    query = query.lt('created_at', cursorData.createdAt);
  }

  // Stable sort
  query = query
    .order('created_at', { ascending: false })
    .order('id', { ascending: false })
    .limit(queryLimit + 1);

  // Execute and build result
  const { data, error } = await query;
  // ... rest of implementation
};
```

### Pattern 3: Complex Cursor Logic

For complex scenarios (e.g., when sorting by multiple fields):

```typescript
if (cursorData) {
  // Multi-field cursor comparison
  query = query.or(
    `created_at.lt.${cursorData.createdAt},and(created_at.eq.${cursorData.createdAt},id.lt.${cursorData.id})`
  );
}
```

## 🔧 TypeScript Type Safety

### Resolver Types

```typescript
import { ResolverFn, DiscoverArgs, ProfileConnection, GraphQLContext } from '../utils/types';

// Type-safe resolver
const discoverResolver: ResolverFn<
  any,           // parent type
  DiscoverArgs,  // args type
  GraphQLContext, // context type
  ProfileConnection // return type
> = async (parent, args, context) => {
  // TypeScript will enforce correct types
  const { cursor, limit, profession } = args; // All typed!
  return { edges: [], pageInfo: { ... } }; // Must match ProfileConnection
};
```

### Extension Types

Add new resolver types as needed:

```typescript
// In utils/types.ts
export interface MyCustomArgs extends PaginationArgs {
  customField?: string;
}

export type MyCustomConnection = PaginationResult<MyCustomType>;
```

## ✅ Testing Checklist

Before deploying, verify:

- [ ] Cursors encode/decode correctly
- [ ] `hasNextPage` is accurate (test with exactly `limit` items)
- [ ] `hasPreviousPage` is accurate (test with/without cursor)
- [ ] `startCursor` and `endCursor` are included
- [ ] Stable sorting prevents duplicates/skips
- [ ] Filters work correctly with pagination
- [ ] Edge cases (empty results, single page) handled
- [ ] TypeScript compiles without errors

## 🚨 Common Mistakes to Avoid

1. **Don't use offset-based pagination** - Use cursors for consistency
2. **Don't forget the +1 fetch** - Always fetch `limit + 1` for hasNextPage
3. **Don't skip stable sorting** - Always include a unique secondary sort key
4. **Don't hardcode pagination logic** - Use the utility functions
5. **Don't return raw database IDs as cursors** - Always encode them
6. **Don't ignore TypeScript errors** - Fix type issues early

## 📖 Additional Resources

- GraphQL Cursor Connections Specification: https://relay.dev/graphql/connections.htm
- Supabase Pagination Docs: https://supabase.com/docs/guides/api/pagination
- Relay Cursor Connections: https://relay.dev/graphql/connections.htm

---

**Last Updated:** 2024-01-XX
**Maintained By:** Backend Team

