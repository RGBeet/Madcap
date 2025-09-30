Madcap.Lists.ConsumableSpatias = {
    ['Tarot']           = 'tarot',
    ['Planet']          = 'planet',
    ['Spectral']        = 'spectral',
    ['CosmaTarot']      = 'cosma',
    ['SpatiaPlanet']    = 'spatia',
    ['PotentiaCrystal'] = 'potentia'
}

function Madcap.Funcs.get_special_card_vars(set,xchips,xmult)
    xchips  = xchips or 0
    xmult   = xmult or 0
    local amt = Madcap.Lists.ConsumableSpatias[set] and MadLib.get_consumeable_usage(set) or 0
    return {
        vars = {
			localize(MadLib.get_most_played_hand(), 'poker_hands'),
			xchips,
			xmult,
			(amt * xchips) + 1,
			(amt * xmult) + 1,
			colours = { G.C.RGMC_MAYHEM }
        }
    }
end

function Madcap.Funcs.use_consumable_specific_special_card(card)
	local set, xchips, xmult = card.ability.set, 1 + (card.ability.xchips or 0), 1 + (card.ability.xmult or 0)
	local select_hand = MadLib.get_most_played_hand()
	local nset = G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total[set] or 0
    
	if not select_hand then return end

    update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.5}, {
        handname 	= select_hand,
        chips	 	= G.GAME.hands[select_hand].chips,
        mult 		= G.GAME.hands[select_hand].mult,
        level 		= ""
	})
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0.5}, {
        handname 	= select_hand,
        chips	 	= "+(" .. number_format(xchips) .. " × " .. number_format(nset) .. ")",
        mult	 	= "+(" .. number_format(xmult) .. " × " .. number_format(nset) .. ")",
        level 		= ""
	})
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.0, delay = 0.5}, {
        handname 	= select_hand,
        chips	 	= "+" .. number_format(xchips * nset),
        mult	 	= "+" .. number_format(xmult * nset),
        level 		= ""
	})
	
	local new_chips = G.GAME.hands[select_hand].chips + (xchips * nset)
	local new_mult  = G.GAME.hands[select_hand].mult + (xmult * nset)

    update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.0, delay = 1.5}, {
        handname 	= select_hand,
        chips	 	= number_format(new_chips),
        mult	 	= number_format(new_mult),
        level 		= ""
	})

	G.GAME.hands[select_hand].chips = new_chips
	G.GAME.hands[select_hand].mult 	= new_mult
                
	update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
end

return {
    categories = {
        'Subhands',
        'Spatia'
    },
    data = {
        object_type = 'Consumable',
        set     = "SpatiaPlanet",
        key     = "terra",
        atlas   = "spatia",
        pos     = MLIB.coords(1,7),
        config  = { set = 'Tarot', xmult = 0.1, xchips = 0.05 },
        cost    = 8,
        aurinko = true,
        loc_vars = function(self, info_queue, card)
            local amt = G.GAME.consumeable_usage_total
                and Madcap.Lists.ConsumableSpatias[card.ability.set]
                and (G.GAME.consumeable_usage_total or {})[Madcap.Lists.ConsumableSpatias[card.ability.set]]
                or 0
            return Madcap.Funcs.get_special_card_vars(self.config.set, (amt * self.config.xchips) + 1, (amt * self.config.xmult) + 1)
        end,
        can_use = function(self, card)
            local amt = G.GAME.consumeable_usage
                and Madcap.Lists.ConsumableSpatias[card.ability.set]
                and (G.GAME.consumeable_usage_total or {})[Madcap.Lists.ConsumableSpatias[card.ability.set]]
                or 0
            return amt > 0
        end,
        use = function(self, card, area, copier)
            Madcap.Funcs.use_consumable_specific_special_card(card)
        end,
    }
}
