
---@type data.CustomInputPrototype
local hugs = {
    type = "custom-input",
    name = "xoxo-hug",
    key_sequence = "o",
    alternative_key_sequence = "O",
    action = "lua",
}

---@type data.CustomInputPrototype
local kisses = {
    type = "custom-input",
    name = "xoxo-kiss",
    key_sequence = "x",
    alternative_key_sequence = "X",
    action = "lua",
}

data:extend {
    hugs,
    kisses,
}

local constants = require("constants")
local path = constants.xoxo_sprite_path
local total_sprite_count = constants.xoxo_sprite_count

for i = 1, total_sprite_count do
    ---@type data.SpritePrototype
    local sprite = {
        type = "sprite",
        name = "xoxo_" .. i,
        filename = path .. i .. ".png",
        width = 836,
        height = 836,
        scale = 32 / 836,
        tint = { .8, .8, .8, .9 },
        apply_runtime_tint = true,
        invert_colors = true,
        usage = "player"
    }
    data:extend { sprite }
    ---@type data.StickerPrototype
    local sticker = {
        type = "sticker",
        name = "xoxo_" .. i,
        animation = sprite --[[@as data.Animation]],
        duration_in_ticks = 60 * 69,
        hidden = true,
        hidden_in_factoriopedia = true,
        damage_interval = 1,
        damage_per_tick = { amount = -0.01, type = "physical" },
    }
    data:extend { sticker }
end
