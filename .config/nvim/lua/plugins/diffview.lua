return {
    "sindrets/diffview.nvim",
  config = function()
    require("diffview").setup({
        show_help_hints = false,
        enhanced_diff_hl = true,
    })
  end,
}
