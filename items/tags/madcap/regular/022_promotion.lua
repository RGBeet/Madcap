return {
    categories = {
        'Tags'
    },
    data = {
        object_type = "Tag",
        key     = "promotion",
        atlas   = "tags",
        pos     = MLIB.coords(3,6),
        config = { luxury_points = 10 },
        loc_vars = function(self, info_queue, tag)
            return { vars = { tag.config.luxury_points } }
        end,
        apply = function(self, tag, context)
            if context.type == 'eval_luxury' then
                if G.GAME.last_blind and G.GAME.last_blind.boss then
                    tag:yep('+', G.C.GOLD, function()
                        return true
                    end)
                    tag.triggered = true
                    return {
                        rgmc_lp = tag.config.luxury_points,
                        condition = localize('ph_defeat_the_boss'),
                        pos = tag.pos,
                        tag = tag
                    }
                end
            end
        end
    }
}