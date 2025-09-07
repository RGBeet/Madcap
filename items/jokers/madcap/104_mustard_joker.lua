return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'mustard_joker',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 5,
        config = { 
            extra = { chips = 10 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.chip_mod, card.ability.immutable.cards)
        end,
        calculate = function(self, card, context)
            if 
                context.individual 
                and context.cardarea == G.play
                and #context.full_hand == 4
            then
                if context.other_card == context.full_hand[4] then
                    context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + card.ability.extra.chips
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.CHIPS
                    }
                end
            end
        end,
        demicoloncompat = false
    }
}
