local function blind_add_tag(t)
    if not G.GAME.blind.disabled then
        add_tag(Tag('tag_'..t))
        G.GAME.blind:wiggle()
        G.GAME.blind.triggered = true
        delay(0.7)
    end
    return true
end

-- The Cheap: at start of Blind, gain an Investment AnTag...?!
local boss_cheap = {
    key = 'cheap',
    pos = MLIB.coords(11),
    boss_colour = HEX('5CB572'),
    in_pool = function(self)
        return Madcap.Data.devmode
            or ((to_big(G.GAME.dollars - 20) > to_big(G.GAME.bankrupt_at))
            and (to_big(G.GAME.dollars) < to_big(20)))
    end,
    min_ante = 4,
    set_blind = function(self)
        return blind_add_tag('rgmc_anti_boomerang') -- change to tag_rgmc_anti_investment
    end,
}

-- The Ricochet: at end of blind, gain a Boomerang AnTag
local boss_ricochet = {
    key = 'ricochet',
    pos = MLIB.coords(12),
    boss_colour = HEX('C17050'),
    in_pool = function(self) return true end,
    defeat = function(self, silent)
        return blind_add_tag('rgmc_anti_boomerang') -- change to tag_rgmc_anti_investment
    end,
    min_ante = 2,
}

-- The Cut: If you score too high (2X blind requirements),
-- halve your chips and lose $5!
local boss_cut = {
    key = 'cut',
    pos = MLIB.coords(13),
    config = { extra = -5 },
    boss_colour = HEX('8857C1'),
    in_pool = function(self)
        return Madcap.Data.devmode or to_big(G.GAME.dollars - self.config.extra*3) > to_big(G.GAME.bankrupt_at)
    end,
    loc_vars = function(self, info_queue, blind)
        return MadLib.collect_vars(
            number_format(2 * get_blind_amount(G.GAME and G.GAME.round_resets.ante or 1)),
            number_format(blind and blind.ability.extra or -5)
        )
    end,
    calculate = function(self, blind, context)
        if
            not G.GAME.blind.disabled
            and context.rgmc_total_score
        then
            local new_total = G.GAME.chips + context.rgmc_total_score
            if
                to_big(new_total) > to_big(self.mult * get_blind_amount(G.GAME.round_resets.ante))
            then
                G.GAME.chips = G.GAME.chips / 2
                MadLib.manipulate_chips_mult(0,0)
                MadLib.simple_event(function()
                    ease_dollars(blind.config.extra)
                    return true
                end,1,'after')
                MadLib.simple_event(function()
                    G.GAME.blind:wiggle() -- nuh uh!
                    G.GAME.blind.triggered = true
                    return true
                end, 1)
            end
        end
    end,
    min_ante = 4,
}

-- The Coil: 1 in 4 chance cards are returned to hand
local boss_coil = {
    key = 'coil',
    pos = MLIB.coords(14),
    config = { extra = { odds = 4 } },
    boss_colour = HEX('F4EFF6'),
    in_pool = function(self) return true end,
    loc_vars = function(self, info_queue, blind)
        return MadLib.collect_vars(
            number_format(MadLib.base_prob(blind)),
            number_format(blind.config.odds))
    end,
    min_ante    = 2,
    mult        = 2.5,
    calculate = function(self, blind, context)
		if
            not G.GAME.blind.disabled
            and context.scoring_hand
			and context.final_scoring_step
		then
            local coilys = MadLib.get_list_matches(context.scoring_hand, function(v)
                return MadLib.calculate_roll({
                    seed = 'rgmc_coil',
                    denom = self.config.extra.odds
                })
            end)
            MadLib.flip_cards(coilys, function(v) v.ability.rgmc_coil = true end)
        end
    end,
}

-- The Halo: Voids are debuffed.
local boss_halo = {
    key = 'halo',
    pos = MLIB.coords(21),
    boss_colour = HEX('FAB06D'),
    in_pool = function(self)
        return G,playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v)
            v:is_suit('rgmc_voids')
        end) > 4 or Madcap.Data.devmode
    end,
    min_ante = 3,
    debuff = { suit = 'rgmc_voids' },
}

