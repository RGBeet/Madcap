return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'triangle',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 3,
        config = {
            extra = { rank = '3', repetitions = 1 },
            immutable = { cards = 0 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.rank or '2', 'ranks'),
                card.ability.extra.repetitions, 
                card.ability.immutable.cards)
        end,
        calculate = function(self, card, context)
            if 
                (context.individual and context.cardarea == G.play and not context.blueprint)
                or context.forcetrigger 
            then
                if card.ability.immutable.cards < 3 then
                    if MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.rank or '3'].id) then
                        card.ability.immutable.cards = card.ability.immutable.cards + 1
                        return { message = tostring(card.ability.immutable.cards) .. '/3' }
                    end
                    if context.forcetrigger then card.ability.immutable.cards = 3 end
                    if card.ability.immutable.cards == 3 then
                        local eval = function(card) return card.ability.immutable.card == 0 and (not G.RESET_JIGGLES) end
                        juice_card_until(card, eval, true)
                    end
                else -- retriggers the next card
                    card.ability.immutable.cards = 0
                    return { repetitions = card.ability.extra.repetitions }
                end
            end
        end,
        demicoloncompat = true
    }
}
