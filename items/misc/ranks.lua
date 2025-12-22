local unstable_enabled = next(SMODS.find_mod("UnStable"))
local list = {}

local grangriss = true

if 1==1 then -- Regular Ranks
    -- Knight: goes between Jack and Queen .
    -- If Royal Family is installed, is replaced by Cavalier (TODO!)
    local knight = {
        object_type = "Rank",
        lc_atlas = 'bs_nr_lc',
        hc_atlas = 'bs_nr_lc',
        hidden = grangriss,
        key = 'Knight',
        card_key = 'KN',
        pos = { x = 0 },
        nominal = 10,
        face_nominal = 0.15,
        face = true,
        --strength_effect = { fixed = 2, random = false, ignore = false },
        shorthand = 'C',
        straight_edge = false,
        in_pool = function(self, args)
            if args and args.initial_deck then
                return false
            end
            return (not grangriss) or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
        end,
    }

    -- M, the funny one. Counts as a face card cause it has the M.
    local m = {
        object_type = "Rank",
        lc_atlas = 'bs_nr_lc',
        hc_atlas = 'bs_nr_lc',
        hidden = grangriss,
        key = 'Madcap',
        card_key = 'M',
        pos = { x = 1 },
        nominal = 13,
        face_nominal = 0,
        face = true,
        shorthand = 'M',
        straight_edge = false,
        in_pool = function(self, args)
            if args and args.initial_deck then
                return false
            end
            return (not grangriss) or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
        end,
    }

    -- Phi/Golden Ratio: 1.618. Counts as a Fibonacci number.
    -- If UnStable is installed, can count as 1 or 2.
    local phi = {
        object_type = "Rank",
        lc_atlas = 'bs_nr_lc',
        hc_atlas = 'bs_nr_lc',
        hidden = grangriss,
        key = 'Phi',
        card_key = 'Phi',
        pos = { x = 2 },
        nominal = 1.618,
        face_nominal = 0,
        shorthand = 'Ph',
        straight_edge = false,
        in_pool = function(self, args)
            if args and args.initial_deck then
                return false
            end
            return (not grangriss) or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
        end,
    }

    MadLib.loop_func({ knight, m, phi } , function(v) table.insert(list,v) end)
end

if 3 == 3 then -- Dynamic Ranks
    -- X: Counts as a random hidden rank* each Ante
    -- *Cannot equal ranks with nominals less than 0 or greater than 21
    local x = {
        object_type = "Rank",
        lc_atlas = 'bs_nr_lc',
        hc_atlas = 'bs_nr_lc',
        hidden = grangriss,
        key = 'X',
        card_key = 'X',
        pos = { x = 3 },
        nominal = 0,
        face = false,
        face_nominal = 20,
        shorthand = 'X',
        straight_edge = false,
        in_pool = function(self, args)
            if args and args.initial_deck then
                return false
            end
            return (not grangriss) or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
        end,
    }

    -- Sum: Equals the sum of all played* numbered cards in hand
    -- *Does not need to score!
    local sum = {
        object_type = "Rank",
        lc_atlas = 'bs_nr_lc',
        hc_atlas = 'bs_nr_lc',
        hidden = grangriss,
        key = 'Sum',
        card_key = 'Sum',
        pos = { x = 4 },
        nominal = 0,
        face = false,
        face_nominal = 50,
        shorthand = '=',
        straight_edge = false,
        in_pool = function(self, args)
            if args and args.initial_deck then
                return false
            end
            return (not grangriss) or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
        end,
    }

    --[[
    -- Infinity: Counts as all ranks played and held in hand (Moved to Overclocked)
    local infinity = {
        object_type = "Rank",
        lc_atlas = 'bs_nr_lc',
        hc_atlas = 'bs_nr_lc',
        hidden = grangriss,
        key = 'Infinity',
        card_key = 'Inf',
        pos = { x = 5 },
        nominal = 0,
        face = false,
        face_nominal = 70,
        shorthand = '~',
        straight_edge = false,
        in_pool = function(self, args)
            if args and args.initial_deck then
                return false
            end
            return (not grangriss) or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
        end,
    }
    MadLib.loop_func({ x, sum, infinity } , function(v) table.insert(list,v) end)
    ]]
end

