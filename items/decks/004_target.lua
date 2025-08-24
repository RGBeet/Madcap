function fib(n)
    if n < 2 then return n end
    local a, b = 0, 1
    for i = 2, n do
        a, b = b, a + b
    end
    return b
end

function Madcap.Funcs.weighted_choice(list)
    local total = 0

    MadLib.loop_table(list, function(_,v)
        total = total + v.weight
    end)

    local r = math.random(total)
    local cumulative = 0

    for _, item in ipairs(list) do
        cumulative = cumulative + item.weight
        if r <= cumulative then
            return item
        end
    end
    return nil
end

Madcap.Lists.Target = {
    [1] = { -- apply rental to random joker
        check = function()
            return #G.jokers.cards > 0
        end,
        weight = 8,
        func = function(self, card, context)
            local eligible_jokers = MadLib.get_list_matches(G.jokers.cards, function(v)
                return not v.ability.rental -- card is NOT rental.
            end)
            local target_card = pseudorandom_element(eligible_jokers, pseudoseed('rental_target'))
			if target_card then
                play_sound('generic1', 0.5 + math.random() * 0.1, 0.8)
                target_card:set_perishable(true)
            end
        end,
    },
    [2] = { -- apply perishable to random joker
        check = function()
            return #G.jokers.cards > 0
        end,
        weight = 4,
        func = function(self, card, context)
            local eligible_jokers = MadLib.get_list_matches(G.jokers.cards, function(v)
                return not v.ability.perishable -- card is NOT perishable.
            end)
            local target_card = pseudorandom_element(eligible_jokers, pseudoseed('perishable_target'))
            if target_card then
                play_sound('generic1', 0.5 + math.random() * 0.1, 0.8)
                target_card:set_perishable(true)
            end
        end,
    },
    [3] = { -- gain random antag (rebound only rn)
        weight = 4,
        func = function(self, card, context)
            local antag = pseudorandom_element(Madcap.Lists.AnTags, pseudoseed('antag_select'))
                add_tag(Tag('tag_rgmc_'..antag))
                play_sound('generic1', 0.7 + math.random() * 0.1, 0.8)
                play_sound('holo1', 0.9 + math.random() * 0.1, 0.4)
        end,
    },
    [4] = { -- -1 hand size
        weight = 2,
        check = function()
            return G.hand.config.card_limit > 1
        end,
        func = function(self, card, context)
            G.hand:change_size(-1)
        end,
    },
    [5] = { -- remove half of money or 10, whichever is more
        weight = 2,
        check = function()
            local money_removed = math.max(to_big(G.GAME.dollars), to_big(10))
            return to_big(G.GAME.dollars) - to_big(money_removed) > to_big(G.GAME.bankrupt_at)
        end,
        func = function(self, card, context)
            local money_removed = math.max(to_big(G.GAME.dollars), to_big(10))
            ease_dollars(-money_removed)
        end,
    },
    [6] = { -- decimate the deck
        check = function()
            return math.floor(#G.playing_cards/10) > 1
                and (#G.playing_cards - math.max(math.floor(#G.playing_cards/10),5)) > 0
        end,
        weight = 2,
        func = function(self, card, context)
            local selection = MadLib.shuffle_sort_list(G.playing_cards, math.max(math.floor(#G.playing_cards/10),5), function(v)
                return not v.ability.eternal
            end)
            MadLib.loop_func(selection, function(v)
                MadLib.simple_event(function()
                    if v.area == G.deck then
                        v:remove()
                    else
                        v:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                    end
                    return true
                end, 0.5, 'after')
            end)
        end,
    },
    [7] = { -- -1 consumable slot
        weight = 1,
        check = function()
            return G.consumeables.config.card_limit > 1
        end,
        func = function(self, card, context)
            G.consumeables:change_size(-1)
        end,
    },
    [8] = { -- -1 joker slot
        weight = 1,
        check = function()
            return G.jokers.config.card_limit > 1
        end,
        func = function(self, card, context)
            G.jokers:change_size(-1)
        end,
    },
    [9] = { -- gain a ruinous MK1 tag
        weight = 10,
        func = function(self, card, context)
            add_tag(Tag('tag_rgmc_ruinous_mk1'))
            play_sound('generic1', 0.5 + math.random() * 0.1, 0.8)
            play_sound('holo1', 0.8 + math.random() * 0.1, 0.4)
        end,
    },
    [10] = { -- gain a ruinous MK2 tag
        weight = 4,
        func = function(self, card, context)
            add_tag(Tag('tag_rgmc_ruinous_mk2'))
            play_sound('generic1', 0.5 + math.random() * 0.1, 0.8)
            play_sound('holo1', 0.8 + math.random() * 0.1, 0.4)
        end,
    },
    [11] = { -- weaken a random joker?!
        check = function()
            return #G.jokers.cards > 0
        end,
        weight = 4,
        func = function(self, card, context)
            local target_card = pseudorandom_element(G.jokers.cards, pseudoseed('halved_target'))
            if target_card then
                play_sound('generic1', 0.5 + math.random() * 0.1, 0.8)
                Madcap.Funcs.mayhemize(target_card, {
                    force_values 	= true,
                    min_mult 		= 0.5,
                    max_mult 		= 0.5
                }, false)
            end
        end,
    },
}

Madcap.DeckFuncs['target'] = {
    calculate = function(self, card, context)
        if context.round_eval then

            local diff = math.abs(to_big(G.GAME.chips) - to_big(G.GAME.blind.chips)) -- difference between your chips and blind chips
            local div = to_big(diff) / to_big(G.GAME.blind.chips) -- blind chips / difference
            tell_stat('Diff / Chips',div)

            if div < (self.config.reward_minimum or 0.5) then -- div less than 50%
                -- Calculate points
                local points, current, working = 0, 1, true
                while current >= 0.02 and working do
                    current = current / 2
                    local goal = MadLib.round(current, 2)
                    if div < goal then
                        points = points + 1
                    else
                        working = false
                    end
                end
                local total = math.floor((math.sqrt(8 * points + 1) - 1) / 2)  -- size of group
                local pos   = points - total * (total - 1) / 2                 -- position within group
                tell ('total is' .. tostring(total))
                for i = 1, total do
                    -- Odd position in group = mk1, even = mk2
                    local tag
                    if pos % 2 == 1 then
                        -- Odd pos → starts with mk1, then all mk1 until filled
                        tag = 'mk1'
                    else
                        -- Even pos → first (pos-1) are mk1, last one(s) mk2
                        tag = (i <= pos - 1) and 'mk1' or 'mk2'
                    end

                    MadLib.simple_event(function()
                        add_tag(Tag('tag_rgmc_reward_' .. tag))
                        play_sound('generic1', 1.2 + math.random() * 0.1, 0.8)
                        play_sound('holo1', 1.0 + math.random() * 0.1, 0.4)
                        return true
                    end, 1.0, 'after')
                end
            elseif div > 1 then -- div 100% or greater
                tell('Punishment time')
                local points, working = 0, 1, true
                while working do
                    if div > fib(points+3) then points = points + 1 else working = false end
                end
                tell_stat('Points',points)
                local tries, passes = 0, 0
                local max_tries = 100
                while passes < points and tries < max_tries do
                    local choice = Madcap.Funcs.weighted_choice(Madcap.Lists.Target)
                    if choice and (choice.check and choice.check() or true) then
                        MadLib.simple_event(function()
                            print('vibe check passed!')
                            choice.func(self, card, context)
                            return true
                        end, 1.0, 'after')
                        passes = passes + 1
                    end
                    tries = tries + 1
                end
            end
        end
    end
}

return {
    categories = {
        'Decks',
        'Sinister Cards'
    },
    data = {
        object_type = "Back",
        key     = "target",
        atlas   = 'decks',
        pos     = MLIB.coords(0,3),
        config = { reward_maximum = 0.5, penalty_minimum = 1.5 },
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
        calculate = Madcap.DeckFuncs['target'].calculate
    }
}
