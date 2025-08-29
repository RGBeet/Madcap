local function create_joker_misprintized(_area)
	local _card = create_card("Joker", G.pack_cards, nil, nil, true, true, nil, "rgmc")
    Madcap.Funcs.mayhemize(_card, {
        force_values 	= true,
        min_mult 		= 0.5,
        max_mult 		= 2
    }, false)
	return _card
end

return {
    categories = {
        'Boosters',
    },
    data = {
        object_type = 'Booster',
        key     = "factory_error",
        weight  = 1,
        kind    = 'Variety',
        cost    = 11,
        atlas   = 'boosters',
        pos     = MLIB.coords(4,0),
        config      = { extra = 6, choose = 1 },
        group_key   = 'k_rgmc_variety_pack',
        draw_hand   = false,
        loc_vars = function(self, info_queue, card)
            local cfg = (card and card.ability) or self.config
            return MadLib.collect_vars(cfg.choose, cfg.extra)
        end,
        ease_background_colour = function(self)
            Madcap.Funcs.booster_ease_bg(self, G.C.GREEN, G.C.BLACK)
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
                colours = { G.C.WHITE, lighten(G.C.WHITE, 0.4), lighten(G.C.GREEN, 0.2), lighten(G.C.BLACK, 0.1) },
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
		create_card		= function(self, card, i)
            return create_joker_misprintized(G.pack_cards)
		end,
        cry_digital_hallucinations = {
            colour = G.C.GREEN,
            loc_key = "k_plus_joker",
            create = function()
                return digihal_prepare(create_joker_misprintized(G.jokers.cards), G.jokers)
            end,
        },
    }
}
