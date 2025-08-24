return {
    categories = {
        'Tags'
    },
    data = {
        object_type = "Tag",
        key     = "boomerang",
        atlas   = "tags",
        pos     = MLIB.coords(0,0),
        config = { type = 'round_start_bonus', x_blind = 0.5 },
        loc_vars = function(self, info_queue, tag)
            return MadLib.collect_vars(number_format(G.GAME and self.config.blind_increase or 0.5))
        end,
        in_pool = function()
            return true -- Always appears!
        end,
        apply = function(self, tag, context)
            if context.type == self.config.type then
                tag:yep('-'..tostring(self.config.x_blind), G.C.GREEN, function() return true end)
                Madcap.Funcs.show_tag_effect_text("Blind Decreased!")
                G.GAME.blind:multiply_chips(self.config.x_blind)
                Madcap.Funcs.add_anti_tag('boomerang').config.x_blind = self.config.blind_increase
                tag.triggered = true
                return true
            end
        end
    }
}
