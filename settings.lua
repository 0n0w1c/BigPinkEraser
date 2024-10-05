-- Require the constants.lua file to access shared constants.
local constants = require("constants")

-- Defines a startup setting for the Big Pink Eraser shortcut button style.
-- Allows the player to choose the button color, defaulting to gray.
-- Type: string-setting
-- Name: big-pink-eraser-button-style
-- Setting type: startup
-- Default value: "gray"
-- Allowed values: "gray", "red", "green", "blue"
data:extend({
    {
        type = "string-setting",
        name = "big-pink-eraser-button-style",
        setting_type = "startup",
        default_value = constants.default_button_color,
        allowed_values = constants.allowed_button_colors,
    }
})

-- Defines a startup setting for the Big Pink Eraser button image type.
-- Allows the player to choose the button image, defaulting to an HD image.
-- Type: string-setting
-- Name: big-pink-eraser-button-icon
-- Setting type: startup
-- Default value: "image"
-- Allowed values: "image", "clip-art-white", "clip-art-black"
data:extend({
    {
        type = "string-setting",
        name = "big-pink-eraser-button-icon",
        setting_type = "startup",
        default_value = constants.default_image_type,
        allowed_values = constants.allowed_image_types,
    }
})
