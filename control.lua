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

    if player.cursor_stack and player.cursor_stack.valid_for_read and player.cursor_stack.name == "big-pink-eraser" then
        local surface = player.surface
        local entities = surface.find_entities(event.area)

        for _, entity in pairs(entities) do
            if entity.type ~= "tile" and entity.name ~= "character" then
                entity.destroy()
            end
        end

        player.cursor_stack.clear()

        local inventory = player.get_main_inventory()
        if inventory then
            for i = 1, #inventory do
                local stack = inventory[i]
                if stack.valid_for_read and stack.name == "big-pink-eraser" then
                    stack.clear()
                end
            end
        end
    end
end)
