return {
    categories = {
        'Tags',
        'AnTags'
    },
    data = {
        object_type = "Tag",
        key     = "anti_boomerang",
        atlas   = "antags",
        pos     = MLIB.coords(0,1),
        config = {
            type = 'round_start_bonus',
            extra = { blind_increase = 0.5, antag = true }
        },
        loc_vars = function(self, info_queue, tag)
            return MadLib.collect_vars(number_format(self.config.extra.blind_increase))
        end,
        in_pool = function()
            return false -- AnTags don't appear normally.
        end,
        apply = function(self, tag, context)
            if context.type == self.config.type then
                tag:yep('+'..tostring(self.config.extra.blind_increase), G.C.RED, function() return true end)
                Madcap.Funcs.show_tag_effect_text("Blind Increased!")
                G.GAME.blind:multiply_chips(1 + (self.config.blind_increase or 0.5))
                tag.triggered = true
                return true
            end
        end
    }
}
