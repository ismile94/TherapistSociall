// Vercel serverless function for GraphQL endpoint
import express from 'express';
import { ApolloServer } from 'apollo-server-express';
import cors from 'cors';
import { loadSchema } from '../src/schema/load-schema';
import { createResolvers } from '../src/resolvers';
import { config } from '../config/env.config';
import type { VercelRequest, VercelResponse } from '@vercel/node';

// Apollo Server instance - cached for cold start optimization
let apolloServer: ApolloServer | null = null;
let expressApp: express.Application | null = null;

async function getApolloServer(): Promise<{ server: ApolloServer; app: express.Application }> {
  if (apolloServer && expressApp) {
    return { server: apolloServer, app: expressApp };
  }

  try {
    // Load schema and resolvers
    const typeDefs = await loadSchema();
    const resolvers = createResolvers();
    
    // Create Express app
    expressApp = express();
    
    // CORS middleware
    expressApp.use(cors({
      origin: process.env.CORS_ORIGIN || '*',
      credentials: true,
      methods: ['GET', 'POST', 'OPTIONS'],
      allowedHeaders: ['Content-Type', 'Authorization'],
    }));
    
    expressApp.use(express.json());
    
    // Create Apollo Server
    apolloServer = new ApolloServer({
      typeDefs,
      resolvers,
      context: async ({ req }) => {
        // Extract user from JWT token
        const token = req?.headers?.authorization?.replace('Bearer ', '') || '';
        // TODO: Verify token and get user
        return {
          user: null, // Will be populated from token
        };
      },
      introspection: config.nodeEnv === 'development',
    });
    
    await apolloServer.start();
    apolloServer.applyMiddleware({ 
      app: expressApp, 
      path: '/api/graphql',
      cors: false, // CORS is handled by express middleware
    } as any);

    return { server: apolloServer, app: expressApp };
  } catch (error) {
    console.error('🔴 [VERCEL_GRAPHQL] Failed to initialize serverless GraphQL handler:', error);
    throw error;
  }
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  try {
    const { app } = await getApolloServer();
    
    // Convert Vercel request/response to Express-compatible format
    return new Promise((resolve, reject) => {
      app(req as any, res as any, (err: any) => {
        if (err) {
          console.error('🔴 [VERCEL_GRAPHQL] Express handler error:', err);
          reject(err);
        } else {
          resolve(undefined);
        }
      });
    });
  } catch (error: any) {
    console.error('🔴 [VERCEL_GRAPHQL] Handler failed:', error);
    res.status(500).json({
      error: 'GraphQL handler initialization failed',
      message: error?.message || 'Unknown error',
    });
  }
}