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
            if context.type == 'new_blind_choice' then
                local lock = tag.ID
                G.CONTROLLER.locks[lock] = true
                tag:yep('+', G.C.SECONDARY_SET.Spectral, function()
                    local booster = SMODS.create_card { key = 'p_rgmc_ruinous_mk2', area = G.play }
                    booster.T.x = G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2
                    booster.T.y = G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2
                    booster.T.w = G.CARD_W * 1.27
                    booster.T.h = G.CARD_H * 1.27
                    booster.cost = 0
                    booster.from_tag = true
                    G.FUNCS.use_card({ config = { ref_table = booster } })
                    booster:start_materialize()
                    G.CONTROLLER.locks[lock] = nil
                    return true
                end)
                tag.triggered = true
                return true
            end
        end
    }
}
