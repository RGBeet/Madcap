function Madcap.Funcs.get_moon_card_vars(sh,levels)
	local subhand 	= G.GAME.subhands and G.GAME.subhands[sh]
	local current_level = subhand and subhand.level or 1
    return {
        vars = {
            current_level,
            localize(sh),
            (subhand and subhand.l_mult
				or SubHands[sh].l_mult) + 1,
            (subhand and subhand.l_chips
				or SubHands[sh].l_chips) + 1,
			colours = { MadLib.get_level_color(subhand.level), }
        }
    }
end

function Madcap.Funcs.use_moon_card(card)
    if not card.ability.subhand then return end
	Madcap.Funcs.card_level_subhand(card, card.ability.subhand, card.ability.levels or 1)
end

return {
    categories = {
        'Subhands',
        'Spatia'
    },
    data = {
        object_type = 'Consumable',
        set     = "SpatiaPlanet",
        key     = "blue_moon",
        atlas   = "spatia",
        pos     = MLIB.coords(1,0),
        cost    = 6,
        aurinko = false,
        config = { subhand = 'ml_sh_light', levels = 1 },
        set_card_type_badge = function(self, card, badges)
            badges[1] = create_badge(localize("rgmc_moon"), get_type_colour(self or card.config, card), nil, 1.2)
        end,
        can_use = function(self, card)
            return true
        end,
        loc_vars = function(self, info_queue, center)
            return Madcap.Funcs.get_moon_card_vars(self.config.subhand, self.config.levels)
        end,
        use = function(self, card, area, copier)
            Madcap.Funcs.use_moon_card(card)
        end,
    }
}
