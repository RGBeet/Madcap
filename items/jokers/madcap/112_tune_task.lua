return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'tune_task',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 6,
        config = {
            extra = { chips = 50, mult = 6 },
            immutable = { position = 1, mode = 1 }
        },
        loc_vars = function(self, info_queue, card)
            local amt1 = card.ability.extra[(card.ability.immutable.mode == 1) and 'chips' or 'mult']
            local amt2 = (card.ability.immutable.mode == 1) and 'Chips' or 'Mult'
            return MadLib.collect_vars(card.ability.immutable.position, amt1, amt2)
        end,
        add_to_deck = function(self, card, from_debuff)
            if not G.jokers then return end
            card.ability.immutable.position = pseudorandom('tune_task', 1, #G.jokers.cards)
        end,
        calculate = function(self, card, context)
            -- Reset, get new position
            if context.setting_blind and G.jokers then
                card.ability.immutable.position = pseudorandom('tune_task', 1, #G.jokers.cards)
            end
            -- Check if position is met
            if context.joker_main or context.forcetrigger then
                local check_pass = card.ability.immutable.position <= #(G.jokers and G.jokers.cards or {})
                    and G.jokers.cards[card.ability.immutable.position] == card
                if check_pass or context.forcetrigger then
                    card.ability.immutable.mode = (card.ability.immutable.mode == 1) and 2 or 1 
                    return {
                        mult    = card.ability.immutable.mode == 1 and card.ability.extra.mult,
                        chips   = card.ability.immutable.mode ~= 1 and card.ability.extra.chips,
                    }
                end
            end
        end,
        demicoloncompat = true
    }
}
