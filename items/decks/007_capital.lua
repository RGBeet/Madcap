return {
    categories = {
        'Decks',
    },
    data = {
        object_type = "Back",
        key     = "capital",
        atlas   = 'decks',
        pos     = MLIB.coords(1,1),
        config = { starting_money  = 20, boss_money_mult = 2, blind_price = 3, shop_price = 2, },
        loc_vars = function(self)
            local bankrupt = (G.GAME and G.GAME.bankrupt_at) or 0
            return MadLib.collect_vars(self.config.starting_money, self.config.boss_money_mult, self.config.blind_price, self.config.shop_price, math.max(-100,bankrupt))
        end,
        apply = function(self, back)
            G.GAME.modifiers.rgmc_deck          = true  -- music activated
            G.GAME.modifiers.rgmc_capital       = true
            G.GAME.modifiers.bankrupt_kill      = true
            G.GAME.modifiers.blind_price        = self.config.blind_price
            G.GAME.modifiers.shop_price         = self.config.shop_price
            G.GAME.starting_params.dollars      = self.config.starting_money
            G.GAME.modifiers.boss_money_mult    = self.config.boss_money_mult
        end,
        calculate = function(self, deck, context)
            if context.setting_blind then
                --tell("Removing the MONEY!")
                local _mult = (G.GAME.blind.boss and G.GAME.modifiers.boss_money_mult or 1)
                ease_dollars(-G.GAME.modifiers.blind_price * _mult)
            end
            if context.starting_shop then
                --tell("Removing the MONEY!")
                ease_dollars(-G.GAME.modifiers.shop_price)
            end
        end,
        trigger_effect = function(self, args)
            if args.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
                --???
                ease_dollars(G.GAME.modifiers.blind_price)
            end
        end
    }
}
