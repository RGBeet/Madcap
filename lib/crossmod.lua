local ggcm_ref = Madcap.Funcs.get_goldenhouse_chipmult
if G.AIJ then -- All in Jest
    -- Compat for the fancy planet cards
    function Madcap.Funcs.get_goldenhouse_chipmult(target)
        local chips, mult, changed = ggcm_ref(target)

        if changed then return chips, mult, true end

        if
            target.ability.hand_type
            and G.GAME.hands[target.ability.hand_type]
            and target.ability.jest_spec_moon
        then
            if
                -- All in Jest - chips moon
                MadLib.list_matches_one(Madcap.Lists.Moons.Chips, function(v)
                    return 'c_aij_' .. v == target.ability.key
                end)
            then
                chips   = chips + G.GAME.hands[v].chips
                changed = true
            elseif
                -- All in Jest - mult moon
                MadLib.list_matches_one(Madcap.Lists.Moons.Mult, function(v)
                    return 'c_aij_' .. v == target.ability.key
                end)
            then
                mult    = mult + G.GAME.hands[v].mult
                changed = true
            end
        end
        return chips, mult, changed
    end
end

if not Cryptid then
	--Calculate events on cash out
	local gfco = G.FUNCS.cash_out
	G.FUNCS.cash_out = function(e)
		local ret = gfco(e)
		SMODS.calculate_context({ cash_out = true })
		return ret
	end
end

