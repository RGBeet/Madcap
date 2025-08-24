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
        config  = { x_score = 1.5 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.x_score) or '??')
        end,
        should_apply = false,
        apply = function(self, card, val)
        end,
        bismuth = true,
        calculate = function(self, card, context)
            -- to purple
            if context.main_scoring and context.cardarea == G.play then
                card.ability.rgmc_purple_bismuth = true
                return {
                    message = "...?",
                    colour = G.C.PURPLE
                }
            end
            -- purpled
            if context.after and card.ability.rgmc_purple_bismuth then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4,
                    func = function()
                        G.GAME.chips = (to_big(G.GAME.chips)) * (to_big(card.ability.x_score))
                        G.HUD:get_UIE_by_ID('chip_UI_count'):juice_up(0.3, 0.3)
                        play_sound('holo1')
                        card.ability.rgmc_purple_bismuth = nil -- not needed now
                        return true
                    end,
                }))
                return {
                    message = "X" .. format_number(card.ability.x_score),
                    colour = G.C.PURPLE
                }
            end
        end,
    }
}
