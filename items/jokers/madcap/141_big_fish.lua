return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'big_fish',
        atlas   = 'jokers',
        pos     = MLIB.coords(14,0),
        rarity  = 'rgmc_unusual',
        cost    = 15,
        config  = {
            extra = { reroll_cost = 3 },
            immutable = { boosters = 0 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.reroll_cost))
        end,
        calculate = function(self, card, context)
            if context.starting_shop then
                local big_fishes = #SMODS.find_card('j_rgmc_big_fish')
                -- add one voucher to shop if there are no vouchers
                if big_fishes - (G.shop_vouchers and #G.shop_vouchers.cards or big_fishes) > 0 then
                    local voucher = SMODS.add_voucher_to_shop()
                    voucher.cost = math.max(1, math.ceil(self.cost * 0.75))
                end
                -- keep track of number of boosters
                card.ability.immutable.boosters = #(G.shop_booster and G.shop_booster.cards or {})

                G.shop:recalculate()
            end
        
            if context.reroll_shop then
                local diff = card.ability.immutable.boosters - #(G.shop_booster and G.shop_booster.cards or {})
                -- Replenish boosters
                for i=1, diff do
                    local booster = SMODS.add_booster_to_shop() -- just add a regular booster
                    booster.cost = math.max(1, math.ceil(self.cost * 0.75))
                end
            end
        end,
        add_to_deck = function(self, card, from_debuff)
            G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost + card.ability.extra.reroll_cost
            G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost + card.ability.extra.reroll_cost)
        end,
        remove_from_deck = function(self, card, from_debuff)
            G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost - card.ability.extra.reroll_cost
            G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost - card.ability.extra.reroll_cost)
        end,
        demicoloncompat = false,
    }
}
