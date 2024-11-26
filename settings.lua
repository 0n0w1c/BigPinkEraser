-- Require the constants.lua file to access shared constants.
-- This includes button colors and image types.
local constants = require("constants")

-- Defines a startup setting for the Big Pink Eraser shortcut button style.
-- Allows the player to choose the button color, defaulting to gray.
-- Defines a startup setting for the Big Pink Eraser shortcut button style.
-- Allows the player to choose the button color, defaulting to gray.
-- @field type string The type of setting, in this case, a string-setting.
-- @field name string The internal name of the setting used to reference it in the code.
-- @field setting_type string Specifies that this is a startup setting.
-- @field default_value string The default button color ("gray"), mapped internally to "default".
-- @field allowed_values table The list of selectable colors for the shortcut button (gray, red, green, blue).
data:extend({
    {
        type = "string-setting",
        name = "big-pink-eraser-button-style",
        setting_type = "startup",
        default_value = constants.default_button_color,
        allowed_values = constants.allowed_button_colors,
        order = "a"
    }
})

-- Defines a startup setting for the Big Pink Eraser button image type.
-- Allows the player to choose the button image, defaulting to an HD image.
-- @field type string The type of setting, in this case, a string-setting.
-- @field name string The internal name of the setting used to reference it in the code.
-- @field setting_type string Specifies that this is a startup setting, configured before the game starts.
-- @field default_value string The default button image type ("image").
-- @field allowed_values table The list of available button image types (image, clip-art-white, clip-art-black).
data:extend({
    {
        type = "string-setting",
        name = "big-pink-eraser-button-icon",
        setting_type = "startup",
        default_value = constants.default_image_type,
        allowed_values = constants.allowed_image_types,
        order = "b"
    }
})

-- Defines a startup setting to restrict the Big Pink Eraser shortcut to admins.
-- @field type string The type of setting, in this case, a bool-setting.
-- @field name string The internal name of the setting used to reference it in the code.
-- @field setting_type string Specifies that this is a startup setting, configured before the game starts.
-- @field default_value boolean Whether the shortcut is restricted to admins by default (true).
data:extend({
    {
        type = "bool-setting",
        name = "big-pink-eraser-admins-only",
        setting_type = "startup",
        default_value = false,
        order = "c"
    }
})
