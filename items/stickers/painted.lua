function Card:set_rgmc_painted(_painted,tally)
    self:set_temp_sticker('rgmc_painted',bool,tally or 1)
end

function Card:calculate_rgmc_painted()
    Madcap.Funcs.handle_sticker_calculation(self, 'rgmc_painted')
    --self:set_ability(G.P_CENTERS.c_base)
end

return {
    data = {
        object_type = "Sticker",
        key     = "rgmc_painted",
        atlas   = 'stickers',
        pos     = MLIB.coords(0,2),
        badge_colour = HEX('8D67E7'),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(G.GAME and card.ability.rgmc_painted_tally or 4)
        end,
        calculate = function(self, card, context)
            if context.end_of_round and not context.repetition and not context.individual then
                card:calculate_rgmc_painted(false)
            end
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_painted = true
            card.ability.rgmc_painted_tally = 1
        end,
    }
}
