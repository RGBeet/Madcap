return {
    data = {
        object_type = 'Consumable',
        set     = "Spectral",
        key     = "warp_speed",
        atlas   = "placeholder",
        pos     = MLIB.get_coords(0,0),
        cost    = 4,
        config  = { extra = 1 },
        loc_vars = function(self, info_queue, card)
        end,
        can_use = function(self, card)
            return true
        end,
        use = function(self, card, area, copier)
            MadLib.loop_func(card.ability.subhands, function(v)
                Madcap.Funcs.set_subhand(v, true)
                Madcap.Funcs.card_level_subhand(card, v, card.ability.level_factor or 1) 
            end)
        end,
    }
}
