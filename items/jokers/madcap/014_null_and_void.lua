return {
    data = {
        object_type = "Joker",
        key     = 'null_and_void',
        atlas   = 'jokers',
        pos     = MLIB.coords(1,3),
        rarity  = 1,
        cost    = 3,
        config =  {
            extra = {
                cards_to_debuff = 1
            },
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.cards_to_debuff or 1)
        end,
        calculate = function(self, card, context)
            if context.before then
                local self_index    = MadLib.get_item_index(card, G.jokers.cards)
                local end_point     = math.min(self_index + (card.ability.extra.cards_to_debuff or 1), #G.jokers.cards)
                --tell('Self index is ' .. tostring(self_index) .. '.')
                MadLib.loop_func(G.jokers.cards, function(v,i)
                    local debuffed = v.ability.debuff_sources and v.ability.debuff_sources['rgmc_null_and_void']
                    if (i < self_index or i > end_point) and debuffed then
                        MadLib.simple_event(function()
                            SMODS.debuff_card(v, false, 'rgmc_null_and_void')
                            v:juice_up(0.3, 0.4)
                            play_sound('rgmc_revert', 1, 0.6)
                            return true
                        end, 0.3, 'before')
                    elseif
                        i > self_index
                        and not debuffed
                        and i <= end_point
                    then
                        MadLib.simple_event(function()
                            SMODS.debuff_card(v, true, 'rgmc_null_and_void')
                            v:juice_up(0.7, 0.5)
                            play_sound('rgmc_laser', 1, 0.6)
                            return true
                        end, 0.3, 'before')
                    end
                end)
            end

            if context.round_eval then
                for i = 1, #card.area.cards do
                    local v = card.area.cards[i]
                    if 
                        (not (v == card or v.config.center.key == card.config.center.key)) 
                        and v.ability.debuff_sources and v.ability.debuff_sources['rgpd_odd_man_out'] 
                    then
                        MadLib.simple_event(function()
                            SMODS.debuff_card(v, false, 'rgmc_null_and_void')
                            v:juice_up(0.7, 0.5)
                            play_sound('rgmc_revert', 1, 0.6)
                            return true
                        end, 0.3, 'before')
                    end
                end
            end
        end,
        in_pool = function(self, args) -- at least one Joker
            return G.jokers and #G.jokers.cards > 0
        end,
        perishable_compat   = false,
        blueprint_compat    = false,
        demicoloncompat     = false,
    },
}
