return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'live_joker_reaction',
        atlas   = 'jokers',
        pos     = MLIB.coords(10,2),
        rarity  = 1,
        cost    = 6,
        config = { 
            extra = { dollars = 12, dollar_mod = 4, starting_amount = 12 },
            immutable = { max_sum = 19, reset = false }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.dollars, card.ability.immutable.max_sum, card.ability.extra.dollar_mod)
        end,
        calculate = function(self, card, context)
            -- If it exceeds max sum, reduce the payout!
            if (context.before and MadLib.get_hand_sum(context.scoring_hand) > card.ability.immutable.max_sum) then
                card.ability.extra.dollars = card.ability.extra.dollars - card.ability.extra.dollar_mod
                return {
                    message = localize { type = 'variable', key = 'a_dollars', vars = { card.ability.extra.dollar_mod } },
                    colour  = G.C.RED
                }
            end
            -- Reset!
            if context.setting_blind and card.ability.immutable.reset then
                card.ability.immutable.reset = false
                card.ability.extra.dollars = card.ability.extra.starting_amount
                return { message = localize('k_reset') }
            end
            -- Show it's about to reset back to its true value
            if 
                (context.end_of_round and G.GAME.blind.boss) 
                and (card.ability.extra.dollars ~= card.ability.extra.starting_amount)
            then
                card.ability.immutable.reset = true
                local eval = function(card) return (not card.ability.immutable.reset) and (not G.RESET_JIGGLES) end
                juice_card_until(card, eval, true)
            end
        end,
        calc_dollar_bonus = function(self, card)
            return MadLib.get_calc_bonus(card.ability.extra.money)
        end,
        demicoloncompat = false
    }
}
