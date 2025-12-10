return {
    categories = {
        'Unfinished Content',
        'New Suits',
        'Luxury Points'
    },
    data = {
        object_type = "Joker",
        key     = 'sterling_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(13,0),
        rarity  = 3,
        cost    = 8,
        config = {
            extra = { luxury = 1 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.luxury))
        end,
        calc_luxury_bonus = function(self, card)
            if MadLib.is_positive_number(card.ability.extra.luxury) then
                return card.ability.extra.luxury
            end
        end,
        demicoloncompat = false,
    }
}
