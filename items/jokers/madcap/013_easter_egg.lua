local calc_func = function(self, card, context)
    if 
        context.end_of_round 
        and context.cardarea == G.jokers
        and not context.blueprint_card
    then
        card.ability.extra.value = MadLib.add(card.ability.extra.value, card.ability.extra.value_mod)
        return {
                message = "+" .. number_format(card.ability.extra.value_mod), -- Upgrade!
                card = card,
        }
    end
    if (context.selling_self or context.forcetrigger) then
        local shuffle = MadLib.shuffle_sort_list(G.playing_cards, MadLib.normalize_stat(card.ability.extra.value), function(v)
            return true
        end, function(a,b)
            return (a.edition and 0 or 1) > (b.edition and 0 or 1)
        end)

        MadLib.event({
            func = function()
                local table = {}
                MadLib.loop_func(shuffle, function(v,i)
                    table[v] = v.area
                    draw_card(v.area, G.play, nil, nil, nil, v)
                end)
                delay(1.5)    
                MadLib.loop_func(shuffle, function(v,i)
                    MadLib.simple_event(function()
                        v:set_edition(MadLib.get_weighted_edition(), true)
                        v:juice_up(0.5, 0.7)
                        v.ability.rgmc_easter_egg = true
                        return true
                    end, 0.8, 'after')
                end)
                for k, v in pairs(table) do
                    draw_card(G.play, v, nil, nil, nil, k)
                end
                delay(1.5)  
                return true
            end
        })
        if context.forcetrigger then card.ability.extra.value = 0 end -- force trigger resets it >:)
    end
end

if Overloaded or Cryptid then
    local calc_func_ref = calc_func
    calc_func = function(self, card, context)
        if context.checktrigger then
            return context.end_of_round 
                and context.cardarea == G.jokers
                and not context.blueprint_card
        end
        return calc_func_ref(self, card, context)
    end
end

return {
    data = {
        object_type = "Joker",
        key     = 'easter_egg',
        atlas   = 'jokers',
        pos     = MLIB.coords(1,2),
        rarity  = 1,
        cost    = 6,
        config =  {
            extra = { value = 2, value_mod = 1 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.value, card.ability.extra.value_mod)
        end,
        calculate = calc_func,
        demicoloncompat = true,
    },
}
