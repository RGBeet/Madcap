
local cce = Card.calculate_enhancement
function Card:calculate_enhancement(context)
	local ret = cce(self, context)

	return ret
end

function Card:get_rank_from_id()
	for k,v in pairs(SMODS.Ranks) do
		if v.id == self:get_id() then return v end
	end
	return nil
end

function Card:has_high_rank()
    if SMODS.has_no_rank(self) then return false end
    local _rank = self:get_rank_from_id()
    return (_rank and _rank.nominal > 6)
end

function Card:has_low_rank()
    if SMODS.has_no_rank(self) then return false end
    local _rank = self:get_rank_from_id()
    return (_rank and _rank.nominal <= 6)
end

function Card:nosuit()
    return SMODS.has_enhancement(self, "m_stone")
		or SMODS.has_enhancement(self, "m_rgmc_bismuth")
		or self.config.center.no_suit
end
