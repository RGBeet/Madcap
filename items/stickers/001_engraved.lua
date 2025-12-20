function Card:calculate_rgmc_engraved()
    if self.ability.rgmc_engraved and self.ability.rgmc_engraved_tally > 0 then
        if self.ability.rgmc_engraved_tally == 1 then
            self.ability.rgmc_engraved_tally = 0
            card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('rgmc_enabled_ex'),colour = G.C.FILTER, delay = 0.45})
            SMODS.Stickers['rgpd_engraved']:apply(self, false)
        else
            self.ability.rgmc_engraved_tally = self.ability.rgmc_engraved_tally - 1
            card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_remaining',vars={self.ability.rgmc_engraved_tally}},colour = G.C.FILTER, delay = 0.45})
        end
    end
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
                    message = localize{ type = 'variable', key = 'a_xmult', vars = { 0.25 } },
                    x_mult = 0.25,
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
