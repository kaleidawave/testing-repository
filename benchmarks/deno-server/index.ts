import { serve } from "https://deno.land/std@0.141.0/http/server.ts";

const port = 3000;

const handler = (request: Request): Response => {
  return new Response("Hello World", { status: 200 });
};

await serve(handler, { port });