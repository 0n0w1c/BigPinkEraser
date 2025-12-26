local constants = require("constants")

data:extend({
    {
        type = "bool-setting",
        name = "big-pink-eraser-enable-alt-mode",
        setting_type = "startup",
        default_value = false,
        order = "a"
    }
})

data:extend({
    {
        type = "string-setting",
        name = "big-pink-eraser-button-style",
        setting_type = "startup",
        default_value = constants.default_button_color,
        allowed_values = constants.allowed_button_colors,
        order = "b"
    }
})

data:extend({
    {
        type = "string-setting",
        name = "big-pink-eraser-button-icon",
        setting_type = "startup",
        default_value = constants.default_image_type,
        allowed_values = constants.allowed_image_types,
        order = "c"
    }
})

data:extend({
    {
        type = "bool-setting",
        name = "big-pink-eraser-admins-only",
        setting_type = "startup",
        default_value = false,
        order = "d"
    }
})
