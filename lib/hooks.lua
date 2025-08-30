local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    ret.visibility_rate = 0 -- Poptart
    ret.last_spectral = nil -- Pact
    ret.last_divine = nil -- Mind
    return ret
end


--Init stuff at the start of the game
local gigo = Game.init_game_object
function Game:init_game_object()
	local G = gigo(self)
	-- Add initial dropshot and number blocks card
	G.current_round = G.current_round or {}
    
    MadLib.merge_lists(G.current_round, {
        rgmc_barbershop = { rank = "7", suit = "Diamonds" },
        rgmc_edwin_card = { rank = "3", suit = "Clubs" },
    })

    -- Create G.GAME.events when starting a run, so there's no errors
	G.events        = {}
	G.jokers_sold   = {}
	G.dead_jokers   = {}

    G.madcap_content_rate   = 0
    G.spatia_rate       = 0
    G.cosma_rate        = 0
    G.potentia_boost    = 0
    
    return G
end

local add_to_deck_ref = Card.add_to_deck
function Card:add_to_deck(from_debuff)
	if (not self.added_to_deck) and not from_debuff then
		if self.added_to_deck and self.ability and self.ability.rgmc_positive and G.hand then
			G.hand.config.card_limit = G.hand.config.card_limit - 1
		end
	end
	add_to_deck_ref(self, from_debuff)
end

local remove_from_deck_ref = Card.remove_from_deck
function Card:remove_from_deck(from_debuff)
	if self.added_to_deck and self.ability and self.ability.rgmc_positive and G.hand and not from_debuff then
		if self.added_to_deck and self.ability and self.ability.rgmc_positive and G.hand then
			G.hand.config.card_limit = G.hand.config.card_limit + 1
		end
	end
	remove_from_deck_ref(self, from_debuff)
end

local card_get_id_ref = Card.get_id
function Card:get_id()
	if not get_id_use then
		get_id_use = true

		local id = card_get_id_ref(self) or self.base.id

		if id == "rgmc_X" then -- x cards equal
            id = SMODS.Ranks[G.GAME.x_value].id
		end

		if -- Rio (legendary)
            next(SMODS.find_card('j_rgmc_legend_rio'))
            and id == 14
        then
            -- counts as either queen, king, or ace depending on which has fewest cards
            -- at start of blind (using G.GAME.rank_dist)
            id = SMODS.Ranks[Madcap.Funcs.get_rio_rank()].id
        end

        -- Sigma Joker
        if id == "rgmc_sum" then -- equals number cards in playing hand
            local _, _2, _3, scoring = G.FUNCS.get_poker_hand_info(G.play.cards)
            if next(SMODS.find_card('j_splash')) then scoring  = G.play.cards end
            id = Madcap.Funcs.get_hand_sigma(scoring)
		end

		get_id_use = false
		return id
	else
		get_id_use = false
		return card_get_id_ref(self)
	end
end


local score_card_ref = SMODS.score_card
function SMODS.score_card(card, context)
	if card.base.value == 'rgmc_infinity' and not infinity_scoring then
		infinity_scoring = true
		local base_value, base_id = card.base.value, card.base.id
		MadLib.loop_function(G.playing_cards, function(c)
			if c == card then return end
			card.base.value = c.base.value
			card.base.id 	= c.base.id
			score_card_ref(card, context)
		end)
		card.base.value = base_value
		card.base.id 	= base_id
		infinity_scoring = nil
		return 
	end
	score_card_ref(card, context)
end