return {
    data = {
        object_type = 'Blind',
        key     = 'final_id',
        atlas   = "blinds_chaotic",
        pos     = MLIB.coords(1),
        boss_colour = HEX('E2A646'),
        debuff = {
            rgmc_blind_multiblind = true,
        },
        in_pool = function(self)
            return true
        end,
        collection_loc_vars = function(self)
            return { vars = { number_format(1), number_format(15) } }
        end,
        loc_vars = function(self)
            local numer = (G.GAME and G.GAME.golden_gauntlet and (G.GAME.golden_gauntlet.current + 1)) or 1
            local denom = (G.GAME and G.GAME.golden_gauntlet and G.GAME.golden_gauntlet.max) or 15
            return { vars = { number_format(numer), number_format(denom) } } -- no bignum?
        end,
        set_blind = function(self, reset, silent)
            G.GAME.rgmc_superboss = 1
            G.GAME.rgmc_bonus_blind = get_new_assist_boss()
            if G.GAME.golden_gauntlet == nil then
				Madcap.Funcs.assist_set_blind()
                G.GAME.golden_gauntlet = {
                    current = 0,
                    max     = 15
                }
                G.GAME.multi_stage_boss = true
            end
        end,
        defeat = function(self, silent)
            G.GAME.golden_gauntlet 		= nil
            G.GAME.multi_stage_boss 	= nil
            G.GAME.rgmc_superboss 		= nil
            Madcap.Funcs.assist_blind_defeat(G.GAME.rgmc_bonus_blind)
        end,
        disable = function(self, silent)
            return Madcap.Funcs.assist_blind_disable(G.GAME.rgmc_bonus_blind)
        end,
        calculate = function(self, card, context)
            return Madcap.Funcs.assist_blind_calculate(G.GAME.rgmc_bonus_blind, self, card, context)
        end,
        press_play = function(self)
            return Madcap.Funcs.assist_blind_press_play(G.GAME.rgmc_bonus_blind, self)
        end,
		modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
			return Madcap.Funcs.assist_blind_modify_hand(G.GAME.rgmc_bonus_blind, self, cards, poker_hands, text, mult, hand_chips)
		end,
		debuff_hand = function(self, cards, hand, handname, check)
			return Madcap.Funcs.assist_blind_debuff_hand(G.GAME.rgmc_bonus_blind, self, cards, hand, handname, check)
		end,
		drawn_to_hand = function(self)
			return Madcap.Funcs.assist_drawn_to_hand(G.GAME.rgmc_bonus_blind, self)
		end,
		stay_flipped = function(self, area, card)
			return Madcap.Funcs.assist_stay_flipped(G.GAME.rgmc_bonus_blind, self, area, card)
		end,
		recalc_debuff = function(self, card, from_blind)
			return Madcap.Funcs.assist_debuff_card(G.GAME.rgmc_bonus_blind, self, card, from_blind)
		end,
    }
}
