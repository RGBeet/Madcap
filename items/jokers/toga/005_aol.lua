function Madcap.Funcs.play_sound_random(snd)
    play_sound(snd, 0.60 + math.random(1,4) * 0.15)
end

function Madcap.Funcs.pass_aol_event(card,context)
    if context.forcetrigger then return 0 end -- always!
    local odds, event_num = 0, nil
    if context.cashing_out then
        odds        = 8
        event_num   = 1
    elseif context.reroll_shop then
        odds        = card.ability.extra.odds
        event_num   = 2
    elseif context.ending_shop then
        odds        = card.ability.extra.odds
        event_num   = 3
    elseif context.skip_blind then
        odds        = card.ability.extra.odds * 0.75
        event_num   = 4
    elseif context.skipping_booster then
        odds        = card.ability.extra.odds * 0.5
        event_num   = 5
    end
    return (event_num ~= nil) and SMODS.pseudorandom_probability(card, 'aol', 1, odds) and event_num or nil
end

Madcap.Lists.MailWhitelist = {
    ['Tarot']               = 10,
    ['Planet']              = 6,
    ['Spectral']            = 3,
    ['CosmaTarot']          = 5,
    ['SpatiaPlanet']        = 4,
    ['PotentiaCrystal']     = 1,
}
function Madcap.Funcs.get_random_consumable(seed, set)
    set = set or MadLib.pick_from_weighted_table(Madcap.Lists.MailWhitelist)
    tell(set)
    local _pool, _pool_key = get_current_pool(set)
    local center = pseudorandom_element(_pool, pseudoseed(_pool_key))
    
    local it = 1
    while center == 'UNAVAILABLE' do
        it = it + 1
        center = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
    end

    center = G.P_CENTERS[center]
    return center
end

SMODS.Consumable({
    key         = "toga_mail",
    set         = "MiscRGMC",
    atlas       = "toga_mail",
    pos         = MLIB.coords(0,0),
    display_size    = { w = 95, h = 71 },
    no_collection   = true,
    config = { extra = { center = nil } },
    loc_vars = function (self, info_queue, card)
        local center_type = SMODS.ConsumableType[card.ability.extra.center]
        local colour = center_type and center_type.secondary_colour or G.C.RED
        return MadLib.collect_vars_colours(MadLib.localize_name_text(card.ability.extra.center.set, card.ability.extra.center.key), { colour })
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card)
        local is_consumeable    = true
        local to_area           = is_consumeable and G.consumeables or G.jokers
        local new_card = create_card(nil, to_area, nil, nil, nil, nil, card.ability.extra.center.key)
        new_card:add_to_deck()
        table.insert(to_area, new_card)
        to_area:emplace(new_card)
    end,
    keep_on_use = function (self, card)
        local keeping = pseudorandom('youvegotmail') < (1/4) and true or false -- Fixed 1 in 4 chance to contain an extra item
        if keeping then -- wow!
            card.ability.extra.center = Madcap.Funcs.get_random_consumable('aol')
            Madcap.Funcs.play_sound_random('rgmc_aol_im')
            card_eval_status_text(card, "extra", nil, nil, nil, {
                message = localize("k_yeah_ex"),
                colour = G.C.GREEN,
            })
        end
        return keeping
    end,
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
                return true
            end
        }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
                return true
            end
        }))
    end,
    load = function (self, card, card_table, other_card)
        self.sell_cost = 0
    end
})

return {
    data = {
        object_type = "Joker",
        key     = 'toga_aol',
        atlas   = 'toga_jokers',
        pos     = MLIB.coords(1,0),
        rarity  = 'rgmc_unusual',
        cost    = 13,
        config =  {
            immutable = {
                unread  = 0,
                read    = 0
            },
            extra = {
                odds    = 8
            }
        },
        add_to_deck = function(self, card, from_debuff)
            if not from_debuff then
                -- WELCOME!
                play_sound('rgmc_aol_welcome')
            else
                -- door open
                play_sound('rgmc_door_open')
            end
        end,
        calculate = function(self, card, context)
            local event = Madcap.Funcs.pass_aol_event(card,context)
            if event ~= nil and not context.blueprint then
                event = (event == 0) and math.random(1,5) or event
                -- general code
                card.ability.immutable.unread = (card.ability.immutable.unread or 0) + 1
                MadLib.event({
                    func = function()
                        card_eval_status_text(card, "extra", nil, nil, nil, {
                            message = "You've Got Mail!",
                            colour = G.C.GREEN,
                            func = function()    
                                Madcap.Funcs.play_sound_random('rgmc_aol_mail')
                                card:juice_up()
                                return true
                            end
                        })
                        return true
                    end,
                    delay = 0.5
                })
            end
        end,
        remove_from_deck = function(self, card, from_debuff)
            if not from_debuff then
                -- GOODBYE!
                play_sound('rgmc_aol_goodbye')
            else
                -- door close
                play_sound('rgmc_door_close')
            end
        end,
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'aol')
            return MadLib.collect_vars(_numer, _denom, number_format(card.ability.immutable.unread), number_format(card.ability.immutable.read))
        end,
        demicoloncompat = true, -- add email to aol
    }
}
