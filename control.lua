
local constants = require("constants")
local xoxo_text = constants.xoxo_text
local total_sprite_count = constants.xoxo_sprite_count

---@param player LuaPlayer
---@param text string
---@param position MapPosition
local function create_render_text(player, text, position)
    local render_object = rendering.draw_text {
        text = text,
        surface = player.surface,
        target = position,
        color = { player.color.r, player.color.g, player.color.b, 1 },
        time_to_live = 60,
        scale_with_zoom = true,
        scale = math.random() * 0.5 + 5,
    }
    storage.render_objects = storage.render_objects or {}
    table.insert(storage.render_objects, {
        origin = { x = player.position.x - 0.5, y = player.position.y - 1.75 },
        direction = math.random() < 0.5 and -1 or 1,
        created_tick = game.tick,
        upward_speed = 0.035 + math.random() * 0.015,
        sideways_speed = 0.018 + math.random() * 0.015,
        gravity = 0.00035 + math.random() * 0.00015,
        render_object = render_object,
    })
end

---@param player LuaPlayer
---@param position MapPosition
local function create_render_sprite(player, position)
    local sprite_index = math.random(1, 113)
    local render_object = rendering.draw_sprite {
        sprite = "xoxo_" .. sprite_index,
        surface = player.surface,
        target = position,
        tint = { player.color.r, player.color.g, player.color.b, 0.5 },
        time_to_live = 90,
        x_scale = 1 / 50,
        y_scale = 1 / 50,
        orientation_target = position,
        orientation = 0.5
    }
    storage.render_objects = storage.render_objects or {}
    table.insert(storage.render_objects, {
        origin = { x = player.position.x - 0.0, y = player.position.y - 1.65 },
        direction = math.random() < 0.5 and -1 or 1,
        created_tick = game.tick,
        upward_speed = 0.035 + math.random() * 0.025,
        sideways_speed = 0.018 + math.random() * 0.025,
        gravity = 0.00035 + math.random() * 0.00025,
        render_object = render_object,
    })
end

---@param event EventData.CustomInputEvent
local function on_hug(event)
    local player_index = event.player_index
    storage.xoxo = storage.xoxo or {}
    storage.xoxo[player_index] = storage.xoxo[player_index] or {}
    storage.xoxo[player_index].hugs = (storage.xoxo[player_index].hugs or 0) + 1
    local text = xoxo_text[math.random(1, #xoxo_text)]
    local player = game.get_player(player_index)
    if player then
        create_render_sprite(player, player.position)
        -- create_render_text(player, "o", player.position)
    end
end

---@param event EventData.CustomInputEvent
local function on_kiss(event)
    local player_index = event.player_index
    storage.xoxo = storage.xoxo or {}
    storage.xoxo[player_index] = storage.xoxo[player_index] or {}
    storage.xoxo[player_index].kisses = (storage.xoxo[player_index].kisses or 0) + 1
    local text = xoxo_text[math.random(1, #xoxo_text)]
    local player = game.get_player(player_index)
    if player then
        create_render_sprite(player, player.position)
        -- create_render_text(player, "x", player.position)
    end
end

script.on_event("xoxo-hug", on_hug)
script.on_event("xoxo-kiss", on_kiss)

local function on_tick(event)
    --[[@type table<integer, xoxo_data>]]
    storage.xoxo = storage.xoxo or {}
    for _, player in pairs(game.connected_players) do
        local player_index = player.index
        storage.xoxo[player_index] = storage.xoxo[player_index] or {}
        local hugs = storage.xoxo[player_index].hugs or 0
        local kisses = storage.xoxo[player_index].kisses or 0
        if hugs > 0 and kisses > 0 then
            if math.random() < 0.125 then
                create_render_sprite(player, player.position)
                -- local text = xoxo_text[math.random(1, #xoxo_text)]
                -- create_render_text(player, text, player.position)
            end
        end
        if event.tick % 1 == 0 then
            if hugs > 0 then
                hugs = math.max(0, hugs - 0.075)
                storage.xoxo[player_index].hugs = hugs
            end
            if kisses > 0 then
                kisses = math.max(0, kisses - 0.075)
                storage.xoxo[player_index].kisses = kisses
            end
        end
    end
    --[[@type xoxo_render_object[] ]]
    storage.render_objects = storage.render_objects or {}
    for i = #storage.render_objects, 1, -1 do
        local xoxo_render_object = storage.render_objects[i]
        local render_object = xoxo_render_object.render_object
        if render_object.valid then
            local position = render_object.target.position
            if position then
                local age = event.tick - xoxo_render_object.created_tick
                local x = xoxo_render_object.origin.x
                    + xoxo_render_object.direction * xoxo_render_object.sideways_speed * age
                local y = xoxo_render_object.origin.y
                    - xoxo_render_object.upward_speed * age
                    + xoxo_render_object.gravity * age * age
                render_object.target = { x = x, y = y }
            end
        else
            table.remove(storage.render_objects, i)
        end
    end
end

script.on_event(defines.events.on_tick, on_tick)

---@class xoxo_data
---@field hugs number
---@field kisses number

---@class xoxo_render_object
---@field origin MapPosition
---@field direction number
---@field created_tick uint
---@field upward_speed number
---@field sideways_speed number
---@field gravity number
---@field render_object LuaRenderObject
