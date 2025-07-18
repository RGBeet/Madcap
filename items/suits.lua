local goblets = {
    object_type = "Suit",
    key = 'goblets',
    card_key = 'GOB',
    hidden = not Madcap.Data.devmode,

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
        return Madcap.Funcs.exotic_in_pool() or Madcap.Data.devmode
    end
}

local towers = {
    object_type = "Suit",
    key = 'towers',
    card_key = 'TOW',
    hidden = not Madcap.Data.devmode,

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
        return Madcap.Funcs.exotic_in_pool() or Madcap.Data.devmode
    end
}

local blooms = {
    object_type = "Suit",
    key = 'blooms',
    card_key = 'BLO',
    hidden = not Madcap.Data.devmode,

    lc_atlas = 'new_suits',
    hc_atlas = 'new_suits_hc',

    lc_ui_atlas = 'ui_suits',
    hc_ui_atlas = 'ui_suits_hc',

    pos = { x = 0, y = 2 },
    ui_pos = { x = 2, y = 0 },

    lc_colour = HEX('A7EE5f'),
    hc_colour = HEX('81B949'),

    in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        end
        return Madcap.Funcs.exotic_in_pool() or Madcap.Data.devmode
    end
}

local daggers = {
    object_type = "Suit",
    key = 'daggers',
    card_key = 'DAG',
    hidden = not Madcap.Data.devmode,

    lc_atlas = 'new_suits',
    hc_atlas = 'new_suits_hc',

    lc_ui_atlas = 'ui_suits',
    hc_ui_atlas = 'ui_suits_hc',

    pos = { x = 0, y = 3 },
    ui_pos = { x = 3, y = 0 },

    lc_colour = HEX('591235'),
    hc_colour = HEX('5D1B1E'),

    in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        end
        return Madcap.Funcs.exotic_in_pool() or Madcap.Data.devmode
    end
}

local voids = {
    object_type = "Suit",
    key = 'voids',
    card_key = 'VOI',
    hidden = not Madcap.Data.devmode,

    lc_atlas = 'new_suits',
    hc_atlas = 'new_suits_hc',

    lc_ui_atlas = 'ui_suits',
    hc_ui_atlas = 'ui_suits_hc',

    pos = { x = 0, y = 5 },
    ui_pos = { x = 5, y = 0 },

    lc_colour = HEX('564C53'),
    hc_colour = HEX('2F1E7A'),

    in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        end
        return Madcap.Funcs.exotic_in_pool() or Madcap.Data.devmode
    end
}

local lanterns = {
    object_type = "Suit",
    key = 'lanterns',
    card_key = 'LAN',
    hidden = not Madcap.Data.devmode,

    lc_atlas = 'new_suits',
    hc_atlas = 'new_suits_hc',

    lc_ui_atlas = 'ui_suits',
    hc_ui_atlas = 'ui_suits_hc',

    pos = { x = 0, y = 4 },
    ui_pos = { x = 4, y = 0 },

    lc_colour = HEX('F09B4A'),
    hc_colour = HEX('FF8D36'),

    in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        end
        return Madcap.Funcs.exotic_in_pool() or Madcap.Data.devmode
    end
}

local list = {
    goblets,
    towers,
    blooms,
    daggers,

    voids,
    lanterns
}

for i=1,#list do
    list[i].order = 100+i
end

return {
    name = "Ranks",
    init = function() print("Ranks!") end,
    items = list
}