-- The Spiral: Lanterns are debuffed.
local boss_spiral = {
    key = 'spiral',
    pos = MLIB.coords(22),
    boss_colour = HEX('5F579D'),
    in_pool = function(self)
        return G,playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v)
            v:is_suit('rgmc_lanterns')
        end) > 4 or Madcap.Data.devmode
    end,
    min_ante = 3,
    debuff = { suit = 'rgmc_lanterns' },
}

-- The Carousel: Joker order is randomized at blind start
-- -1 hand size per Joker moved
local boss_carousel = {
    key     = 'carousel',
    config  = { penalty = 0 },
    pos = MLIB.coords(23),
    boss_colour = HEX('AA5173'),
    in_pool = function(self)
        return Madcap.Data.devmode or (G.jokers and #G.jokers.cards > 3)
    end,
    loc_vars = function(self, info_queue, card)
    end,
    min_ante = 4,
    calculate = function(self, blind, context)
		if context.setting_blind and not G.GAME.blind.disabled then
            Madcap.CheckJokerOrder = true
            MadLib.simple_event(function()
                MadLib.get_loop_func_number(4, function(i)
                    MadLib.simple_event(function()
                        G.jokers:shuffle('rgmc_carousel')
                        play_sound('cardSlide1', 0.85 + i*0.15)
                        return true
                    end)
                    delay(0.25*i)
                end, true)
                return true
            end, 0.25, 'after')
        end

        if context.break_positions and not G.GAME.blind.disabled then
            MadLib.simple_event(function()
                G.hand:change_size(-1)
                blind.ability.penalty = (blind.ability.penalty or 0) + 1
                G.GAME.blind:wiggle()
                G.GAME.blind.triggered = true
                return true
            end)
            delay(1.0)
        end
    end,
    defeat = function(self, silent)
        Madcap.CheckJokerOrder =
        G.hand:change_size(blind.ability.penalty)
        self.config.penalty = 0
    end,
	disable = function(self, silent)
        Madcap.CheckJokerOrder = false
        G.hand:change_size(blind.ability.penalty)
        self.config.penalty = 0
    end,
}

-- The Axe: disables Blooms
local boss_axe = {
    key = 'axe',
    pos = MLIB.coords(24),
    boss_colour = HEX('56C39F'),
    in_pool = function(self)
        return G,playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v)
            v:is_suit('rgmc_blooms')
        end) > 4 or Madcap.Data.devmode
    end,
    min_ante = 3,
    debuff = { suit = 'rgmc_blooms' },
}

-- The Rust: disables Daggers
local boss_rust = {
    key = 'rust',
    pos = MLIB.coords(25),
    boss_colour = HEX('A28345'),
    in_pool = function(self)
        return G,playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v)
            v:is_suit('rgmc_daggers')
        end) > 4 or Madcap.Data.devmode
    end,
    min_ante = 3,
    debuff = { suit = 'rgmc_daggers' },
}

local function check_pattern_rank(_func, _card)
    return _card and _func and (_func(MadLib.round(_card.base.nominal)) or false) or false
end

local function is_single_digit(_card)
    local _data = SMODS.Ranks[_card:get_id()]
    return _data.base.nominal < 10
        and _data.base.nominal % 1 == 0
        and _data.base.face_nominal > 0
        and _data.base.nominal > -1
        and not MadLib.has_rank_in_list(_card,RankTypes.Irregular)
end

-- The Factor: disables prime numbers (1, 2, 3, 5, 7, 11, 13, Ace)
local boss_factor = {
    key = 'factor',
    pos = MLIB.coords(26),
    boss_colour = HEX('423894'),
    in_pool = function(self)
        return Madcap.Data.devmode
    end,
    loc_vars = function(self, info_queue, card)
    end,
    min_ante = 1,
    recalc_debuff = function(self, card, from_blind)
        if
            not G.GAME.blind.disabled
            and card.area ~= G.jokers
        then
            if check_pattern_rank(MadLib.is_prime, card) then
                card:set_debuff(true)
                return true
            else
                return false
            end
        end
    end,
}

