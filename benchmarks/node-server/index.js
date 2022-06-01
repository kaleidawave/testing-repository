const http = require('http');

let counter = 0;

http.createServer(function (request, response) {
    counter += 1;
    if (request.method !== "GET") {
        response.statusCode = 406;
        response.end();
        return;
    }

    const { pathname } = new URL(request.url, `http://${request.headers.host}`);
    if (pathname === "/") {
        response.write('Hello World!'); 
    } else if (pathname === "/counter.json") {
        response.setHeader('Content-Type', 'application/json');
        response.write(`{"counter":${counter}}`); 
    } else {
        response.statusCode = 404;
    }
    response.end();
}).listen(3000);