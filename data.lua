
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
        name = "xoxo_sticker_" .. i,
        animation = table.deepcopy(sprite) --[[@as data.Animation]],
        duration_in_ticks = 60 * 69,
        hidden = true,
        hidden_in_factoriopedia = true,
        damage_interval = 1,
        damage_per_tick = { amount = -0.01, type = "physical" },
        stickers_per_square_meter = 25,
    }
    sticker.animation.scale = 2 / 836
    data:extend { sticker }
    ---@type data.ProjectilePrototype
    local projectile = {
        type = "projectile",
        name = "xoxo_projectile_" .. i,
        acceleration = 0.01,
        animation = sprite --[[@as data.Animation]],
        action = {
            {
                type = "area",
                radius = 0.25,
                action_delivery = {
                    type = "instant",
                    target_effects = {
                        {
                            type = "create-sticker",
                            sticker = "xoxo_sticker_" .. i
                        }
                    }
                }
            }
        },
        hidden = true,
        hidden_in_factoriopedia = true,
    }
    data:extend { projectile }
end

---@type data.ProjectilePrototype
local xoxo_barrel_projectile = {
    type = "projectile",
    name = "xoxo_barrel_projectile",
    acceleration = 0.01,
    animation = {
        filename = "__xoxo__/graphics/barrel/xoxo_barrel.png",
        width = 64,
        height = 64,
        frame_count = 1,
        direction_count = 1,
        scale = 1 / 4,
    },
    rotatable = true,
    action = {
        -- {
        --     type = "area",
        --     radius = 2,
        --     action_delivery = {
        --         type = "instant",
        --         target_effects = {}
        --     }
        -- },
        {
            type = "direct",
            action_delivery = {
                type = "instant",
                target_effects = {
                    type = "script",
                    effect_id = "xoxo_barrel",
                }
            }
        }
    },
    hidden = true,
    hidden_in_factoriopedia = true,
}

-- for i = 1, total_sprite_count do
--     ---@type data.CreateEntityTriggerEffectItem
--     local target_effect = {
--         type = "create-entity",
--         entity_name = "xoxo_" .. i .. "_projectile",
--     }
--     table.insert(xoxo_barrel_projectile.action[1].action_delivery.target_effects, target_effect)
--     -- ---@type data.CreateStickerTriggerEffectItem 
--     -- local target_effect = {
--     --     type = "create-sticker",
--     --     sticker = "xoxo_" .. i
--     -- }
--     -- table.insert(xoxo_barrel_projectile.action[1].action_delivery.target_effects, target_effect)
-- end

---@type data.CapsulePrototype
local xoxo_barrel_capsule = {
    type = "capsule",
    name = "xoxo_barrel",
    icon = "__xoxo__/graphics/barrel/xoxo_barrel.png",
    icon_size = 64,
    stack_size = 100,
    subgroup = "capsule",
    order = "a[barrel]-a[xoxo]",
    capsule_action = {
        type = "throw",
        attack_parameters = {
            type = "projectile",
            ammo_category = "capsule",
            cooldown = 30,
            range = 50,
            ammo_type = {
                category = "capsule",
                target_type = "position",
                action = {
                    type = "direct",
                    action_delivery = {
                        type = "projectile",
                        projectile = "xoxo_barrel_projectile",
                        starting_speed = 0.3
                    }
                }
            }
        }
    }
}

---@type data.RecipePrototype
local xoxo_barrel_recipe = {
    type = "recipe",
    name = "xoxo_barrel",
    enabled = false,
    ingredients = {
        { type = "item", name = "steel-plate", amount = 1 }
    },
    results = {
        { type = "item", name = "xoxo_barrel", amount = 10 }
    }
}

---@type data.TechnologyPrototype
local xoxo_barrel_technology = {
    type = "technology",
    name = "xoxo_barrel",
    icon = "__xoxo__/graphics/barrel/xoxo_hearts_barrel.png",
    icon_size = 64,
    prerequisites = { "steel-processing" },
    unit = {
        count = 100,
        ingredients = {
            { "automation-science-pack", 1 },
        },
        time = 30
    },
    effects = {
        {
            type = "unlock-recipe",
            recipe = "xoxo_barrel"
        }
    },
    order = "xoxo"
}

data:extend { xoxo_barrel_projectile, xoxo_barrel_capsule, xoxo_barrel_recipe, xoxo_barrel_technology }
