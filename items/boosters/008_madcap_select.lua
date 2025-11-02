return {
    categories = {
        'Boosters',
        'Joker',
    },
    data = {
        object_type = 'Booster',
        key     = "madcap_select",
        weight  = 1,
        kind    = 'Variety',
        cost    = 6,
        atlas   = 'boosters',
        pos     = MLIB.coords(2,3),
        config      = { extra = 5, choose = 1 },
        group_key   = 'k_rgmc_variety_pack',
        draw_hand   = false,
        loc_vars = function(self, info_queue, card)
            local cfg = (card and card.ability) or self.config
            return MadLib.collect_vars(cfg.choose, cfg.extra)
        end,
        ease_background_colour = function(self)
            local c = {0.5, 0.5, 0.5, 1.0}
            ease_colour(G.C.DYN_UI.MAIN, c)
            ease_background_colour{new_colour = c, special_colour = G.C.BLACK, contrast = 2}
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
                colours = { G.C.WHITE, lighten(G.C.BLUE, 0.4), lighten(G.C.RED, 0.2), lighten(G.C.GREEN, 0.2) },
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
		create_card		= function(self, card, i)
            return {
                set     = "MadcapJoker",
                area    = G.pack_cards,
                soulable    = true,
                key_append  = "madcap_select",
                skip_materialize = true,
            }
		end,
		digital_hallucinations_compat = function()
            local cc = {
                    set     = "MadcapJoker",
                    area    = G.consumeables,
                    soulable    = true,
                    key_append  = "madcap_select",
                    skip_materialize = true,
                }
			cc:set_edition({ negative = true }, true)
			cc:add_to_deck()
			G.consumeables:emplace(cc)
		end
    }
}
