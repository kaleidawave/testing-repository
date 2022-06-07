/** @jsxImportSource https://esm.sh/preact */

function jsxTemplate() {
    const name = "Hello";
    const result = (
      <div>
        <h1>Hello {name}!</h1>
        <ul>
          <li>Item 1</li>
          <li>Item 2</li>
          <li>Item 3</li>
          <li>Item 4</li>
          <li>Item 5</li>
          <li>Item 6</li>
          <li>Item 7</li>
          <li>Item 8</li>
          <li>Item 9</li>
          <li>Item 10</li>
        </ul>
      </div>
    );

  }
function templateLiteralTemplate() {
    const name = "Hello";
    const result = `<div><h1>Hello ${name}!</h1><ul><li>Item 1</li><li>Item 2</li><li>Item 3</li><li>Item 4</li><li>Item 5</li><li>Item 6</li><li>Item 7</li><li>Item 8</li><li>Item 9</li><li>Item 10</li></ul></div> )`;
}

Deno.bench(jsxTemplate);
Deno.bench(templateLiteralTemplate);