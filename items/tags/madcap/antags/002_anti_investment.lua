return {
    categories = {
        'Tags',
        'AnTags'
    },
    data = {
        object_type = "Tag",
        key     = "anti_investment",
        atlas   = "antags",
        pos     = MLIB.coords(1,1),
        config = { extra = { dollars = 15, antag = true } },
        loc_vars = function(self, info_queue, tag)
            return MadLib.collect_vars(number_format(self.config.extra.blind_increase))
        end,
        in_pool = function()
            return false -- AnTags don't appear normally.
        end,
        apply = function(self, tag, context)
            if context.type == 'eval' then
                if G.GAME.last_blind and G.GAME.last_blind.boss then
                    tag:yep('+', G.C.GOLD, function()
                        return true
                    end)
                    local amount = -tag.config.extra.dollars
                    if (G.GAME.dollars + amount) < G.GAME.bankrupt_at then
                        -- you CANNOT AFFORD!
                        tell()
                        local debt = math.abs(G.GAME.dollars + amount)
                        amount = amount + (G.GAME.dollars + amount)

                    end
                    tag.triggered = true
                    return {
                        dollars = amount,
                        condition = localize('ph_defeat_the_boss'),
                        pos = tag.pos,
                        tag = tag
                    }
                end
            end
        end
    }
}
