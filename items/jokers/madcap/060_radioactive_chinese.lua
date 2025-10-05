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
                    { 1.5,   0.75 },  -- Xchips
                    { 1.5,   0.85 },  -- Xmult
                    { 0.25,  0.70 },  -- Xchips
                    { 0.25,  0.80 },  -- Xmult
                    { 1.12,  0.5 }    -- Escore
                }
            },
            immutable = { mode = 1 }
        },
        loc_vars = function(self, info_queue, card)
            local numer, denom = SMODS.get_probability_vars(card, 1, (card.ability.extra.odds or 3), 'radioactive_chinese')
            local str = "null"

            if card.ability.immutable.mode > 0 and card.ability.immutable.mode < 8 then
                str = "rgmc_rad_chinese_effect"..tostring(card.ability.immutable.mode)
            end

            info_queue[#info_queue + 1] = {
                set = "Other",
                key = str,
                vars = {
                    number_format(card.ability.extra.effects[card.ability.immutable.mode][1]), -- THE SUCCEED
                    number_format(numer),
                    number_format(denom),
                    number_format(card.ability.extra.effects[card.ability.immutable.mode][2]), -- THE FAIL
                }
            }

            return MadLib.collect_vars(card.ability.extra.rounds_remaining, numer, denom)
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
                local val = SMODS.pseudorandom_probability(card, 'rgmc_radioactive_chinese_' .. tostring(card.ability.immutable.mode),
                    1, card.ability.extra.odds, "Radioactive Chinese?!") and 1 or 2
                local pick = card.ability.extra.effects[card.ability.immutable.mode][val]
                if
                    card.ability.immutable.mode == 1
                then
                    return { xscore = pick }
                elseif
                    card.ability.immutable.mode == 2
                    or card.ability.immutable.mode == 4
                then
                    return { xchips = pick }
                elseif
                    card.ability.immutable.mode == 3
                    or card.ability.immutable.mode == 5
                then
                    return { xmult = pick }
                else
                    return { escore = pick }
                end
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
