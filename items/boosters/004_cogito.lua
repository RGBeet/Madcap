return {
    categories = {
        'Boosters',
        'Cosma Tarots',
        'Unusual',
        'Chaotic'
    },
    data = {
        object_type = 'Booster',
        key     = "cogito",
        weight  = 0.00,
        kind    = 'CosmaTarot',
        cost    = 66,
        atlas   = 'boosters',
        pos     = MLIB.coords(0,3),
        config      = { extra = 2, choose = 1 },
        group_key   = 'k_rgmc_cosma_pack',
        draw_hand   = false,
        loc_vars = function(self, info_queue, card)
            local cfg = (card and card.ability) or self.config
            return MadLib.collect_vars(cfg.choose, cfg.extra)
        end,
        ease_background_colour = function(self)
            Madcap.Funcs.booster_ease_bg(self, G.C.SET.CosmaTarot, G.C.BLACK)
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
            local aversion_enabled  = i%2 == 0 and not G.GAME.banned_keys['c_rgmc_aversion']
            local sleeping_ships_enabled = i%2 == 1 and not G.GAME.banned_keys['c_rgmc_sleeping_ships']
            local soul_enabled = not G.GAME.banned_keys['c_soul']

            return (aversion_enabled and create_card("CosmaTarot", G.pack_cards, nil, nil, true, true, "c_cry_gateway"))
                or (sleeping_ships_enabled and create_card("CosmaTarot", G.pack_cards, nil, nil, true, true, "c_rgmc_sleeping_ships"))
                or (soul_enabled and create_card("Spectral", G.pack_cards, nil, nil, true, true, "c_soul"))
                or create_card("CosmaTarot", G.pack_cards, nil, nil, true, true)
        end,
        digital_hallucinations_compat = {
            colour = G.C.SECONDARY_SET.Spectral,
            loc_key = "k_plus_cosma",
            create = function()
                local aversion_enabled  = i%2 == 0 and not G.GAME.banned_keys['c_rgmc_aversion']
                local sleeping_ships_enabled = i%2 == 1 and not G.GAME.banned_keys['c_rgmc_sleeping_ships']
                local soul_enabled = not G.GAME.banned_keys['c_soul']

                local ccard = (aversion_enabled and create_card("CosmaTarot", G.consumeables, nil, nil, true, true, "c_cry_gateway"))
                    or (sleeping_ships_enabled and create_card("CosmaTarot", G.consumeables, nil, nil, true, true, "c_rgmc_sleeping_ships"))
                    or (soul_enabled and create_card("Spectral", G.consumeables, nil, nil, true, true, "c_soul"))
                    or create_card("CosmaTarot", G.consumeables, nil, nil, true, true)

                ccard:set_edition({ negative = true }, true)
                ccard:add_to_deck()
                G.consumeables:emplace(ccard)
            end,
        },
        no_doe 	= true,
        in_pool = function()
            return false
        end,
    }
}
