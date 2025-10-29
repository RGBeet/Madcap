return {
    categories = {
        'Tags'
    },
    data = {
        object_type = "Tag",
        key     = "scoop",
        atlas   = "tags",
        pos     = MLIB.coords(0,7),
        config = { extra = { chips = 100 } },
        loc_vars = function(self, info_queue, tag)
            return MadLib.collect_vars(number_format(self.config.extra.chips), number_format(self.config.extra.chip_mod))
        end,
        in_pool = function()
            return true -- Always appears!
        end,
        apply = function(self, tag, context)
            if context.type == "ml_before_scoring" then
                SMODS.calculate_effect({ chips = self.config.extra.chips }, tag)
            end
            if context.type == "eval" then -- Disappear at end of blind
                tag:yep("X", G.C.CHIPS, function() return true end)
                tag.triggered = true
            end
        end
    }
}
