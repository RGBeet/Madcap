return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'happy_stick_joker',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 'rgmc_unusual',
        cost    = 15,
        config  = {
            extra = { mayhem = 2, odds = 9 }
        },
        loc_vars = function(self, info_queue, card)
            local numer, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'happy_stick_joker')
            return MadLib.collect_vars(number_format(numer), 
                number_format(denom),
                number_format(card.ability.extra.mayhem))
        end,
        add_to_deck = function(self, card, from_debuff)
            G.GAME.max_mayhem = G.GAME.max_mayhem + card.ability.extra.mayhem
            ease_mayhem(card.ability.extra.mayhem)
        end,
        remove_from_deck = function(self, card, from_debuff)
            G.GAME.max_mayhem = G.GAME.max_mayhem - card.ability.extra.mayhem
            ease_mayhem(-card.ability.extra.mayhem)
        end,
        demicoloncompat = false,
    }
}
