return {
    categories = {
        'Cosma Tarots',
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "bridge",
        atlas   = "cosma",
        pos 	= MLIB.coords(1,8),
        cost 	= 6,
        config	= { select = 3 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.select))
        end,
        can_use = function(self, card)
            return G.hand and MadLib.loop_func(G.hand.cards, function(v)
                return v:has_dark_suit()
            end) > 0
        end,
        use = function (self, card, area, copier)
            Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 3, function(v)
                return v:has_dark_suit()
            end, function(v)
                local _suit = MadLib.suit_get_counterpart_lightdark(v.base.suit)
                MadLib.simple_event(function()
                    assert(SMODS.change_base(v, _suit, nil))
                    return true
                end)
            end)
        end
    }
}
