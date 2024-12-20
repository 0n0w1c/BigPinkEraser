local constants = require("constants")

local function get_icon()
    local image_type = tostring(settings.startup["big-pink-eraser-button-icon"].value)
    local icon

    if image_type == "image" then
        icon = constants.icon_path .. "big-pink-eraser.png"
    else
        icon = constants.icon_path .. image_type .. ".png"
    end

    return icon
end

local shortcut_style = tostring(settings.startup["big-pink-eraser-button-style"].value)
if shortcut_style == constants.default_button_color then shortcut_style = "default" end

data:extend({
    {
        type = "selection-tool",
        name = constants.mod_name,
        icon = constants.tool_icon,
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
        icon = get_icon(),
        icon_size = constants.icon_size,
        small_icon = get_icon(),
        small_icon_size = constants.icon_size,
        associated_control_input = "give-big-pink-eraser",
        style = shortcut_style,
        toggleable = false,
        order = constants.shortcut_order
    }
})
