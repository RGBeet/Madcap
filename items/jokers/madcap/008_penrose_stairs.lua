return {
    data = {
        object_type = "Joker",
        key     = 'penrose_stairs',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,7),
        rarity  = 1,
        cost    = 4,
        config = {
            extra = { times = 1, odds = 6 },
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'penrose_stairs')
            return MadLib.collect_vars(_numer, _denom, card.ability.extra.times)
        end,
        calculate = function (self, card, context)
            if context.joker_main then
                local cards = {}
                for i, v in ipairs(G.play.cards) do
                    if
                        SMODS.pseudorandom_probability(card, 'penrose_stairs', 1, card.ability.extra.odds)
                        and not v:is_rankless()
                    then
                        cards[#cards+1]=v
                    end
                end
                MadLib.flip_cards(cards, function(v)
                    assert(SMODS.modify_rank(v, card.ability.extra.times))
                end)
            end
        end,
        demicoloncompat = true,
    },
}
