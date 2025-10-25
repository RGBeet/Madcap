function Card:calculate_rgmc_engraved()
    handle_sticker_calculation(self, 'rgmc_engraved', 'rgmc_enabled_ex')
end

return {
    data = {
        object_type = "Sticker",
        key     = "rgmc_engraved",
        atlas   = 'stickers',
        pos     = MLIB.coords(0,0),
        badge_colour = HEX('736C4E'),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(G.GAME and card.ability.rgmc_engraved_tally or 4)
        end,
        calculate = function(self, card, context)
            if (context.joker_main and context.cardarea == G.jokers) or (context.main_scoring and context.cardarea == G.play) then
                return {
                    message = localize{ type='variable', key='a_xmult', vars={0} },
                    x_mult = 0,
                    colour = G.C.RED,
                }
            end
            if context.end_of_round and not context.repetition and not context.individual then
                card:calculate_rgmc_engraved()
            end
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_engraved = true
            card.ability.rgmc_engraved_tally = 3
        end,
    }
}
