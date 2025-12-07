// Map resolvers placeholder
export const mapResolvers = {
  Query: {
    mapClusters: async (parent: any, { bounds, zoom, profession, specialties }: any, context: any) => {
      // TODO: Implement server-side clustering with PostGIS
      // This will use ST_SnapToGrid and ST_Within for clustering
      return [];
    },
  },
  Mutation: {}, // Bu satırı ekleyin
};