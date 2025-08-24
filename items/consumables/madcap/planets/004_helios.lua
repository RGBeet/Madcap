return {
    categories = {
        'Poker Hands',
    },
    data = {
        object_type = 'Consumable',
        set     = "Planet",
        key     = "helios",
        atlas   = "planets",
        pos     = MLIB.coords(0,3),
        cost    = 5,
        aurinko = true,
        config  = { hand_type = 'rgmc_blazer', softlock = true },
        set_card_type_badge = function(self, card, badges)
            badges[1] = create_badge(localize("rgmc_planet_alt"), get_type_colour(self or card.config, card), nil, 1.2)
        end,
        generate_ui = 0,
    }
}
