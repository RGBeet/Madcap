return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'magical_die_of_judgement',
        atlas   = 'jokers',
        pos     = MLIB.coords(11,7),
        rarity  = 1,
        cost    = 3,
        config = {
            extra = { mult = 4 }
        },
        loc_vars = function(self, info_queue, card)
            local numer = SMODS.get_probability_vars(card, 1, 6, 'magical_die_of_judgement')
            return MadLib.collect_vars(number_format(numer), number_format(numer+5), number_format(card.ability.extra.mult))
        end,
        calculate = function(self, card, context)
            if context.joker_main or context.forcetrigger then
                -- Rolls a d6, gives +4 Mult per die pip.
                -- Increasing the base numerator increases 1-6 to 2-7 and so forth.
                local numer = SMODS.get_probability_vars(card, 1, 6, 'magical_die_of_judgement')
                local multiplier = numer * pseudorandom('magical_die_of_judgement', numer, numer + 5)
                return { xmult = card.ability.extra.mult * multiplier }
            end
        end,
        demicoloncompat = true
    }
}
