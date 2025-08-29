function Madcap.Funcs.get_enhancements_from_cards(cards)
    local enhancement_table = {}
    MadLib.loop_func(cards, function(v) enhancement_table[v.config.center] = true end)
    return enhancement_table
end

--function Madcap.Funcs.use_cosma(self, card, area, copier, num_cards, check, func)
return {
    categories = {
        'Cosma Tarots'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "spirit_plane",
        atlas   = "cosma",
        pos 	= MLIB.coords(0,7),
        cost 	= 5,
        config	= { select = 2 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.select))
        end,
        can_use = function(self, card)
            return (G.hand and G.hand.cards and #G.hand.cards > 1)
        end,
        use = function (self, card, area, copier)
            local enhancements = Madcap.Funcs.get_enhancements_from_cards(G.hand.cards)

            Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 2, function(v) return true end, function(v)
                local random_enhancement = #enhancements > 0
                    and pseudorandom_element(enhancements, pseudoseed('spirit_plane'))
                    or SMODS.poll_enhancement { key = 'spirit_plane', guaranteed = true }
                v:set_ability(random_enhancement)
            end)
        end
    }
}
