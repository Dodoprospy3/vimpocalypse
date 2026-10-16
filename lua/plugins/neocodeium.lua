return {
    {
        "monkoose/neocodeium",
        event = "VeryLazy",
        config = function()
            local neocodeium = require("neocodeium")
            local blink = require("blink.cmp")

            neocodeium.setup({
                show_label = false,
                silent = false,
                filter = function()
                    return not blink.is_visible()
                end,
            })

            local function feed_key(key)
                vim.api.nvim_feedkeys(
                    vim.api.nvim_replace_termcodes(key, true, false, true),
                    "n",
                    false
                )
            end

            -- Accept AI suggestion, or pass Ctrl-Y through normally.
            vim.keymap.set("i", "<C-y>", function()
                if neocodeium.visible() and not blink.is_visible() then
                    neocodeium.accept()
                else
                    feed_key("<C-y>")
                end
            end, {
                desc = "Accept AI suggestion",
            })

            -- Reject AI suggestion, or pass Ctrl-N through normally.
            vim.keymap.set("i", "<C-n>", function()
                if neocodeium.visible() and not blink.is_visible() then
                    neocodeium.clear()
                else
                    feed_key("<C-n>")
                end
            end, {
                desc = "Reject AI suggestion",
            })

            -- Clear AI suggestions when Blink's completion menu opens.
            vim.api.nvim_create_autocmd("User", {
                pattern = "BlinkCmpMenuOpen",
                callback = function()
                    neocodeium.clear()
                end,
            })
        end,
    },
}
