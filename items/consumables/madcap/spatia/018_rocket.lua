Madcap.PickFiveDefault = {
	{ rank = '2' , suit = 'Spades' },
	{ rank = '4' , suit = 'Hearts' },
	{ rank = '6' , suit = 'Diamonds' },
	{ rank = '10' , suit = 'Clubs' },
	{ rank = 'Ace' , suit = 'Spades' }
}

return {
    categories = {
        'Poker Hands',
        'Spatia'
    },
    data = {
        object_type = 'Consumable',
        set     = "SpatiaPlanet",
        key     = "rocket",
        atlas   = "spatia",
        pos     = get_pos(1,6),
        cost    = 3,
        aurinko = true,
        config = { hands = { 'rgmc_pick_five' }, level_factor = 1 },
        set_card_type_badge = function(self, card, badges)
            badges[1] = create_badge(localize("rgmc_rocket"), get_type_colour(self or card.config, card), nil, 1.2)
        end,
        loc_vars = function(self, info_queue, center)
            local planet_vars 		= {}
            local planet_colours 	= {}
            local pick_5_cards		= G.GAME.pick_5 or Madcap.PickFiveDefault
            MadLib.loop_func(self.config.hands, function(v)
                table.insert(planet_vars, G.GAME.hands[v].level)
                table.insert(planet_vars, localize(v, 'poker_hands'))
                table.insert(planet_vars, G.GAME.hands[v].l_mult)
                table.insert(planet_vars, G.GAME.hands[v].l_chips)
                table.insert(planet_colours, (
                    to_big(G.GAME.hands[v].level) == to_big(1) and G.C.UI.TEXT_DARK
                    or G.C.HAND_LEVELS[to_number(math.min(7, G.GAME.hands[v].level))]
                ))
            end)
            MadLib.loop_func(pick_5_cards, function(v)
                table.insert(planet_vars, localize(v.rank, 'ranks'))
                table.insert(planet_vars, localize(v.suit, 'suits_plural'))
                table.insert(planet_colours, G.C.SUITS[v.suit] or G.C.ORANGE)
            end)
            planet_vars['colours'] = planet_colours
            return { vars = planet_vars }
        end,
    }
}