-- The Figure: disables hands containing anything other than
-- single-digit numbers (1-9)
local boss_figure = {
    key = 'figure',
    pos = MLIB.coords(27),
    boss_colour = HEX('A65096'),
    in_pool = function(self)
        return Madcap.Data.devmode
    end,
    loc_vars = function(self, info_queue, card)
    end,
    min_ante = 2,
    debuff_hand = function(self, cards, hand, handname, check)
        local pass = MadLib.list_matches_all(cards, function(v)
            return is_single_digit(v)
        end) or G.GAME.blind.disabled
        if not pass then
            G.GAME.blind:wiggle() -- nuh uh!
            G.GAME.blind.triggered = true
        end
        return not pass
    end,
}

-- The Gyre: "destroys" Fibonacci numbers (0, 1, 2, 3, 5, 8, 13, 21)
local boss_gyre = {
    key = 'gyre',
    pos = MLIB.coords(28),
    boss_colour = HEX('CC8C59'),
    in_pool = function(self)
        return Madcap.Data.devmode
    end,
    loc_vars = function(self, info_queue, card)
    end,
    min_ante = 1,
    mult = 1.618,
    calculate = function (self, blind, context)
        if
            not G.GAME.blind.disabled
            and context.after
            and context.other_card
            and check_pattern_rank(MadLib.is_fibonacci, context.other_card)
        then
            context.other_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
        end
    end
}

