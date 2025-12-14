local function copy_table(src)
    local dst = {}
    for i = 1, #src do
        dst[i] = src[i]
    end
    return dst
end

local function combinations(t, combo_size, start, current, result)
    if #current == combo_size then
        table.insert(result, copy_table(current))
        return
    end
    for i = start, #t do
        table.insert(current, t[i])
        combinations(t, combo_size, i + 1, current, result)
        table.remove(current)
    end
end

local function get_combinations(t, combo_size)
    local result = {}
    combinations(t, combo_size, 1, {}, result)
    return result
end

function Madcap.Funcs.get_best_hand(cards)
    local combo_list = get_combinations(cards, 5)
    tell('Combo list is size ' .. number_format(#combo_list) .. '.')
    local poker_hand_table = { ['High Card'] = true }

    MadLib.loop_func(combo_list, function(c)
        local _, _, poker_hands, _, _ = G.FUNCS.get_poker_hand_info(c)
        --print(poker_hands)
        MadLib.loop_table(poker_hands, function(k,v)
            if (type(v) == 'table' and #v > 0) and poker_hand_table[k] == nil then
                poker_hand_table[k] = true
                tell(k .. ' is TRUE!')
            end
        end)
    end)

    local best_hand     = 'High Card'
    local best_score    = 0
    local best_level    = 1

    local poker_hand_list = {}
    for k,_ in pairs(poker_hand_table) do poker_hand_list[#poker_hand_list+1] = k end
    --print(poker_hand_table)

    MadLib.loop_func(poker_hand_list, function(h)
        if not G.GAME.hands[h].visible then return end
        local score     = MadLib.multiply(G.GAME.hands[h].chips, G.GAME.hands[h].mult)
        local change    = false
        tell('Hand: ' .. h .. ', Score: ' .. number_format(score))
        if MadLib.compare_numbers(score, best_score) > 0 then
            change = true
        elseif MadLib.compare_numbers(score, best_score) == 0 then
            if MadLib.compare_numbers(G.GAME.hands[h].level, best_level) > 0 then change = true end
        end
        if not change then return end
        best_hand   = h
        best_score  = MadLib.multiply(G.GAME.hands[h].chips, G.GAME.hands[h].mult)
        best_level  = G.GAME.hands[h].level
    end)

    return best_hand
end

return {
    categories = {
        'Unfinished Content',
        'Chaotic Jokers'
    },
    data = {
        object_type = "Joker",
        key     = 'superego',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 'rgmc_chaotic',
        cost    = 50,
        config  = {
            extra = { powchips = 1.30 },
            immutable = { penalty = 0, best_hand = nil }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.powchips), localize(card.ability.immutable.best_hand, 'poker_hands'))
        end,
        calculate = function(self, card, context)

            -- Upon finishing card draw, check if best hand has changed
            -- TODO: ensure that highest? rank is drawn. Maybe.
            if context.finished_drawing then
                local best_hand = Madcap.Funcs.get_best_hand(G.hand.cards)
                if best_hand ~= card.ability.immutable.best_hand then
                    card.ability.immutable.best_hand = best_hand
                    return { message = localize(card.ability.immutable.best_hand, 'poker_hands') }
                end
            end
            
            -- The main part
            if context.joker_main or context.forcetrigger then
                return { emult = card.ability.extra.powchips, card = card }
            end
        end,       
        remove_from_deck = function(self, card, from_debuff)
            --G.jokers.config.card_limit = lenient_bignum(G.jokers.config.card_limit + card.ability.immutable.penalty)
        end,
        demicoloncompat = false,
    }
}