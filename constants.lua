-- Constants shared between settings.lua, data.lua, and control.lua.
-- This file contains allowed image types, excluded entity types, button colors, and utility functions.
local constants = {}

-- Mod name
constants.mod_name = "big-pink-eraser"

-- The mod path used to access assets like icons and graphics
constants.mod_path = "__" .. constants.mod_name .. "__/"

-- Base path to the icons folder.
constants.icon_path = constants.mod_path .. "graphics/icons/"

-- Path to the image icon
constants.image = constants.icon_path .. "big-pink-eraser.png"

-- Path to the pink clip-art icon
constants.pink_clip_art = constants.icon_path .. "clip-art-pink.png"

-- Table of allowed button colors for the Big Pink Eraser shortcut
constants.allowed_button_colors = { "gray", "red", "green", "blue" }

-- Default button color for the Big Pink Eraser shortcut
constants.default_button_color = "gray"

-- Table of allowed image types for the Big Pink Eraser tool
constants.allowed_image_types = { "image", "clip-art-white", "clip-art-black" }

-- Default image type for the Big Pink Eraser tool
constants.default_image_type = "image"

-- Forces used for filtering in entity searches
constants.allowed_forces = { "neutral", "player" }

-- The color pink used for the selection box
constants.pink = { r = 1, g = 0.44, b = 0.71 }

-- Sort order for the selection tool
constants.tool_order = "c[automated-construction]-a[big-pink-eraser]"

-- Sort order for the shortcut
constants.shortcut_order = "a[tools]-c[big-pink-eraser]"

-- Small icon size
constants.icon_size_small = 32

-- List of entity types that are excluded from destruction by the Big Pink Eraser tool
constants.excluded_types_list = { "character", "cliff", "decorative", "fish", "resource", "simple-entity", "tile", "tree" }

-- Create the excluded_types_table table from the excluded_strings list
local function create_excluded_types_table()
    local excluded_types_table = {}

    -- Loop through each string in constants.excluded_list
    for _, type in ipairs(constants.excluded_types_list) do
        excluded_types_table[type] = true
    end

    return excluded_types_table
end

constants.excluded_types_table = create_excluded_types_table()

return constants