-- MoreFluff compat
if next(SMODS.find_mod("MoreFluff")) then
	function Madcap.Funcs.get_enhancement_tarot_loc_vars(self, info_queue, card)
		if not (self and card) then return  { vars = {} } end
		MadLib.add_to_queue(G.P_CENTERS[self.config.mod_conv])
		return MadLib.collect_vars(card and card.ability.max_highlighted or self.config.max_highlighted,
			localize{type = 'name_text', set = 'Enhanced', key = self.config.mod_conv})
	end

	-- Progress bar for colour consumables.
	function Madcap.Funcs.get_progress_bar(val, max)
		if max > 10 then
			return val, "/"..max
		end
		return string.rep("#", val), string.rep("#", max - val)
	end

	function Madcap.Funcs.get_colour_loc_vars(self, info_queue, card)
		local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
		return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
	end

	function Madcap.Funcs.colour_can_use(self, card)
		return true
	end

	function Madcap.Funcs.colour_convert_suit(self, card, area, copier, suit)
		if not (self and card) then return end
		local blacklist = {}
		for i = 1, card.ability.val do
			local temp_pool = MadLib.get_list_matches(G.hand.cards, function(v) return not v:is_suit(suit) and not blacklist[v] end)
			if #temp_pool == 0 then break end

			local eligible_card = pseudorandom_element(temp_pool, pseudoseed(self.config.key))
			blacklist[eligible_card] = true

			MadLib.simple_event(function()
				eligible_card:flip()
				play_sound('card1', 1)
				eligible_card:juice_up(0.3, 0.3)
				return true
			end, 0.15, 'after')

			MadLib.simple_event(function()
				eligible_card:flip()
				play_sound('card1', 1)
				eligible_card:change_suit(suit)
				card:juice_up(0.3, 0.5)
				return true
			end, 0.4, 'after')
		end
	end

	function Madcap.Funcs.colour_add_consumable(self, card, area, copier, set, not_negative)
		if not (self and card) then return end
		for i = 1, card.ability.val do
			MadLib.simple_event(function()
				play_sound('timpani')
				local n = MadLib.get_random_card(set, G.consumeables, self.config.key)
				n:add_to_deck()
				n:set_edition({negative = not not_negative}, true)
				G.consumeables:emplace(n)
				card:juice_up(0.3, 0.5)
				return true
			end, 0.4, 'after')
		end
		delay(0.6)
	end

	function Madcap.Funcs.colour_add_consumable_exact(self, card, area, copier, id, not_negative)
		if not (self and card) then return end
		for i = 1, card.ability.val do
			MadLib.simple_event(function()
				play_sound('timpani')
				local n = create_card(nil, G.consumeables, nil, nil, true, true, 'c_'..id)
				n:add_to_deck()
				n:set_edition({negative = not not_negative}, true)
				G.consumeables:emplace(n)
				card:juice_up(0.3, 0.5)
				return true
			end, 0.4, 'after')
		end
		delay(0.6)
	end

	function Madcap.Funcs.colour_add_tag(self, card, area, copier, tag)
		if not (self and card) then return false end
		for i = 1, card.ability.val do
			MadLib.simple_event(function()
				add_tag(Tag('tag_'..tag))
				play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
				play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
				return true
			end)
			delay(0.2)
		end
		delay(0.6)
		return true
    end

    function Madcap.Funcs.colour_add_edition (self, card, area, copier, edition)
		if not (self and card) then return false end
		for i=1, card.ability.val do
			MadLib.simple_event(function()
				local temp_pool = MadLib.get_list_matches(G.hand.cards, function(v)
					return not v.edition
				end) or {}
				local backup_pool = MadLib.get_list_matches(G.hand.cards, function(v)
					return v.edition and not v.edition['rgmc_infernal']
				end) or {}

				local pool = (#temp_pool > 0 and temp_pool) or (#backup_pool > 0 and backup_pool)
				if pool then
					local eligible_card = pseudorandom_element(pool, pseudoseed(self.config.key))
					eligible_card:set_edition({ ['rgmc_infernal'] = true }, true)
					check_for_unlock({type = 'have_edition'})
					card:juice_up(0.3, 0.5)
				end
				return true
			end, 0.4, 'after')
		end
		return true
	end

	-- loc_var for Colours
    function Madcap.Funcs.get_colour_loc_vars(self, info_queue, card)
		if not (self and card) then return end
		local val, max = get_progress_bar(card.ability.partial_rounds, card.ability.upgrade_rounds)
		return MadLib.collect_vars(card.ability.val, val, max, card.ability.upgrade_rounds)
	end

	function Madcap.Funcs.get_poker_hand_level()
		local phand = (G.GAME and G.STATE == G.STATES.HAND_PLAYED) and G.hand or G.play
		if not (phand and phand.highlighted and #phand.highlighted > 0) then return 0 end

		local text, loc_disp_text, poker_hands, scoring_hand, disp_text = G.FUNCS.get_poker_hand_info(phand.highlighted)
		----print(poker_hands[1])

		return G.GAME.hands[poker_hands[1]] and G.GAME.hands[poker_hands[1]].level or 0
	end
end

if Partner_API then
	function Madcap.Funcs.get_partner_key()
		return G.GAME.selected_partner_card and G.GAME.selected_partner_card.key
	end

	function Madcap.Funcs.get_partner_link_level()
		return G.GAME.selected_partner_card and G.GAME.selected_partner_card:get_link_level()
	end
end

Madcap.ExtraSuits = {}
Madcap.ExtraRanks = {}

Madcap.VanillaSuits = {
	Hearts 		= true,
	Diamonds	= true,
	Clubs		= true,
	Spades		= true
}

function Madcap.Funcs.init_suit_compat(suit, prefix, p)
	Madcap.ExtraSuits[suit] = { id = prefix, pos = p }
end

function Madcap.Funcs.init_rank_compat(rank, prefix, p)
	Madcap.ExtraRanks[rank] = { id = prefix, pos = p }
end

-- suit stuff
MadLib.loop_func({'goblets','towers','blooms','daggers','voids','lanterns'}, function(v,i)
	Madcap.Funcs.init_suit_compat('rgmc_'..v,'ns',i-1) -- y coord
end)

if next(SMODS.find_mod("Bunco")) then
	MadLib.loop_func({'Fleurons', 'Halberds'}, function(v,i)
		Madcap.Funcs.init_suit_compat('bunc_'..v,'bunc',i-1) -- y coord
	end)
end

if PB_UTIL then -- paperback moment!
	MadLib.loop_func({'Stars', 'Crowns'}, function(v,i)
		Madcap.Funcs.init_suit_compat('paperback_'..v,'paperback',i-1) -- y coord
	end)
end

-- UR
MadLib.loop_func({'0','0.5','1','11','12','13','21','25'}, function(v,i)
	Madcap.Funcs.init_rank_compat(MadLib.RankIds[v], 'ur',i-1) -- x coord
end)

-- HR
MadLib.loop_func({'10.5','16','24','32','34','52','55','64','128'}, function(v,i)
	Madcap.Funcs.init_rank_compat('rgmc_'..v,'hr',i-1) -- x coord
end)

-- NR
MadLib.loop_func({'Knight','Madcap','Phi','X','Sum','Infinity','Draw2','Skip','Reverse'}, function(v,i)
	Madcap.Funcs.init_rank_compat('rgmc_'..v,'nr',i-1) -- x coord
end)

--Suit injection code based on Showdown by Mistyk__
local function inject_p_card_suit_compat(suit, rank)
	local r = Madcap.ExtraRanks[rank.key]
	local s = Madcap.ExtraSuits[suit.key]

	if not (r and s) then
        tell('FAIL for ' .. rank.key .. (r and '(+)' or '(-)') .. ' and ' .. suit.key .. (s and '(+)' or '(-)'))
        return
	end

    local full_atlas = 'rgmc_' .. s.id .. '_' .. r.id .. '_'
    --tell_stat('Full atlas is',full_atlas)
    --tell_stat('Full suit card ky thing is',suit.card_key .. '_' .. rank.card_key)

	local card = {
		name 	= rank.key .. ' of ' .. suit.key,
		value 	= rank.key,
		suit 	= suit.key,
		pos 	= { x = r.pos, y = s.pos },
		lc_atlas = full_atlas..'lc',
		hc_atlas = full_atlas..'lc'
	}
	G.P_CARDS[suit.card_key .. '_' .. rank.card_key] = card
end

local function rank_injection(self)
	----print("Performing extra rank injection YAY!")
	for _, suit in pairs(SMODS.Suits) do
		inject_p_card_suit_compat(suit, self)
	end
end

--Injected Rank List, will loop over all possible ranks
--table: key = rank_key, pos_x = rank's x position
local inject_rank_list = {}

local function inject_rank_atlas(prefix)
	MadLib.loop_table(SMODS.Ranks, function(k)
		if k:find(prefix) then
			local rank = SMODS.Ranks[k]
			rank.inject = rank_injection
			inject_rank_list[#inject_rank_list+1] = {key = k, pos_x = rank.pos.x}
			----print("Injecting the graphic for rank "..rank.key)
		end
	end)
end

inject_rank_atlas('rgmc_')
inject_rank_atlas('unstb_')

Madcap.SuitIds = { 'goblets', 'towers', 'blooms', 'daggers', 'voids', 'lanterns' }

-- Temporary code until UnStableEX updates
if next(SMODS.find_mod("UnStable")) then
	local unstb_ranks = { '21', '???', '0.5', 'e', 'Pi', '1', '0', 'r2', '11', '12', '13', '25', '161' }

	MadLib.loop_func(Madcap.SuitIds, function(v1,_y)
		MadLib.loop_func(unstb_ranks, function(v2,_x)
			local id = (_x < 9) and 'ex' or 'ex2'
			local suit = SMODS.Suits['rgmc_'..v1]
			local rank = SMODS.Ranks['unstb_'..v2]

			G.P_CARDS[suit.card_key .. '_' .. rank.card_key] = {
				name 	= rank.key .. ' of ' .. suit.key,
				value 	= rank.key,
				suit 	= suit.key,
				pos 	= { x = _x, y = _y },
				lc_atlas = 'ns_unstb_'..id..'lc',
				hc_atlas = 'ns_unstb_'..id..'lc'
			}
		end)
	end)
end

if AKYRS then
	table.insert(AKYRS.tea_cards, 'm_rgmc_boba_tea_card')
end

-- Pure ranks and suits
if AKYRS_CROSSMOD then

	local pure_atlas = 'rgmc_akyrs_pure'
	-- Madcap suits
	MadLib.loop_func(Madcap.SuitIds, function(v,i)
		AKYRS_CROSSMOD.suit_to_atlas_map['rgmc_'..v] = { pure_atlas, MLIB.coords(0,i-1) }
	end)
	-- Bunco suits
	if next(SMODS.find_mod("Bunco")) then
		MadLib.loop_func({ 'Fleurons', 'Halberds' }, function(v,i)
			AKYRS_CROSSMOD.suit_to_atlas_map['bunc_'..v] = { pure_atlas, MLIB.coords(1,i-1) }
		end)
    end
	-- Paperback suits
    if next(SMODS.find_mod("Paperback")) or PB_UTIL then
		MadLib.loop_func({ 'Stars', 'Crowns' }, function(v,i)
			AKYRS_CROSSMOD.suit_to_atlas_map['paperback_'..v] = { pure_atlas, MLIB.coords(1,i+1) }
		end)
	end
	-- UnStable/Madcap overlap ranks
	local unstb = next(SMODS.find_mod("UnStable")) and 'unstb_' or 'rgmc_'
	MadLib.loop_func({ '0', '0.5', '1', '11', '12', '13', '21', '25' }, function(v,i)
		AKYRS_CROSSMOD.suit_to_atlas_map[unstb..v] = { pure_atlas, MLIB.coords(2,i-1) }
	end)
	-- large numbers above 10
	MadLib.loop_func({ '10.5', '16', '24', '32', '34', '52', '55', '64', '128' }, function(v,i)
		local n = i+24
		AKYRS_CROSSMOD.suit_to_atlas_map['rgmc_'..v] = { pure_atlas, MLIB.coords(math.floor(n/8), (i%8)-1) }
	end)
	-- and the rest!
	MadLib.loop_func({ 'Knight', 'Madcap', 'Phi', 'X', 'Sum', 'Infinity' }, function(v,i)
		AKYRS_CROSSMOD.suit_to_atlas_map['rgmc_'..v] = { pure_atlas, MLIB.coords(4, i+1) }
	end)
	-- oh, and the UNO ranks too.
	MadLib.loop_func({ 'Draw2', 'Skip', 'Reverse' }, function(v,i)
		AKYRS_CROSSMOD.suit_to_atlas_map['rgmc_'..v] = { pure_atlas, MLIB.coords(5, i-1) }
	end)
	-- UnStable ranks
	if next(SMODS.find_mod("UnStable")) then
		MadLib.loop_func({ '161', '???', 'e', 'Pi', 'r2' }, function(v,i)
			AKYRS_CROSSMOD.suit_to_atlas_map['unstb_'..v] = { pure_atlas, MLIB.coords(5,2+i) }
		end)
	end
end

if CardSleeves then




end