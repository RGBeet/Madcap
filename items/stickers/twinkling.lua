function Card:set_rgmc_twinkling(bool,tally)
    self:set_temp_sticker('rgmc_twinkling',bool,tally or 1)
end

function Card:calculate_rgmc_twinkling()
end

return {
    data = {
        object_type = "Sticker",
        key     = "rgmc_twinkling",
        atlas   = 'stickers',
        pos     = MLIB.coords(0,3),
        badge_colour = HEX('15BE59'),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(G.GAME and card.ability.rgmc_twinkling_tally or 4)
        end,
        calculate = function(self, card, context)
            if context.end_of_round then
                if math.floor(card.ability.rgmc_twinkling_tally - 1) > 0 then
                    card.ability.rgmc_twinkling_tally = math.floor(card.ability.rgmc_twinkling_tally - 1)
                    if card.area == G.hand then
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize{type='variable',
                                key = 'a_remaining',
                                vars = { card.ability.rgmc_twinkling_tally }
                            }, colour = G.C.FILTER, delay = 0.45
                        })
                    end
                else
                    local visible = card.area == G.hand or card.area == G.play
                    MadLib.simple_event(function()
                        card.ability.rgmc_twinkling_tally   = 0
                        card.ability.rgmc_twinkling         = nil
                        card:set_edition(nil,true,true) -- remove editions
                        if not visible then return true end
                        play_sound('card3', math.random()*0.2 + 0.9, 0.35)
                        card:juice_up(0.5,0.5)
                        return true
                    end, visible and 0.5 or 0, visible and 'after' or 'immediate')
                end
            end
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_twinkling = true
            card.ability.rgmc_twinkling_tally = 1
        end,
    }
}
