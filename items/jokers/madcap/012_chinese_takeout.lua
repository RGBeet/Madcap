-- Used for both forcetrigger and normal trigger
function Madcap.Funcs.do_chinese_takeout(card)
    local ret = {}
    if
        card.ability.immutable.mode == 1
        or card.ability.immutable.mode == 3
        or card.ability.immutable.mode == 5
    then
        ret.chips = card.ability.extra.effects[card.ability.immutable.mode]
    elseif
        card.ability.immutable.mode == 2
        or card.ability.immutable.mode == 4
    then
        ret.mult = card.ability.extra.effects[card.ability.immutable.mode]
    elseif
        card.ability.immutable.mode == 6
        or card.ability.immutable.mode == 7
    then
        ret.x_mult = card.ability.extra.effects[card.ability.immutable.mode]
    else
        ret.x_score = card.ability.extra.effects[card.ability.immutable.mode]
    end
    return ret
end

local calc_func = function(self, card, context)
    if context.setting_blind and not context.blueprint then
        local new_food = math.random(1, 8)
        card.ability.immutable.mode = new_food

        if -- if doable, show a line
            card.ability.immutable.mode > 0
            and card.ability.immutable.mode <= 8
        then
            return { message = localize("rgmc_chinese_line" .. card.ability.immutable.mode) }
        end
    end
    
    if (context.cardarea == G.jokers and context.joker_main) or context.forcetrigger then
        Madcap.Funcs.do_chinese_takeout(card)
    end

    if Madcap.Funcs.get_end_of_round(context) then
        return MadLib.food_joker_logic(card)
    end
end

if Overloaded or Cryptid then
    local calc_func_ref = calc_func
    calc_func = function(self, card, context)
        if context.checktrigger then
            return context.cardarea == G.jokers and context.joker_main
        end
        return calc_func_ref(self, card, context)
    end
end

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
                rounds      = 8,
                max_rounds  = 8,
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
            immutable = { mode = 1 }
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
            return MadLib.collect_vars_colours(
                number_format(card.ability.extra.rounds),
                { MadLib.get_warning_colour(card.ability.extra.rounds / card.ability.extra.max_rounds)})
        end,
        calculate = calc_func,
        perishable_compat   = false,
        demicoloncompat     = true,
    },
}
