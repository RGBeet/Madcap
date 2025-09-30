return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'brains_and_bronze',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 2,
        cost    = 5,
        config = { extra = { repetitions = 2 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(
                number_format(card.ability.extra.repetitions * 2),
                number_format(card.ability.extra.repetitions))
        end,
        calculate = function(self, card, context)
            if 
                context.individual
                and context.cardarea == G.play
            then
                print(context.other_card.seal)
                if context.other_card.seal == 'rgmc_bronze' then
                    return { repetitions = card.ability.extra.repetitions*2 }
                elseif context.other_card.seal == 'rgmc_patina' then
                    return { repetitions = card.ability.extra.repetitions }
                end
            end
        end,
    },
}
