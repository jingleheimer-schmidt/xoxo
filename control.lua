
local xoxo_text = {
    ":-*",
    ":*",
    ";*",
    ";-*",
    "=*",
    ":x",
    ":X",
    "xx",
    "xxx",
    "xxxx",
    "xox",
    "xoxo",
    "xo xo",
    "mwah",
    "*mwah*",
    "muah",
    "muah!",
    "x",
    "X",
    "xo",
    "xoxo",
    "XOXO",
    ":*",
    ":-*",
    ":x",
    ":-x",
    "*smooch*",
    "*kiss*",
    "*kith*",
    "mwah~*",
    "chu~",
    "chu!",
    "chu♡",
    "xo~xo",
    "xoxo~",
}

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

---@param event EventData.CustomInputEvent
local function on_hug(event)
    local player_index = event.player_index
    storage.xoxo = storage.xoxo or {}
    storage.xoxo[player_index] = storage.xoxo[player_index] or {}
    storage.xoxo[player_index].hugs = (storage.xoxo[player_index].hugs or 0) + 1
    local text = xoxo_text[math.random(1, #xoxo_text)]
    local player = game.get_player(player_index)
    if player then
        create_render_text(player, "o", player.position)
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
        create_render_text(player, "x", player.position)
    end
end

script.on_event("xoxo-hug", on_hug)
script.on_event("xoxo-kiss", on_kiss)
