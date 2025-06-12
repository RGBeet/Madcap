-- cryptid decks be like "OOH WAH OOH WAH"
if Cryptid and Cryptid.edeck_sprites then
    local cryptid_atlas = "cryptid_decks"
    Cryptid.edeck_sprites.enhancement.m_rgmc_ferrous = { atlas = cryptid_atlas, pos = { x = 0, y = 0} }
    Cryptid.edeck_sprites.enhancement.m_rgmc_wolfram = { atlas = cryptid_atlas, pos = { x = 1, y = 0} }
    Cryptid.edeck_sprites.enhancement.m_rgmc_lustrous = { atlas = cryptid_atlas, pos = { x = 2, y = 0} }
    Cryptid.edeck_sprites.seal.rgmc_patina = { atlas = cryptid_atlas, pos = { x = 0, y = 2} }
    Cryptid.edeck_sprites.seal.rgmc_bronze = { atlas = cryptid_atlas, pos = { x = 1, y = 2} }
    Cryptid.edeck_sprites.seal.rgmc_jade = { atlas = cryptid_atlas, pos = { x = 2, y = 2} }
    Cryptid.edeck_sprites.seal.rgmc_cream = { atlas = cryptid_atlas, pos = { x = 3, y = 2} }
    Cryptid.edeck_sprites.seal.rgmc_umber = { atlas = cryptid_atlas, pos = { x = 4, y = 2} }
    Cryptid.edeck_sprites.edition.rgmc_iridescent = { atlas = cryptid_atlas, pos = { x = 1, y = 1} }
    Cryptid.edeck_sprites.edition.rgmc_infernal = { atlas = cryptid_atlas, pos = { x = 0, y = 1} }
    Cryptid.edeck_sprites.edition.rgmc_chrome = { atlas = cryptid_atlas, pos = { x = 3, y = 1} }
    Cryptid.edeck_sprites.edition.rgmc_disco = { atlas = cryptid_atlas, pos = { x = 2, y = 1} }
    Cryptid.edeck_sprites.suit.rgmc_goblets = { atlas = cryptid_atlas, pos = { x = 3, y = 0} }
    Cryptid.edeck_sprites.suit.rgmc_towers = { atlas = cryptid_atlas, pos = { x = 4, y = 0} }
end

local get_pos = function(_y,_x)
    return { x=_x, y=_y }
end

