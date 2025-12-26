local constants = require("constants")

local function is_player_holding_eraser(player)
    return player.cursor_stack and player.cursor_stack.valid_for_read and player.cursor_stack.name == constants.mod_name
end

local function is_environment_entity(entity)
    return constants.excluded_types_table and constants.excluded_types_table[entity.type] ~= nil
end

script.on_event(defines.events.on_lua_shortcut, function(event)
    if event.prototype_name ~= "big-pink-eraser" then return end

    local player = game.get_player(event.player_index)
    if not player then return end

    local restrict_to_admins = settings.startup["big-pink-eraser-admins-only"].value
    if game.is_multiplayer and restrict_to_admins and not player.admin then
        player.print("Use of the Big Pink Eraser is restricted to admins only.")
        return
    end

    if player.clear_cursor() and player.cursor_stack then
        player.cursor_stack.set_stack({ name = constants.mod_name })
    end
end)

local function process_deletion(event, is_alt_mode)
    local player = game.get_player(event.player_index)
    if not player or not is_player_holding_eraser(player) then return end

    if is_alt_mode and not settings.startup["big-pink-eraser-enable-alt-mode"].value then
        player.create_local_flying_text({
            text = "Alternate mode is disabled in startup settings",
            create_at_cursor = true
        })
        return
    end

    local surface = player.surface
    if not surface then return end

    local search_params = { area = event.area }

    if is_alt_mode and game.is_multiplayer and player.admin then
    else
        search_params.force = { player.force, "neutral", "enemy" }
    end

    if is_alt_mode then
        surface.destroy_decoratives({ area = event.area })
    end

    local entities = surface.find_entities_filtered(search_params)

    for _, entity in pairs(entities) do
        if entity.valid and entity.type ~= "character" then
            local is_env = is_environment_entity(entity)

            if is_alt_mode == is_env then
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
