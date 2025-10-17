return {
    data = {
        object_type = "Joker",
        key     = 'toga_joker_311',
        atlas   = 'toga_jokers',
        pos     = MLIB.coords(0,2),
        rarity  = 3,
        cost    = 10,
        config =  {
            extra = {
                h_size           = 3,
                selection_size  = -2,
                levels          = 1,
                active_hand     = false
            }
        },
        calculate = function(self, card, context)
            if
                context.before
                and context.scoring_name
            then
                card.ability.extra.active_hand = context.scoring_name
                level_up_hand(context.blueprint_card or card, card.ability.extra.active_hand, nil, 1)
            end

            if
                context.after
                and card.ability.extra.active_hand ~= nil
            then
                level_up_hand(context.blueprint_card or card, card.ability.extra.active_hand, nil, -1)
                card.ability.extra.active_hand = nil
            end
        end,
        add_to_deck = function(self, card, from_debuff)
            SMODS.change_play_limit(card.ability.extra.selection_size)
            G.hand:change_size(card.ability.extra.h_size)
        end,
        remove_from_deck = function(self, card, from_debuff)
            SMODS.change_play_limit(-card.ability.extra.selection_size)
            G.hand:change_size(-card.ability.extra.h_size)
        end,
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.h_size), number_format(card.ability.extra.selection_size), number_format(card.ability.extra.levels))
        end,
        demicoloncompat = false,
    }
}
