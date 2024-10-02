--- Handles the shortcut event for the big-pink-eraser tool.
-- When the shortcut is triggered, the big-pink-eraser tool is placed in the player's cursor.
-- @param event Event containing data about the shortcut, including the player index and the shortcut prototype name.
-- @return nil No return value.
script.on_event(defines.events.on_lua_shortcut, function(event)
    -- Check if the shortcut event is for the "big-pink-eraser" tool
    if event.prototype_name == "big-pink-eraser" then
        --- Get the player who triggered the event
        -- @type LuaPlayer
        local player = game.get_player(event.player_index)
        if not player then return end -- Exit if no player is found

        -- Clear the player's cursor and set the big-pink-eraser tool if successful
        if player.clear_cursor() then
            player.cursor_stack.set_stack({ name = "big-pink-eraser" }) -- Set the tool in the player's cursor
        end
    end
end)

--- Handles the selection area event triggered by the player using the big-pink-eraser tool.
-- This function destroys certain entities within the selected area based on settings.
-- @param event Event data containing information about the selected area and player index.
-- @return nil No return value.
script.on_event(defines.events.on_player_selected_area, function(event)
    --- Get the player who triggered the event
    -- @type LuaPlayer
    local player = game.get_player(event.player_index)
    if not player then return end -- Exit if no player is found

    --- Check if the player is holding the big-pink-eraser tool
    -- @type LuaItemStack
    if player.cursor_stack and player.cursor_stack.valid_for_read and player.cursor_stack.name == "big-pink-eraser" then
        local surface = player.surface
        --- Entities found in the selected area
        -- @type LuaEntity[]
        local entities = surface.find_entities(event.area)

        --- Loop through all entities found in the selected area
        for _, entity in pairs(entities) do
            -- Skip tile entities, the player character, resource entities, enemy forces, and environmental entities
            if entity.force.name ~= "enemy" and
                entity.name ~= "character" and
                entity.type ~= "cliff" and
                entity.type ~= "decorative" and
                entity.type ~= "resource" and
                entity.type ~= "simple-entity" and
                entity.type ~= "tile" and
                entity.type ~= "tree" then
                entity.destroy() -- Destroy non-excluded entities
            end
        end

        --- Clear the player's cursor stack (removes the tool from the cursor)
        player.cursor_stack.clear()

        --- Remove all big-pink-eraser tools from the player's inventory
        -- @type LuaInventory
        local inventory = player.get_main_inventory()
        if inventory then
            for i = 1, #inventory do
                local stack = inventory[i]
                if stack.valid_for_read and stack.name == "big-pink-eraser" then
                    stack.clear() -- Clear the stack if it's a big-pink-eraser tool
                end
            end
        end
    end
end)
