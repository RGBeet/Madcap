return {
    data = {
        object_type = "Sticker",
        key         = "rgmc_positive",
        atlas       = 'stickers',
        pos             = MLIB.coords(0,3),
        badge_colour    = HEX('15BE59'),
        config          = { card_limit = 1 },
        loc_vars = function(self, info_queue, card)
            return { vars = { self.config.card_limit } }
        end,
        get_rate = function(self, card)
            if G.GAME.modifiers.enable_perishables_in_shop then return 0.25 end
            return 0.08
        end,
	    apply = function(self, card, val)
            card:remove_from_deck()
            card:add_to_deck()
        end,
    }
}
