return {
    categories = {
        'Boosters',
        'Subhands',
        'Spatia Planets'
    },
    data = {
        object_type = 'Booster',
        key     = "spatia_mega",
        weight  = 1,
        kind    = 'SpatiaPlanet',
        cost    = 11,
        atlas   = 'boosters',
        pos     = MLIB.coords(2,2),
        config      = { extra = 5, choose = 2 },
        group_key   = 'k_rgmc_spatia_pack',
        draw_hand   = true,
        loc_vars = function(self, info_queue, card)
            local cfg = (card and card.ability) or self.config
            return MadLib.collect_vars(cfg.choose, cfg.extra)
        end,
        ease_background_colour = function(self)
            Madcap.Funcs.booster_ease_bg(self, G.C.SET.SpatiaPlanet, G.C.BLACK)
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
                colours = { G.C.WHITE, lighten(G.C.SET.SpatiaPlanet, 0.4), lighten(G.C.SET.SpatiaPlanet, 0.2), lighten(G.C.GOLD, 0.2) },
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
		create_card		= function(self, card, i)
            local get_potentia = Madcap.Funcs.get_spatia_pack_potentia()
            local _card = {
                    set = get_potentia and "PotentiaCrystal" or "SpatiaPlanet",
                    area = G.pack_cards,
                    skip_materialize = true,
                    soulable = true,
                    key_append = "spatia_mega"
                }
            return _card
		end,
		digital_hallucinations_compat = function()
            local get_potentia = Madcap.Funcs.get_spatia_pack_potentia()
            local cc = {
                    set = get_potentia and "PotentiaCrystal" or "SpatiaPlanet",
                    area = G.consumeables,
                    skip_materialize = true,
                    soulable = true,
                    key_append = "spatia_mega"
                }
			cc:set_edition({ negative = true }, true)
			cc:add_to_deck()
			G.consumeables:emplace(cc)
		end
    }
}
