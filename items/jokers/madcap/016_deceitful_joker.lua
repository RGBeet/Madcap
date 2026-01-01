return {
    categories = {
        'Suits' -- requires new suits to load
    },
    data = {
        object_type = "Joker",
        key     = 'deceitful_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(1,5),
        rarity  = 1,
        cost    = 4,
        config = {
            extra = { mult = 6, suit = 'rgmc_towers' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                number_format(card.ability.extra.mult),
                localize(Madcap.Funcs.get_joker_suit(card, 'rgmc_towers'), 'suits_singular'),
                { G.C.SUITS[Madcap.Funcs.get_joker_suit(card, 'rgmc_towers')] })
        end,
        calculate = function(self, card, context)
            if context.checktrigger then
                return (context.individual
                    and context.cardarea == G.play
                    and context.other_card
                    and context.other_card:is_suit(Madcap.Funcs.get_joker_suit(card, 'rgmc_towers')))
            end
            if
                (context.individual
                and context.cardarea == G.play
                and context.other_card:is_suit(Madcap.Funcs.get_joker_suit(card, 'rgmc_towers')))
                or context.forcetrigger
            then
                return { mult = card.ability.extra.mult }
            end
        end,
        in_pool = function(self, args) -- At least one compatible card
            return MadLib.list_matches_one(G.playing_cards or {}, function(v)
                return v:is_suit('rgmc_towers')
            end)
        end,
        demicoloncompat = true,
        quasicoloncheck = true
    },
}
