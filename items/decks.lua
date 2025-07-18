-- cryptid decks be like "OOH WAH OOH WAH"
if Cryptid and Cryptid.edeck_sprites then
    local cryptid_atlas = "rgmc_cryptid_decks"
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
local function get_pale_score(card)
    if not card then return -1 end
    local edition   = (card.edition and 10) or 0
    return edition
end

local pale = {
    key = "pale",
    config = {
        hand_size = -3,
        hands = -1
    },
    loc_vars = function(self)
        MadLib.collect_vars(self.config.hand_size, self.config.hands, (G.GAME and G.GAME.MADCAP) and math.floor(#G.playing_cards/4) or 13)
    end,
    apply = function(self) -- Start of the run
        Madcap.Funcs.init_deck('pale', {
            force_chance    = 7,         -- 1 in 7 to get The Force, turns into 1 in 1 at Ante 7
            force_awakened  = false,     -- forces The Force until beaten
            finishers       = { 'bl_rgmc_final_void' } -- force Midnight Void
        })
    end,
	calculate = function(self, card, context)
        if
            context.setting_blind        -- start of round
        then
            local seed = pseudoseed('rgmc_pale_deck_'..tostring(G.GAME.round_resets.ante))
            local number = math.floor(#G.playing_cards/4)

            local shuffle = MadLib.shuffle_sort_list(G.playing_cards, number, function(v,k)
                return not (v.edition and v.edition.negative)
            end, function(a,b)
                return get_pale_score(a) > get_pale_score(b)
            end)

            MadLib.loop_func(shuffle, function(c)
                c.pale_deck = true
                c:set_rgmc_twinkling(true)
                c:set_edition({ negative = true }, true, true)
            end)

            MadLib.loop_func(MadLib.list_pick_range(shuffle, number+1, #shuffle), function(c)
                c.pale_deck = nil
            end)
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
    key = "hexing",
    config = {
        starting_suits = {
            'Hearts', 'Spades', 'Diamonds',
            'Clubs', 'rgmc_goblets', 'rgmc_towers'
        },
        starting_ranks = { '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'}
    },
    apply = function(self)
        Madcap.Funcs.init_deck('hexing', {
            finishers       = { 'bl_rgmc_final_chimes' } -- force ???
        })
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
    key = "sangria",
    config = {
        starting_suits = {'rgmc_goblets','rgmc_towers'}, -- new suits!
        starting_suits_doubles = true -- 2 of each suit/rank combo
    },
    apply = function(self)
        Madcap.Funcs.init_deck('sangria', {
            finishers       = { 'bl_rgmc_final_moon' } -- force Macchiato Moon
        })
        G.GAME.Exotic = true -- Exotic Suits show up!
    end
}

local merlot = {
    key = "merlot",
    config = {
        starting_suits = {'rgmc_blooms','rgmc_daggers'}, -- new suits!
        starting_suits_doubles = true -- 2 of each suit/rank combo
    },
    apply = function(self)
        Madcap.Funcs.init_deck('merlot', {
            finishers       = { 'bl_rgmc_final_moon' } -- force ???
        })
        G.GAME.Exotic = true -- Exotic Suits show up!
    end
}

--[[
    TARGET DECK:
    - Gain prizes for scoring within 1%, 5%, 10%, 25%, and 50% of the BR.
    - Gain penalties for scoring outside 100%, 200%, and 500% of the BR.
    - Tomato Target is guaranteed as first Showdown Blind,
        and has a 1 in 3 chance to reappear after Ante 8
]]

local target = {
    key = "target",
    config = {
        good_max = 0.5,
        bad_min = 1.5
    },
    loc_vars = function(self)
        return MadLib.collect_vars(self.config.good_max, self.config.bad_min)
    end,
    apply = function(self)
        Madcap.Funcs.init_deck('target', {
            finishers       = { 'bl_rgmc_final_target' }, -- force ???
            target_logic    = true
        })
        G.GAME.Exotic = true -- Exotic Suits show up!
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

            if div < 0.5 then -- div less than 50%
                -- Receive a prize!
                prize = true

                    local boosters = {}

                for k, v in pairs(G.P_CENTERS) do
                    if v.set == 'Booster' then table.insert(boosters, k) end
                end

                if div < 0.01 then -- div less than 1% (prize 5)
                    Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk2')
                    Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
                elseif div < 0.05 then -- div less than 5% (prize 4)
                    Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
                    Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
                elseif div < 0.10 then -- div less than 10% (prize 3)
                    Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk2')
                elseif div < 0.25 then -- div less than 25% (prize 2)
                    Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
                else -- prize 1
                    Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
                end
            elseif div > 1 then -- div 100% or greater
                -- Receive a punishment!
                punishment = true

                if div < 1.5 then -- div less than 150% (punishment 1)
                    -- apply rental to joker
                elseif div < 2.5 then -- div less than 250% (punishment 2)
                    -- apply perishable to joker
                elseif div < 4.0 then -- div less than 400% (punishment 3)
                    --  gain antag (right now only the boomerang one)
                elseif div < 6.0 then -- div less than 600% (punishment 4)
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
    key = "micro",
	config = {
        hand_size = -3,
        play_limit = -1,
        ante_scaling = 0.5
    },
    loc_vars = function(self)
        return MadLib.collect_vars(self.config.hand_size, self.config.play_limit, self.config.ante_scaling)
    end,
	apply = function(self, back)
        -- change the play limit
        MadLib.simple_event(function()
            SMODS.change_play_limit(self.config.play_limit)
            return true
        end, 0.7, 'after')

        MadLib.loop_func(G.handlist, function(h)
            if MadLib.list_matches_one(micro_list, function(h2)
                return h == h2
            end) then
                G.GAME.hands[h].visible = false
            end
        end)

        Madcap.Funcs.init_deck('micro', {
            finishers       = { 'bl_rgmc_final_blindfold' }, -- force ???
            target_logic    = true
        })

	end,
}

local mayhem = {
    key = "mayhem",
	config = {
        mayhem          = 5,
        mayhem_scale    = 2,
        void_suit_spawn = 2
    },
    loc_vars = function(self)
        return {
            vars = {
                self.config.mayhem,
                self.config.mayhem_scale,
                self.config.void_suit_spawn
            }
        }
    end,
	apply = function(self, back)
        G.GAME.modifiers.rgmc_deck     = true  -- music activated
		G.GAME.Mayhem = 5
	end,
	calculate = function(self, card, context)
	end
}

local capital = {
    key = "capital",
	config = {
        starting_money  = 20,
        boss_money_mult = 1.5,
        blind_price     = 4,
        shop_price      = 2,
    },
    loc_vars = function(self)
        local bankrupt = (G.GAME and G.GAME.bankrupt_at) or 0
        return MadLib.collect_vars(self.config.starting_money, self.config.boss_money_mult, self.config.blind_price, self.config.shop_price, math.max(-100,bankrupt))
    end,
	apply = function(self, back)
        G.GAME.modifiers.rgmc_deck          = true  -- music activated
		G.GAME.modifiers.rgmc_capital       = true
		G.GAME.modifiers.bankrupt_kill      = true
        G.GAME.starting_params.dollars      = self.config.starting_money
        G.GAME.boss_blind_money_mult        = self.config.boss_money_mult
	end,
	calculate = function(self, deck, context)
        if context.setting_blind then
            tell("Removing the MONEY!")
            local _mult = (G.GAME.blind.boss and self.config.boss_money_mult or 1)
            ease_dollars(-self.config.blind_price * _mult)
        end

        if context.starting_shop then
            tell("Removing the MONEY!")
            ease_dollars(-self.config.shop_price)
        end
	end,
	init = function(self)

	end,
    trigger_effect = function(self, args)
        if args.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then

        end
    end
}

local lunacy = {
    key = "lunacy",
    atlas = 'rgmc_deck_lunacy',
    pos = get_pos(0,0),
	config = {
        finisher_frequency = 4,
        ante_win = 12
    },
    loc_vars = function(self)
        return MadLib.collect_vars(self.config.finisher_frequency, self.config.ante_win)
    end,
	apply = function(self, back)
        G.GAME.modifiers.rgmc_deck      = true  -- music activated
		G.GAME.modifiers.rgmc_lunacy    = true
		G.GAME.Mayhem = 10

	end,
	calculate = function(self, card, context)
	end
}

local cross = {
    key = "cross",
	config = { hand_size = 1 },
    loc_vars = function(self)
        return MadLib.collect_vars(self.config.hand_size)
    end,
	apply = function(self, back)
        G.GAME.modifiers.rgmc_deck = true  -- music activated
		G.GAME.modifiers.rgmc_cross = true

	end,
	calculate = function(self, card, context)

        -- mark the cards
		if context.scoring_hand and context.before then
            MadLib.loop_func(context.scoring_hand, function (v,i)
                if not v.debuff then v.rgmc_cross = true end
            end)
		end

		-- disable the cards the cards
        if context.cardarea == G.play and context.other_card then
            for k,v in pairs do
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    func = function()
                        SMODS.debuff_card(_card, true, 'rgmc_cross')
                        _card.rgmc_cross = nil
                        _card:juice_up(0.3, 0.3)
                        return true
                    end,
                }))
            end
        end

        -- enable the cards
        if context.playing_card_end_of_round and context.cardarea == G.hand then
            local debuffed = MadLib.get_loop_func(G.hand.cards, function (v,i)
                return v.ability.rgmc_cross -- TODO: card.ability.debuff_sources[source] = debuff
            end)
            MadLib.loop_func(debuffed, function(v,i)
                MadLib.simple_event(function()
                    v.ability.rgmc_cross = nil
                    SMODS.debuff_card(v, false, 'rgmc_cross')
                    v:juice_up(0.3, 0.3)
                    return true
                end, 0.7, 'after')
            end)
        end
	end
}

local function jumble_ranks(self)
    if G.playing_cards then return false end
    local rank_map = MadLib.get_ranks_from_cards(G.playing_cards)
    local rank_list, changed_ranks = {}, {}
    -- add to list
    MadLib.loop_func_table(rank_map, function(k,v)
        table.insert(rank_list, v)
        table.insert(changed_ranks, v)
    end)
    pseudoshuffle(changed_ranks, pseudoseed('jumble'))
    MadLib.loop_func(rank_list, function(v,i)
        G.GAME.JumbleVals[v] = changed_ranks[i] -- old
    end)
    return true
end

local jumble = {
    key = "jumble",
	config = {

    },
	apply = function(self, back)
        G.GAME.modifiers.rgmc_deck      = true  -- music activated
		G.GAME.modifiers.rgmc_jumble    = true

		G.GAME.JumbleVals = {}
		jumble_ranks(self)
	end,
	calculate = function(self, card, context)
        if
            context.seting_blind
            and (#G.GAME.JumbleVals == 0)
        then -- get the ranks

        end
	end,
	init = function(self)
        -- get id
        local get_id_ref = Card.get_id
        function Card:get_id()
            local old_id = get_id_ref(self)
            if
                G.GAME.modifiers
                and G.GAME.modifiers.rgmc_jumble
                and G.GAME.JumbleVals
                and G.GAME.JumbleVals[old_id] ~= nil
            then
                return G.GAME.JumbleVals[old_id]
            end
            -- continue as usual...
            return old_id
        end

        -- ease ante does the jumble
        local ease_ante_ref = ease_ante
        function ease_ante(mod)
            if
                G.GAME.modifiers
                and G.GAME.modifiers.rgmc_jumble
            then
                jumble_ranks(self)
            end
        end
    end
}

local list = {}
Madcap.Funcs.LoadDecks({
    pale,
    hexing,
    sangria,
    target,
    micro,
    mayhem,
    capital,
    cross,
    merlot,
    jumble,
}, list, 'rgmc_decks')

Madcap.Funcs.LoadDecks({
    lunacy,
}, list)

return {
    name = "Decks",
    init = function() print("Decks!") end,
    items = list
}
