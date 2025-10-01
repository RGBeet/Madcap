return {
    categories = {
        'Tags'
    },
    data = {
        object_type = "Tag",
        key     = "chippy",
        atlas   = "tags",
        pos     = MLIB.coords(0,6),
        config = { x_chips = 2.0 },
        loc_vars = function(self, info_queue, tag)
            return MadLib.collect_vars(number_format(self.config.x_chips))
        end,
        in_pool = function()
            return true -- Always appears!
        end,
        apply = function(self, tag, context)
            if context.type == "final_scoring_step" then
                SMODS.calculate_effect({ xchips = self.config.x_chips }, tag) -- add X2 Chips
            end
            if context.type == "eval" then -- Disappear at end of blind
                tag:yep("X", G.C.CHIPS, function() return true end)
                tag.triggered = true
                return true
            end
        end
    }
}
