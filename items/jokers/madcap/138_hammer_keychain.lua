return {
    categories = {
        'Unfinished Content',
    },
    data = {
        object_type = "Joker",
        key     = 'hammer_keychain',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 3,
        cost    = 7,
        config =  {
            extra = {
                selection_size = 1,
                h_size = 1,
                hands = -1,
                d_size = -1
            }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.selection_size),
                number_format(card.ability.extra.h_size),
                number_format(card.ability.extra.hands),
                number_format(card.ability.extra.d_size))
        end,
        add_to_deck = function(self, card, from_debuff)
            SMODS.change_play_limit(card.ability.extra.selection_size)
            SMODS.change_discard_limit(card.ability.extra.selection_size)
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
            G.hand:change_size(card.ability.extra.h_size)
            ease_discard(card.ability.extra.d_size)
            ease_hands_played(card.ability.extra.hands)
        end,
        remove_from_deck = function(self, card, from_debuff)
            SMODS.change_play_limit(-card.ability.extra.selection_size)
            SMODS.change_discard_limit(-card.ability.extra.selection_size)
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
            G.hand:change_size(-card.ability.extra.h_size)
            ease_discard(-card.ability.extra.d_size)
            ease_hands_played(-card.ability.extra.hands)
        end,
        demicoloncompat = false,
    }
}