--[[
    PALE DECK:
    - Apply Negative edition to 1/4 of total playing cards
        (prioritie base edition cards)
    - Decrease starting hand size by 2.
    - Decrease hands by 1
    - The Force is guaranteed to appear once every 8 antes
    - Midnight Void is guaranteed as first Showdown Blind,
        and has a 1 in 3 chance to reappear after Ante 8
]]
local pale = {
	object_type = "Back",
    key = "pale",
    atlas = 'decks',
    config = {
        hand_size = -4,
        hands = -2
    },
    pos = get_pos(0,0),
    config = { },
    loc_vars = function(self)
        return {
            vars = {
                self.config.hand_size or -4,
                self.config.hands or -1,
                (G.GAME and G.GAME.MADCAP) and math.floor(#G.playing_cards/4) or 13
            }
        }
    end,
    apply = function(self) -- Start of the run
        tell('Pale Deck applied!')

        G.GAME.modifiers.rgmc_deck    = true  -- music activated
		G.GAME.modifiers.rgmc_pale = true
		G.GAME.modifiers.rgmc_force_chance = 7        -- 1 in 7, turns into 1 in 1 at Ante 7
		G.GAME.modifiers.rgmc_force_awakened = false  -- forces "the force" if true (until beaten)

		G.GAME.MADCAP.deck_finishers = { 'bl_rgmc_final_void' }    -- force midnight void
    end,
	calculate = function(self, card, context)
        if
            context.setting_blind        -- start of round
        then
            local seed = pseudoseed('rgmc_pale_deck_'..tostring(G.GAME.round_resets.ante))
            local number = math.floor(#G.playing_cards/4)

            pseudoshuffle(G.playing_cards,seed)
            for i=1,number do
                if not G.playing_cards[i].pale_deck then
                    G.playing_cards[i].pale_deck = true
                    G.playing_cards[i]:set_rgmc_twinkling(true)
                    G.playing_cards[i]:set_edition({ negative = true },true,true)
                end
            end

            -- rest of cards
            for i=number+1,#G.playing_cards do
                if G.playing_cards[i].pale_deck then
                    G.playing_cards[i].pale_deck = nil
                end
            end
        end
    end
}

--[[
    HEXING DECK:
    - Start with six suits (Goblets/Towers added) with
        ranks from 6 to Ace.
    - Start with special suits enabled.
    - Han Purple Hoop is guaranteed as first Showdown Blind,
        and has a 1 in 3 chance to reappear after Ante 8
]]
local hexing = {
	object_type = "Back",
    key = "hexing",
    atlas = 'decks',
    pos = get_pos(0,1),
    config = {
        starting_suits = {
            'Hearts',
            'Spades',
            'Diamonds',
            'Clubs',
            'rgmc_goblets',
            'rgmc_towers'
        },
        starting_ranks = { '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'}
    },
    loc_vars = function(self)
        return { vars = { }}
    end,
    apply = function(self)
        tell('Hexing Deck applied!')

        G.GAME.modifiers.rgmc_deck    = true  -- music activated
		G.GAME.modifiers.rgmc_hexing = true
		G.GAME.MADCAP.deck_finishers = { 'bl_rgmc_final_chimes' }    -- force wisteria chimes, i guess
    end
}


--[[
    HEXING DECK:
    - Start with only Goblets/Towers added, similar to Checkered Deck.
    - Start with special suits enabled.
    - Goblets and Tower suits are more likely to appear.
    - Verdigris Vessel is guaranteed as first Showdown Blind,
        and has a 1 in 3 chance to reappear after Ante 8
]]

local sangria = {
	object_type = "Back",
    key = "sangria",
    atlas = 'decks',
    pos = get_pos(0,2),
    config = {
        starting_suits = {'rgmc_goblets','rgmc_towers'}, -- new suits!
        starting_suits_doubles = true -- 2 of each suit/rank combo
    },
    loc_vars = function(self)
        return { vars = { }}
    end,
    apply = function(self)
        tell('Sangria Deck applied!')

        G.GAME.modifiers.rgmc_deck    = true  -- music activated
		G.GAME.modifiers.rgmc_sangria     = true
		G.GAME.MADCAP.deck_finishers      = { 'bl_rgmc_final_hoop' }    -- force han purple hoop - EVIL!
        G.GAME.Exotic = true -- also works with bunco stuff!
    end
}

--[[
    TARGET DECK:
    - Gain prizes for scoring within 1%, 5%, 10%, 25%, and 50% of the BR.
    - Gain penalties for scoring outside 100%, 200%, and 500% of the BR.
    - Tomato Target is guaranteed as first Showdown Blind,
        and has a 1 in 3 chance to reappear after Ante 8
]]

function RGMC.funcs.less_than(a,b,equals)
    if equals then
        return to_big(a) <= to_big(b)
    else
        return to_big(a) < to_big(b)
    end
end

function RGMC.funcs.greater_than(a,b,equals)
    if equals then
        return to_big(a) >= to_big(b)
    else
        return to_big(a) > to_big(b)
    end
end

function RGMC.funcs.create_target_deck_reward(list,id)
    local boosty = list[math.random(1, #list)]

    local t = Tag(id, nil)
    add_tag(t)

    G.GAME.tags[#G.GAME.tags].config.extra.booster_type = boosty
end

local target = {
	object_type = "Back",
    key = "target",
    atlas = 'rgmc_decks',
    pos = get_pos(0,3),
    config = { },
    loc_vars = function(self)
        return { vars = { }}
    end,
    apply = function(self)
        tell('Target Deck applied!')

		G.GAME.modifiers.rgmc_deck    = true  -- music activated
		G.GAME.modifiers.rgmc_target  = true
		G.GAME.MADCAP.deck_finishers  = { 'bl_rgmc_final_target' }    -- force tomato target - EVIL!

    end,
	calculate = function(self, card, context)
        if
            context.end_of_round         -- end of round
			and not context.game_over    -- do nothing if you lose
			and not context.individual
			and not context.repetition
        then
            local diff = math.abs(to_big(G.GAME.chips) - to_big(G.GAME.blind.chips)) -- difference between your chips and blind chips
            local div = to_big(diff) / to_big(G.GAME.blind.chips) -- blind chips / difference

            local punishment, prize = false, false
            tell_stat('Diff / Chips',div)

            if RGMC.funcs.less_than(div, 0.5, false) then -- div less than 50%
                -- Receive a prize!
                prize = true

                    local boosters = {}

                for k, v in pairs(G.P_CENTERS) do
                    if v.set == 'Booster' then table.insert(boosters, k) end
                end

                if RGMC.funcs.less_than(div, 0.01, false) then -- div less than 1% (prize 5)
                    RGMC.funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk2')
                    RGMC.funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
                elseif RGMC.funcs.less_than(div, 0.05, false) then -- div less than 5% (prize 4)
                    RGMC.funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
                    RGMC.funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
                elseif RGMC.funcs.less_than(div, 0.1, false) then -- div less than 10% (prize 3)
                    RGMC.funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk2')
                elseif RGMC.funcs.less_than(div, 0.25, false) then -- div less than 25% (prize 2)
                    RGMC.funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
                else -- prize 1
                    RGMC.funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
                end
            elseif RGMC.funcs.greater_than(div, 1, false) then -- div 100% or greater
                -- Receive a punishment!
                punishment = true

                if RGMC.funcs.less_than(div, 1.5, false) then -- div less than 150% (punishment 1)
                    -- apply rental to joker
                elseif RGMC.funcs.less_than(div, 2.5, false) then -- div less than 250% (punishment 2)
                    -- apply perishable to joker
                elseif RGMC.funcs.less_than(div, 4, false) then -- div less than 400% (punishment 3)
                    --  gain antag (right now only the boomerang one)
                elseif RGMC.funcs.less_than(div, 6, false) then -- div less than 600% (punishment 4)
                    -- lose 1 joker or 1 joker slot
                else -- div 600% or greater (punishment 5)
                    -- lose 1 hand size
                end
            end
        end
	end
}

--[[
    MICRO DECK:
    - Start with -3 hand size and -1 play limit - can only play High Card, Pair, or Two Pair.
    - -0.5X blind size
    - Beige Blindfold is guaranteed as first Showdown Blind,
        and has a 1 in 3 chance to reappear after Ante 8
]]

-- Poker hands that involve only <5 cards
local micro_list = {
    "High Card",
    "Pair",
    "Three of a Kind",
    "Two Pair",
    "Four of a Kind",
}

local micro = {
	object_type = "Back",
    key = "micro",
    atlas = 'rgmc_decks',
    pos = get_pos(0,4),
	config = {
        hand_size = -3,
        ante_scaling = 0.5
    },
    loc_vars = function(self)
        return { vars = { }}
    end,
	apply = function(self, back)

        -- play limit go boing boing
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.7,
			func = function()
				SMODS.change_play_limit(-1)
				return true
			end,
		}))

		-- remove hands with 5+ cards
        for _, v in ipairs(G.handlist) do
            local valid = false
            for _, v2 in ipairs(micro_list) do
                if v == v2 then
                    valid = true
                    break
                end
            end
            if not valid then -- must be doable with 4 hand size
                G.GAME.hands[v].visible = false
            end
        end

        G.GAME.modifiers.rgmc_deck    = true  -- music activated
		G.GAME.modifiers.rgmc_target = true
		G.GAME.MADCAP.deck_finishers = { 'bl_rgmc_final_blindfold' }    -- force tomato target - EVIL!

	end,
	calculate = function(self, card, context)
		local iter, iterlimit = 0, 1024 -- Just so we don't freeze the game.
		while
            G.GAME.round_resets.blind_choices.Boss == 'bl_psychic'
            and (G.hand.card_limit < 5 or G.GAME.starting_params.play_limit < 5) -- Must be able to play 5 cards
        do
			G.GAME.round_resets.blind_choices.Boss = get_new_boss()
			iter = iter + 1
			if iter >= iterlimit then break end
		end
	end
}

local list = {}

local decks = {
    pale,
    hexing,
    sangria,
    target,
    micro
}

for i=1, #decks do
    list[i] = decks[i]
end

for i=1, #list do
    if list[i] then list[i].order = i-1 end
end

return {
    name = "Decks",
    init = function() print("Decks!") end,
    items = decks
}
