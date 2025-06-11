local goblets = {
    object_type = "Suit",
    key = 'goblets',
    card_key = 'GOBLETS',
    hidden = true,

    lc_atlas = 'new_suits',
    hc_atlas = 'new_suits_hc',

    lc_ui_atlas = 'ui_suits',
    hc_ui_atlas = 'ui_suits_hc',

    pos = { x = 0, y = 0 },
    ui_pos = { x = 0, y = 0 },

    lc_colour = HEX('D66FA3'),
    hc_colour = HEX('C82F87'),

    in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        end
        return RGMC.funcs.exotic_in_pool()
    end
}

local towers = {
    object_type = "Suit",
    key = 'towers',
    card_key = 'TOWERS',
    hidden = true,

    lc_atlas = 'new_suits',
    hc_atlas = 'new_suits_hc',

    lc_ui_atlas = 'ui_suits',
    hc_ui_atlas = 'ui_suits_hc',

    pos = { x = 0, y = 1 },
    ui_pos = { x = 1, y = 0 },

    lc_colour = HEX('593559'),
    hc_colour = HEX('822C8F'),

    in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        end
        return RGMC.funcs.exotic_in_pool()
    end
}

local list = {
    goblets,
    towers,
    --blooms,
    --daggers,
    --voids
}

return {
    name = "Ranks",
    init = function() print("Ranks!") end,
    items = list
}
