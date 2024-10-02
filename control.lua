--- Table of entity types that are to be excluded from destruction.
-- The keys are entity types, and the values are boolean flags indicating exclusion.
-- @type table<string, boolean>
local excluded_types = {
    ["cliff"] = true,
    ["decorative"] = true,
    ["fish"] = true,
    ["resource"] = true,
    ["simple-entity"] = true,
    ["tile"] = true,
    ["tree"] = true,
}

--- Triggered by the shortcut event, places the big-pink-eraser tool on the player's cursor.
-- @param event Event Data about the shortcut, including player index and shortcut prototype name.
script.on_event(defines.events.on_lua_shortcut, function(event)
    if event.prototype_name == "big-pink-eraser" then
        --- Get the player who triggered the event.
        -- @type LuaPlayer
        local player = game.get_player(event.player_index)
        if not player then return end

        -- Clear the player's cursor and set the big-pink-eraser tool if successful.
        if player.clear_cursor() then
            player.cursor_stack.set_stack({ name = "big-pink-eraser" }) -- Set the tool in the player's cursor
        end
    end
end)

--- Destroys certain entities within the selected area based on exclusion criteria.
-- @param event Event Data containing the selected area and player index.
script.on_event(defines.events.on_player_selected_area, function(event)
    --- Get the player who triggered the event.
    -- @type LuaPlayer
    local player = game.get_player(event.player_index)
    if not player then return end

    --- Check if the player is holding the big-pink-eraser tool.
    -- @type LuaItemStack
    if player.cursor_stack and player.cursor_stack.valid_for_read and player.cursor_stack.name == "big-pink-eraser" then
        local surface = player.surface
        --- Entities found in the selected area.
        -- @type LuaEntity[]
        local entities = surface.find_entities(event.area)

        --- Loop through all entities found in the selected area and destroy non-excluded entities.
        -- @param entity LuaEntity The entity being evaluated for destruction.
        for _, entity in pairs(entities) do
            if entity.valid and not excluded_types[entity.type] and entity.force.name ~= "enemy" and entity.name ~= "character" then
                entity.destroy()
            end
        end

        --- Clear the player's cursor stack (removes the tool from the cursor).
        player.cursor_stack.clear()

        --- Removes all instances of the big-pink-eraser tool from the player's inventory.
        player.remove_item { name = "big-pink-eraser" }
    end
end)
