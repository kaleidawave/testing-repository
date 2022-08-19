import { defineConfig } from 'astro/config';

import react from "@astrojs/react";
import preact from "@astrojs/preact";
import vue from "@astrojs/vue";
import svelte from "@astrojs/svelte";
import solid from "@astrojs/solid-js";
import lit from "@astrojs/lit";

// https://astro.build/config
export default defineConfig({
  integrations: [react(), preact(), vue(), svelte(), solid(), lit()]
});