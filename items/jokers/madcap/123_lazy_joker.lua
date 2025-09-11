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
        key     = 'lazy_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(12,2),
        rarity  = 2,
        cost    = 5,
        add_to_deck = function(self, card, from_debuff)
            G.GAME.subhand_minimum = G.GAME.subhand_minimum - 1
        end,
        remove_from_deck = function(self, card, from_debuff)
            G.GAME.subhand_minimum = G.GAME.subhand_minimum + 1
        end,
        in_pool = function(self, args) -- can play Dark subhands
            MadLib.loop_table(G.GAME.subhands, function(_,v)
                if v.enabled then return true end
            end)
            return false
        end,
        demicoloncompat = false
    }
}
