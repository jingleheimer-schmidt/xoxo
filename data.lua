
---@type data.CustomInputPrototype
local hugs = {
    type = "custom-input",
    name = "xoxo-hug",
    key_sequence = "o",
    alternative_key_sequence = "O",
    action = "lua",
}

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

local path = "__xoxo__/graphics/standardized/xoxo_"
local total_sprite_count = 113
for i = 1, total_sprite_count do
    --[[@type data.SpritePrototype]]
    local sprite = {
        type = "sprite",
        name = "xoxo_" .. i,
        filename = path .. i .. ".png",
        width = 836,
        height = 836,
        apply_runtime_tint = true,
        invert_colors = true,
        usage = "player"
    }
    data:extend { sprite }
end
