return {
    categories = {
        'Poker Hands',
        'Enhancements'
    },
    data = {
        object_type = 'Consumable',
        set     = "Planet",
        key     = "lobster",
        atlas   = "planets",
        pos     = MLIB.coords(0,4),
        cost    = 6,
        aurinko = true,
        config  = { hand_type = 'rgmc_kaleidoscope', softlock = true },
        set_card_type_badge = function(self, card, badges)
            badges[1] = create_badge(localize("rgmc_space_lobster"), get_type_colour(self or card.config, card), nil, 1.2)
        end,
        generate_ui = 0,
    }
}
