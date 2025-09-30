return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'simple_simon',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 'rgmc_unusual',
        cost    = 16,
        config = { 
            extra = { 
                hands       = 1,
                h_size      = 2,
                active      = true
            },
            immutable = {
                h_size_decrement    = 0,
                hands_increment     = 0,
            }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(
                number_format(card.ability.extra.hands),
                number_format(-card.ability.extra.h_size),
                number_format(card.ability.immutable.hands_increment),
                number_format(-card.ability.immutable.h_size_decrement))
        end,
        calculate = function(self, card, context)
            if context.setting_blind then
                card.ability.extra.active = true
                MadLib.event({
                    func = function()
                        ease_hands_played(card.ability.immutable.hands_increment)
                        SMODS.calculate_effect(
                            { message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.immutable.hands_increment } } },
                            context.blueprint_card or card)
                        return true
                    end
                })
            end
            if
                (context.joker_main
                    and card.ability.extra.active
                    and G.GAME.current_round.hands_left == 0
                    and not context.blueprint)
                or context.forcetrigger
            then
                card.ability.extra.active = false
                MadLib.event({
                    func = function()
                        ease_hands_played(card.ability.extra.hands)
                        SMODS.calculate_effect(
                            { message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.extra.hands } } },
                            context.blueprint_card or card)
                        return true
                    end
                })
                card.ability.immutable.hands_increment = card.ability.immutable.hands_increment + card.ability.extra.hands
                card.ability.immutable.h_size_decrement = card.ability.immutable.h_size_decrement + card.ability.extra.h_size
                G.hand:change_size(card.ability.extra.h_size)
            end
        end,
        remove_from_deck = function(self, card, from_debuff)
            if card.ability.immutable.h_size_decrement == 0 then return end
            G.hand:change_size(card.ability.immutable.h_size_decrement)
        end
    },
}
