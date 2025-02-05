import { $ } from "bun";

$.nothrow();

const out = $`cargo check -q --message-format json`.lines();

for await (const line of out) {
    if (line) {
        const out = JSON.parse(line);
        if (out.message?.code) {
            const first = out.message.spans[0];
            const file = `one-off/github-file-annotations/${first.file_name}`;
            const line = first.line_start;
            const endLine = first.line_end;
            const col = first.column_start;
            const colEnd = first.column_end;
            const message = first.label;
            console.log(`::error file=${file},line=${line},endLine=${endLine},col=${col},colEnd=${colEnd}::'${message}'`);
        }
    }
}
