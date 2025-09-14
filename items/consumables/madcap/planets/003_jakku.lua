if MadLib.SpectrumId == 'na' then return {} end

return {
    categories = {
        'Poker Hands'
    },
    data = {
        object_type = 'Consumable',
        set     = "Planet",
        key     = "jakku",
        atlas   = "planets",
        pos     = MLIB.coords(0,2),
        cost    = 5,
        aurinko = true,
        config  = { hand_type = 'rgmc_pyramid_spectrum', softlock = true },
        set_card_type_badge = function(self, card, badges)
            badges[1] = create_badge(localize("k_planet"), get_type_colour(self or card.config, card), nil, 1.2)
        end,
        generate_ui = 0,
    }
}
