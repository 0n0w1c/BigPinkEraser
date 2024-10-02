data:extend({
    {
        type = "selection-tool",
        name = "big-pink-eraser",
        icon = "__big-pink-eraser__/graphics/icons/big-pink-eraser.png",
        icon_size = 64,
        flags = {},
        subgroup = "tool",
        order = "c[automated-construction]-a[big-pink-eraser]",
        stack_size = 1,
        selection_color = { r = 1, g = 0, b = 1 },
        alt_selection_color = { r = 1, g = 0.5, b = 1 },
        selection_mode = { "any-entity" },
        alt_selection_mode = { "any-entity" },
        selection_cursor_box_type = "not-allowed",
        alt_selection_cursor_box_type = "not-allowed",
        entity_filter_mode = "whitelist",
        tile_filter_mode = "blacklist",
    },
    {
        type = "shortcut",
        name = "big-pink-eraser",
        action = "lua",
        icon = {
            filename = "__big-pink-eraser__/graphics/icons/big-pink-eraser.png",
            priority = "extra-high-no-scale",
            size = 64,
        },
        associated_control_input = "give-big-pink-eraser",
        toggleable = true,
        order = "a[tools]-c[big-pink-eraser]",
    }
})
