-- Constants shared between settings.lua, data.lua, and control.lua.
-- This file contains allowed image types, excluded entity types, button colors, and utility functions.
local constants = {}

-- The mod path used to access assets like icons and graphics.
constants.mod = "__big-pink-eraser__"

-- Base path to the icons folder.
constants.icon_path = constants.mod .. "/graphics/icons/"

-- Table of allowed button colors for the Big Pink Eraser shortcut.
constants.allowed_button_colors = { "gray", "red", "green", "blue" }

-- Default button color for the Big Pink Eraser shortcut.
constants.default_button_color = "gray"

-- Table of allowed image types for the Big Pink Eraser tool.
constants.allowed_image_types = { "image", "clip-art-white", "clip-art-black" }

-- Default image type for the Big Pink Eraser tool.
constants.default_image_type = "image"

-- Forces used for filtering in entity searches.
constants.allowed_forces = { "neutral", "player" }

-- Table of entity types that are excluded from destruction by the Big Pink Eraser tool.
-- The keys represent entity types, and the values are boolean flags indicating exclusion.
constants.excluded_types = {
    ["character"] = true,
    ["cliff"] = true,
    ["decorative"] = true,
    ["fish"] = true,
    ["resource"] = true,
    ["simple-entity"] = true,
    ["tile"] = true,
    ["tree"] = true,
}

return constants
