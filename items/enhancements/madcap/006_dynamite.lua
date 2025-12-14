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
        config = { 
            extra = { 
                x_score = 1.4, 
                x_mult = 2, 
                odds = 6, 
            }
        },
        disenhancement      = true,
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'dynamite')
            local x_score = math.max(0,card.ability.extra.x_score)
            return MadLib.collect_vars(number_format(MadLib.round(x_score,2)), number_format(_numer), number_format(_denom))
        end,
        calculate = function(self, card, context)
            if context.cardarea == G.play and context.main_scoring then
                return { 
                    xscore          = card.ability.extra.x_score,
                    after_scoring   = true 
                }
            end

            if 
                context.ml_post_scoring
                and context.scoring_hand
            then
                if 
                    context.other_card == card 
                    --and SMODS.pseudorandom_probability(card, 'dynamite', 1, card.ability.extra.odds) 
                then
                    local target = card
                    print('Kaboom!')
                    MadLib.event({
                        func    = function()
                            Madcap.Funcs.explode_card(card)
                            --target:start_dissolve()
                            return true
                        end,
                        trigger = 'after',
                        delay   = 0.8
                    })
                end
            end
        end,
    }
}
