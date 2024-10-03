--- Selection tool and a shortcut for the big-pink-eraser.
-- Allows players to select and remove entities within the selected area.
-- Shortcut adds a button to the player's UI for quickly accessing the big-pink-eraser tool.
data:extend({
    {
        --- This tool allows the player to select any entity in the game world and perform actions on them.
        -- @field type The type of entity being defined (selection-tool).
        -- @field name The internal name of the tool (big-pink-eraser).
        -- @field icon The file path to the tool's icon.
        -- @field icon_size The size of the icon in pixels.
        -- @field flags Additional flags affecting tool behavior.
        -- @field subgroup Defines the grouping of the tool in the game menu.
        -- @field order The ordering of the tool in the submenu.
        -- @field stack_size Maximum number of tools that can be stacked in the inventory.
        -- @field selection_color The color used when selecting entities.
        -- @field alt_selection_color The color used for alternate selection (shift-selection).
        -- @field selection_mode The mode for selecting entities, allowing any entity.
        -- @field alt_selection_mode The alternate mode for selecting entities, allowing any entity.
        -- @field selection_cursor_box_type The type of cursor box shown when selecting.
        -- @field alt_selection_cursor_box_type The alternate cursor box type for selection.
        -- @field entity_filter_mode Determines the filtering mode for entities (whitelist).
        -- @field tile_filter_mode Determines the filtering mode for tiles (blacklist).
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
        --- Define the big-pink-eraser shortcut.
        -- @field type The type of entity being defined (shortcut).
        -- @field name The internal name of the shortcut (big-pink-eraser).
        -- @field action The action triggered by the shortcut (lua action).
        -- @field icon The file path to the shortcut's icon.
        -- @field associated_control_input The control input associated with the shortcut.
        -- @field toggleable Whether the shortcut can be toggled on and off.
        -- @field order The ordering of the shortcut in the UI.
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
