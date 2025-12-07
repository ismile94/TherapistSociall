// Discover resolvers placeholder
export const discoverResolvers = {
  Query: {
    discover: async (parent: any, { profession, city, specialties, cursor, limit }: any, context: any) => {
      // TODO: Search profiles with filters
      return {
        edges: [],
        pageInfo: {
          hasNextPage: false,
          hasPreviousPage: false,
        },
      };
    },
    searchProfilesByLocation: async (parent: any, { location, radius, profession, specialties, cursor, limit }: any, context: any) => {
      // TODO: Search profiles by location using PostGIS
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

