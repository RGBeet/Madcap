return {
    categories = {
        'Tags',
        'Unusual',
        'Chaotic'
    },
    data = {
        object_type = "Tag",
        key     = "cogito",
        atlas   = "tags",
        pos     = MLIB.coords(3,2),
        config = { type = "new_blind_choice" },
        loc_vars = function(self, info_queue)
            info_queue[#info_queue+1] = G.P_CENTERS.p_spectral_normal_1
            info_queue[#info_queue+1] = { set = "CosmaTarot", key = "c_rgmc_sleeping_ships" }
            info_queue[#info_queue+1] = { set = "CosmaTarot", key = "c_rgmc_aversion" }
        end,
        apply = function(self, tag, context)
            local lock = tag.ID
            if context.type == "new_blind_choice" then
                G.CONTROLLER.locks[lock] = true
                tag:yep('+', G.C.ORANGE,function()
                    Madcap.Funcs.open_booster_quick("rgmc_cosma")
                end)
                tag.triggered = true
                return true
            end
        end,
        in_pool = function()
            return false -- this is a very special tag
        end,
    }
}
