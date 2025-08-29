function Madcap.Funcs.get_blind_suits()
	return (G.GAME.blind_stats and G.GAME.blind_stats.suits) or {}
end

return {
    categories = {
        'Cosma Tarots'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "soulmates",
        atlas   = "cosma",
        pos 	= MLIB.coords(0,6),
        cost 	= 5,
        config	= { select = 3 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.select))
        end,
        can_use = function(self, card)
            return #Madcap.Funcs.get_blind_suits() > 0
        end,
        use = function (self, card, area, copier)
            Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 2, function(v)
                return true -- must have suit
            end, function(v)
                -- try not to have suits swap into the SAME SUIT
                local _suit = pseudorandom_element(Madcap.Funcs.get_blind_suits(), pseudoseed('soulmates')) -- pick a suit
                MadLib.simple_event(function()
                    assert(SMODS.change_base(v, _suit, nil))
                    return true
                end, 0.2, 'after')
            end)
        end
    }
}
