return {
    data = {
        object_type = "Joker",
        key     = 'waveworx',
        atlas   = 'jokers',
        pos     = MLIB.coords(4,3),
        rarity  = 3,
        config  = { extra = { poker_hand = 'Straight' }},
        cost    = 7,
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(
                localize(card.ability.extra.target_hand, 'poker_hands'),
                G.GAME.current_round.hands_played == 0
                    and localize("k_active_ex")
                    or localize("rgmc_inactive"))
        end,
        calculate = function(self, card, context)
            if context.setting_blind or context.forcetrigger then
                G.GAME.force_poker_hand = card.ability.extra.target_hand or 'Straight'
                local eval = function() return G.GAME.current_round.hands_played > 0 end
                juice_card_until(card, eval, true)
            end
            if G.GAME.current_round.hands_played == 0 and context.after then G.GAME.force_poker_hand = nil end
        end,
        demicoloncompat = true,
    }
}
