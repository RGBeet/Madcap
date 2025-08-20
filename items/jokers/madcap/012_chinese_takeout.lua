return {
    data = {
        object_type = "Joker",
        key     = 'chinese_takeout',
        atlas   = 'jokers',
        pos     = MLIB.coords(1,1),
        rarity  = 1,
        cost    = 5,
        config =  {
            extra = {
                rounds_remaining = 8,
                effects = {
                    20,     -- +chips
                    4,      -- +mult
                    70,     -- +chips
                    9,      -- +mult
                    120,    -- +chips
                    1.5,    -- Xmult
                    2.5,    -- Xmult
                    2.5     -- Xscore
                }
            },
            immutable = {
                mode = 1    -- starts off at just fried rice
            }
        },
        loc_vars = function(self, info_queue, card)
            local str = "null"
            if card.ability.immutable.mode > 0 and card.ability.immutable.mode < 8 then
                str = "rgmc_chinese_effect"..tostring(card.ability.immutable.mode)
            end
            info_queue[#info_queue + 1] = {
                set = "Other",
                key = str,
                vars = { card.ability.extra.effects[card.ability.immutable.mode] }
            }
            return MadLib.collect_vars(number_format(card.ability.extra.rounds_remaining),
                number_format(card.ability.extra.effects[card.ability.immutable.mode]))
        end,
        calculate = function(self, card, context)

            -- Start of blind
            if
                context.setting_blind
                and not context.blueprint
            then

                local new_food = math.random(1, 8)
                card.ability.immutable.mode = new_food

                if -- if doable, show a line
                    card.ability.immutable.mode > 0
                    and card.ability.immutable.mode <= 8
                then
                    return { message = localize("rgmc_chinese_line" .. card.ability.immutable.mode) }
                end
            end

            -- At scoring time...
            if
                context.forcetrigger or
                (context.cardarea == G.jokers and context.joker_main)
            then
                tell('Value: '..number_format(card.ability.extra.effects[card.ability.immutable.mode]))
                if
                    card.ability.immutable.mode == 1
                    or card.ability.immutable.mode == 3
                    or card.ability.immutable.mode == 5
                then
                    return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.effects[card.ability.immutable.mode])
                elseif
                    card.ability.immutable.mode == 2
                    or card.ability.immutable.mode == 4
                then
                    return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.effects[card.ability.immutable.mode])
                elseif
                    card.ability.immutable.mode == 6
                    or card.ability.immutable.mode == 7
                then
                    return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.effects[card.ability.immutable.mode])
                else
                    -- Xscore
                    card.ability.rgmc_tsao_chicken = true
                    return {
                        message = "...?",
                        colour = G.C.PURPLE
                    }
                end
            end

            -- If you get the tsao chicken...
            if
                context.after
                and card.ability.rgmc_tsao_chicken
            then
                MadLib.simple_event(function()
                    G.GAME.chips = (to_big(G.GAME.chips))*(to_big(card.ability.extra.effects[card.ability.immutable.mode]))
                    G.HUD:get_UIE_by_ID('chip_UI_count'):juice_up(0.3, 0.3)

                    play_sound('holo1')
                    card.ability.rgmc_tsao_chicken = nil -- not needed now
                    return true
                end, 0.4, 'after')

                return {
                    message = "X" .. tostring(card.ability.extra.effects[card.ability.immutable.mode]),
                    colour = G.C.PURPLE
                }
            end

            -- End of round
            if Madcap.Funcs.get_end_of_round(context) then
                return MadLib.food_joker_logic(card)
            end
        end,
        perishable_compat   = false,
        demicoloncompat     = true,
    },
}
