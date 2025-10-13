return {
    categories = {
        'Tags',
        'Cosma Tarots',
    },
    data = {
        object_type = "Tag",
        key     = "cosma",
        atlas   = "tags",
        pos     = MLIB.coords(1,0),
        config = { },
        loc_vars = function(self, info_queue)
            MadLib.add_to_queue({ set = "Other", key = "p_rgmc_cosma", specific_vars = {1,3} })
            return Madcap.BlankVar
        end,
        apply = function(self, tag, context)
            local lock = tag.ID
            if context.type == "new_blind_choice" then
                G.CONTROLLER.locks[lock] = true
                tag:yep('+', G.C.ORANGE,function()
                    --?!?
                end)
                tag.triggered = true
                return true
            end
        end,
    }
}
