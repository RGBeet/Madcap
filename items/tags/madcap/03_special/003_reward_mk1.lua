function Madcap.Funcs.booster_opened_rn()
	return (
		G.STATE == G.STATES.TAROT_PACK
		or G.STATE == G.STATES.PLANET_PACK
		or G.STATE == G.STATES.SPECTRAL_PACK
		or G.STATE == G.STATES.STANDARD_PACK
		or G.STATE == G.STATES.BUFFOON_PACK
		or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
	)
end

function Madcap.Funcs.do_the_target_tag(self, tag, params)
	local key = tag.config.extra.booster_type or 'p_arcana_normal'

	tag:yep('+', G.C.BOOSTER, function()
		SMODS.add_booster_to_shop(key,params)
		return true
	end)

	self.triggered = true
end

return {
    categories = {
        'Tags',
        'Reward',
    },
    data = {
        object_type = "Tag",
        key     = "reward_mk1",
        atlas   = "tags",
        pos     = MLIB.coords(3,0),
        config = { type = "new_blind_choice" },
        loc_vars = function(self, info_queue, tag)
            MadLib.add_to_queue({ set = "Other", key = "p_rgmc_reward_jumbo", specific_vars = { 1, 3 } })
            return Madcap.BlankVar
        end,
        in_pool = function()
            return false -- special tag for target deck
        end,
        apply = function(self, tag, context)
            if context.type == "new_blind_choice" then
                Madcap.Funcs.open_booster_quick('rgmc_reward_jumbo')
                tag.triggered = true
                return true
            end
        end
    }
}
