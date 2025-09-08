
-- Used for managing the future Toy Piano Joker
Madcap.ToyPiano = {
	Positions = { '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace' },
	BigSteps = { 12, 9, 7, 4, 6, 7, 5, 9, 6, 4, 1, 3, 4, 2, 6, 7, 5, 9, 10, 8, 12, 13, 11, 14, 12, 12 }
}

return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'toy_piano',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 2,
        config = { 
            extra = { chips = 0, chip_mod = 2 },
            immutable = { step = 1 }
        },
        loc_vars = function(self, info_queue, card)
            local current_step = Madcap.ToyPiano.BigSteps[card.ability.immutable.step]
            local rank = Madcap.ToyPiano.Positions[current_step]
            return MadLib.collect_vars(number_format(card.ability.extra.chip_mod),
                number_format(card.ability.extra.chip_mod*5),
                number_format(card.ability.extra.chips),
                number_format(card.ability.immutable.step),
                number_format(#Madcap.ToyPiano.BigSteps),
                localize(rank or '?', 'ranks'))
        end,
        calculate = function(self, card, context)
            if 
                context.individual 
                and context.cardarea == G.play
                and context.other_card
                and not context.blueprint
            then
                local current_step = Madcap.ToyPiano.BigSteps[card.ability.immutable.step]
                local rank = Madcap.ToyPiano.Positions[current_step]
                if MadLib.is_rank(context.other_card, SMODS.Ranks[rank or 'rgmc_X'].id) then
                    if card.ability.immutable.step < #Madcap.ToyPiano.BigSteps then -- not done yet
                        card.ability.immutable.step = card.ability.immutable.step + 1
                        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                    else
                        card.ability.immutable.step = 1
                        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod * 5
                    end
                    return {
                        colour = G.C.CHIPS,
                        message = "!",
                        func = function()
                            MadLib.simple_event(function()
                                local pitch = 1 + (current_step - 1)/12
                                play_sound('rgmc_toy_piano', pitch, 0.78)
                                return true
                            end, 0.0, 'after')
                            return true
                        end
                    }
                end
            end
            -- Give the chips
            if context.joker_main then
                return { chips = card.ability.extra.chips }
            end
        end,
        demicoloncompat = false
    }
}
