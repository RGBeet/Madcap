
local function fix_hand_size()
    -- Fix the hand size
    G.GAME.blind.hand_size = math.max(G.GAME.starting_params.hand_size,G.hand.config.card_limit)
    local diff = G.GAME.blind.hand_size - G.hand.config.card_limit
    G.hand:change_size(diff)
    return true
end

-- Set hand blind size
function Madcap.Funcs.chaotic_blind_start()
    fix_hand_size()
    local s = nil
end

-- Sets a fake blind
function Madcap.Funcs.set_fake_blind(s, self, reset, silent)
    -- custom blinds
    if s.set_blind then s:set_blind(reset, silent) end

    if s.name == "The Eye" and not reset then
        MadLib.loop_func_table(G.GAME.hands, function(k,v)
            G.GAME.blind.hands[k] = false
        end)
    end

    if s.name == "The Mouth" and not reset then
        G.GAME.blind.only_hand = false
    end

    if s.name == "The Fish" and not reset then
        G.GAME.blind.prepped = nil
    end

    if s.name == "The Water" and not reset then
        G.GAME.blind.discards_sub = G.GAME.current_round.discards_left
        ease_discard(-G.GAME.blind.discards_sub)
    end

    if s.name == "The Needle" and not reset then
        G.GAME.blind.hands_sub = G.GAME.round_resets.hands - 1
        ease_hands_played(-G.GAME.blind.hands_sub)
    end

    if s.name == "The Manacle" and not reset then
        G.hand:change_size(-1)
    end

    if s.name == "Amber Acorn" and not reset and #G.jokers.cards > 0 then
        G.jokers:unhighlight_all()
        for k, v in ipairs(G.jokers.cards) do v:flip() end
        if #G.jokers.cards > 1 then
            -- the shuffler
            MadLib.simple_event(function()
                MadLib.simple_event(function()
                    G.jokers:shuffle("aajk")
                    play_sound("cardSlide1", 0.85)
                    return true
                end)
                delay(0.15)
                MadLib.simple_event(function()
                    G.jokers:shuffle("aajk")
                    play_sound("cardSlide1", 1.15)
                    return true
                end)
                delay(0.15)
                MadLib.simple_event(function()
                    G.jokers:shuffle("aajk")
                    play_sound("cardSlide1", 1.00)
                    return true
                end)
                delay(0.5)
                return true
            end,0.2,'after')
        end
    end

    --add new debuffs?
    for _, v in ipairs(G.playing_cards) do self:debuff_card(v) end
    for _, v in ipairs(G.jokers.cards) do
        if not reset then self:debuff_card(v, true) end
    end

end


function Madcap.Funcs.defeat_fake_blind(s, self, silent)
    if s.defeat then s:defeat(silent) end

    if s.name == "The Manacle" and not self.disabled then
        G.hand:change_size(1)
    end
end

function Madcap.Funcs.disable_fake_blind(s, self, silent)
    if s.disable then s:disable(silent) end

    if s.name == "The Water" then
        ease_discard(G.GAME.blind.discards_sub)
    end

    if s.name == "The Wheel" or s.name == "The House" or s.name == "The Mark" or s.name == "The Fish" then
        MadLib.loop_func_list(G.hand.cards, function(v,i)
            if v.facing == "back" then v:flip() end
        end)
        for k, v in pairs(G.playing_cards) do v.ability.wheel_flipped = nil end
    end

    if s.name == "The Needle" then
        ease_hands_played(G.GAME.blind.hands_sub)
    end

    if s.name == "The Wall" then
        G.GAME.blind.chips = G.GAME.blind.chips / 2
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end

    if s.name == "Cerulean Bell" then
        for k, v in ipairs(G.playing_cards) do v.ability.forced_selection = nil end
    end

    if s.name == "The Manacle" then
        G.hand:change_size(1)
        G.FUNCS.draw_from_deck_to_hand(1)
    end

    if s.name == "Violet Vessel" then
        G.GAME.blind.chips = G.GAME.blind.chips / 3
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
end

