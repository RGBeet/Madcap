return {
    data = {
        object_type = "Joker",
        key     = 'changing_had',
        atlas   = 'jokers',
        pos     = MLIB.coords(2,2),
        rarity  = 1,
        cost    = 5,
        config =  {
            extra = { repetitions = 3, },
            immutable = { position = 1, changing = true }
        },
        loc_vars = function(self, info_queue, card)
            local total_repetitions = math.min(card.ability.extra.repetitions, 20)
            return MadLib.collect_vars(MadLib.get_num_position(card.ability.immutable.position or 1), number_format(total_repetitions))
        end,
        calculate = function(self, card, context)
            if
                context.repetition
                and context.cardarea == G.play
                and (context.other_card == context.scoring_hand[card.ability.immutable.position]
                or context.forcetrigger)
            then
            local total_repetitions = math.min(card.ability.extra.repetitions, 20)
                card.ability.immutable.changing = true
                return {
                    message = localize('k_again_ex'),
                    repetitions = total_repetitions,
                    card = context.other_card
                }
            end

            if context.after and card.ability.immutable.changing then
                return {
                    message = 'Changing Had!',
                    card = card,
                    func = function()
                        card.ability.immutable.changing = false
                        card.ability.immutable.position = math.random(1, G.hand.config.highlighted_limit) -- chose random hand in sequence
                        card:juice_up(0.3, 0.4)
                    end
                }
            end
        end,
        demicoloncompat = true,
    },
}
