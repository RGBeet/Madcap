-- To be fixed once scaling is implemented in the stable release???

-- Used for x/e vars
Madcap.PercentageValues= {
    'x_mult', 'x_chips', 'e_mult', 'e_chips', 'x_score', 'e_score'
}

-- Mostly used
function Madcap.Funcs.get_food_joker_stats(joker)
    local key = joker.config.center.key
    local index = MadLib.MLIB.coordsition_in_list_prefix(key, MadLib.JokerLists.Food, 'j')
    if index == -1 then return nil end -- not a food joker
    local stats = {}
    local target = type(joker.ability.extra) == 'table' and joker.ability.extra or joker.ability
    for k,v in pairs(target) do stats[k] = v end
    for _,v in pairs(Madcap.PercentageValues) do
        if stats[v] then stats[v] = stats[v] - 1 end
    end
    -- check for specific joker things
    -- chinese takeout and radioactive chinese only do stat of chosen "food"
    return stats -- must have at least one thing
end

return {
    devmode = true,
    data = {
        object_type = "Joker",
        key         = 'legend_lollipop',
        atlas       = 'jokers_legendary',
        pos         = MLIB.legend(2,false),
        soul_pos    = MLIB.legend(2,true),
        rarity      = 4,
        cost        = 19,
        config =  {
            extra = {
                mult    = 0,
                x_mult  = 1,
                e_mult  = 1,
                chips   = 0,
                x_chips = 1,
                e_chips = 1,
                money   = 0,
            },
            immutable = { div = 0.5 }
        },
        loc_vars = function(self, info_queue, card)
            -- Not the best way to handle dynamic values
            -- but this'll do for now!
            for k, v in pairs(card.ability.extra) do
                local default = MadLib.list_matches_one({'x_','e_'}, function(_k) return string.sub(k, 1, 2) == _k end) and 1 or 0
                if v ~= default then
                    info_queue[#info_queue + 1] = {
                        set = "Other",
                        key = "rgmc_accum_"..k,
                        vars = { v }
                    }
                end
            end

        end,
        calculate = function(self, card, context)
            -- Triggers whenever a compatible Food Joker loses value
            if context.rgmc_food_descale then
                print(context.rgmc_food_descale.value)
                local value     = context.rgmc_food_descale.value
                local amount    = MadLib.round(context.rgmc_food_descale.amt * card.ability.immutable.div, 3)
                local vtype     = MadLib.ScoreKeySets[value]
                if card.ability.extra[value] and amount > 0 then
                    card.ability.extra[value] = card.ability.extra[value] + amount
                    if MadLib.ScoreKeySets[value] then
                        local t = MadLib.ScoreKeys[MadLib.ScoreKeySets[value]]
                        return {
                            message = localize({
                                type    = "variable",
                                key     = t.key,
                                vars    = { number_format(lenient_bignum(to_big(amount))) },
                                card    = card
                            }),
                        colour = t.colour
                        }
                    else
                        return {
                            message = localize("!"),
                            colour = G.C.RGMC_UNUSUAL
                        }
                    end
                end
            end
            if context.forcetrigger or (context.cardarea == G.jokers and context.joker_main) then
                local ret = {}
                return {
                    chips       = card.ability.extra.chips ~= 0 and card.ability.extra.chips or nil,
                    mult        = card.ability.extra.mult ~= 0 and card.ability.extra.mult or nil,
                    x_mult      = card.ability.extra.x_mult ~= 1 and card.ability.extra.x_mult or nil,
                    x_chips     = card.ability.extra.x_chips ~= 1 and card.ability.extra.x_chips or nil,
                }
            end
        end,
        demicoloncompat   = true,
    }
}
