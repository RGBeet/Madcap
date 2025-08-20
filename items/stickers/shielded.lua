function Card:set_rgmc_shielded(bool,tally)
    self:set_temp_sticker('rgmc_shielded',bool,tally or 3)
end

function Card:calculate_rgmc_shielded()
    Madcap.Funcs.handle_sticker_calculation(self, 'rgmc_shielded', 'rgmc_shield_removed_ex')
end

return {
    data = {
        object_type = "Sticker",
        key     = "rgmc_shielded",
        atlas   = 'stickers',
        pos     = MLIB.coords(0,0),
        badge_colour = HEX('8D67E7'),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(G.GAME and card.ability.rgmc_shielded_tally or 4)
        end,
        calculate = function(self, card, context)
            if context.end_of_round and not context.repetition and not context.individual then
                card:calculate_rgmc_shielded()
            end
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_shielded 			= true
            card.ability.rgmc_shielded_tally 	= 3
        end,
    }
}
