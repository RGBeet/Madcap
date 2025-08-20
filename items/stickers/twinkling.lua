function Card:set_rgmc_twinkling(bool,tally)
    self:set_temp_sticker('rgmc_twinkling',bool,tally or 1)
end

function Card:calculate_rgmc_twinkling()
    handle_sticker_calculation(self, 'rgmc_twinkling')
    --self:set_edition(nil,true,true)
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
            if context.end_of_round and not context.repetition and not context.individual then
                card:calculate_rgmc_twinkling(false)
            end
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_twinkling = true
            card.ability.rgmc_twinkling_tally = 1
        end,
    }
}
