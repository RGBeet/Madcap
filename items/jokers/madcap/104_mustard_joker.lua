return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'mustard_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(10,3),
        rarity  = 1,
        cost    = 5,
        config = { 
            extra = { chips = 10 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.chips)
        end,
        calculate = function(self, card, context)
            if 
                context.individual 
                and context.cardarea == G.play
                and #context.full_hand == 4
                and (#context.scoring_hand == 4 and not context.scoring_hand[4].debuff)
                and context.other_card
            then
                for i=1,3 do
                    if context.other_card == context.full_hand[i] then
                        return {
                            message = tostring(i)..',',
                            colour = G.C.FILTER,
                            sound = 'rgmc_mustard'..tostring(i)
                        }
                    end
                end
                if context.other_card == context.full_hand[4] then
                    context.other_card.ability.perma_bonus = MadLib.add((context.other_card.ability.perma_bonus or 0), card.ability.extra.chips)
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.CHIPS,
                        sound = 'rgmc_mustard4'
                    }
                end
            end
        end,
        demicoloncompat = false
    }
}
