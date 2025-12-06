return {
    data = {
        object_type = "Joker",
        key     = 'nope_joker',
        atlas   = 'jokers',
        rarity  = 1,
        cost    = 4,
        pos     = MLIB.coords(5,6),
        config =  {
            extra = { odds = 4 }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom    = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
            local _numer2, _denom2  = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
            return MadLib.collect_vars(
                number_format(_numer),
                number_format(_denom),
                number_format(_denom2))
        end,
        calculate = function(self, card, context)
            if context.before or context.forcetrigger then

                local good_odds = SMODS.pseudorandom_probability(card, 'nope_joker', 1, card.ability.extra.odds, "nope_jkr_pos") and 1
                local bad_odds  = SMODS.pseudorandom_probability(card, 'nope_joker', 1, card.ability.extra.odds, "nope_jkr_neg") and 1
                local discarding = context.pre_discard and true or false

                local amount = (good_odds and card.ability.extra.add)
                    or (bad_odds and -card.ability.extra.add)
                    or 0

                if amount ~= 0 then
                    if discarding then
                        if G.GAME.temporary_discards + amount < G.GAME.max_temp_discards then
                            Madcap.Funcs.ease_temp_discards(amount, false, false)
                        else
                            ease_discard(amount)
                        end
                    else
                        if G.GAME.temporary_hands + amount < G.GAME.max_temp_hands then
                            Madcap.Funcs.ease_temp_hands(amount, false, false)
                        else
                            ease_hands_played(amount)
                        end
                    end

                    if good_odds then
                        return {
                            message = localize({
                                type = "variable",
                                key = "a_" .. (discarding and "discard" or "hand") .. "_plus",
                                colour  = discarding and G.C.RED or G.C.BLUE,
                                vars = { add }
                            }),
                        }
                    else
                        return {
                            message = localize({
                                type = "variable",
                                key = "a_" .. (discarding and "discard" or "hand") .. "_minus",
                                colour  = discarding and G.C.RED or G.C.BLUE,
                                vars = { add }
                            }),
                        }
                    end
                end
            end
        end,
        demicoloncompat = true,
    }
}
