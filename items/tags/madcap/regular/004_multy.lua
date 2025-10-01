return {
    categories = {
        'Tags'
    },
    data = {
        object_type = "Tag",
        key     = "multy",
        atlas   = "tags",
        pos     = MLIB.coords(0,7),
        config = { x_mult = 2.0 },
        loc_vars = function(self, info_queue, tag)
            return MadLib.collect_vars(number_format(self.config.x_mult))
        end,
        in_pool = function()
            return true -- Always appears!
        end,
        apply = function(self, tag, context)
            if context.type == "final_scoring_step" then
                SMODS.calculate_effect({ xmult = self.config.x_mult }, tag)
            end
            if context.type == eval then -- Disappear at end of blind
                tag:yep("X", G.C.MULT, function() return true end)
                tag.triggered = true
                return true
            end
        end
    }
}
