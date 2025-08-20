return {
    categories = {
        'Tags',
        'Reward',
        'Sinister Cards'
    },
    data = {
        object_type = "Tag",
        key     = "ruinous_mk2",
        atlas   = "antags",
        pos     = MLIB.coords(3,1),
        config = { type = "new_blind_choice" },
        loc_vars = function(self, info_queue, tag)
            MadLib.add_to_queue({ set = "Other", key = "p_rgmc_ruinous_mega", specific_vars = { 2, 5 } })
            return Madcap.BlankVar
        end,
        in_pool = function()
            return false -- special tag for target deck
        end,
        apply = function(self, tag, context)
            if context.type == "new_blind_choice" then
                Madcap.Funcs.open_booster_quick('rgmc_ruinous_mega')
                tag.triggered = true
                return true
            end
        end
    }
}
