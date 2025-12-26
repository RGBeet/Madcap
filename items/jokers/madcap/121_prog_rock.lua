function Madcap.Funcs.sveerz_generate_pattern(card)
    card.ability.immutable.suit_pattern = {}
    local potential_cards = MadLib.shuffle_sort_list(G.playing_cards, card.ability.immutable.pattern_length, function(v)
        return not SMODS.has_no_suit(v)
    end) or {}
    local j = 1
    for i=1,card.immutable.pattern_length do
        card.ability.immutable.suit_pattern[i] = potential_cards[j].base.suit
        if j+1 < #potential_cards then j=j+1 end
    end
end

return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'prog_rock',
        atlas   = 'jokers',
        pos     = MLIB.coords(12,0),
        rarity  = 2,
        cost    = 7,
        config = {
            extra = {
                ranks = { '7', '8' },
                retriggers = 2
            }
        },
        loc_vars = function(self, info_queue, card)
            local ranks = Madcap.Funcs.get_joker_ranks(card, { '7', '8' })
            return { vars = {
                localize(ranks[1], 'ranks'),
                localize(ranks[2], 'ranks'),
                number_format(card.ability.extra.retriggers)
            }}
        end,
        calculate = function(self, card, context)
            if 
                (context.individual 
                and context.cardarea == G.play
                and not context.blueprint)
            then
                local ranks = Madcap.Funcs.get_joker_ranks(card, { '7', '8' })
                if MadLib.joker_check_rank(context.other_card, card, ranks[2]) then
                    local position = 0
                    local list = context.scoring_hand or {}
                    for i=1, #list do
                        if context.scoring_hand[i] == context.other_card then
                            position = i
                            break
                        end
                    end
                    for i=1, position-1 do -- if 7 is before 8, retrigger the 8 twice
                        if MadLib.joker_check_rank(list[i], card, ranks[1]) then
                            return { 
                                repetitions = card.ability.extra.repetitions
                            }
                        end
                    end
                end
            end
        end,
        demicoloncompat = false
    }
}
