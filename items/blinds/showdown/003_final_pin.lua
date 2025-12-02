-- 1.5X Blind Requirements per Rare+ Joker held at start of blind.
return {
    data = {
        object_type = 'Blind',
        key     = 'final_pin',
        atlas   = "blinds",
        pos     = MLIB.coords(17),
        dollars = 8,
        boss_colour = HEX('ABB3FF'),
        config = {
            immutable = { min_rarity = 'Rare' },
            extra = { mult_increase = 1.5 }
        },
        in_pool = function(self)
            return (not G.jokers)
                or #MadLib.get_jokers_matching_min_rarity(G.jokers.cards,self.config.immutable.min_rarity) > 0
                or Madcap.Data.devmode
        end,
        loc_vars = function(self, info_queue, card)
            return  MadLib.collect_vars(number_format(card.ability.extra.mult_increase), localize(string.lower("k_" .. SMODS.Rarities[self.config.immutable.min_rarity].key)))
        end,
        set_blind = function(self, reset, silent)
            if not G.GAME.blind.disabled then
                local matches = #MadLib.get_jokers_matching_min_rarity(G.jokers.cards,self.config.immutable.min_rarity)
                local multiplier = 1
                G.GAME.blind.triggered = (matches > 1) or nil

                local old_amount = G.GAME.blind.chips
                multiplier = multiplier + (matches * self.config.extra.mult_increase)
                G.GAME.blind.chips = G.GAME.blind.chips * multiplier

                G.GAME.rgmc_boss_blind_penalty = G.GAME.blind.chips / old_amount
                return true
            end
        end,
        disable = function(self, silent)
            if G.GAME and G.GAME.blind.disabled then
                G.GAME.blind.chips = G.GAME.blind.chips / (G.GAME.rgmc_boss_blind_penalty or 1)
                G.GAME.rgmc_boss_blind_penalty = nil
            end
        end,
        defeat = function(self, silent)
            G.GAME.rgmc_boss_blind_penalty = nil
        end,
    }
}
