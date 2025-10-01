return {
    data = {
        object_type = "Joker",
        key     = 'sticker_shock',
        atlas   = 'jokers',
        pos     = MLIB.coords(5,3),
        rarity  = 1,
        cost    = 7,
        config = {
            extra = { chips = 20 }
        },
        in_pool = function()
            -- if eternals/perishables/rentals/pinned are available in shop
            local stickers = MadLib.get_stickered_cards()
            return G.GAME.modifiers.enable_eternals_in_shop
                or G.GAME.modifiers.enable_perishables_in_shop
                or G.GAME.modifiers.enable_rentals_in_shop
                or G.GAME.modifiers.cry_enable_pinned_in_shop
                or (stickers and #stickers > 0) -- # of bad-stickered jokers
        end,
        loc_vars = function(self, info_queue, card)
            local stickers = MadLib.get_stickered_cards()
            return MadLib.collect_vars(card.ability.extra.chips, card.ability.extra.chips * (stickers and #stickers or 0))
        end,
        calculate = function(self, card, context)
            if (context.before or context.forcetrigger) then
                local stickers = MadLib.get_stickered_cards()
                if stickers and #stickers > 0 then
                    MadLib.loop_func(stickers, function(v)
                        MadLib.simple_event(function()
                            v:juice_up(0.2, 0.5)
                            return true
                        end, 0.1, 'immediate')
                    end)
                    return { chips = #stickers * card.ability.extra.chips }
                end
            end
        end,
        demicoloncompat = true,
    }
}
