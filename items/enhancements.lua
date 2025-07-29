-- TODO: Add check if enhancements are enabled.

-- Ferrous: upgraded Bonus enhancement, adds +chips if held at end of round
local ferrous = {
	key = "ferrous",
    config = { extra = { chips = 15, gain = 15 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.chips, card.ability.extra.gain)
    end,
	calculate = function(self, card, context)
        if
            context.cardarea == G.play
            and context.main_scoring
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
        end

        if -- Upgrades if left in hand at end of round
            context.playing_card_end_of_round
            and context.cardarea == G.hand
        then
            return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.gain)
        end
    end,
    draw = function(self, card, layer)
		card.children.center:draw_shader("negative_shine", nil, card.ARGS.send_to_shader)
	end
}

-- Wolfram: upgraded Mult enhancement, adds +mult if held at end of round
 local wolfram = {
	key = "wolfram",
    config = { extra = { mult = 3, gain = 3 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.mult, card.ability.extra.gain)
    end,
	calculate = function(self, card, context)
        if
            context.cardarea == G.play
            and context.main_scoring
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
        end

        if -- Upgrades if left in hand at end of round
            context.playing_card_end_of_round
            and context.cardarea == G.hand
        then
            return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.gain)
        end
    end,
    draw = function(self, card, layer)
		card.children.center:draw_shader("negative_shine", nil, card.ARGS.send_to_shader)
	end
}

local lustrous = {
	key = "lustrous",
    config = { extra = { x_mult = 1.2, gain = 0.2 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.x_mult, card.ability.extra.gain)
    end,
	calculate = function(self, card, context)
        if
            context.cardarea == G.play
            and context.main_scoring
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.mult)
        end

        if -- Upgrades if left in hand at end of round
            context.playing_card_end_of_round
            and context.cardarea == G.hand
        then
            return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.gain)
        end
    end,
    draw = function(self, card, layer)
		card.children.center:draw_shader("negative_shine", nil, card.ARGS.send_to_shader)
	end
}

-- List of bismuth enhancements
Madcap.Lists.bismuth = { 'red', 'yellow', 'green', 'blue', 'purple' }

local bismuth = {
	key = "bismuth",
    config = {
        immutable = { sticker_type = 'red' }
    },
    no_rank = true,
    no_suit = true,
    always_scores = true,
    replace_base_card = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { }
        }
    end,
	calculate = function(self, card, context)
        if
            context.setting_blind
        then
            local new_type = pseudorandom_element(Madcap.Lists.bismuth, pseudoseed('rgmc_bismuth'))
            if new_type ~= card.ability.immutable.sticker_type then
                card.ability.immutable.sticker_type = new_type
                card.ability['rgmc_bismuth_'..new_type] = true
                SMODS.Stickers['rgmc_bismuth_'..new_type]:apply(self,true)
            end
        end

        if context.playing_card_end_of_round then
            local old_type = card.ability.immutable.sticker_type
            card.ability.immutable.sticker_type = nil
            card.ability['rgmc_bismuth_'..old_type] = false
            SMODS.Stickers['rgmc_bismuth_'..old_type]:apply(self,false)
        end
    end,
    draw = function(self, card, layer)
        local notilt = nil
        if card.area and card.area.config.type == "deck" then notilt = true end
        card.children.center:draw_shader("voucher", nil, card.ARGS.send_to_shader, notilt, card.children.center)
	end
}

-- Unhancement, takes away score when scoring but turns into a Bismuth if scored in winning hand.
local vino = {
	key = "vino",
    config = { extra = { x_score = 0.9, active = false } },
    replace_base_card   = true,
    no_suit             = true,
    no_rank             = true,
    always_scores       = true,
	disenhancement      = true,
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.x_sore)
    end,
	calculate = function(self, card, context)
        -- when scoring and wins...
        if
            context.cardarea == G.play
            and context.main_scoring
        then
            card.ability.extra.active = true
            local score = card.ability.extra and card.ability.extra.score or 0.8
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiScore, card, score)
        end

        if
            context.after
            and card.ability.extra.active
        then
            if  MadLib.meets_blind_requirements() then
                -- change into bismuth
                MadLib.flip_cards(stoned, function(v)
                    v:set_ability(G.P_CENTERS['m_rgmc_bismuth'])
                end, nil, function(v)
                    MadLib.simple_event(function()
                        v:juice_up()
                        return true
                    end)
                end)
            else
                card.ability.extra.active = false
            end
        end
    end,
}

