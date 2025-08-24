return {
    categories = {
        'Tags'
    },
    data = {
        object_type = "Tag",
        key     = "multy",
        atlas   = "tags",
        pos     = MLIB.coords(0,7),
        config = { x_mult = 2.0, active = false },
        loc_vars = function(self, info_queue, tag)
            return MadLib.collect_vars(number_format(self.config.x_mult))
        end,
        in_pool = function()
            return true -- Always appears!
        end,
        apply = function(self, tag, context)
            if context.type == "new_blind_choice" then -- Activate at start of blind
                tag.config.active = true
            end
            if context.type == "final_scoring_step" then
                SMODS.calculate_effect({ xmult = self.config.x_mult }, tag) -- add X2 Chips
            end
            if context.type == "end_of_round" and tag.config.active then -- Disappear at end of blind
                tag:yep("X", G.C.RED, function() return true end)
                tag.triggered = true
                return true
            end
        end
    }
}
