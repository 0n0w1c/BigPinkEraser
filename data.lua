local constants = require("constants")

local function get_icons(image_type)
    local button_icon

    if image_type == "image" then
        button_icon = constants.icon_path .. "big-pink-eraser.png"
    else
        button_icon = constants.icon_path .. "clip-art-tool.png"
    end

    return button_icon
end

local shortcut_style = tostring(settings.startup["big-pink-eraser-button-style"].value)
if shortcut_style == constants.default_button_color then shortcut_style = "default" end

local button_image_type = tostring(settings.startup["big-pink-eraser-button-icon"].value)
local button_icon = get_icons(button_image_type)

data:extend({
    {
        type = "selection-tool",
        name = constants.mod_name,
        icon = constants.tool,
        icon_size = constants.icon_size_small,
        flags = { "only-in-cursor", "spawnable", "not-stackable" },
        hidden_in_factoriopedia = true,
        hidden = true,
        draw_label_for_cursor_render = false,
        subgroup = "tool",
        order = constants.tool_order,
        stack_size = 1,
        select = {
            border_color = constants.white,
            cursor_box_type = "not-allowed",
            mode = { "any-entity", "items" },
            entity_filter_mode = "blacklist",
            entity_type_filters = constants.excluded_types_list
        },
        alt_select = {
            border_color = constants.white,
            cursor_box_type = "not-allowed",
            mode = { "any-entity", "items" },
            entity_filter_mode = "blacklist",
            entity_type_filters = constants.excluded_types_list
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
