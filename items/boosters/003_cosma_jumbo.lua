return {
    categories = {
        'Boosters',
        'Cosma Tarots'
    },
    data = {
        object_type = 'Booster',
        key     = "cosma_jumbo",
        weight  = 1,
        kind    = 'CosmaTarot',
        cost    = 6,
        atlas   = 'boosters',
        pos     = MLIB.coords(0,2),
        config      = { extra = 5, choose = 1 },
        group_key   = 'k_rgmc_cosma_pack',
        draw_hand   = true,
        loc_vars = function(self, info_queue, card)
            local cfg = (card and card.ability) or self.config
            return MadLib.collect_vars(cfg.choose, cfg.extra)
        end,
        ease_background_colour = function(self)
            ease_colour(G.C.DYN_UI.MAIN, G.C.SET.CosmaTarot)
            ease_background_colour{new_colour = G.C.SET.CosmaTarot, special_colour = G.C.BLACK, contrast = 2}
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
                colours = { G.C.WHITE, lighten(G.C.SET.CosmaTarot, 0.4), lighten(G.C.SET.CosmaTarot, 0.2), lighten(G.C.GOLD, 0.2) },
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
        create_card = function(self, card, i)
            local _card = {
                    set = "CosmaTarot",
                    area = G.pack_cards,
                    skip_materialize = true,
                    soulable = true,
                    key_append = "cosma_jumbo"
                }
            return _card
        end,
		digital_hallucinations_compat = function()
            local cc = {
                    set = "CosmaTarot",
                    area = G.consumeables,
                    skip_materialize = true,
                    soulable = true,
                    key_append = "cosma_jumbo"
                }
			cc:set_edition({ negative = true }, true)
			cc:add_to_deck()
			G.consumeables:emplace(cc)
		end
    }
}
