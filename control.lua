
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
    local angle = -math.pi + math.random() * math.pi
    local speed = 0.045 + math.random() * 0.025
    local velocity_x = math.cos(angle) * speed
    local velocity_y = math.sin(angle) * speed
    table.insert(storage.render_objects, {
        origin = { x = position.x - 0.5, y = position.y - 1.75 },
        created_tick = game.tick,
        gravity = 0.00035 + math.random() * 0.00015,
        velocity_x = velocity_x,
        velocity_y = velocity_y,
        render_object = render_object,
    })
end

---@param player LuaPlayer
---@param position MapPosition
local function create_render_sprite(player, position)
    local sprite_index = math.random(1, total_sprite_count)
    local scale = 1 / (50 + math.random(-10, 10))
    local render_object = rendering.draw_sprite {
        sprite = "xoxo_" .. sprite_index,
        surface = player.surface,
        target = position,
        tint = { player.color.r, player.color.g, player.color.b, player.color.a },
        time_to_live = 95,
        x_scale = scale,
        y_scale = scale,
        orientation_target = position,
        orientation = 0.5
    }
    storage.render_objects = storage.render_objects or {}
    local angle = -math.pi + math.random() * math.pi
    local speed = 0.045 + math.random() * 0.025
    local velocity_x = math.cos(angle) * speed
    local velocity_y = math.sin(angle) * speed
    table.insert(storage.render_objects, {
        origin = { x = position.x - 0.0, y = position.y - 1.65 },
        created_tick = game.tick,
        gravity = 0.00035 + math.random() * 0.00025,
        velocity_x = velocity_x,
        velocity_y = velocity_y,
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
        local character = player.character
        if not character then return end
        create_render_sprite(player, character.position)
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
        local character = player.character
        if not character then return end
        create_render_sprite(player, character.position)
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
            if math.random() < 0.15 then
                local character = player.character
                if not character then return end
                create_render_sprite(player, character.position)
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
                    + xoxo_render_object.velocity_x * age
                local y = xoxo_render_object.origin.y
                    + xoxo_render_object.velocity_y * age
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
---@field created_tick uint
---@field gravity number
---@field velocity_x number
---@field velocity_y number
---@field render_object LuaRenderObject
