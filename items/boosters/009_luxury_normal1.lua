Madcap.Lists.LuxuryRarities = {
    { value = 2, weight = 4 },
    { value = 3, weight = 6 },
    { value = 'rgmc_unusual', weight = 2 },
    { value = 4, weight = 1 },
}

Madcap.Lists.LuxurySets = {
    { value = 'Spectral', weight = 4 },
    { value = 'CosmaTarot', weight = 6 },
    { value = 'SpatiaPlanet', weight = 2 },
    { value = 'PotentiaCrystal', weight = 1 },
}

if AKYRS then
    table.insert(Madcap.Lists.LuxurySets, { value = 'Umbral', weight = 4 })
end

if MoreFluff then
    table.insert(Madcap.Lists.LuxurySets, { value = 'Rotarot', weight = 4 })
end

local function create_luxury_item(_area)
    _area = _area or G.pack_cards
    local nubby         = pseudorandom('luxury_normal1', 1, 100)
    local card = nil

    --[[
        Possible items:
        - Joker (60%)
        - Any consumable (25%)
        - Enhanced card (10%)
        - Voucher (5%)
    ]]
    local e = pseudorandom('luxury_normal1', 1, 2) < 2
    if nubby <= 60 then -- Joker
        local r = Madcap.Funcs.get_weighted_choice(Madcap.Lists.LuxuryRarities)
        card = SMODS.create_card({ 
            set         = 'Joker',
            rarity      = r,
            edition     = e and poll_edition('wheel_of_fortune', nil, true, true) or nil,
            no_edition  = not e or nil,
        })
    elseif nubby <= 85 then -- Consumable
        local cs = Madcap.Funcs.get_weighted_choice(Madcap.Lists.LuxurySets)
        card = SMODS.create_card({ 
            set         = cs,
            edition     = e and poll_edition('wheel_of_fortune', nil, true, true) or nil,
            no_edition  = not e or nil,
        })
    elseif nubby <= 90 then -- Voucher  
        card = SMODS.create_card({ 
            set         = 'Voucher',
            no_edition  = not e or nil,
        })
    else -- Playing Card
        card = SMODS.create_card({ 
            set         = 'Playing Card',
            edition     = e and poll_edition('wheel_of_fortune', nil, true, true) or nil,
            no_edition  = not e or nil,
        })
    end
    return card
end

return {
    categories = {
        'Boosters',
    },
    data = {
        object_type = 'Booster',
        key     = "luxury_normal1",
        weight  = 0,
        kind    = 'booster_luxury',
        cost    = 9,
        atlas   = 'boosters',
        pos     = MLIB.coords(1,0),
        config      = { extra = 3, choose = 1 },
        group_key   = 'k_rgmc_variety_pack',
        draw_hand   = false,
        loc_vars = function(self, info_queue, card)
            local cfg = (card and card.ability) or self.config
            return MadLib.collect_vars(cfg.choose, cfg.extra)
        end,
        ease_background_colour = function(self)
            local c = darken(G.C.RED,0.5)
            ease_colour(G.C.DYN_UI.MAIN, c)
            ease_background_colour{new_colour = c, special_colour = G.C.BLACK, contrast = 2}
        end,
        particles = function(self)
            G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
                timer = 0.015,
                scale = 0.2,
                initialize = true,
                lifespan = 1,
                speed = 1.1,
                padding = -1,
                attach = G.ROOM_ATTACH,
                colours = { G.C.WHITE, lighten(G.C.RED, 0.4), lighten(G.C.GOLD, 0.2), lighten(G.C.GOLD, 0.1) },
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
		create_card		= function(self, card, i)
            return create_luxury_item(G.pack_cards)
		end,
    }
}
