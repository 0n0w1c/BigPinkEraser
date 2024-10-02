script.on_event(defines.events.on_lua_shortcut, function(event)
    if event.prototype_name == "big-pink-eraser" then
        local player = game.get_player(event.player_index)
        if not player then return end

        if player.clear_cursor() then
            player.cursor_stack.set_stack({ name = "big-pink-eraser" })
        end
    end
end)

script.on_event(defines.events.on_player_selected_area, function(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    -- Check if the player is holding the "big-pink-eraser" tool
    if player.cursor_stack and player.cursor_stack.valid_for_read and player.cursor_stack.name == "big-pink-eraser" then
        local surface = player.surface
        local entities = surface.find_entities(event.area)

        -- Get the setting value for excluding environmental entities
        local exclude_environmental = settings.get_player_settings(player)["bpe-environmental-entities"].value

        -- Destroy non-tile entities, but skip the player character, resource tiles, and certain environmental entities
        for _, entity in pairs(entities) do
            if entity.type ~= "tile" and entity.name ~= "character" and entity.type ~= "resource" then
                -- Skip environmental entities if the setting is enabled
                if exclude_environmental then
                    if entity.type ~= "decorative" and entity.type ~= "cliff" and entity.type ~= "tree" and entity.type ~= "simple-entity" then
                        entity.destroy()
                    end
                else
                    entity.destroy()
                end
            end
        end

        -- Clear the cursor stack
        player.cursor_stack.clear()

        -- Remove all "big-pink-eraser" tools from the player's inventory
        local inventory = player.get_main_inventory()
        if inventory then
            for i = 1, #inventory do
                local stack = inventory[i]
                if stack.valid_for_read and stack.name == "big-pink-eraser" then
                    stack.clear() -- Clear the entire stack if it's a big-pink-eraser
                end
            end
        end
    end
end)
