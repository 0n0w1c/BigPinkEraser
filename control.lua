-- Require the constants.lua file to access shared constants.
-- This includes excluded entity types and any other shared data.
local constants = require("constants")

-- Checks if the player is holding the big-pink-eraser tool on the cursor stack.
-- This function verifies the tool held by the player, particularly during selection and cursor events.
-- @param player LuaPlayer The player whose cursor stack is being checked.
-- @return boolean Returns true if the player is holding the big-pink-eraser tool, otherwise false.
local function is_player_holding_eraser(player)
    return player.cursor_stack and player.cursor_stack.valid_for_read and player.cursor_stack.name == constants.mod_name
end

-- Determines if an entity should be excluded from destruction.
-- This function checks whether the entity type exists in the excluded_types_table table defined in constants.lua.
-- @param entity LuaEntity The entity to evaluate.
-- @return boolean Returns true if the entity is excluded from destruction, otherwise false.
local function is_entity_excluded(entity)
    return constants.excluded_types_table and constants.excluded_types_table[entity.type] ~= nil
end

-- Triggered by the shortcut event, places the big-pink-eraser tool on the player's cursor.
-- This event is triggered when the player activates the big-pink-eraser shortcut.
-- It clears the player's cursor and places the big-pink-eraser tool on it, and updates the is_eraser_on_cursor table to track this.
-- @param event LuaEvent The event data containing the player index and prototype name.
script.on_event(defines.events.on_lua_shortcut, function(event)
    if event.prototype_name ~= "big-pink-eraser" then return end

    local player = game.get_player(event.player_index)
    if not player then return end

    if game.is_multiplayer and storage.restrict_to_admins and not player.admin then
        player.print("Use of the Big Pink Eraser is restricted to admins only.")
        return
    end

    if player.clear_cursor() and player.cursor_stack then
        player.cursor_stack.set_stack({ name = constants.mod_name })
    end
end)

-- Destroys certain entities within the selected area based on exclusion criteria.
-- This event is triggered when the player selects an area using the big-pink-eraser tool.
-- Relies on the is_entity_excluded function to filter out excluded entities.
-- The tool remains on the cursor after use until manually cleared by the player.
-- @param event LuaEvent The event data containing the selected area and player index.
script.on_event(defines.events.on_player_selected_area, function(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    if not is_player_holding_eraser(player) then return end

    local surface = player.surface
    if not surface then return end

    local entities = surface.find_entities_filtered({
        area = event.area,
        force = constants.allowed_forces
    })

    for _, entity in pairs(entities) do
        if entity.valid and not is_entity_excluded(entity) then
            entity.destroy()
        end
    end
end)

--- Initializes the mod's persistent storage on game start.
-- Reads the "big-pink-eraser-admins-only" startup setting and stores its value in storage.
-- Ensures the "restrict_to_admins" flag is properly initialized for runtime use.
script.on_init(function()
    storage = storage or {}
    storage.restrict_to_admins = false

    --- Fetch the "big-pink-eraser-admins-only" setting value.
    -- @field storage.restrict_to_admins boolean Indicates whether the eraser is restricted to admins.
    if settings.startup["big-pink-eraser-admins-only"] then
        storage.restrict_to_admins = settings.startup["big-pink-eraser-admins-only"].value
    end
end)

--- Updates the mod's persistent storage when the mod configuration changes.
-- Handles changes to the "big-pink-eraser-admins-only" startup setting, ensuring consistency.
-- Triggered when mods are updated, added, or removed, or when configuration changes occur.
script.on_configuration_changed(function()
    storage = storage or {}
    storage.restrict_to_admins = false

    --- Re-fetch the "big-pink-eraser-admins-only" setting value.
    -- @field storage.restrict_to_admins boolean Ensures the "restrict_to_admins" flag remains up-to-date.
    if settings.startup["big-pink-eraser-admins-only"] then
        storage.restrict_to_admins = settings.startup["big-pink-eraser-admins-only"].value
    end
end)
