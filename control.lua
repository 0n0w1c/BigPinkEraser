--- Require the constants.lua file to access shared constants.
-- This includes excluded entity types and any other shared data.
local constants = require("constants")

--- Checks if the player is holding the big-pink-eraser tool on the cursor stack.
-- This function verifies the tool held by the player, particularly during selection and cursor events.
-- @param player LuaPlayer The player whose cursor stack is being checked.
-- @return boolean Returns true if the player is holding the big-pink-eraser tool, otherwise false.
local function is_player_holding_eraser(player)
    return player.cursor_stack and player.cursor_stack.valid_for_read and player.cursor_stack.name == constants.mod_name
end

--- Determines if an entity should be excluded from destruction.
-- This function checks whether the entity type exists in the excluded_types_table table defined in constants.lua.
-- @param entity LuaEntity The entity to evaluate.
-- @return boolean Returns true if the entity is excluded from destruction, otherwise false.
local function is_entity_excluded(entity)
    return constants.excluded_types_table and constants.excluded_types_table[entity.type] ~= nil
end

--- Triggered by the shortcut event, places the big-pink-eraser tool on the player's cursor.
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

--- Handles the destruction of entities and decoratives within a selected area.
-- This function uses an "inverse logic" approach to split functionality between
-- two modes: Factory Eraser (Normal) and Environmental & Combat Eraser (Alt).
-- @param event LuaEvent The event data containing the area and player index.
-- @param ignore_filters boolean If true (Alt-Select), targets environmental/excluded entities and clears decoratives.
local function process_deletion(event, ignore_filters)
    local player = game.get_player(event.player_index)
    if not player or not is_player_holding_eraser(player) then return end

    if ignore_filters and not settings.startup["big-pink-eraser-enable-alt-mode"].value then
        player.create_local_flying_text({
            text = "Alt-mode is disabled in startup settings",
            create_at_cursor = true
        })
        return
    end

    local surface = player.surface
    if not surface then return end

    -- Shift-Click (Alt Mode) handles the "Environment" and Decoratives
    if ignore_filters then
        surface.destroy_decoratives({ area = event.area })
    end

    -- Find entities belonging to the user's force, neutral (nature), or enemies.
    -- This ensures the tool respects force ownership in multiplayer scenarios.
    local entities = surface.find_entities_filtered({
        area = event.area,
        force = { player.force, "neutral", "enemy" }
    })

    for _, entity in pairs(entities) do
        if entity.valid and entity.type ~= "character" then
            local is_excluded = is_entity_excluded(entity)

            -- Inverse Logic Gate:
            -- If Shift is held, we delete only what IS excluded (Nature/Combat).
            -- If Shift is NOT held, we delete only what is NOT excluded (Factory).
            if ignore_filters == is_excluded then
                entity.destroy({ raise_destroy = true })
            end
        end
    end
end

script.on_event(defines.events.on_player_selected_area, function(event)
    process_deletion(event, false)
end)

script.on_event(defines.events.on_player_alt_selected_area, function(event)
    process_deletion(event, true)
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
