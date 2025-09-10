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
        key     = 'sveerz',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 2,
        cost    = 7,
        config = {
            extra = {
                mult = 0,
                mult_mod = 10
            },
            immutable = {
                suit_pattern    = {},
                pattern_length  = 4,
                pattern_current = 1 
            }
        },
        loc_vars = function(self, info_queue, card)
            if not G.playing_cards then
                return { vars = 
                    {card.ability.extra.mult_mod, 
                    card.ability.extra.mult,
                    colours = { G.C.FILTER, G.C.FILTER, G.C.FILTER, G.C.FILTER }
                }}
            end
            local total_vars    = { card.ability.extra_mult_mod, card.ability.extra.mult, colours = {} }
            local total_colours = {}
            MadLib.loop_func(card.ability.immutable.suit_pattern, function(v)
                table.insert(total_vars, localize(v, 'suits_plural'))
                table.insert(total_colours, G.C.SUITS[v])
            end)
            total_vars[colours] = total_colours
            return { vars = total_vars }
        end,
        add_to_deck = function(self, card, from_debuff)
            Madcap.Funcs.sveerz_generate_pattern(card)
        end,
        calculate = function(self, card, context)
            if 
                (context.individual 
                and context.cardarea == G.play
                and not context.blueprint)
            then
                if -- follow the pattern
                    not SMODS.has_no_suit(context.other_card)
                    and context.other_card:is_suit(card.ability.immutable.suit_pattern[card.ability.immutable.pattern_current])
                then
                    if card.ability.immutable.pattern_current < card.ability.immutable.pattern_length then
                        card.ability.immutable.pattern_current = card.ability.immutable.pattern_current + 1
                    else
                        card.ability.immutable.pattern_current = 1
                        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                        Madcap.Funcs.sveerz_generate_pattern(card)
                        return {
                            message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
                            colour = G.C.MULT
                        }
                    end
                elseif card.ability.immutable.pattern_current > 1 then
                    card.ability.immutable.pattern_current = 1
                    return {
                        message = localize('k_reset'),
                        colour = G.C.FILTER
                    }
                end
            end
            
            if (context.joker_main or context.forcetrigger) and card.ability.extra.mult > 0 then
                return { mult = lenient_bignum(card.ability.extra.mult) }
            end
        end,
        demicoloncompat = true
    }
}
