return {
    data = {
        object_type = "Joker",
        key     = 'nope_joker',
        atlas   = 'jokers',
        rarity  = 1,
        cost    = 4,
        pos     = MLIB.coords(5,6),
        config =  {
            extra = { odds = 6, odds_bad = 6 }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom    = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
            local _numer2, _denom2  = SMODS.get_probability_vars(card, 1, card.ability.extra.odds_bad)
            return MadLib.collect_vars(
                number_format(_numer),
                number_format(_denom),
                number_format(_denom2))
        end,
        calculate = function(self, card, context)
            if context.before or context.forcetrigger then

                local good_odds = SMODS.pseudorandom_probability(card, 'nope_joker', 1, card.ability.extra.odds, "nope_jkr_pos")
                local bad_odds  = SMODS.pseudorandom_probability(card, 'nope_joker', 1, card.ability.extra.odds_bad, "nope_jkr_neg")
                local discarding = context.discard and true or false

                local amount = (good_odds and 1) or (bad_odds and -1) or 0

                if amount ~= 0 then
                    if discarding then
                        if MadLib.compare_numbers(MadLib.add(G.GAME.temporary_discards, amount), G.GAME.max_temp_discards) < 0 then
                            Madcap.Funcs.ease_temp_discards(amount, false, false)
                        else
                            ease_discard(amount)
                        end
                    else
                        if MadLib.compare_numbers(MadLib.add(G.GAME.temporary_hands, amount), G.GAME.max_temp_hands) < 0 then
                            Madcap.Funcs.ease_temp_hands(amount, false, false)
                        else
                            ease_hands_played(amount)
                        end
                    end

                    if good_odds then
                        return {
                            message = localize({
                                key = "a_" .. (discarding and "discard" or "hand") .. "_plus",
                                colour  = discarding and G.C.RED or G.C.BLUE,
                                vars = { 1 }
                            }),
                        }
                    elseif bad_odds then
                        return {
                            message = localize({
                                key = "a_" .. (discarding and "discard" or "hand") .. "_minus",
                                colour  = discarding and G.C.RED or G.C.BLUE,
                                vars = { 1 }
                            }),
                        }
                    end
                end
            end
        end,
        demicoloncompat = true,
    }
}
