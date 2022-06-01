import { serve } from "https://deno.land/std@0.141.0/http/server.ts";

const port = 3000;
let counter = 0;

const headers = new Headers({
    'Content-Type': 'application/json'
});

const handler = (request: Request): Response => {
    counter += 1;
    if (request.method !== "GET") {
        return new Response("", { status: 406 });
    }

    const { pathname } = new Url(request.url);
    if (pathname === "/") {
        return new Response("Hello World");
    } else if (pathname === "/counter.json") {
        return new Response(`{"counter":${counter}}`, { headers });
    } else {
        return new Response("", { status: 404 });
    }
};

await serve(handler, { port });