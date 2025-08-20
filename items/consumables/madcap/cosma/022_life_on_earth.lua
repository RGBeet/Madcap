-- Turns two random cards into Voids (if dark) and Lanterns (if light)
return {
    categories = {
        'Cosma Tarots',
        'New Suits',
        'Voids and Lanterns'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "life_on_earth",
        atlas   = "cosma",
        pos 	= MLIB.coords(2,1),
        cost 	= 8,
        config	= { select = 2, extra = { suits = {'rgmc_voids', 'rgmc_lanterns'} } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(number_format(card.ability.select), localize(card.ability.extra.suits[1], 'suits_plural'), localize(card.ability.extra.suits[2], 'suits_plural'),{
                MadLib.get_suit_colour(card.ability.extra.suits[1]),
                MadLib.get_suit_colour(card.ability.extra.suits[2])
            })
        end,
        can_use = function(self, card)
            return G.hand and MadLib.loop_func(G.hand.cards, function(v)
                return not (v:is_suit(self.config.extra[1]) or v:is_suit(self.config.extra[2]))
            end) > 0
        end,
        use = function(self, card, area, copier)
            Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 2, function(v)
                return not (v:is_suit(self.config.extra[1]) or v:is_suit(self.config.extra[2]))
            end, function(v)
                local _suit = v:has_light_suit() and self.config.extra.suits[2]
                    or v:has_dark_suit() and self.config.extra.suits[1]
                    or pseudorandom_element(self.config.suits,psuedoseed('life_on_earth'))
                MadLib.simple_event(function()
                    assert(SMODS.change_base(v, _suit, nil))
                    MadLib.simple_event(function()
                        v:juice_up()
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                    return true
                end)
            end)
        end
    }
}
