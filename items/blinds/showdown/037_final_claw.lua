return {
    data = {
        object_type = 'Blind',
        key     = 'final_claw',
        atlas   = "blinds",
        pos     = MLIB.coords(34),
        boss_colour = HEX('E54C6A'),
        config = { selection_size = 3, active = false, hand_size = 0 },
        in_pool = function(self)
            return true
        end,
        loc_vars = function(self, info_queue, blind)
            local hand_limit = G.hand and G.hand.config.highlighted_limit
            local must_play = (G.GAME.blind and G.GAME.blind.key == self.key) -- you are playing this blind
                and hand_limit or (self.config.selection_size + (hand_limit or 5))
            return MadLib.collect_vars(
                number_format(self.config.selection_size),
                number_format(must_play))
        end,
        set_blind = function(self, reset, silent)
            if not G.GAME.blind.disabled then
                local select_size = (G.hand and G.hand.config.highlighted_limit or 0) + self.config.selection_size
                local hand_size = (G.hand and G.hand.config.card_limit or 0)
                local add_hand_size = hand_size - select_size

                SMODS.change_play_limit(self.config.selection_size)
                if add_hand_size < 0 then
                    self.config.hand_size = -add_hand_size
                    G.hand:change_size(-add_hand_size)
                end
                self.config.active = true
            end
        end,
        loc_vars = function(self, info_queue, blind)
            local _numer, _denom = SMODS.get_probability_vars(self, 1, 4, 'final_vino')
            return MadLib.collect_vars(number_format(_numer), number_format(_denom))
        end,
        defeat = function(self, silent)
            if not G.GAME.blind.disabled then
                self.config.active = false
                SMODS.change_play_limit(self.config.selection_size)
                if self.config.hand_size > 0 then
                    self.config.hand_size = 0
                    G.hand:change_size(-self.config.hand_size)
                end
            end
        end,
        disable = function(self, silent)
            if self.config.active then -- nice try, chicot
                SMODS.change_play_limit(self.config.selection_size)
                self.config.active = false
                if self.config.hand_size > 0 then
                    self.config.hand_size = 0
                    G.hand:change_size(-self.config.hand_size)
                end
            end
        end,
        debuff_hand = function(self, cards, hand, handname, check)
            return (not G.GAME.blind.disabled and #cards ~= G.hand.config.highlighted_limit) -- must play highlight limit
        end,
    }
}