function Madcap.Funcs.get_aoe_cards(center,cards,range)
    local left, right  = math.max(index - range, 1), math.min(index + range, #cards)
    local list, index = {}, MadLib.get_item_index(center, cards)

    if index == -1 then return {} end
    for i=left, right do
        if i ~= index then table.insert(list, cards[i]) end
    end

    return list
end

function Card:do_volatile_explode(bypass_reqs)
    -- if NOT a volatile or marked by already marked by volatile
    if
        not (bypass_reqs or SMODS.has_enhancement(v, 'm_rgmc_volatile'))
        or self.ability.volatile_marked
    then
        return false
    end

    self.ability.volatile_marked = true -- mark as volatile

    local targets, temp, ep = {}, {}, 0

    -- Hit the next
    if (self.area and self.area.cards and #self.area.cards > 1) then
        local index = MadLib.get_item_index(self, self.area.cards)
        targets = Madcap.Funcs.get_aoe_cards(self,self.area.cards,1)

        -- get the temp info
        MadLib.loop_func(targets, function(v,i)
            v:do_volatile_explode(true)
            table.insert(temp, { card = v, ind = i })
        end)

        -- closer, left, right
        table.sort(temp_cards, function(a, b)
            local abs_a, abs_b = math.abs(index-a), math.abs(index-b)
            return abs_a ~= abs_b
                and (abs_a < abs_b)
                or (a < b)
        end)

        MadLib.loop_func(temp_cards, function (v, i)
            if not SMODS.has_enhancement(v, 'm_rgmc_volatile') then
                MadLib.simple_event(function()
                    v:juice_up(0.5, 0.5)
                    v:start_dissolve()
                    return true
                end, 0.4, 'after')
                delay(0.4)
            else -- is a volatile
                MadLib.simple_event(function()
                    local _xmult = self.ability.x_mult or 2
                    v:juice_up(0.6, 0.6)
                    mult = mod_mult(mult * _xmult)
                    card_eval_status_text(v, 'extra', nil, nil, nil, {
                        message = 'X' .. number_format(_mult) , colour = G.C.RED
                    })
                    return true
                end, 0.5, 'after')
                MadLib.simple_event(function()
                    v:juice_up(1.2, 1.2)
                    v:shatter()
                    return true
                end, 0.8, 'after')
                delay(0.8)
            end
        end)
    end
    return true
end

local volatile = {
	key = "volatile",
    config = { extra = { x_score = 1.4, x_mult = 2, odds = 5, active = false } },
    always_scores       = true,
	disenhancement      = true,
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.x_score)
    end,
	calculate = function(self, card, context)
        -- when scoring and wins...
        if
            context.cardarea == G.play
            and context.main_scoring
        then
            -- 1 in 5 chance it explode.
            if  MadLib.calculate_roll({ seed = 'rgmc_volatile', denom = self.config.extra.odds }) then
                card.ability.extra.active = true
                MadLib.simple_event(function()
                    v:juice_up()
                    return true
                end)
            end
            return MadLib.get_fake_score_data(MadLib.ScoreKeys.MultiScore, card,  card.ability.extra.x_score)
        end

        if
            context.final_scoring_step
            and card.ability.extra.active
            and context.scoring_hand
        then
            card:do_volatile_explode()
        end
    end,
}

local lazurite= {
	key = "lazurite",
    calculate = function(self, card, context)
        -- SEASONED CURLIES!!!
    end,
}

local list = {}

Madcap.Funcs.LoadEnhancements({
    ferrous,
    wolfram,
    lustrous,
    bismuth,
    -- disenhancement
    vino,
    volatile,
    -- back to regular
    lazurite
}, list, 'enhance', 4)

return {
    name = "Enhancements",
    init = function() print("Enhancements!") end,
    items = list
}
