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
  if (!apolloServer || !expressApp) {
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
  }
  
  return { server: apolloServer, app: expressApp };
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  const { app } = await getApolloServer();
  
  // Convert Vercel request/response to Express-compatible format
  return new Promise((resolve, reject) => {
    app(req as any, res as any, (err: any) => {
      if (err) {
        reject(err);
      } else {
        resolve(undefined);
      }
    });
  });
}