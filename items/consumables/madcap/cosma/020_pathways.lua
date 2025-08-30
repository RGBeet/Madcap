function Madcap.Funcs.get_joker_shop_width(jokers)
	return jokers * 1.02 * G.CARD_W * (jokers > 4 and 4 / jokers or 1)
end

local buy_shop_ref = G.FUNCS.buy_from_shop
G.FUNCS.buy_from_shop = function(e)
	local r 	= buy_shop_ref(e)
    local c1 	= e.config.ref_table
	if G.GAME.rgmc_pathway and G.GAME.rgmc_pathway > 0 then
        tell('Buy from shop')

        SMODS.change_booster_limit(-1)
        if (G.shop_booster and #G.shop_booster.cards > 1) then
            G.shop_booster.cards[#G.shop_booster.cards]:start_dissolve()
        end

		SMODS.change_voucher_limit(-1)
        if (G.shop_vouchers and #G.shop_vouchers.cards > 1) then
            G.shop_vouchers.cards[#G.shop_vouchers.cards]:start_dissolve()
        end

        G.GAME.shop.joker_max = G.GAME.shop.joker_max - 1
		G.GAME.rgmc_pathway = G.GAME.rgmc_pathway - 1
		G.shop_jokers.T.w = Madcap.Funcs.get_joker_shop_width(#G.shop_jokers.cards)
		G.shop_jokers.T.h = 1.05*G.CARD_H
		G.shop:recalculate()
	end
	return r
end

return {
    categories = {
        'Cosma Tarots',
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "pathways",
        atlas   = "cosma",
        pos 	= MLIB.coords(1,9),
        cost 	= 7,
        config	= { select = 3 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.select))
        end,
        can_use = function(self, card)
            return not G.shop -- not in shop
        end,
        use = function (self, card, area, copier)
            local used_tarot = copier or card
            MadLib.simple_event(function()
                play_sound("timpani")
                card:juice_up(0.3, 0.5)
                G.GAME.rgmc_pathway = (G.GAME.rgmc_pathway or 0) + 1
                SMODS.change_booster_limit(self.config.extra or 1)
                SMODS.change_voucher_limit(self.config.extra or 1)
                G.GAME.shop.joker_max = G.GAME.shop.joker_max + (self.config.extra or 1)
                -- in case this triggers in shop?
                if G.shop then
                    G.shop_jokers.T.w = Madcap.Funcs.get_joker_shop_width()
                    G.shop_jokers.T.h = 1.05*G.CARD_H
                    G.shop:recalculate()
                end
                return true
            end, 0.3, 'after')
            Madcap.Funcs.set_last_cosma(self)
        end
    }
}
