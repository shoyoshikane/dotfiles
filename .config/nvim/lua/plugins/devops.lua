return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>y",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        "<leader>cw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open yazi in the working directory",
      },
    },
    opts = {
      open_for_directories = false,
    },
  },
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
  },
}
