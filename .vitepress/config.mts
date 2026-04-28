import { defineConfig } from "vitepress";

export default defineConfig({
  title: "Zero-Drag Dotfiles",
  description: "A systems-thinking approach to Hyprland & Arch Linux",

  // High-Agency Setup: Point to your existing wiki folder
  srcDir: "docs/wiki",

  // Professional URLs: Removes .html from the end
  cleanUrls: true,

  // GitHub Pages Path: Matches your repo name
  base: "/Zero_Drag.dotfiles/",

  // Map Home.md to index.md so it becomes the landing page
  rewrites: {
    "Home.md": "index.md",
  },

  themeConfig: {
    logo: "https://raw.githubusercontent.com/babyanonymouse/Zero_Drag.dotfiles/main/peolabs-logo.svg",
    nav: [
      { text: "Home", link: "/" },
      { text: "Installation", link: "/Installation" },
    ],

    sidebar: [
      {
        text: "Getting Started",
        items: [
          { text: "Installation", link: "/Installation" },
          { text: "Configuration", link: "/Configuration" },
          { text: "Keybindings", link: "/Keybindings" },
        ],
      },
      {
        text: "Core Components",
        items: [
          { text: "Shell Setup", link: "/Shell-Setup" },
          { text: "UI Customization", link: "/Customization" },
          { text: "Components", link: "/Components" },
        ],
      },
      {
        text: "Resources",
        items: [{ text: "Troubleshooting", link: "/Troubleshooting" }],
      },
    ],

    socialLinks: [
      {
        icon: "github",
        link: "https://github.com/babyanonymouse/Zero_Drag.dotfiles",
      },
    ],

    footer: {
      message: "Released under the MIT License.",
      copyright: "Copyright © 2026-present Samuel Lwanga",
    },
  },
});
