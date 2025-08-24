return {
    categories = {
        'Boosters',
        'Cosma Tarots',
        'Unusual',
        'Chaotic'
    },
    data = {
        object_type = 'Booster',
        key     = "reward_mk2",
        weight  = 0.00,
        kind    = 'Reward',
        cost    = 14,
        atlas   = 'boosters',
        pos     = MLIB.coords(1,1),
        config      = { extra = 6, choose = 2 },
        group_key   = 'k_rgmc_reward_pack',
        draw_hand   = true,
        loc_vars = function(self, info_queue, card)
            local cfg = (card and card.ability) or self.config
            return MadLib.collect_vars(cfg.choose, cfg.extra)
        end,
		update_pack		= function(self, dt)
			ease_colour(G.C.DYN_UI.MAIN, G.C.DARK_EDITION)
			ease_background_colour({ new_colour = G.C.DARK_EDITION, special_colour = G.C.BLACK, contrast = 2 })
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
                colours = { G.C.WHITE, lighten(G.C.GOLD, 0.4), lighten(G.C.GOLD, 0.2), G.C.GOLD },
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
        create_card = function(self, card, i)
            return SMODS.create_card({ set = 'Consumables', area = G.pack_cards, legendary = leg, skip_materialize = true, soulable = true, key = leg and 'c_soul' or Madcap.Funcs.get_random_consumable('rar'), key_append = 'reward_mk2'})
        end,
		digital_hallucinations_compat = Madcap.Funcs.digital_hallucinations_compat('Reward', 'rgmc_plus_reward', G.C.GOLD, function()
            local cc = Madcap.Funcs.get_reward_card('reward_mk2')
			cc:set_edition({ negative = true }, true)
			cc:add_to_deck()
			G.consumeables:emplace(cc)
        end),
        no_doe 	= true,
        in_pool = function()
            return false -- given out by reward tags
        end,
    }
}
