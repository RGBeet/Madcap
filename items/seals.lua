width = 4
local function c(n)
    return {
        x = (n % width),
        y = math.floor(n / width)
    }
end

-- Patina: Prioritized to front of deck
local patina = {
    key = "patina",
    badge_colour = HEX("49ab9a"),
}

-- Bronze (Cuprum): Prioritized to back of deck
local bronze = {
    key = "bronze",
    badge_colour = HEX("754D42"),
}

-- Jade: When played and scoring, return to hand (1 in X chance per time)
local jade = {
    key = "jade",
    badge_colour = HEX("226F4C"),
    config = {
        extra = { odds = 1 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(self.config.extra.odds or 0))
    end,
    calculate = function(self, card, context)

        if context.setting_blind then
            self.config.extra.odds = 1
        end

		if context.main_scoring and context.cardarea == G.play then
            --draw_card(G.play,G.deck, it*100/play_count,'down', false, v)
            card.ability.rgmc_jade = true
            self.config.extra.odds = (self.config.extra.odds or 1) + 1
            --tell("Jade Seal activated!")
		end
    end,
}

-- Umber: When discarded, draw an extra card
local umber = {
    key = "umber",
    badge_colour = HEX("DF6622"),
    config = {
        active = true,
        extra = { draw_cards = 2 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(self.config.extra.draw_cards or 2))
    end,
    calculate = function(self, card, context)
		if
            context.pre_discard
            and card.ability.active
            and context.other_card == card
        then
            for i=1, MadLib.clamp(card.ability.extra.draw_cards,2,10) do
                draw_card(G.deck,G.hand, i*100/i,'up', true)
            end
            print("Umber Seal activated!")
            card.ability.active = false
		end

		if context.after then
            card.ability.active = true
		end
    end,
}

-- Cream: When held at end of round, 1 in 3 chance to generate a Spectral card
local cream = {
    key = "cream",
    badge_colour = HEX("EAE9BD"),
    config = {
        extra = { odds = 3 }
    },
    loc_vars = function(self, info_queue, card)
		return {
			vars = {
				number_format(MadLib.base_prob(self)),
                number_format(self.config.extra.odds)
			},
		} -- note that the check for (card.ability.cry_prob or 1) is probably unnecessary due to cards being initialised with ability.cry_prob
    end,
    calculate = function(self, card, context)
		if
            context.end_of_round
            and context.cardarea == G.hand
            and not context.game_over
            and MadLib.calculate_card_odds(self, 'rgmc_cream_seal')
        then
            tell("Cream Seal activated!")
		end
    end,
}

-- Cherry: Triggers once as usual, but stays in hand and is guaranteed to score again next hand (then returns to deck as usual)
local cherry = {
    key = "cherry",
    badge_colour = HEX("B8304B"),
    config = {
        active = false -- if active, add to next scoring hand.
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(self.config.active)
    end,
    calculate = function(self, card, context)
		if
            context.before
            and card.ability.active
            and context.scoring_hand
        then
            local index = MadLib.get_item_index(card,G.deck.cards)
            tell(index)
                if index then
                MadLib.simple_event(function()
                    card:bring_card_to_front(G.deck.cards)
                    --function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
                    draw_card(G.hand,G.play, i*100,'down', nil, nil, 0.07)
                    context.scoring_hand[#context.scoring_hand+1] = card
                    return true
                end, 0.5, 'before')
            end
        end

		if
            context.other_card
            and context.cardarea == G.play
            and context.main_scoring
            and not card.ability.active
        then
            MadLib.simple_event(function()
                v:juice_up(0.3,0.3)
                play_sound('tarot2', 1.2, 0.4)
                return true
            end, 0.4, 'before')
        end
    end,
}

-- Seafoam: 1 in 2 chance to spawn a Cosma card when discarded (like Purple)
local seafoam = {
    key = "seafoam",
    badge_colour = HEX("5CC497"),
    config = {
        extra = { odds = 2 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(MadLib.base_prob(card)), number_format(self.config.extra.odds))
    end,
    calculate = function(self, card, context)
		if
            context.pre_discard
            and context.other_card == card
            and MadLib.calculate_card_odds(card,'rgmc_seafoam_seal')
        then
            tell("Seafoam Seal activated!")
        end
    end,
}

-- Sunrise: light/dark suit changes
local sunrise = {
    key = "sunrise",
    badge_colour = HEX("C1A769"),
    calculate = function(self, card, context)
		if
            context.other_card
            and context.main_scoring
            and context.cardarea == G.play
        then
            local to_suit = MadLib.suit_get_counterpart_lightdark(card.base.suit)
            if to_suit then
                MadLib.flip_card(context.other_card,function(v)
                    SMODS.change_base(c, SMODS.Suits[to_suit].value, _)
                end)
            end
		end
    end,
}

-- Midnight: base/modded suit changes
local midnight = {
    key = "midnight",
    badge_colour = HEX("8753E0"),
    calculate = function(self, card, context)
		if
            context.other_card
            and context.main_scoring
            and context.cardarea == G.play
        then
            local to_suit = MadLib.suit_get_counterpart_basemodded(card.base.suit)
            if to_suit then
                MadLib.flip_card(context.other_card,function(v)
                    SMODS.change_base(c, SMODS.Suits[to_suit].value, _)
                end)
            end
		end
    end,
}

local anaglyph = {
    key = "anaglyph",
    badge_colour = HEX("39474A"),
    config = {
        extra = { odds = 3 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(MadLib.base_prob(card)), number_format(self.config.extra.odds))
    end,
    calculate = function(self, card, context)
		if
            context.end_of_round
            and context.cardarea == G.hand
            and not context.game_over
            and MadLib.calculate_card_odds(card,'rgmc_anaglyph_seal') -- 1 in 3 chance.
        then
            MadLib.simple_event(function()
				add_tag(Tag('tag_double'))
				return true
            end, 0.00, 'after')
            --tell("Anaglyph Seal activated!")
		end
    end,
}

local list = {
    patina,
    bronze,
    jade,
    umber,
    cream,
    cherry,
    seafoam,
    sunrise,
    midnight,
    anaglyph
}

for i=1, #list do
    list[i].object_type = "Seal"
    list[i].atlas = "seals"
    list[i].pos = c(i-1)
end

return {
    name = "Seals",
    init = function() print("Seals!") end,
    items = list
}
