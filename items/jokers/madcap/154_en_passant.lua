return {
    categories = {
        'Unreleased',
        'Suits' -- requires new suits to load
    },
    data = {
        object_type = "Joker",
        key     = 'en_passant',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 5,
        config = {
            extra       = { suit = 'rgmc_towers', h_size = 2 },
            immutable   = { active = 0 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                localize(card.ability.extra.suit, 'suits_singular'),
                card.ability.extra.h_size
                { G.C.SUITS[card.ability.extra.suit] })
        end,
        calculate = function(self, card, context)
            if 
                (context.end_of_round 
                and context.game_over == false 
                and context.main_eval)
                and card.ability.immutable.active > 0 
            then
                G.hand:change_size(-card.ability.immutable.active * card.ability.extra.h_size)
                card.ability.immutable.active = 0
                return {
                    colour = G.C.FILTER,
                    message = localize('k_reset')
                }
            end

            if 
                not (context.blueprint or context.retrigger_joker)
                and #context.full_hand == 1
                and G.GAME.current_round.hands_played == 0 
                and context.full_hand[1]:is_suit(card.ability.extra.suit)
            then
                card.ability.immutable.active = card.ability.immutable.active + 1
                G.hand:change_size(card.ability.extra.h_size)
            end
        end,
        remove_from_deck = function(self, card, from_debuff)
            if not (card.ability.immutable.active > 0) then return end
            G.hand:change_size(-card.ability.immutable.active * card.ability.extra.h_size)
        end,
        demicoloncompat = true,
    },
}
