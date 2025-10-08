function Madcap.Funcs.get_multistage_boss_win()
    if not G.GAME.multi_stage_boss then return nil end
    local thing = false

    if G.GAME.golden_gauntlet ~= nil and type(G.GAME.golden_gauntlet) == 'table' then
        thing = (G.GAME.golden_gauntlet.current + 1) >= G.GAME.golden_gauntlet.max
        print("Golden Gauntlet is finished? " .. tostring(thing))
    end
    
    return thing
end

function Madcap.Funcs.multistage_boss_round_end(add)
    if not G.GAME.multi_stage_boss then return false end
    
    local reset = false
    local function _reset(anim)
		G.GAME.chips = 0
		G.GAME.current_round.discards_left = math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards)
		G.GAME.current_round.hands_left = (math.max(1, G.GAME.round_resets.hands + G.GAME.round_bonus.next_hands))
		G.GAME.current_round.hands_played = 0
		G.GAME.current_round.discards_used = 0
		for k, v in pairs(G.GAME.hands) do 
			v.played_this_round = 0
		end
        
		G.GAME.blind:set_text()

        MadLib.simple_event(function()
			G.STATE = G.STATES.DRAW_TO_HAND
			G.deck:shuffle('nr'..G.GAME.round_resets.ante)
			G.deck:hard_set_T()
			G.STATE_COMPLETE = false
            return true
        end, 0, 'immediate')
        if anim then
            MadLib.simple_event(function()
                if G.GAME.rgmc_bonus_blind then G.GAME.rgmc_bonus_blind:set_text() end
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                SMODS.juice_up_blind()
                play_sound('timpani')
                return true
            end, 0, 'after')
        end
	end

    if G.GAME.golden_gauntlet ~= nil and type(G.GAME.golden_gauntlet) == 'table' then
        G.GAME.golden_gauntlet.current = G.GAME.golden_gauntlet.current + 1
        print("Golden Gauntlet " .. tostring(G.GAME.golden_gauntlet.current) .. " / " .. tostring(G.GAME.golden_gauntlet.max))
        
        if G.GAME.golden_gauntlet.current < G.GAME.golden_gauntlet.max then
            G.GAME.blind.chips = G.GAME.blind.chips * 1.5
            _reset(true)
        end
        
        return true
    end
end

function Madcap.Funcs.golden_gauntlet_reset()
	G.E_MANAGER:add_event(Event({
		trigger = 'immediate',
		func = function()
			for i, v in ipairs({'blind', 'rgmc_bonus_blind'}) do
				if G.GAME[v].name == 'rgmc_final_gauntlet' then SMODS.juice_up_blind(v) end
			end
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
				play_sound('tarot2', 0.76, 0.4); _reset();return true end}))
			play_sound('tarot2', 1, 0.4)
			return true
		end
	}))
	delay(0.8)

    --[[
	-- literally just copypasted an entire set_blind chunk (i can't run the rest of it)
	for i, v in ipairs({'blind', 'rgmc_bonus_blind'}) do
		local self = G.GAME[v]
		local obj = self.config.blind
		self.disabled = false
		if self.name == 'The Eye' and not reset then
			obj = G.P_BLINDS['bl_small']	-- nuke obj to avoid smods ownership
			self.hands = {}
			for _, v in ipairs(G.handlist) do
				self.hands[v] = false
			end
		end
		
        if not self.name == 'rgmc_final_gauntlet' and obj.set_blind and type(obj.set_blind) == 'function' then
			obj:set_blind()
		elseif self.name == 'The Mouth' and not reset then
			self.only_hand = false
		elseif self.name == 'The Fish' and not reset then 
			self.prepped = nil
		elseif self.name == 'The Water' and not reset then 
			self.discards_sub = G.GAME.current_round.discards_left
			ease_discard(-self.discards_sub)
		elseif self.name == 'The Needle' and not reset then 
			self.hands_sub = G.GAME.round_resets.hands - 1
			ease_hands_played(-self.hands_sub)
		elseif self.name == 'The Manacle' and not reset then
			G.hand:change_size(-1)
		elseif self.name == 'Amber Acorn' and not reset and #G.jokers.cards > 0 then
			G.jokers:unhighlight_all()
			for k, v in ipairs(G.jokers.cards) do
				if v.facing == 'front' then
					v:flip()
				end
			end
			if #G.jokers.cards > 1 then 
				G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
					G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 0.85);return true end })) 
					delay(0.15)
					G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1.15);return true end })) 
					delay(0.15)
					G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1);return true end })) 
					delay(0.5)
				return true end })) 
			end
		end
	end
	for _, v in ipairs(G.playing_cards) do G.GAME.blind:debuff_card(v) end
	for _, v in ipairs(G.jokers.cards) do if not reset then G.GAME.blind:debuff_card(v, true) end; end]]

	G.GAME.blind:alert_debuff(true)
	if G.GAME.rgmc_bonus_blind then
		G.GAME.rgmc_bonus_blind:alert_debuff(true)
	end
	
	-- TARGET: setting_blind effects
	delay(0.4)
	G.E_MANAGER:add_event(Event({
		trigger = 'immediate',
		func = function()
			G.STATE = G.STATES.DRAW_TO_HAND
			G.deck:shuffle('nr'..G.GAME.round_resets.ante)
			G.deck:hard_set_T()
			G.STATE_COMPLETE = false
			return true
		end
	}))
end

return {
    data = {
        object_type = 'Blind',
        key     = 'final_gauntlet',
        atlas   = "blinds",
        pos     = MLIB.coords(48),
        boss_colour = HEX('E2A646'),
        in_pool = function(self)
            return true
        end,
        collection_loc_vars = function(self)
            return { vars = { number_format(1), number_format(3) } }
        end,
        loc_vars = function(self)
            local numer = (G.GAME and G.GAME.golden_gauntlet and (G.GAME.golden_gauntlet.current + 1)) or 1
            local denom = (G.GAME and G.GAME.golden_gauntlet and G.GAME.golden_gauntlet.max) or 3
            return { vars = { number_format(numer), number_format(denom) } } -- no bignum?
        end,
        set_blind = function(self, reset, silent)
            print('Golden Gauntlet Begin!')
            if G.GAME.golden_gauntlet == nil then
                
                G.GAME.rgmc_bonus_blind = Blind(0,0,2, 1)
                G.GAME.rgmc_bonus_blind:set_blind(get_new_boss())

                G.GAME.golden_gauntlet = {
                    current = 0,
                    max     = 3
                }
                G.GAME.multi_stage_boss = true
                G.HUD:recalculate()
            end
        end,
        defeat = function(self, silent)
            G.GAME.golden_gauntlet = nil
            G.GAME.multi_stage_boss = nil
        end,
        disable = function(self, silent)
            G.GAME.multi_stage_boss = nil
        end,
    }
}
