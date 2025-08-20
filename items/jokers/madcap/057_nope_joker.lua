
return {
    data = {
        object_type = "Joker",
        key     = 'nope_joker',
        atlas   = 'jokers',
        rarity  = 1,
        cost    = 4,
        pos     = MLIB.coords(5,6),
        config =  {
            extra = { odds = 4, odds2 = 3 }
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
                local add = SMODS.pseudorandom_probability(card, 'nope_joker', 1, card.ability.extra.odds, "Nope.jkr") and 1
                    or SMODS.pseudorandom_probability(card, 'nope_joker', 1, card.ability.extra.odds2, "Nope.jkr") and -1
                    or 0
                local discarding = context.pre_discard and true or false

                if add ~= 0 then
                    if discarding then -- hand
                        ease_discard(add)
                    else -- discard
                        ease_hands_played(add)
                    end
                end

                if add == 0 then --
                    return {
                        message = localize("k_nope_ex"),
                        colour  = discarding and G.C.RED or G.C.BLUE
                    }
                elseif add == 1 then -- add
                    return {
                        message = localize({
                            type = "variable",
                            key = "a_" .. (discarding and "discard" or "hand") .. "_plus",
                            colour  = discarding and G.C.RED or G.C.BLUE,
                            vars = { add }
                        }),
                    }
                else -- subtract
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
        end,
        demicoloncompat = true,
    }
}
