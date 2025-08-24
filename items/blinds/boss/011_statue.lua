return {
    data = {
        object_type = 'Blind',
        key     = 'statue',
        atlas   = "blinds",
        pos     = MLIB.coords(10),
        mult = 2,
        dollars = 5,
        config = {
            extra = { odds = 6 }
        },
        in_pool = function(self)
            return true
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = { G.GAME and G.GAME.probabilities.normal or 1, self.config.extra.odds or 6 } }
        end,
        calculate = function(self, blind, context)

            if
                context.final_scoring_step
                and not G.GAME.blind.disabled
            then
                local stoned = false
                for k,v in pairs(context.scoring_hand) do
                    if -- fixed  1 in 6
                        (pseudorandom(pseudoseed("rgmc_statue")) < ((G.GAME.probabilities.normal) / self.config.extra.odds))
                    then
                        tell('STONED!')
                        -- turn to stone
                        stoned = true
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:set_ability(G.P_CENTERS.m_stone)
                                v:juice_up()
                                return true
                            end
                        }))
                    end
                end
                if stoned then
                    -- make concrete noise for the laughs
                    print("H!!!")
                end
            end
        end,
    }
}
