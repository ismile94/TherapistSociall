import { IncomingMessage, ServerResponse } from 'http';

declare module '@vercel/node' {
  export interface VercelRequest extends IncomingMessage {
    query: Record<string, string | string[]>;
    cookies: Record<string, string>;
    body?: any;
  }

  export interface VercelResponse extends ServerResponse {
    send: (body: any) => void;
    json: (body: any) => void;
    status: (statusCode: number) => VercelResponse;
  }
}

