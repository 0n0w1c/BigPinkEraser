-- Require the constants.lua file to access shared constants.
-- This includes the path for icons and allowed image types.
local constants = require("constants")

-- Helper function to determine the appropriate icons based on the button image type.
-- This function encapsulates the logic for setting the tool and button icons.
-- The icons are dynamically generated based on the selected image type from the settings.
-- @param image_type string The type of image selected from the settings.
-- @return tool_icon string The icon used for the tool.
-- @return button_icon string The icon used for the shortcut button.
local function get_icons(image_type)
    local tool_icon
    local button_icon

    if not image_type then image_type = constants.default_image_type end

    if image_type == constants.default_image_type then
        tool_icon = constants.icon_path .. "big-pink-eraser.png"
        button_icon = constants.icon_path .. "big-pink-eraser.png"
    else
        tool_icon = constants.icon_path .. "clip-art-pink.png"
        button_icon = constants.icon_path .. image_type .. ".png"
    end

    return tool_icon, button_icon
end

-- Retrieve the startup setting for shortcut style.
-- Maps "gray" to "default", as "gray" is used as the default button color in the mod.
local shortcut_style = tostring(settings.startup["big-pink-eraser-button-style"].value)
if shortcut_style == constants.default_button_color then shortcut_style = "default" end

-- Retrieve the startup setting for the button image type.
-- The button image can be set to HD image or one of the clip-art options.
local button_image_type = tostring(settings.startup["big-pink-eraser-button-icon"].value)

-- Use the helper function to dynamically generate the icons for the tool and shortcut.
local tool_icon, button_icon = get_icons(button_image_type)

-- Selection tool and a shortcut for the big-pink-eraser.
-- The tool allows players to select and remove entities within the selected area.
-- The tool and shortcut icons are dynamically set based on the startup settings.
data:extend({
    {
        type = "selection-tool",
        name = "big-pink-eraser",
        icon = tool_icon,
        icon_size = 32,
        flags = {},
        subgroup = "tool",
        order = "c[automated-construction]-a[big-pink-eraser]",
        stack_size = 1,
        selection_color = { r = 1, g = 0.44, b = 0.71 },
        alt_selection_color = { r = 1, g = 0.44, b = 0.71 },
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
            filename = button_icon,
            priority = "high",
            size = 32,
        },
        associated_control_input = "give-big-pink-eraser",
        style = shortcut_style,
        toggleable = false,
        order = "a[tools]-c[big-pink-eraser]",
    }
})
