
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
