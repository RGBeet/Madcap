local shore_list = {'shielding'} -- only adds shielding for now
return {
    categories = {
        'Cosma Tarots'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "shore",
        atlas   = "cosma",
        pos 	= MLIB.coords(1,6),
        cost 	= 6,
        config	= { select = 2 },
        loc_vars = function(self, info_queue, card)
            local selection = math.ceil(MadLib.clamp(card.ability.select, 1, (G.hand and #G.hand.cards or 8)))
            return MadLib.collect_vars(selection)
        end,
        can_use = function(self, card)
            return G.hand and #G.hand.cards > 1
        end,
        use = function (self, card, area, copier)
            local selection = math.ceil(MadLib.clamp(card.ability.select, 1, (G.hand and #G.hand.cards or 8)))
            local targets = MadLib.shuffle_sort_list(G.hand.cards, selection, function(v) return true end)

            MadLib.loop_func(targets, function(v)
                --local shore_choice = pseudorandom_element(shore_list, pseudoseed('shore'..G.GAME.round_resets.ante))
                SMODS.Stickers['rgmc_shielded']:apply(v, true)
            end)
        end
    }
}
