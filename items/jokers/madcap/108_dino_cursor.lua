return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'dino_cursor',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 6,
        config = {
            immutable = { play_limit = 1, discard_limit = -1 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.immutable.play_limit, card.ability.immutable.discard_limit)
        end,
        add_to_deck = function(self, card, from_debuff)
            SMODS.change_play_limit(card.ability.immutable.play_limit)
            SMODS.change_discard_limit(card.ability.immutable.discard_limit)
        end,
        remove_from_deck = function(self, card, from_debuff)
            SMODS.change_play_limit(-card.ability.immutable.play_limit)
            SMODS.change_discard_limit(-card.ability.immutable.discard_limit)
        end,
        demicoloncompat = false,
    }
}
