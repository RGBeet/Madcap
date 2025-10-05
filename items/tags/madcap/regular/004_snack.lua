return {
    categories = {
        'Tags'
    },
    data = {
        object_type = "Tag",
        key     = "snack",
        atlas   = "tags",
        pos     = MLIB.coords(0,6),
        config = { extra = { mult = 20 } },
        loc_vars = function(self, info_queue, tag)
            return MadLib.collect_vars(number_format(self.config.extra.mult), number_format(self.config.extra.mult_loss))
        end,
        in_pool = function()
            return true -- Always appears!
        end,
        apply = function(self, tag, context)
            if context.type == "ml_before_scoring" then
                SMODS.calculate_effect({ mult = self.config.extra.mult }, tag)
            end
            if context.type == "eval" then -- Disappear at end of blind
                tag:yep("X", G.C.MULT, function() return true end)
                tag.triggered = true
            end
        end
    }
}
