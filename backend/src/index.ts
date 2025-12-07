// Main entry point for GraphQL server
import express from 'express';
import { ApolloServer } from 'apollo-server-express';
import cors from 'cors';
import helmet from 'helmet';
import { config } from '../config/env.config';
import { loadSchema } from './schema/load-schema';
import { createResolvers } from './resolvers';

async function startServer() {
  const app = express();
  
  // Middleware
  // CORS must be before helmet to avoid conflicts
  app.use(cors({
    origin: process.env.CORS_ORIGIN || '*',
    credentials: true,
    methods: ['GET', 'POST', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  }));
  
  app.use(helmet({
    crossOriginEmbedderPolicy: false,
    contentSecurityPolicy: false,
  }));
  
  app.use(express.json());
  
  // Request logging middleware
  app.use((req, res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.path} from ${req.ip || req.socket.remoteAddress}`);
    next();
  });
  
  // Root route - info message
  app.get('/', (req, res) => {
    res.json({
      message: 'TherapistSocial GraphQL API',
      endpoint: '/graphql',
      status: 'running',
      version: '1.0.0'
    });
  });
  
  // Load GraphQL schema
  const typeDefs = await loadSchema();
  const resolvers = createResolvers();
  
  // Create Apollo Server
  const server = new ApolloServer({
    typeDefs,
    resolvers,
    context: async ({ req }) => {
      // Extract user from JWT token
      const token = req.headers.authorization?.replace('Bearer ', '');
      console.log('🔵 [APOLLO] Context created - hasToken:', !!token);
      // TODO: Verify token and get user
      return {
        user: null, // Will be populated from token
      };
    },
    introspection: config.nodeEnv === 'development',
    formatError: (error) => {
      console.error('🔴 [APOLLO] GraphQL Error:', error.message);
      console.error('🔴 [APOLLO] Error path:', error.path);
      console.error('🔴 [APOLLO] Error extensions:', error.extensions);
      if (error.originalError) {
        console.error('🔴 [APOLLO] Original error:', error.originalError);
      }
      return error;
    },
    plugins: [
      {
        requestDidStart() {
          return {
            didResolveOperation(requestContext) {
              console.log('🔵 [APOLLO] Operation:', requestContext.operationName || 'unnamed');
              console.log('🔵 [APOLLO] Variables:', JSON.stringify(requestContext.request.variables, null, 2));
            },
            didEncounterErrors(requestContext) {
              console.error('🔴 [APOLLO] Request errors:', requestContext.errors);
            },
            willSendResponse(requestContext) {
              if (requestContext.response.data) {
                console.log('🟢 [APOLLO] Response data keys:', Object.keys(requestContext.response.data));
              }
            },
          };
        },
      },
    ],
  });
  
  await server.start();
  server.applyMiddleware({ app, path: '/graphql' } as any);
  
  const port = typeof config.port === 'string' ? parseInt(config.port, 10) : config.port;
  
  // 0.0.0.0 dinleyerek tüm network interface'lerinden erişilebilir yap
  app.listen(port, '0.0.0.0', () => {
    console.log(`🚀 Server ready at http://localhost:${port}${server.graphqlPath}`);
    console.log(`📱 Accessible from Android emulator at http://10.0.2.2:${port}${server.graphqlPath}`);
    console.log(`📱 Accessible from network at http://192.168.1.219:${port}${server.graphqlPath}`);
  });
}

startServer().catch(console.error);