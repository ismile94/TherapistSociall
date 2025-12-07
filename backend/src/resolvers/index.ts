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
      comments: async (parent, { cursor, limit }, { db }) => {
        // TODO: Fetch comments with pagination
        return {
          edges: [],
          pageInfo: {
            hasNextPage: false,
            hasPreviousPage: false,
          },
        };
      },
    },
  };
}

