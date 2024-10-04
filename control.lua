--- Local table to track when the big-pink-eraser is on the cursor for each player.
-- This table is indexed by player index and stores a boolean value.
-- @type table<int, boolean>
local eraser_on_cursor = {}

--- Table of entity types that are to be excluded from destruction.
-- The keys are entity types, and the values are boolean flags indicating exclusion.
-- @type table<string, boolean>
local excluded_types = {
    ["character"] = true,
    ["cliff"] = true,
    ["decorative"] = true,
    ["fish"] = true,
    ["resource"] = true,
    ["simple-entity"] = true,
    ["tile"] = true,
    ["tree"] = true,
}

--- Checks if the player is holding the big-pink-eraser tool.
-- @param player LuaPlayer The player whose cursor stack is being checked.
-- @return boolean Returns true if the player is holding the big-pink-eraser tool, otherwise false.
local function is_player_holding_eraser(player)
    return player.cursor_stack and player.cursor_stack.valid_for_read and player.cursor_stack.name == "big-pink-eraser"
end

--- Determines if an entity should be excluded from destruction.
-- This function checks whether the entity type exists in the excluded_types table.
-- @param entity LuaEntity The entity to evaluate.
-- @return boolean Returns true if the entity is excluded from destruction, otherwise false.
local function is_entity_excluded(entity)
    return excluded_types[entity.type] ~= nil
end

--- Initialize the mod state on game startup or mod reload.
-- This function ensures that the eraser_on_cursor table is initialized when the mod starts or reloads.
script.on_init(function()
    eraser_on_cursor = {}
end)

--- Handles mod configuration changes (such as mod updates or settings changes).
-- This function ensures that necessary state (like eraser_on_cursor) is reinitialized if needed.
-- Rebuilds the eraser_on_cursor table by checking each player's current cursor stack, but only if eraser_on_cursor has been reset.
-- @param event LuaEvent The event data indicating what configuration has changed.
script.on_configuration_changed(function(event)
    -- Check if eraser_on_cursor has been reset or lost.
    if not eraser_on_cursor then
        -- Reinitialize the eraser_on_cursor table.
        eraser_on_cursor = {}

        -- Rebuild the eraser_on_cursor table by examining each player's cursor if there are connected players.
        if game.connected_players and #game.connected_players > 0 then
            for _, player in pairs(game.connected_players) do
                -- Check if the player is holding the big-pink-eraser tool.
                if player.cursor_stack and player.cursor_stack.valid_for_read and player.cursor_stack.name == "big-pink-eraser" then
                    -- Update the table to track that the player is holding the tool.
                    eraser_on_cursor[player.index] = true
                else
                    -- If not holding the eraser, set the table entry to nil.
                    eraser_on_cursor[player.index] = nil
                end
            end
        end
    end
end)

--- Triggered by the shortcut event, places the big-pink-eraser tool on the player's cursor.
-- This event is triggered when the player activates the "big-pink-eraser" shortcut.
-- It clears the player's cursor and places the big-pink-eraser tool on it, and updates the eraser_on_cursor table to track this.
-- @param event LuaEvent The event data containing the player index and prototype name.
script.on_event(defines.events.on_lua_shortcut, function(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    -- Clear player cursor and set the big-pink-eraser tool.
    if player.clear_cursor() then
        player.cursor_stack.set_stack({ name = "big-pink-eraser" })

        -- Track that the big-pink-eraser is on the player's cursor.
        eraser_on_cursor[player.index] = true
    end
end)

--- Destroys certain entities within the selected area based on exclusion criteria.
-- This event is triggered when the player selects an area using the big-pink-eraser tool.
-- The mod checks the type of each entity in the selected area, excludes entities like cliffs, resources, and the player character,
-- and destroys all non-excluded entities.
-- The tool remains on the cursor after use until manually cleared by the player.
-- @param event LuaEvent The event data containing the selected area and player index.
script.on_event(defines.events.on_player_selected_area, function(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    -- Check if the player is holding the big-pink-eraser tool.
    if not is_player_holding_eraser(player) then return end

    local surface = player.surface
    if not surface then return end

    -- Find entities in the selected area and filter them by neutral and player forces.
    local entities = surface.find_entities_filtered({
        area = event.area,
        force = { "neutral", "player" }
    })

    -- Loop through all entities and destroy those that are not excluded.
    for _, entity in pairs(entities) do
        if entity.valid and not is_entity_excluded(entity) and (entity.force == player.force or entity.force.name == "neutral") then
            entity.destroy()
        end
    end
end)

--- Removes any big-pink-eraser tools from the player's inventory when the cursor is cleared.
-- This event is triggered when the player's cursor stack changes (e.g., when the player clears the cursor).
-- @param event LuaEvent The event data containing the player index.
script.on_event(defines.events.on_player_cursor_stack_changed, function(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    -- Check if the big-pink-eraser tool was on the cursor and if the cursor is now empty.
    if eraser_on_cursor[player.index] and not player.cursor_stack.valid_for_read then
        -- Remove all instances of the big-pink-eraser tool from the player's inventory.
        player.remove_item { name = "big-pink-eraser" }

        -- Clear the tracking flag.
        eraser_on_cursor[player.index] = nil
    end
end)
