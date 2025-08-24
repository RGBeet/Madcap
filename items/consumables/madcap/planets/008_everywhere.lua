return {
    categories = {
        'Poker Hands',
        'New Ranks',
        'Variable Ranks'
    },
    data = {
        object_type = 'Consumable',
        set     = "Planet",
        key     = "everywhere",
        atlas   = "planets",
        pos     = MLIB.coords(0,7),
        cost    = 8,
        aurinko = true,
        config  = { hand_type = 'rgmc_infoak_flush', softlock = true },
        set_card_type_badge = function(self, card, badges)
            badges[1] = create_badge(localize("rgmc_anomality"), get_type_colour(self or card.config, card), nil, 1.2)
        end,
        generate_ui = 0,
    }
}
