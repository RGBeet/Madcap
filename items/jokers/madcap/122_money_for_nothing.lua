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
        key     = 'money_for_nothing',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 2,
        cost    = 8,
        config = {
            extra = {
                ranks   = { '9', '5' },
                dollars = 4
            }
        },
        loc_vars = function(self, info_queue, card)
            return { vars = {
                localize(card.ability.extra.ranks[1], 'ranks'),
                localize(card.ability.extra.ranks[2], 'ranks'),
                number_format(card.ability.extra.dollars)
            }}
        end,
        calculate = function(self, card, context)
            if 
                (context.individual 
                and context.cardarea == G.play
                and not context.blueprint)
            then
                if MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.ranks[2]].id) then
                    local position = 0
                    for i=1, #(context.scoring_hand or {}) do
                        if context.scoring_hand[i] == context.other_card then
                            position = i
                            break
                        end
                    end
                    for i=1, position-1 do -- if 9 is before 5, gain $4
                        if MadLib.is_rank(context.scoring_hand[i], SMODS.Ranks[card.ability.extra.ranks[1]].id) then
                            return { dollars = card.ability.extra.dollars }
                        end
                    end
                end
            end
            if context.forcetrigger then
                return { dollars = card.ability.extra.dollars }
            end
        end,
        demicoloncompat = true
    }
}
