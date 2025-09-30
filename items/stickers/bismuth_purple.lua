local fix_value = function(card) return math.max(1, (card.ability.extra.edit_factor or 1) * Madcap.Lists.BismuthValues.Purple) end
return {
    categories = {
        'Enhancements'
    },
    data = {
        object_type = "Sticker",
        key     = "rgmc_bismuth_purple",
        atlas   = 'stickers',
        pos     = MLIB.coords(2,3),
        badge_colour = HEX("3867DD"),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(fix_value(card)))
        end,
        config = { extra = { edit_factor = 1 } },
        should_apply = false,
        bismuth = true,
        calculate = function(self, card, context)
            -- to purple
            if context.main_scoring and context.cardarea == G.play then
                card.ability.rgmc_purple_bismuth = true
                return { message = "...?", colour = G.C.PURPLE }
            end
            -- purpled
            if context.after and card.ability.rgmc_purple_bismuth then
                local _xscore = fix_value(card)
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4,
                    func = function()
                        G.GAME.chips = to_big(G.GAME.chips) * to_big(_xscore)
                        G.HUD:get_UIE_by_ID('chip_UI_count'):juice_up(0.3, 0.3)
                        play_sound('holo1')
                        card.ability.rgmc_purple_bismuth = nil -- not needed now
                        return true
                    end,
                }))
                return {
                    message = "X" .. number_format(_xscore),
                    colour = G.C.PURPLE
                }
            end
        end,
    }
}
