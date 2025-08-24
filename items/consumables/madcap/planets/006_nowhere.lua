return {
    categories = {
        'Poker Hands',
        'New Ranks',
        'Variable Ranks'
    },
    data = {
        object_type = 'Consumable',
        set     = "Planet",
        key     = "nowhere",
        atlas   = "planets",
        pos     = MLIB.coords(0,5),
        cost    = 6,
        aurinko = true,
        config  = { hand_type = 'rgmc_noak', softlock = true },
        set_card_type_badge = function(self, card, badges)
            badges[1] = create_badge(localize("rgmc_anomality"), get_type_colour(self or card.config, card), nil, 1.2)
        end,
        generate_ui = 0,
    }
}
