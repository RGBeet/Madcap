return {
    categories = {
        'Editions'
    },
    data = {
        object_type = "Joker",
        key     = 'streemerz',
        atlas   = 'jokers',
        pos     = MLIB.coords(8,3),
        rarity  = 3,
        cost    = 15, -- get it?
        config = {
            extra = { odds = 6 }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'streemerz')
            return MadLib.collect_vars(number_format(_numer), number_format(_denom))
        end,
        calculate = function(self, card, context)
            -- Most of this takes place outside calculate.
            if context.discard then
                MadLib.loop_table(G.hand.highlighted, function(v)
                    if (v.edition and v.edition['rgmc_flipped']) and SMODS.pseudorandom_probability(card, 'streemerz', 1, card.ability.extra.odds) then set_edition_flipped(v) end
                end)
            end
        end,
        demicoloncompat = false,
    }
}
