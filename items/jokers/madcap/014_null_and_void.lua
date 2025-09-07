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
                    if (i < self_index or i > end_point) and v.rgmc_nullified then
                        MadLib.simple_event(function()
                            v.rgmc_nullified = nil
                            v:set_debuff(false)
                            v:juice_up(0.3, 0.4)
                            play_sound('rgmc_revert', 1, 0.6)
                            return true
                        end, 0.3, 'before')
                    elseif
                        i > self_index
                        and not (v.debuff or v.rgmc_nullified)
                        and i <= end_point
                    then
                        MadLib.simple_event(function()
                            v.rgmc_nullified = true
                            v:set_debuff(true)
                            v:juice_up(0.7, 0.5)
                            play_sound('rgmc_laser', 1, 0.6)
                            return true
                        end, 0.3, 'before')
                    end
                end)
            end

            if(context.end_of_round and context.cardarea == G.jokers) then
                MadLib.loop_func(G.jokers.cards, function(v) v.rgmc_nullified = nil end)
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
