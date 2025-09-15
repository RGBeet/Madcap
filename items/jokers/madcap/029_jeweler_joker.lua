-- thorium joker conversions
return {
    data = {
        object_type = "Joker",
        key     = 'jeweler_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(2,8),
        rarity  = 2,
        cost    = 8,
        config = {
            enhancement = 'rgmc_lustrous', extra = { x_mult = 0.1 }
        },
        loc_vars = function(self, info_queue, card)
            local cards = G.playing_cards
                and #MadLib.get_enhanced_cards(G.playing_cards,card.ability.enhancement)
                or 0
            return MadLib.collect_vars(
                    number_format(card.ability.extra.x_mult),
                    number_format(card.ability.extra.x_mult * cards))
        end,
        calculate = function(self, card, context)
            if context.joker_main or context.forcetrigger then
                local amt = #MadLib.get_enhanced_cards(G.playing_cards,card.ability.enhancement)
                return { xmult = card.ability.extra.x_mult * (amt or 0) }
            end
        end,
        demicoloncompat = true,
    },
    in_pool = function(self, args) -- At least one Lustrous Card
        return MadLib.list_matches_one(G.playing_cards or {}, function(v)
            return SMODS.has_enhancement(v, 'm_rgmc_lustrous')
        end)
    end
}
