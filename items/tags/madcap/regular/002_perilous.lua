return {
    categories = {
        'Tags'
    },
    data = {
        object_type = "Tag",
        key     = "perilous",
        atlas   = "tags",
        pos     = MLIB.coords(0,1),
        config = { type = 'round_start_bonus', blind_increase = 0.5, dollars = 10, extra = 2 },
        loc_vars = function(self, info_queue, tag)
            return MadLib.collect_vars(
                number_format(G.GAME and self.config.blind_increase or 0.5),
                number_format(G.GAME and self.config.dollars or 20))
        end,
        in_pool = function()
            return true -- Always appears. Less likely to appear if you have >$20.
        end,
        apply = function(self, tag, context)
            if context.type == self.config.type then
                tag:yep('+', G.C.MONEY, function() return true end) -- Money
                Madcap.Funcs.show_tag_effect_text("Blind Increased!")
                G.GAME.blind:multiply_chips(1 + (self.config.blind_increase or 0.5))
                ease_dollars(self.config.dollars) -- Add money
                tag.triggered = true
                return true
            end
        end
    }
}
