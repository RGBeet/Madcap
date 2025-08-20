return {
    categories = {
        'Unusual'
    },
    data = {
        object_type = "Joker",
        key     = 'weighted_die',
        atlas   = 'jokers',
        pos     = MLIB.coords(8,7),
        rarity  = 'rgmc_unusual',
        cost    = 9,
        config = {
            extra = { odds = 6 }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'weighted_die')
            return MadLib.collect_vars(number_format(_numer), number_format(_denom))
        end,
        calculate = function(self, card, context)
            if (context.pre_discard or context.final_scoring_step) and SMODS.pseudorandom_probability(card, 'weighted_die', 1, card.ability.extra.odds) then
                G.deck:reverse()
                MadLib.simple_event(function()
                    card:juice_up(0.8, 0.4)
                    play_sound('rgmc_blip', 1, 0.5)
                    return true
                end, 0.5, 'before')
            end
            if context.finished_drawing then
                play_sound('rgmc_pop', 1, 0.5)
                card:juice_up(0.4, 0.2)
                G.deck:reverse()
            end
        end,
        demicoloncompat = false, -- maybe draw from bottom of deck?
    }
}
