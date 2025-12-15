return {
    categories = {
        'Subhands'
    },
    data = {
        object_type = "Joker",
        key     = 'palette',
        atlas   = 'jokers',
        pos     = MLIB.coords(8,2),
        rarity  = 3,
        cost    = 8,
        config =  {
            extra = { x_chips = 3.5 }
        },
        loc_vars = function(self, info_queue, card)
            local area = G.hand and G.hand.highlighted or {}
            return { vars = { card.ability.extra.x_chips, 5, MadLib.get_unique_enhancements(area) } }
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                local driver_tally = MadLib.get_unique_enhancements(G.play.cards)
                if driver_tally >= 5 then
                    return { xchips = card.ability.extra.x_chips }
                end
            end
            if context.forcetrigger then
                return { xchips  = card.ability.extra.x_chips }
            end
        end,
        in_pool = function(self, args)
            return MadLib.get_unique_enhancements(G.playing_cards) > 4
        end,
        demicoloncompat = true,
    }
}
