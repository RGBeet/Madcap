return {
    data = {
        object_type = "Joker",
        key     = 'sticker_shock',
        atlas   = 'jokers',
        pos     = MLIB.coords(5,3),
        rarity  = 1,
        cost    = 7,
        config = {
            extra = { chips = 10 }
        },
        in_pool = function()
            return MadLib.get_card_stickers() > 0
        end,
        loc_vars = function(self, info_queue, card)
            local stickers = MadLib.get_card_stickers()
            return MadLib.collect_vars(card.ability.extra.chips, MadLib.multiply(card.ability.extra.chips, stickers))
        end,
        calculate = function(self, card, context)
            if context.joker_main or context.forcetrigger then
                local stickers = MadLib.get_card_stickers()
                if stickers > 0 then
                    MadLib.loop_func(stickers, function(v)
                        MadLib.simple_event(function()
                            v:juice_up(0.2, 0.5)
                            return true
                        end, 0.1, 'immediate')
                    end)
                    return { chips = MadLib.multiply(card.ability.extra.chips, stickers) }
                end
            end
        end,
        add_to_deck = function(self, card, from_debuff)
            G.GAME.rgmc_sticker_mod = G.GAME.rgmc_sticker_mod + 0.1
        end,
        remove_from_deck = function(self, card, from_debuff)
            G.GAME.rgmc_sticker_mod = G.GAME.rgmc_sticker_mod - 0.1
        end,
        demicoloncompat = true,
    }
}
