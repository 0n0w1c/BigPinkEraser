-- Require the constants.lua file to access shared constants.
-- This includes the path for icons and allowed image types.
local constants = require("constants")

-- Helper function to check if the given image type is allowed.
-- @param image_type string The image type to check.
-- @return boolean Returns true if the image type is allowed, otherwise false.
local function is_image_type_allowed(image_type)
    for _, type in ipairs(constants.allowed_image_types) do
        if type == image_type then
            return true
        end
    end
    return false
end

-- Helper function to determine the appropriate icons based on the button image type.
-- This function encapsulates the logic for setting the tool and button icons.
-- The icons are dynamically generated based on the selected image type from the settings.
-- @param image_type string The type of image selected from the settings.
-- @return tool_icon string The icon used for the tool.
-- @return button_icon string The icon used for the shortcut button.
local function get_icons(image_type)
    local tool_icon
    local button_icon

    -- Validate if image_type is allowed, otherwise default to constants.default_image_type
    if not image_type or not is_image_type_allowed(image_type) then
        image_type = constants.default_image_type
    end

    if image_type == constants.default_image_type then
        tool_icon = constants.image
        button_icon = tool_icon
    else
        tool_icon = constants.pink_clip_art
        button_icon = constants.icon_path .. image_type .. ".png"
    end

    return tool_icon, button_icon
end

-- Retrieve the startup setting for shortcut style.
-- Maps "gray" to "default", as "gray" is used as the default button color in the mod.
local shortcut_style = tostring(settings.startup["big-pink-eraser-button-style"].value)
if shortcut_style == constants.default_button_color then shortcut_style = "default" end

-- Retrieve the startup setting for the button image type.
-- The button image can be set to "image" or one of the clip-art options.
local button_image_type = tostring(settings.startup["big-pink-eraser-button-icon"].value)

-- Use the helper function to dynamically generate the icons for the tool and shortcut.
local tool_icon, button_icon = get_icons(button_image_type)

-- Selection tool and a shortcut for the big-pink-eraser.
-- The tool allows players to select and remove entities within the selected area.
-- The tool and shortcut icons are dynamically set based on the startup settings.

data:extend({
    {
        type = "selection-tool",
        name = constants.mod_name,
        icon = tool_icon,
        icon_size = constants.icon_size_small,
        flags = { "only-in-cursor", "spawnable", "not-stackable" },
        hidden_in_factoriopedia = true,
        hidden = true,
        draw_label_for_cursor_render = false,
        subgroup = "tool",
        order = constants.tool_order,
        stack_size = 1,
        select = {
            border_color = constants.pink,
            cursor_box_type = "entity",
            mode = "any-entity",
            entity_filter_mode = "whitelist"
        },
        alt_select = {
            border_color = constants.pink,
            cursor_box_type = "entity",
            mode = "any-entity",
            entity_filter_mode = "whitelist"
        }
    },
    {
        type = "shortcut",
        name = constants.mod_name,
        action = "lua",
        icon = button_icon,
        icon_size = 32,
        small_icon = button_icon,
        small_icon_size = 32,
        associated_control_input = "give-big-pink-eraser",
        style = shortcut_style,
        toggleable = false,
        order = constants.shortcut_order
    }
})