function Madcap.Funcs.fake_press_play(s, self)
    if s.press_play then s:press_play() end

    if s.name == "The Hook" then
        MadLib.simple_event(function()
            local _cards, any_selected = {}, nil
            for k, v in ipairs(G.hand.cards) do _cards[#_cards + 1] = v end

            for i = 1, 2 do
                if G.hand.cards[i] then
                    local selected_card, card_key = pseudorandom_element(_cards, pseudoseed("madlib"))
                    G.hand:add_to_highlighted(selected_card, true)
                    table.remove(_cards, card_key)
                    any_selected = true
                    play_sound("card1", 1)
                end
            end
            if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end
            return true
        end)
        G.GAME.blind.triggered = true
        delay(0.7)
    end

    if s.name == "Crimson Heart" then
        if G.jokers.cards[1] then
            G.GAME.blind.triggered = true
            G.GAME.blind.prepped = true
        end
    end

    if s.name == "The Fish" then
        G.GAME.blind.prepped = true
    end

    if s.name == "The Tooth" then
        MadLib.simple_event(function()
            MadLib.loop_func(G.play.cards, function(v,i)
                -- juicy card
                MadLib.simple_event(function()
                    v:juice_up()
					return true
                end)
                ease_dollars(-1)
				delay(0.23)
            end)
        end, 0.2, 'after')
    end
end

function Madcap.Funcs.modify_fake_blind(s, self, cards, poker_hands, text, mult, hand_chips)
    local new_mult  = mult
    local new_chips = hand_chips
    local trigger   = false

    if s.modify_hand then
        local this_trigger = false
        new_mult, new_chips, this_trigger = s:modify_hand(cards, poker_hands, text, new_mult, new_chips)
        trigger = trigger or this_trigger
    end

    if s.name == "The Flint" then
        G.GAME.blind.triggered = true
        new_mult = math.max(math.floor(new_mult * 0.5 + 0.5), 1)
        new_chips = math.max(math.floor(new_chips * 0.5 + 0.5), 0)
        trigger = true
    end

    return new_mult or mult, new_chips or hand_chips, trigger
end

function Madcap.Funcs.debuff_blind(s, self, cards, hand, handname, check)
    G.GAME.blind.debuff_boss = nil

    if s.debuff_hand and s:debuff_hand(cards, hand, handname, check) then
        G.GAME.blind.debuff_boss = s
        return true
    end

    if s.debuff then
        G.GAME.blind.triggered = false
        if s.debuff.hand and next(hand[s.debuff.hand]) then
            G.GAME.blind.triggered = true
            G.GAME.blind.debuff_boss = s
            return true
        end

        if s.debuff.h_size_ge and #cards < s.debuff.h_size_ge then
            G.GAME.blind.triggered = true
            G.GAME.blind.debuff_boss = s
            return true
        end

        if s.debuff.h_size_le and #cards > s.debuff.h_size_le then
            G.GAME.blind.triggered = true
            G.GAME.blind.debuff_boss = s
            return true
        end

        if s.name == "The Eye" then
            if G.GAME.blind.hands[handname] then
                G.GAME.blind.triggered = true
                G.GAME.blind.debuff_boss = s
                return true
            end
            if not check then G.GAME.blind.hands[handname] = true end
        end

        if s.name == "The Mouth" then
            if s.only_hand and s.only_hand ~= handname then
                G.GAME.blind.triggered = true
                G.GAME.blind.debuff_boss = s
                return true
            end
            if not check then
                s.only_hand = handname
            end
        end
    end

    if s.name == "The Arm" then
        G.GAME.blind.triggered = false
        if to_big(G.GAME.hands[handname].level) > to_big(1) then
            G.GAME.blind.triggered = true
            if not check then
                level_up_hand(G.GAME.blind.children.animatedSprite, handname, nil, -1)
                G.GAME.blind:wiggle()
            end
        end
    end

    if s.name == "The Ox" then
        G.GAME.blind.triggered = false
        if handname == G.GAME.current_round.most_played_poker_hand then
            G.GAME.blind.triggered = true
            if not check then
                ease_dollars(-G.GAME.dollars, true)
                G.GAME.blind:wiggle()
            end
        end
    end

    return false
end

function Madcap.Funcs.fake_drawn_to_hand(s, self)
    if s.drawn_to_hand then s:drawn_to_hand() end

    if s.name == "Cerulean Bell" then
        local any_forced = nil
        for k, v in ipairs(G.hand.cards) do
            if v.ability.forced_selection then
                any_forced = true
            end
        end

        if not any_forced then
            G.hand:unhighlight_all()
            local forced_card = pseudorandom_element(G.hand.cards, pseudoseed("madlib"))
            forced_card.ability.forced_selection = true
            G.hand:add_to_highlighted(forced_card)
        end
    end

    if s.name == "Crimson Heart" and G.GAME.blind.prepped and G.jokers.cards[1] then
        local jokers = {}
        for i = 1, #G.jokers.cards do
            if not G.jokers.cards[i].debuff or #G.jokers.cards < 2 then
                jokers[#jokers + 1] = G.jokers.cards[i]
            end
            G.jokers.cards[i]:set_debuff(false)
        end
        local _card = pseudorandom_element(jokers, pseudoseed("ObsidianOrb"))
        if _card then
            _card:set_debuff(true)
            _card:juice_up()
            G.GAME.blind:wiggle()
        end
    end
end

function Madcap.Funcs.fake_stay_flipped(s, self, area, card)
    if s.stay_flipped and s:stay_flipped(area, card) then return true end

    if area == G.hand then
        if s.name == "The Wheel" and SMODS.pseudorandom_probability(card, 'wheel', 1, 7) then
            return true
        end

        if
            s.name == "The House"
            and G.GAME.current_round.hands_played == 0
            and G.GAME.current_round.discards_used == 0
        then
            return true
        end

        if s.name == "The Mark" and card:is_face(true) then return true end

        if s.name == "The Fish" and G.GAME.blind.prepped then return true end
    end
end

function Madcap.Funcs.fake_debuff_card(s, self, card, from_blind)
    if not (card and type(card) == "table" and card.area) then return end

    if s.debuff_card then s:debuff_card(card, from_blind) return end

    if s.debuff and not G.GAME.blind.disabled and card.area ~= G.jokers then

        if s.debuff.suit and Card.is_suit(card, s.debuff.suit, true) then
            card:set_debuff(true)
            return
        end

        if s.debuff.is_face == "face" and Card.is_face(card, true) then
            card:set_debuff(true)
            return
        end

        if s.name == "The Pillar" and card.ability.played_this_ante then
            card:set_debuff(true)
            return
        end

        if s.debuff.value and s.debuff.value == card.base.value then
            card:set_debuff(true)
            return
        end

        if s.debuff.nominal and s.debuff.nominal == card.base.nominal then
            card:set_debuff(true)
            return
        end
    end

    if s.name == "Crimson Heart" and not G.GAME.blind.disabled and card.area == G.jokers then
        return
    end

    if s.name == "Verdant Leaf" and not G.GAME.blind.disabled and card.area ~= G.jokers then
        card:set_debuff(true)
        return
    end
end

-- change the phase
function Madcap.Funcs.change_phase(args)
    if not (args and G.GAME.blind and G.GAME.blind.boss.chaotic) then return false end

    -- After beating one phase of the blind,
    -- reset (1) deck, (2) hands and discards, (3) hand size,
    -- (4) remove some mayhem
    G.GAME.blind:juice_up()

    G.FUNCS.draw_from_hand_to_deck()
    G.FUNCS.draw_from_discard_to_deck()
    G.FUNCS.draw_from_deck_to_hand()

    -- hands and discards
    local hands     = math.max(1, G.GAME.round_resets.hands) - math.max(0, G.GAME.current_round.hands_left)
    local discards  = math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards) - math.max(0, G.GAME.current_round.discards_left)
    ease_hands_played(hands)
	ease_discard(discards)

    -- hand size
    fix_hand_size()

    -- remove 10% of current mayhem
    local _mayhem = (G.GAME.mayhem or 0) * 0.10
    Madcap.Funcs.ease_mayhem(-_mayhem)

    if _old then
        Madcap.Funcs.set_fake_blind(_blind, self, reset, silent)
    end

    if _blind then
        Madcap.Funcs.set_fake_blind(_blind, self, reset, silent)
    end

    return true
end

local function valid_blind(v)
    return MadLib.list_matches_all({
        MadLib.BanLists.SuperBlinds,
        MadLib.BanLists.OverpoweredBlinds
    }, function(list, k)
        return not MadLib.get_item_index(v, list) == -1
    end) and not G.GAME.banned_keys[k]
end

-- Random Bosses
local chaos_boss1 = {
    key         = 'chaos_boss1',
    discovered  = true,
    config      = {
        cur_blind   = 1,
        num_blinds  = 15,
        phase       = 1,
        hand_size   = 8,
        handle_win  = 0, -- does a lil nuh uh!
    },
    pos         = MLIB.coords(1),
    boss_colour = HEX('E9C15A'),
    in_pool     = function(self) return false end,
    boss = { chaotic = true, min = 32, max = 99 },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(
            number_format(2 * get_blind_amount(G.GAME and G.GAME.round_resets.ante or 1)),
            number_format(blind.config.num_blinds)
        )
    end,
    debuff = {
        superboss                   = true,
        akyrs_cannot_be_disabled    = true,
        akyrs_unskippable_blind     = true,
    },
	set_blind = function(self, reset, silent)
        Madcap.Funcs.chaotic_blind_start()
        G.GAME.temp['chaotic_boss_blinds'] = {}

        -- prepare the blinds
        for i=1, G.GAME.blind.config.num_blinds do
            local eligible_bosses = MadLib.get_list_matches(G.P_BLINDS, function(v,k)
                return valid_blind(v) and ((i % 4 == 0 and v.boss.showdown) or (i % 4 ~= 0 and not v.boss.showdown))
            end)
            local _seed = pseudoseed('chaotic_pick_' .. tostring(i))
            table.insert(G.GAME.temp['chaotic_boss_blinds'], pseudorandom_element(eligible_bosses, _seed))
        end

        if _blind then
            Madcap.Funcs.set_fake_blind(_blind, self, reset, silent)
        end
	end,
	calculate = function(self, blind, context)
		if to_big(G.GAME.chips) > to_big(G.GAME.blind.chips) then
			G.GAME.chips = 0
			--G.GAME.blind:set_blind(G.P_BLINDS[self.next_phase])
			Madcap.Funcs.change_phase()
		end
	end,
    disable = function(self) -- cannot disable!!

    end,
    drawn_to_hand = function(self)
        local fake = nil
        if fake then
            Madcap.Funcs.fake_drawn_to_hand(fake, self)
        end
    end,
    press_play = function(self)
        local fake = nil
        if fake then
            Madcap.Funcs.fake_press_play(fake, self)
        end
    end,
    recalc_debuff = function(self, card, from_blind)
        local fake = nil
        if fake then
            Madcap.Funcs.fake_debuff_card(fake, self, card, from_blind)
        end
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        local fake = nil
        if fake then
            Madcap.Funcs.debuff_blind(fake, self, cards, hand, handname, check)
        end
    end,
    stay_flipped = function(self, area, card)
        local fake = nil
        if fake then
            Madcap.Funcs.fake_stay_flipped(fake, self, area, card)
        end
    end,
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        local fake = nil
        if fake then
            Madcap.Funcs.modify_fake_blind(fake, self, cards, poker_hands, text, mult, hand_chips)
        end
    end
}

local list = {}

Madcap.Funcs.LoadBlind({
    chaos_boss1
}, list, 'blinds_chaotic', { priority = 1000 })

return {
    name = "Blinds (Chaotic)",
    init = function() print("Blinds!") end,
    items = list
}
