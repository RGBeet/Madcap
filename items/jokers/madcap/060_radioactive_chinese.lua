return {
    categories = {
        'Score Mechanic',
    },
    data = {
        object_type = "Joker",
        key     = 'radioactive_chinese',
        atlas   = 'jokers',
        pos     = MLIB.coords(5,9),
        rarity  = 1,
        cost    = 9,
        config =  {
            extra = {
                odds = 3,
                rounds_remaining = 8,
                effects = {
                    { 1.5,   0.95 },  -- Xscore
                    { 1.5,   0.75 },  -- Xmult
                    { 1.5,   0.85 },  -- Xchips
                    { 0.25,  0.70 },  -- Xmult
                    { 0.25,  0.80 },  -- Xmult
                    { 1.12,  0.5 }   -- Escore
                }
            },
            immutable = { mode = 1 }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
            local str = "null"

            if card.ability.immutable.mode > 0 and card.ability.immutable.mode < 8 then
                str = "rgmc_rad_chinese_effect"..tostring(card.ability.immutable.mode)
            end

            info_queue[#info_queue + 1] = {
                set = "Other",
                key = str,
                vars = {
                    number_format(card.ability.extra.effects[card.ability.immutable.mode][1]), -- THE SUCCEED
                    number_format(math.max(_denom - _numer, 1)), -- NOT X in Y
                    number_format(_denom),
                    number_format(card.ability.extra.effects[card.ability.immutable.mode][2]), -- THE FAIL
                }
            }

            return MadLib.collect_vars(card.ability.extra.rounds_remaining)
        end,
        calculate = function(self, card, context)

            -- Start of blind
            if
                context.setting_blind
                and not context.blueprint
            then

                local new_food = math.random(1, 6)
                card.ability.immutable.mode = new_food

                if -- if doable, show a line
                    card.ability.immutable.mode > 0
                    and card.ability.immutable.mode <= 6
                then
                    return { message = localize("rgmc_rad_chinese_line" .. card.ability.immutable.mode) }
                end
            end

            -- At scoring time...
            if
                context.forcetrigger or
                (context.cardarea == G.jokers and context.joker_main)
            then
                local passes = SMODS.pseudorandom_probability(card, 'rgmc_radioactive_chinese_' .. tostring(card.ability.immutable.mode),
                    1, card.ability.extra.odds, "Radioactive Chinese?!")
                local val = passes and 1 or 2

                --tell('Value: '..number_format(card.ability.extra.effects[card.ability.immutable.mode]))
                if
                    card.ability.immutable.mode == 1 -- radioactive stir fry (Xscore)
                then
                    -- Xscore
                    card.ability['rgmc_e_score'] = val
                    return {
                        message = "...!?",
                        colour = G.C.PURPLE
                    }
                elseif
                    card.ability.immutable.mode == 2
                    or card.ability.immutable.mode == 4
                then
                    -- +chip
                    return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiChips, card, card.ability.extra.effects[card.ability.immutable.mode])
                elseif
                    card.ability.immutable.mode == 3
                    or card.ability.immutable.mode == 5
                then
                    -- +mult
                    return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.effects[card.ability.immutable.mode])
                else
                    card.ability['rgmc_e_score'] = 1
                    return {
                        message = "...!?",
                        colour = G.C.PURPLE
                    }
                end
            end

            if context.after then
            end

            -- End of round
            if Madcap.Funcs.get_end_of_round(context) then
                return MadLib.food_joker_logic(card)
            end
        end,
        perishable_compat = false,
        demicoloncompat = true,
    }
}
