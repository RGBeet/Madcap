return {
    data = {
        object_type = 'Blind',
        key     = 'final_gauntlet',
        atlas   = "blinds",
        pos     = MLIB.coords(48),
        boss_colour = HEX('E2A646'),
        debuff = {
            rgmc_blind_multiblind = true,
        },
        in_pool = function(self)
            return false -- must be uhhh
        end,
        set_blind = function(self, reset, silent)
            --print('Golden Gauntlet Begin!')
            G.GAME.force_finisher_music = true
            if G.GAME.golden_gauntlet == nil then
				--Madcap.Funcs.assist_set_blind()
                G.GAME.golden_gauntlet = {
                    current = 0,
                    max     = 3
                }
                G.GAME.multi_stage_boss = true
            end
        end,
    }
}
