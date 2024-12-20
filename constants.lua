local constants = {}

constants.mod_name = "big-pink-eraser"
constants.mod_path = "__" .. constants.mod_name .. "__/"
constants.icon_path = constants.mod_path .. "graphics/icons/"
constants.tool_icon = constants.icon_path .. "clip-art-tool.png"
constants.icon_size = 32
constants.icon_size_small = 24
constants.allowed_button_colors = { "gray", "red", "green", "blue" }
constants.default_button_color = "gray"
constants.allowed_image_types = { "image", "clip-art-pink", "clip-art-white", "clip-art-black" }
constants.default_image_type = "clip-art-black"
constants.allowed_forces = { "neutral", "player" }
constants.white = { r = 1, g = 1, b = 1, a = 1 }
constants.tool_order = "c[automated-construction]-a[big-pink-eraser]"
constants.shortcut_order = "a[tools]-c[big-pink-eraser]"
constants.excluded_types_list = { "character", "cliff", "decorative", "fish", "resource", "simple-entity", "tile", "tree" }

local function create_excluded_types_table()
    local excluded_types_table = {}

    for _, type in ipairs(constants.excluded_types_list) do
        excluded_types_table[type] = true
    end

    return excluded_types_table
end

constants.excluded_types_table = create_excluded_types_table()

return constants
