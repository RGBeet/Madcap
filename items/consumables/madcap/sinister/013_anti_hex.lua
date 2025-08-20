return {
    categories = {
        'Sinister Cards',
    },
    data = {
        object_type = 'Consumable',
        set     = "AntiSpectral",
        key		= 'anti_hex',
        atlas   = 'sinister',
        pos 	= MLIB.coords(1,2),
        cost 	= 2,
        config	= { extra = { money = 2 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.money * 1.5, card.ability.extra.money)
        end,
        can_use = function(self, card)
            return MadLib.valid_table(MadLib.get_editioned_cards(G.playing_cards), 1)
        end,
        use 	= function(self, card, area, copier)
            local total_money = 0

            local enhanced 	= MadLib.get_enhanced_cards(G.playing_cards)
            MadLib.loop_func(enhanced, function(v)
                v:set_ability(G.P_CENTERS.c_base, nil, true) -- remove enhancement
                total_money = total_money + self.config.extra.money
            end)

            local editioned	= MadLib.get_editioned_cards(G.playing_cards)
            MadLib.loop_func(editioned, function(v)
                v:set_edition(nil,true,true) -- remove editions
                total_money = total_money + self.config.extra.money * 1.5
            end)

            if total_money > 0 then ease_dollars(math.floor(total_money)) end
        end
    }
}
