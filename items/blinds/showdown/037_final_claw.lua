function Madcap.Funcs.boss_claw_end(self,silent)
    if G.GAME.blind.disabled then return end
    SMODS.change_play_limit(self.config.selection_size)
    if self.config.hand_size > 0 then
        G.hand:change_size(-self.config.hand_size)
        --self.config.hand_size = 0
    end
end

return {
    data = {
        object_type = 'Blind',
        key     = 'final_claw',
        atlas   = "blinds",
        pos     = MLIB.coords(34),
        boss_colour = HEX('E54C6A'),
        config = { selection_size = 3, active = false},
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
                    G.hand:change_size(add_hand_size)
                end
                self.config.active = true
            end
        end,
        defeat  = Madcap.Funcs.boss_claw_end,
        disable = Madcap.Funcs.boss_claw_end,
        debuff_hand = function(self, cards, hand, handname, check)
            return (not G.GAME.blind.disabled 
                and #cards ~= G.hand.config.highlighted_limit) -- must play highlight limit
        end,
    }
}
