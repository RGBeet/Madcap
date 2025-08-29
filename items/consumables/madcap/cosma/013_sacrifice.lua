return {
    categories = {
        'Cosma Tarots'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "sacrifice",
        atlas   = "cosma",
        pos 	= MLIB.coords(1,2),
        cost 	= 6,
        config	= { select = 1, extra = 1.0 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.select), number_format(card.ability.extra))
        end,
        can_use = function(self, card)
            return (G.jokers and #G.jokers.cards > 1)
                and (Madcap.Funcs.get_mayhem() + self.config.extra) <= Madcap.Funcs.get_max_mayhem()
        end,
        use = function(self, card, area, copier)
            Madcap.Funcs.ease_mayhem(self.config.extra or 1, true)
            local selection = MadLib.shuffle_sort_list(G.jokers.cards, self.config.select or 1, function(v)
                return not SMODS.is_eternal(v, card)
            end)
            local _first_dissolve = nil
            MadLib.loop_func(selection, function(v,i)
                v:start_dissolve(v, _first_dissolve)
                _first_dissolve = true
            end)
        end
    }
}
