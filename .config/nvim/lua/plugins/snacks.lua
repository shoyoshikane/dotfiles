return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = { hidden = true, exclude = { ".git" } },
          files = { hidden = true, exclude = { ".git" } },
          grep = { hidden = true, exclude = { ".git" } },
        },
      },
    },
  },
}