if 4 then -- UNO Ranks
    -- Draw 2: If scoring hand contains at least 1 Draw 2, draw +2 cards before scoring.
    local uno_draw_2 = {
        object_type = "Rank",
        lc_atlas = 'bs_nr_lc',
        hc_atlas = 'bs_nr_lc',
        hidden = grangriss,
        key = 'Draw2',
        card_key = 'Draw2',
        pos = { x = 6 },
        nominal = 10,
        face = true,
        face_nominal = 0.001,
        shorthand = 'D2',
        straight_edge = false,
        in_pool = function(self, args)
            if args and args.initial_deck then
                return false
            end
            return (not grangriss) or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
        end,
    }

    -- Skip: If scoring hand contains at least 1 Skip, gives +1 Discard before scoring.
    local uno_skip = {
        object_type = "Rank",
        lc_atlas = 'bs_nr_lc',
        hc_atlas = 'bs_nr_lc',
        hidden = grangriss,
        key = 'Skip',
        card_key = 'Skip',
        pos = { x = 7 },
        nominal = 10,
        face = true,
        face_nominal = 0.002,
        shorthand = 'Sk',
        straight_edge = false,
        in_pool = function(self, args)
            if args and args.initial_deck then
                return false
            end
            return (not grangriss) or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
        end,
    }

    -- Reverse: Once scored, reverse the scoring order for the hand.
    local uno_reverse = {
        object_type = "Rank",
        lc_atlas = 'bs_nr_lc',
        hc_atlas = 'bs_nr_lc',
        hidden = grangriss,
        key = 'Reverse',
        card_key = 'Reverse',
        pos = { x = 8 },
        nominal = 10,
        face = true,
        face_nominal = 0.003,
        shorthand = 'Rv',
        straight_edge = false,
        in_pool = function(self, args)
            if args and args.initial_deck then
                return false
            end
            return (not grangriss) or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
        end,
    }
    MadLib.merge_lists(list, { uno_draw_2, uno_skip, uno_reverse })
end


-- 10 and a Half: +10.5 Chips, a Pair can score a Blackjack.
-- If UnStable is installed, can count as a 10 or an 11.
local ten_half = {
    object_type = "Rank",
    lc_atlas = 'bs_hr_lc',
	hc_atlas = 'bs_hr_lc',
	hidden = grangriss,
    key = '10.5',
    card_key = 'TH',
    pos = { x = 0 },
    nominal = 10.5,
    face = false,
    shorthand = '10.5',
	straight_edge = false,
	in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        end
        return (not grangriss) or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
    end,
}

-- High Cards, cards past 10

if true or MadcapConfigs['High Ranks'] then -- High Cards are enables
    local high_cards = { ten_half }
    MadLib.loop_func({ 16, 24, 32, 34, 52, 55, 64, 128 }, function(v,i)
        table.insert(high_cards, {
            object_type = "Rank",
            lc_atlas = 'bs_hr_lc',
            hc_atlas = 'bs_hr_lc',
            hidden = grangriss,
            key         = tostring(v),
            card_key    = tostring(v),
            pos         = { x = i },
            nominal     = v,
            face        = false,
            shorthand   = tostring(v),
            straight_edge = false,
            in_pool = function(self, args)
                if args and args.initial_deck then
                    return false
                end
                return (not grangriss) or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
            end,
        })
    end)
    MadLib.merge_lists(list, high_cards)
end

if not unstable_enabled then
    
    local zero = {
        object_type = "Rank",
        lc_atlas = 'bs_ur_lc',
        hc_atlas = 'bs_ur_lc',
        hidden = grangriss,
        key = '0',
        card_key = '0',
        pos = { x = 0 },
        nominal = 0,
        face = false,
        shorthand = '10.5',
        straight_edge = false,
        in_pool = function(self, args)
            if args and args.initial_deck then
                return false
            end
            return (not grangriss) or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
        end,
    }
    
    local one_half = {
        object_type = "Rank",
        lc_atlas = 'bs_ur_lc',
        hc_atlas = 'bs_ur_lc',
        hidden = grangriss,
        key = '0.5',
        card_key = '0.5',
        pos = { x = 1 },
        nominal = 0.5,
        face = false,
        shorthand = '10.5',
        straight_edge = false,
        in_pool = function(self, args)
            if args and args.initial_deck then
                return false
            end
            return (not grangriss) or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
        end,
    }

    tell('UnStable not installed - adding some ranks from UnStable')
    -- Cards normally added by UnStable, but can be added by Madcap if UnStable is not installed.
    local unst_cards = { zero, one_half }
    MadLib.loop_func({ 1, 11, 12, 13, 21, 25}, function(v,i)
        table.insert(unst_cards, {
            object_type = "Rank",
            lc_atlas = 'bs_ur_lc',
            hc_atlas = 'bs_ur_lc',
            hidden = grangriss,
            key         = tostring(v),
            card_key    = tostring(v),
            pos         = { x = i+1 },
            nominal     = v,
            face        = false,
            shorthand   = tostring(v),
            straight_edge = false,
            in_pool = function(self, args)
                if args and args.initial_deck then
                    return false
                end
                return (not grangriss) or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
            end,
        })
    end)
    MadLib.merge_lists(list, unst_cards)
else
    tell('UnStable installed - no need to add ranks.')
end

return { name = "Ranks", items = list }
