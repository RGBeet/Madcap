function Madcap.Funcs.get_aoe_cards(center,cards,range)
    local left, right  = math.max(index - range, 1), math.min(index + range, #cards)
    local list, index = {}, MadLib.get_item_index(center, cards)
    if index == -1 then return {} end
    for i=left, right do
        if i ~= index then table.insert(list, cards[i]) end
    end
    return list
end

function Card:do_volatile_explode(bypass_reqs)
    -- if NOT a volatile or marked by already marked by volatile
    if
        not (bypass_reqs or SMODS.has_enhancement(v, 'm_rgmc_volatile'))
        or self.ability.volatile_marked
    then
        return false
    end

    self.ability.volatile_marked = true -- mark as volatile

    local targets, temp, ep = {}, {}, 0

    -- Hit the next
    if (self.area and self.area.cards and #self.area.cards > 1) then
        local index = MadLib.get_item_index(self, self.area.cards)
        targets = Madcap.Funcs.get_aoe_cards(self,self.area.cards,1)

        -- get the temp info
        MadLib.loop_func(targets, function(v,i)
            v:do_volatile_explode(true)
            table.insert(temp, { card = v, ind = i })
        end)

        -- closer, left, right
        table.sort(temp_cards, function(a, b)
            local abs_a, abs_b = math.abs(index-a), math.abs(index-b)
            return abs_a ~= abs_b
                and (abs_a < abs_b)
                or (a < b)
        end)

        MadLib.loop_func(temp_cards, function (v, i)
            if not SMODS.has_enhancement(v, 'm_rgmc_dynamite') then
                MadLib.simple_event(function()
                    v:juice_up(0.5, 0.5)
                    v:start_dissolve()
                    return true
                end, 0.4, 'after')
                delay(0.4)
            else -- is a volatile
                MadLib.simple_event(function()
                    local _xmult = self.ability.x_mult or 2
                    v:juice_up(0.6, 0.6)
                    mult = mod_mult(mult * _xmult)
                    card_eval_status_text(v, 'extra', nil, nil, nil, {
                        message = 'X' .. number_format(_mult) , colour = G.C.RED
                    })
                    return true
                end, 0.5, 'after')
                MadLib.simple_event(function()
                    v:juice_up(1.2, 1.2)
                    v:shatter()
                    return true
                end, 0.8, 'after')
                delay(0.8)
            end
        end)
    end
    return true
end

return {
    categories = {
        'Enhancements',
        'Disenhancements',
        'Score'
    },
    data = {
        object_type = "Enhancement",
        key     = 'dynamite',
        atlas   = 'enhancements',
        pos     = MLIB.coords(1,1),
        config = { extra = { x_score = 1.4, x_mult = 2, odds = 5, active = false } },
        disenhancement      = true,
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'dynamite')
            local x_score = math.max(0,card.ability.extra.x_score)
            return MadLib.collect_vars(number_format(MadLib.round(x_score,2)), number_format(_numer), number_format(_denom))
        end,
        calculate = function(self, card, context)
            if context.cardarea == G.play and context.main_scoring then
                if SMODS.pseudorandom_probability(card, 'dynamite', 1, card.ability.extra.odds) then
                    card.ability.extra.active = true
                    MadLib.simple_event(function()
                        v:juice_up()
                        return true
                    end)
                end
                return MadLib.get_fake_score_data(MadLib.ScoreKeys.MultiScore, card,  card.ability.extra.x_score)
            end

            if context.final_scoring_step and card.ability.extra.active and context.scoring_hand then
                card:do_volatile_explode()
            end
        end,
    }
}
