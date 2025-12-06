local function create_joker_common(_area)
	return create_card("Joker", _area, nil, "Common")
end

return {
    categories = {
        'Boosters',
    },
    data = {
        object_type = 'Booster',
        key     = "riff_raff",
        weight  = 1,
        kind    = 'Variety',
        cost    = 9,
        atlas   = 'boosters',
        pos     = MLIB.coords(3,2),
        config      = { extra = 5, choose = 2 },
        group_key   = 'k_rgmc_variety_pack',
        draw_hand   = false,
        loc_vars = function(self, info_queue, card)
            local cfg = (card and card.ability) or self.config
            return MadLib.collect_vars(cfg.choose, cfg.extra)
        end,
        ease_background_colour = function(self)
            local c = darken(G.C.BLUE,0.5)
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
                colours = { G.C.WHITE, lighten(G.C.BLUE, 0.4), lighten(G.C.BLUE, 0.2), lighten(G.C.BLUE, 0.1) },
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
		create_card		= function(self, card, i)
            return create_joker_common(G.pack_cards)
		end,
        cry_digital_hallucinations = {
            colour = G.C.PURPLE,
            loc_key = "k_plus_joker",
            create = function()
                return digihal_prepare(create_joker_common(G.jokers.cards), G.jokers)
            end,
        },
    }
}
