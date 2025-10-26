return {
    categories = {
        'Rotarots',
        'Tarots',
    },
    mods = {
        'aikoyorisshenanigans',
        'MoreFluff'
    },
    data = {
        object_type = 'Consumable',
		set   = "Rotumbral",
		atlas = "crossmod_rotumbrals",
		pos         = MLIB.coords(2,6),
        soul_pos = {x=9,y=2, draw=function (card, scale_mod, rotate_mod)
            if card.children.floating_sprite then
                rotate_mod = -G.TIMERS.REAL * 0.731
                local sc = -0.25
                local xm = 0.2 * math.sin(G.TIMERS.REAL)
                local ym = 0.2 * math.cos(G.TIMERS.REAL)
                card.children.floating_sprite:draw_shader('dissolve', 0, nil,nil,card.children.center,sc, rotate_mod,xm,ym,nil, 0.6)
                card.children.floating_sprite:draw_shader('dissolve', nil, nil,nil,card.children.center,sc, rotate_mod,xm,ym+0.2,nil, 0.6)
            end
        end},
		key   = "rot_umbral_free_will",
		config = { extra = { play_size = 2 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.play_size)
        end,
        can_use = function (self, card)
            return false
        end,
        use = function (self, card, area, copier)
        end
    }
}