local function pendulum_end(self, silent)
    MadLib.loop_func({ G.jokers, G.hand }, function(v,_)
        if v and (#v.cards > 0) then
            MadLib.flip_cards(v.cards, function(c)
                c:set_debuff(false)
            end, nil, function(c)
                c:juice_up(0.3, 0.3)
            end)
        end
    end)
    return true
end

local boss_pendulum = {
    key = 'pendulum',
    pos = MLIB.coords(29),
    config = { left_side = false },
    boss_colour = HEX('6AA075'),
    in_pool = function(self)
        return Madcap.Data.devmode
    end,
    loc_vars = function(self, info_queue, card)
    end,
    min_ante = 4,
    calculate = function (self, blind, context)
        if
            not G.GAME.blind.disabled
            and (context.setting_blind or context.after)
            and not context.end_of_round
        then
            if not context.setting_blind then
                blind.config.left_side = (not blind.config.left_side)
                G.GAME.blind.triggered = true
            end

            MadLib.loop_func({ G.jokers, G.hand }, function(v,_)
                if v and (#v.cards > 0) then
                    local num = math.ceil(math.max(2, #v.cards)/2)
                    MadLib.loop_func(v.cards, function(c,i)
                        MadLib.simple_event(function()
                            c:set_debuff(blind.config.left_side and i < num or i > num)
                            c:juice_up(0.3, 0.3)
                            return true
                        end,0.08,'after')
                        return true
                    end)
                end
            end)
        end
    end,
    defeat = function(self, silent)
        if not G.GAME.blind.disabled then return pendulum_end(self, silent) end
    end,
	disable = pendulum_end(self, silent),
}

-- Ranks must be played in ascending order
local boss_slide = {
    key = 'slide',
    pos = MLIB.coords(30),
    boss_colour = HEX('427B85'),
    in_pool = function(self)
        return Madcap.Data.devmode -- 4+ ranks?
    end,
    min_ante = 4,
    debuff_hand = function(self, cards, hand, handname, check)
        if G.GAME.blind.disabled then
            for i=2, #cards do
                local this_rank = SMODS.Ranks[cards[i]:get_id()]
                local that_rank = SMODS.Ranks[cards[i-1]:get_id()]

                local n1 = (this_rank.base.nominal + this_rank.base.face_nominal)
                local n2 = (that_rank.base.nominal + that_rank.base.face_nominal)

                if n1 > n2 then
                    G.GAME.blind.triggered = true
                   return true
                end
            end
        end
        return false
    end,
}

local boss_bowler = {
    key = 'bowler',
    pos = MLIB.coords(31),
    boss_colour = HEX('D8A193'),
    in_pool = function(self)
        return Madcap.Data.devmode
    end,
    loc_vars = function(self, info_queue, card)
    end,
    min_ante = 4,
    calculate = function (self, blind, context)
        if
            not G.GAME.blind.disabled
            and context.after
            and #G.hand.cards > 0
        then
            MadLib.loop_func(G.hand.cards, function(v,i)
                if check_pattern_rank(MadLib.is_triangular, v) then -- 1/Ace, 3, 6, 10, 15, 21
                    if i < #G.hand.cards then -- discard this card
                        local target = G.hand.cards[i+1]
                        print(target ~= nil)
                    end
                end
            end)
        end
    end,
}

local boss_din = {
    key = 'din',
    pos = MLIB.coords(35),
    config = { extra = 1 },
    boss_colour = HEX('454E4D'),
    in_pool = function(self)
        return Madcap.Data.devmode
    end,
    loc_vars = function(self, info_queue, card)
    end,
    min_ante = 4,
	set_blind = function(self, reset, silent)
        if not G.GAME.blind.disabled then
            Madcap.Funcs.ease_mayhem(self.config.extra)
            return true
        end
	end,
    disable = function(self) -- cannot disable!!
        Madcap.Funcs.ease_mayhem(-self.config.extra)
    end,
	defeat = function(self, silent)
        if not G.GAME.blind.disabled then
            Madcap.Funcs.ease_mayhem(-self.config.extra)
            return true
        end
	end,
}

function MadLib.get_coin_flip()
    return math.random() > 0.5
end

local function boss_flip_revert(k,v)
    if not v.ability.rgmc_flip then return false end
        SMODS.change_base(c, _, v.ability.rgmc_flip)
        v.ability.rgmc_flip = nil
    return true
end

local function boss_flip_end(self,silent)
    -- swap the ranks back for the current hand
    MadLib.flip_cards(G.hand, function(c)
        boss_flip_revert(nil,c)
        play_sound((sound or 'tarot2'), 0.76, 0.4)
    end)
    -- do the rest silently
    MadLib.loop_func_table(G.playing_cards, boss_flip_revert)
    G.GAME.temp['rgmc_flip'] = nil
end

-- The Flip: Ranks temporarily switch to another value.
local boss_flip = {
    key = 'flip',
    pos = MLIB.coords(36),
    boss_colour = HEX('126EAF'),
    in_pool = function(self)
        return G.playing_cards and #MadLib.get_ranks_from_cards(G.playing_cards,true) > 1 or Madcap.Data.devmode
    end,
    min_ante = 6,
	set_blind = function(self, reset, silent)
        -- initialize the list
        G.GAME.temp['rgmc_flip'] = {}
        local list = {}

        -- get the ranks, randomly swap.
        for k,_ in pairs(MadLib.get_ranks_from_cards(G.playing_cards,true)) do list[#list+1] = k end
        table.sort(list, MadLib.get_coin_flip())

        -- make a table with the ranks
        for i=1,#list do G.GAME.temp['rgmc_flip'][list[i]] = list[(i%#list)+1] end
    end,
    stay_flipped = function(self, area, card)
        if G.GAME.temp.rgmc_flip[card.base.value] then
            card.ability.rgmc_flip = card.base.value -- set to the old rank
            SMODS.change_base(c, _, G.GAME.temp.rgmc_flip[card.base.value]) -- switch to new rank
        end
        return false
    end,
    defeat = boss_flip_end,
	disable = boss_flip_end,
}

local function boss_switch_revert(k,v)
    if not v.ability.rgmc_switch then return false end
        SMODS.change_base(c, v.ability.rgmc_switch, _)
        v.ability.rgmc_switch = nil
    return true
end

local function boss_switch_end(self,silent)
    -- swap the ranks back for the current hand
    MadLib.flip_cards(G.hand, function(c)
        boss_flip_switch(nil,c)
        play_sound((sound or 'tarot2'), 0.76, 0.4)
    end)
    -- do the rest silently
    MadLib.loop_func_table(G.playing_cards, boss_switch_revert)
    G.GAME.temp['rgmc_switch'] = nil
end

-- The Switch: Suits temporarily switch to another value.
local boss_switch = {
    key = 'switch',
    pos = MLIB.coords(37),
    boss_colour = HEX('F5C387'),
    in_pool = function(self)
        return G.playing_cards or Madcap.Data.devmode
    end,
    min_ante = 4,
    stay_flipped = function(self, area, card)
        if G.GAME.temp.rgmc_switch[card.base.suit] then
            card.ability.rgmc_switch = card.base.suit -- set to the old suit
            SMODS.change_base(c, G.GAME.temp.rgmc_switch[card.base.suit], _) -- switch to new suit
        end
        return false
    end,
    defeat = boss_switch_end,
	disable = boss_switch_end,
}

-- merges cards together?
local final_twins = {
    key = 'final_twins',
    pos = MLIB.coords(32),
    boss_colour = HEX('88A5D9'),
    in_pool = function(self)
        return true
    end,
    min_ante = 0,
    calculate = function (self, blind, context)
        if
            not G.GAME.blind.disabled
            and context.scoring_hand
            and context.final_scoring_step
            and next(context.poker_hands["Pair"]) -- at least ONE pair is played
        then
            local cards_by_rank = {}

            -- add card
            MadLib.loop_func(context.scoring_hand, function(v,i)
                local _rank = v:get_id()
                cards_by_rank[_rank] = cards_by_rank[_rank] or {}
                table.insert(cards_by_rank[_rank],v)
            end)

            -- look through ranks
            MadLib.loop_func(cards_by_rank, function(list,i)
                table.sort(list, MadLib.get_coin_flip())
                local num_pairs = math.floor(#list/2)
                for j=0, num_pairs-1 do
                    local _left, _right = list[j*2], list[j*2+1]
                    local _target = MadLib.get_coin_flip() and _left or _right
                    _target:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                end
            end)
        end
    end,
}

local final_vino = {
    key = 'final_vino',
    pos = MLIB.coords(33),
    boss_colour = HEX('43B34D'),
    config = { extra = { odds = 4 } },
    min_ante = 0,
    in_pool = function(self)
        return true
    end,
    loc_vars = function(self, info_queue, blind)
        return MadLib.collect_vars(
            number_format(MadLib.base_prob(blind)),
            number_format(blind.config.odds))
    end,
    calculate = function (self, blind, context)
        if
            not G.GAME.blind.disabled
            and (context.pre_discard or context.after)
        then
            local vino_converts = MadLib.get_loop_func(context.pre_discard and G.hand.highlighted or G.hand.cards, function(v)
                return not SMODS.has_enhancement(v, 'm_rgmc_vino')
                    and MadLib.calculate_roll({
                        seed = 'rgmc_vino',
                        denom = self.config.extra.odds
                    })
            end)
            MadLib.flip_cards(anim, function(v)
                v.ability.vino_boss = true -- marked by this blind
                v:set_ability(G.P_CENTERS['m_rgmc_vino'])
            end, nil, function(v)
                MadLib.simple_event(function()
                    v:juice_up()
                    return true
                end)
            end)
        end
    end,
    defeat = function(self, silent)
        MadLib.loop_func(G.playing_cards, function(v)
            v.ability.vino_boss = nil
        end)
    end,
	disable = function(self, silent)
        -- revert vino cards converted this round
        MadLib.loop_func(G.playing_cards, function(v)
            if
                SMODS.has_enhancement(v, 'm_rgmc_vino')
                and v.ability.vino_boss
            then
                if v.area ~= G.hand then
                    v:set_ability(G.P_CENTERS.c_base)
                else
                    table.insert(anim, v)
                end
                v.ability.vino_boss = nil
            end
        end)
        -- do animation for hand cards
        MadLib.flip_cards(anim, function(v)
            v:set_ability(G.P_CENTERS.c_base)
        end, nil, function(v)
            MadLib.simple_event(function()
                v:juice_up()
                return true
            end)
        end)
    end,
}

-- must play 6 cards (+? selection size)
local final_claw = {
    key = 'final_claw',
    pos = MLIB.coords(34),
    boss_colour = HEX('E54C6A'),
    config = { selection_size = 3, active = false, hand_size = 0 },
    in_pool = function(self)
        return true
    end,
    min_ante = 4,
    loc_vars = function(self, info_queue, blind)
        local hand_limit = G.hand and G.hand.config.highlighted_limit
        local must_play = (G.GAME.blind and G.GAME.blind.key == self.key) -- you are playing this blind
            and hand_limit or (self.config.selection_size + (hand_limit or 5))
        return MadLib.collect_vars(
            number_format(MadLib.base_prob(must_play)),
            number_format(self.config.selection_size))
    end,
	set_blind = function(self, reset, silent)
        if not G.GAME.blind.disabled then
            local select_size = (G.hand and G.hand.config.highlighted_limit or 0) + self.config.selection_size
            local hand_size = (G.hand and G.hand.config.card_limit or 0)
            local add_hand_size = hand_size - select_size

            SMODS.change_play_limit(self.config.selection_size)
            if add_hand_size < 0 then
                self.config.hand_size = -add_hand_size
                G.hand:change_size(-add_hand_size)
            end
            self.config.active = true
        end
	end,
    defeat = function(self, silent)
        if not G.GAME.blind.disabled then
            self.config.active = false
            SMODS.change_play_limit(self.config.selection_size)
            if self.config.hand_size > 0 then
                self.config.hand_size = 0
                G.hand:change_size(-self.config.hand_size)
            end
        end
    end,
	disable = function(self, silent)
        if self.config.active then -- nice try, chicot
            SMODS.change_play_limit(self.config.selection_size)
            self.config.active = false
            if self.config.hand_size > 0 then
                self.config.hand_size = 0
                G.hand:change_size(-self.config.hand_size)
            end
        end
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        return (not G.GAME.blind.disabled and #cards ~= G.hand.config.highlighted_limit) -- must play highlight limit
    end,
}


local function has_nonstandard_cards(cards,percentage)
    return #MadLib.get_list_matches(cards, function(_,v)
        return not MadLib.list_matches_one(MadLib.SuitTypes.Base, function(v2,_) return v2 == v.base.suit end)
            or not MadLib.list_matches_one(MadLib.RankTypes.Base, function(v2,_) return v2 == v.base.value end)
    end) > (#cards) * percentage
end

local final_horn = {
    key = 'final_horn',
    pos = MLIB.coords(45),
    boss_colour = HEX('DA9100'),
    in_pool = function(self)
        return (G.playing_cards and has_nonstandard_cards(G.playing_cards, 0.5)) or Madcap.Data.devmode
    end,
    min_ante = 4,
    debuff_hand = function(self, cards, hand, handname, check)
        return not has_nonstandard_cards(G.hand.cards, 1) -- must play highlight limit
    end,
}

local final_moon = {
    key = 'final_moon',
    pos = MLIB.coords(46),
    boss_colour = HEX('7D6E59'),
    config = { light_cards = true },
    in_pool = function(self)
        return true
    end,
    min_ante = 4,
    press_play = function(self)
        self.config.light_cards = not self.config.light_cards -- flip it!
    end,
    recalc_debuff = function(self, card, from_blind)
        return (card:has_light_suit() and self.config.light_cards)
            or (card:has_dark_suit() and not self.config.light_cards)
            or false
    end,
}

local list = {}
Madcap.Funcs.LoadBlind({
    boss_cheap,
    boss_ricochet,
    boss_cut,
    boss_coil,

    boss_halo,
    boss_spiral,
    boss_carousel,
    boss_axe,

    boss_rust,
    boss_factor,
    boss_figure,
    boss_gyre,

    boss_pendulum,
    boss_slide,
    boss_bowler,
    boss_din,

    boss_flip,
    boss_switch,
    final_twins,
    final_vino,

    final_claw,
    final_horn,
    final_moon,
}, list, 'blinds')

return {
    name = "Blinds (Part 2)",
    init = function() print("Blinds!") end,
    items = list
}
