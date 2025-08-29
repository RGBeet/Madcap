function Madcap.Funcs.get_weighted_choice(choices)
    if not choices then return nil end
    -- Step 1: total weight
    local total_weight = 0
    for _, entry in ipairs(choices) do
        total_weight = total_weight + entry.weight
    end
    -- Step 2: random roll
    local roll = math.random(total_weight)
    -- Step 3: find which entry it lands on
    local cumulative = 0
    for _, entry in ipairs(choices) do
        cumulative = cumulative + entry.weight
        if roll <= cumulative then
            return entry.value
        end
    end
end
Madcap.LifeMapOdds = {
    [1] = 3,
    [2] = 5,
    [3] = 7,
}
Madcap.RarityUpgrades = {
	[1] = {
        { value = 2, weight = 10 },
        { value = 3, weight = 1 },
    },
	[2] = {
        { value = 3, weight = 10 },
        { value = "rgmc_unusual", weight = 1 },
    },
	[3] = {
        { value = "rgmc_unusual", weight = 10 },
        { value = 4, weight = 1 },
    },
}

local unusual_enabled = true
if unusual_enabled then -- add unusual config
   table.insert(Madcap.RarityUpgrades[2], { value = "rgmc_unusual", weight = 10 })
   table.insert(Madcap.RarityUpgrades[3], { value = "rgmc_unusual", weight = 1 })
   Madcap.RarityUpgrades["rgmc_unusual"] = { { value = 4, weight = 10 } }
end

if next(SMODS.find_mod('finity')) then
   table.insert(Madcap.RarityUpgrades[3], { value = "finity_showdown", weight = 1 })
    if unusual_enabled then
        table.insert(Madcap.RarityUpgrades['rgmc_unusual'], { value = "finity_showdown", weight = 2 })
    end
end

return {
    categories = {
        'Cosma Tarots'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "life_map",
        atlas   = "cosma",
        pos 	= MLIB.coords(1,0),
        cost 	= 6,
        loc_vars = function(self, info_queue, card)
            local rightmost_rarity = Madcap.LifeMapOdds[1]
            if G.jokers and #G.jokers.cards > 0 then
                rightmost_rarity = Madcap.LifeMapOdds[G.jokers.cards[#G.jokers.cards].config.center.rarity]
            end
            local _numer, _denom = SMODS.get_probability_vars(self, 1, rightmost_rarity or 0, 'life_map')
            return MadLib.collect_vars(number_format(_numer), number_format(_denom))
        end,
        can_use = function(self, card)
            local rightmost_rarity = nil
            if G.jokers and #G.jokers.cards > 0 then
                rightmost_rarity = Madcap.LifeMapOdds[G.jokers.cards[#G.jokers.cards].config.center.rarity]
            end
            return rightmost_rarity
        end,
        use = function(self, card, area, copier)
            local changed = {}
            local rightmost_rarity = Madcap.LifeMapOdds[G.jokers.cards[#G.jokers.cards].config.center.rarity]
            if SMODS.pseudorandom_probability(card, 'life_map', 1, rightmost_rarity) then
                local joker = G.jokers.cards[#G.jokers.cards]
                local center = joker.config.center
                if Madcap.RarityUpgrades[center.rarity] then
                    local new_rarity = Madcap.Funcs.get_weighted_choice(Madcap.RarityUpgrades[center.rarity])
                    local nj = SMODS.add_card {
                        set = "Joker",
                        rarity = new_rarity
                    }
                    nj:set_edition(joker.edition or nil)
                    if not SMODS.is_eternal(joker) then joker:start_dissolve() end
                else
                    card_eval_status_text(copier or card, 'extra', nil, nil, nil, { message = localize('k_nope_ex'), instant = true, sound = 'tarot2' });
                end
            else
                card_eval_status_text(copier or card, 'extra', nil, nil, nil, { message = localize('k_nope_ex'), instant = true, sound = 'tarot2' });
            end
        end
    }
}
