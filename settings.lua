--- Defines a startup setting for the Big Pink Eraser shortcut button style.
-- Allows the player to choose the button color, defaulting to gray.
-- @field type The type of setting, in this case, a string-setting.
-- @field name The internal name of the setting used to reference it in the code.
-- @field setting_type Specifies that this is a startup setting.
-- @field default_value The default button color ("gray"), mapped internally to "default".
-- @field allowed_values List of selectable colors for the shortcut button (gray, red, green, blue).
-- @field order Defines the order in which the setting appears in the settings menu.
data:extend({
    {
        type = "string-setting",
        name = "big-pink-eraser-style",
        setting_type = "startup",
        default_value = "gray",
        allowed_values = { "gray", "red", "green", "blue" },
        order = "a"
    }
})

--- Defines a startup setting for the Big Pink Eraser button image type.
-- Allows the player to choose the button image, defaulting to an HD image.
-- @field type The type of setting, in this case, a string-setting.
-- @field name The internal name of the setting used to reference it in the code.
-- @field setting_type Specifies that this is a startup setting, configured before the game starts.
-- @field default_value The default button image type ("hd image").
-- @field allowed_values List of available button image types (hd image, clip art (white), clip art (black)).
-- @field order Defines the order in which the setting appears in the settings menu.
data:extend({
    {
        type = "string-setting",
        name = "big-pink-eraser-button-icon",
        setting_type = "startup",
        default_value = "image",
        allowed_values = { "image", "clip-art-white", "clip-art-black" },
        order = "b"
    }
})
