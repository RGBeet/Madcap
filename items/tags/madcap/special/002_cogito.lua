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
            if context.type == "new_blind_choice" then
                local lock = tag.ID
                G.CONTROLLER.locks[lock] = true
                tag:yep("+", G.C.SECONDARY_SET.Spectral, function()
                    local key = "p_rgmc_cogito"
                    local card = Card(
                        G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
                        G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
                        G.CARD_W * 1.27,
                        G.CARD_H * 1.27,
                        G.P_CARDS.empty,
                        G.P_CENTERS[key],
                        { bypass_discovery_center = true, bypass_discovery_ui = true }
                    )
                    card.cost = 0
                    card.from_tag = true
                    G.FUNCS.use_card({ config = { ref_table = card } })
                    card:start_materialize()
                    G.CONTROLLER.locks[lock] = nil
                    return true
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
