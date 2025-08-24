return {
    categories = {
        'Boosters',
        'Cosma Tarots',
        'Unusual',
        'Chaotic'
    },
    data = {
        object_type = 'Booster',
        key     = "ruinous_mk2",
        weight  = 0.00,
        kind    = 'AntiSpectral',
        cost    = 10,
        atlas   = 'boosters',
        pos     = MLIB.coords(1,2),
        config      = { extra = 5, choose = 2 },
        group_key   = 'k_rgmc_ruinous_pack',
        draw_hand   = true,
        loc_vars = function(self, info_queue, card)
            local cfg = (card and card.ability) or self.config
            return MadLib.collect_vars(cfg.choose, cfg.extra)
        end,
		update_pack		= function(self, dt)
			ease_colour(G.C.DYN_UI.MAIN, G.C.SET.AntiSpectral)
			ease_background_colour({ new_colour = G.C.SET.AntiSpectral, special_colour = G.C.BLACK, contrast = 2 })
			SMODS.Booster.update_pack(self, dt)
		end,
        particles = function(self)
            G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
                timer = 0.015,
                scale = 0.2,
                initialize = true,
                lifespan = 1,
                speed = 1.1,
                padding = -1,
                attach = G.ROOM_ATTACH,
                colours = { G.C.BLACK, lighten(G.C.SET.AntiSpectral, 0.4), lighten(G.C.SET.AntiSpectral, 0.2), G.C.SET.AntiSpectral },
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
        create_card = function(self, card, i)
            _card = {
                set = "AntiSpectral",
                area = G.pack_cards,
                skip_materialize = true,
                soulable = true,
                key_append =
                "rgmc"
            }
            return _card
        end,
		digital_hallucinations_compat = Madcap.Funcs.digital_hallucinations_compat('AntiSpectral', 'rgmc_plus_antispectral', G.C.SET.AntiSpectral),
        no_doe 	= true,
        in_pool = function()
            return false -- given out by reward tags
        end,
    }
}
