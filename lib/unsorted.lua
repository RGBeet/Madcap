-- Checks whether the rank of a card is one
-- that is not standard (Sum, Infinity, X, Entropy's Nil)
function RGMC.funcs.is_irregular_rank(card)
	local rank = card:get_id()

	return rank == 'rgmc_sum'
end

-- the cooler irregular rank checker
function Card:is_irregular_rank()
	return self.id == 'rgmc_sum'
end

-- DEPRECATED. replace with uhh the cooler random
-- Do a random number check using the card's odds config and the game's probability stat.
function RGMC.funcs.get_random(card, seed)
    local full_seed = seed and 'rgmc_'..seed or 'rgmc'
    local first, second = pseudoseed(full_seed), (G.GAME.probabilities.normal or 1) / card.ability.extra.odds
    --tell("PROBABILITY: "..tostring(first).." then "..tostring(second))
    return first < second
end

-- card has no dang rank
function Card:norank()
    return SMODS.has_enhancement(self, "m_stone")
		or SMODS.has_enhancement(self, "m_rgmc_bismuth")
		or self.config.center.no_rank
end





