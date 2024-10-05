--- Local table to track when the big-pink-eraser is on the cursor for each player.
-- This table is indexed by player index and stores a boolean value indicating whether the tool is on the player's cursor.
-- @type table<int, boolean>
local is_eraser_on_cursor = {}

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

--- Checks if the player is holding the big-pink-eraser tool on the cursor stack.
-- This function is used to verify the current tool held by the player, particularly during selection and cursor events.
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

--- Reinitializes the is_eraser_on_cursor table and checks if the player is holding the tool.
-- This function is called during mod initialization and configuration changes to rebuild the table.
-- It ensures that the state is correctly tracked after game events or mod updates.
local function reinitialize_eraser_tracking()
    is_eraser_on_cursor = {}
    if game.connected_players and #game.connected_players > 0 then
        for _, player in pairs(game.connected_players) do
            -- Check if the player is holding the big-pink-eraser tool.
            if is_player_holding_eraser(player) then
                is_eraser_on_cursor[player.index] = true
            else
                is_eraser_on_cursor[player.index] = nil
            end
        end
    end
end

--- Initialize the mod state on game startup.
-- This calls reinitialize_eraser_tracking to ensure the is_eraser_on_cursor table is initialized when the mod starts.
script.on_init(function()
    reinitialize_eraser_tracking()
end)

--- Handles mod configuration changes (such as mod updates or settings changes).
-- Calls reinitialize_eraser_tracking to rebuild the is_eraser_on_cursor table by checking each player's current cursor stack.
-- @param event LuaEvent The event data indicating what configuration has changed.
script.on_configuration_changed(function(event)
    reinitialize_eraser_tracking()
end)

--- Triggered by the shortcut event, places the big-pink-eraser tool on the player's cursor.
-- This event is triggered when the player activates the "big-pink-eraser" shortcut.
-- It clears the player's cursor and places the big-pink-eraser tool on it, and updates the is_eraser_on_cursor table to track this.
-- @param event LuaEvent The event data containing the player index and prototype name.
script.on_event(defines.events.on_lua_shortcut, function(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    -- Clear player cursor and set the big-pink-eraser tool.
    if player.clear_cursor() then
        player.cursor_stack.set_stack({ name = "big-pink-eraser" })

        -- Track that the big-pink-eraser is on the player's cursor.
        is_eraser_on_cursor[player.index] = true
    end
end)

--- Destroys certain entities within the selected area based on exclusion criteria.
-- This event is triggered when the player selects an area using the big-pink-eraser tool.
-- Relies on the is_entity_excluded function to filter out excluded entities.
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
        if entity.valid and not is_entity_excluded(entity) then
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
    if is_eraser_on_cursor[player.index] and not player.cursor_stack.valid_for_read then
        -- Get the count of "big-pink-eraser" tools in the player's inventory.
        local count = player.get_item_count("big-pink-eraser")

        -- Only remove the items if any exist in the inventory.
        if count > 0 then
            -- Remove all instances of the big-pink-eraser tool from the player's inventory.
            player.remove_item { name = "big-pink-eraser", count = count }
        end

        -- Clear the tracking flag.
        is_eraser_on_cursor[player.index] = nil
    end
end)
