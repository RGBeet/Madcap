return {
    categories = {
        'Boosters',
    },
    data = {
        object_type = 'Booster',
        key     = "chipmult",
        weight  = 1,
        kind    = 'Variety',
        cost    = 6,
        atlas   = 'boosters',
        pos     = MLIB.coords(3,0),
        config      = { extra = 2, choose = 1 },
        group_key   = 'k_rgmc_variety_pack',
        draw_hand   = false,
        loc_vars = function(self, info_queue, card)
            local cfg = (card and card.ability) or self.config
            return MadLib.collect_vars(cfg.choose, cfg.extra)
        end,
        ease_background_colour = function(self)
            Madcap.Funcs.booster_ease_bg(self, G.C.RED, G.C.BLUE)
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
                colours = { G.C.WHITE, lighten(G.C.BLUE, 0.2), lighten(G.C.RED, 0.2), lighten(G.C.PURPLE, 0.2) },
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
		create_card		= function(self, card, i)
            return {
                set     = (i%2 == 0) and "MultJoker" or "ChipsJoker",
                area    = G.pack_cards,
                soulable    = false,
                key_append  = "chipmult",
                skip_materialize = true,
            }
		end,
		digital_hallucinations_compat = function()
            local cc = {
                    set     = (math.random() < 0.5) and "ChipsJoker" or "MultJoker",
                    area    = G.consumeables,
                    soulable    = false,
                    key_append  = "chipmult",
                    skip_materialize = true,
                }
			cc:set_edition({ negative = true }, true)
			cc:add_to_deck()
			G.consumeables:emplace(cc)
		end
    }
}
