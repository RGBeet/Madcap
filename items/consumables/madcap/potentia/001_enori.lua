function Madcap.Funcs.get_potentia_vars(sh,lvl)
	local subhand = G.GAME.subhands and G.GAME.subhands[sh]
	local current_level = subhand and subhand.level 	or 1
	local empower_level = subhand and subhand.empower 	or 0
    return {
        vars = {
            current_level,
            (empower_level > 0) and (" + " .. empower_level .."") or "",
            localize(sh),
            lvl,
			colours = {
				to_big(current_level) < to_big(2) and G.C.BLACK or G.C.HAND_LEVELS[to_number(math.min(7, current_level))]
			}
        },
    }
end

function Madcap.Funcs.use_potentia_card(card)
	local subhand = G.GAME.subhands and G.GAME.subhands[card.ability.subhand]
	if not subhand then return end
	if #SMODS.find_card('j_rgmc_empowerer') > 0 then
		MadLib.loop_func(SMODS.find_card('j_rgmc_empowerer'), function(v)
			level_up_hand_ref(card, MadLib.get_random_poker_hand(), false, G.GAME.potentias_used)
		end)
	end
	Madcap.Funcs.empower_subhand(card, card.ability.subhand, false, card.ability.levels or 1)
end

return {
    categories = {
        'Subhands',
        'Potentia'
    },
    data = {
        object_type = 'Consumable',
        set     = "PotentiaCrystal",
        key     = "enori",
        atlas   = "potentia",
        pos     = MLIB.coords(0,0),
        cost    = 8,
        config  = { subhand = 'ml_sh_light', levels = 1 },
        aurinko = true,
        loc_vars = function(self, info_queue, center)
            return Madcap.Funcs.get_potentia_vars(self.config.subhand, self.config.levels)
        end,
        can_use = function(self, card)
            return true
        end,
        use = function(self, card, area, copier)
            Madcap.Funcs.use_potentia_card(card)
        end,
    }
}
