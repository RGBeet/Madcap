-- convert cash to lp
function cash_to_lp(m)
	return math.ceil(m/2)
end

function Card:calc_lp()
	return cash_to_lp(self.cost)
end

function ease_lp(mod, instant)
    local function _mod(mod)
        local dollar_UI = G.HUD:get_UIE_by_ID('luxury_text_UI')
        mod = mod or 0
        local text = '+'..localize('$')
        local col = G.C.RGMC_LUXURY
        if mod < 0 then
            text = '-'..localize('$')
            col = G.C.RED
        else
          --inc_career_stat('c_dollars_earned', mod)
        end
        --Ease from current chips to the new number of chips
        G.GAME.rgmc_luxury_pts = G.GAME.rgmc_luxury_pts + mod
        dollar_UI.config.object:update()
        G.HUD:recalculate()
        --Popup text next to the chips in UI showing number of chips gained/lost
        attention_text({
          text = text..tostring(math.abs(mod)),
          scale = 0.8,
          hold = 0.7,
          cover = dollar_UI.parent,
          cover_colour = col,
          align = 'cm',
          })
        --Play a chip sound
        if mod > 0 then
          play_sound('rgmc_kaching')
        elseif mod ~= 0 then
          play_sound('rgmc_kaching_evil')
        end
    end
    if instant then
        _mod(mod)
    else
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            _mod(mod)
            return true
        end
        }))
    end
end

-- different one for luxury points
G.FUNCS.can_buy_luxury = function(e)
	local lp_cost = cash_to_lp(e.config.ref_table.cost)
    if (G.GAME.rgmc_luxury_pts - lp_cost) <= 0 then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.DARK_EDITION
        e.config.button = 'buy_from_shop'
    end
    if e.config.ref_parent and e.config.rref_parent.children.buy_and_use then
      if e.config.ref_parent.children.buy_and_use.states.visible then
        e.UIBox.alignment.offset.y = -0.6
      else
        e.UIBox.alignment.offset.y = 0
      end
    end
end

-- Can buy & use if enough Luxe held
G.FUNCS.can_buy_and_use_luxury = function(e)
	local lp_cost = cash_to_lp(e.config.ref_table.cost)
    if (G.GAME.rgmc_luxury_pts - lp_cost) <= 0 then
        e.UIBox.states.visible = false
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        if e.config.ref_table.highlighted then
          e.UIBox.states.visible = true
        end
        e.config.colour = G.C.SECONDARY_SET.Voucher
        e.config.button = 'buy_from_shop_luxury'
    end
end

-- Can use if enough Luxe held
G.FUNCS.can_open_luxury = function(e)
	local lp_cost = cash_to_lp(e.config.ref_table.cost)
    if (G.GAME.rgmc_luxury_pts - lp_cost) <= 0 then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.DARK_EDITION
        e.config.button = 'use_card'
    end
end

-- Can redeem Voucher if enough Luxe held
G.FUNCS.can_redeem_luxury = function(e)
	local lp_cost = cash_to_lp(e.config.ref_table.cost)
    if (G.GAME.rgmc_luxury_pts - lp_cost) <= 0 then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.DARK_EDITION
        e.config.button = 'use_card'
    end
end

function Madcap.Funcs.uses_lp(card)
    return card.ability.force_lp
end

function Madcap.Funcs.luxury_shoppe_enabled()
    if G.GAME.rgmc_luxury_pts and G.GAME.rgmc_luxury_pts > 5 then
        return true
    end
    return false
end

--[[
    The LUXURY SHOPPE
]]

G.FUNCS.can_reroll_luxury_shoppe = function(e)
    if G.GAME.rgmc_luxury_pts - 2 < 0 then 
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.GREEN
        e.config.button = 'reroll_luxury_shoppe'
    end
end

-- Luxury Shoppe definition
function G.UIDEF.luxury_shoppe()
    G.shop_jokers = CardArea(
      G.hand.T.x+0,
      G.hand.T.y+G.ROOM.T.y + 9,
      math.min(G.GAME.shop.joker_max*1.02*G.CARD_W,4.08*G.CARD_W),
      1.05*G.CARD_H, 
      {card_limit = G.GAME.shop.joker_max, type = 'shop', highlight_limit = 1, negative_info = true})

    G.shop_booster = CardArea(
      G.hand.T.x+0,
      G.hand.T.y+G.ROOM.T.y + 9,
      2.4*G.CARD_W,
      1.15*G.CARD_H, 
      {card_limit = 2, type = 'shop', highlight_limit = 1, card_w = 1.27*G.CARD_W})

    local shop_sign = AnimatedSprite(0,0, 4.4, 2.2, G.ANIMATION_ATLAS['rgmc_luxury_shoppe_sign'])
    shop_sign:define_draw_steps({
      {shader = 'dissolve', shadow_height = 0.05},
      {shader = 'dissolve'}
    })
    G.SHOP_SIGN = UIBox{
        definition = 
            {n=G.UIT.ROOT, config = {colour = G.C.DYN_UI.MAIN, emboss = 0.05, align = 'cm', r = 0.1, padding = 0.1}, nodes={
                {n=G.UIT.R, config={align = "cm", padding = 0.1, minw = 4.72, minh = 3.1, colour = G.C.DYN_UI.DARK, r = 0.1}, nodes={
                    {n=G.UIT.R, config={align = "cm"}, nodes={
                        {n=G.UIT.O, config={object = shop_sign}}
                    }},
                    {n=G.UIT.R, config={align = "cm"}, nodes={
                        {n=G.UIT.O, config={object = DynaText({string = {localize('ph_luxury')}, colours = {lighten(G.C.GOLD, 0.3)},shadow = true, rotate = true, float = true, bump = true, scale = 0.5, spacing = 1, pop_in = 1.5, maxw = 4.3})}}
                    }},
                }},
            }},
        config = {
            align="cm",
            offset = {x=0,y=-15},
            major = G.HUD:get_UIE_by_ID('row_blind'),
            bond = 'Weak'
        }
    }
    
    MadLib.event({
      trigger = 'immediate',
      func = (function()
          G.SHOP_SIGN.alignment.offset.y = 0
          return true
      end)
    })

    local can_reroll = false
    local reroll_button = {n=G.UIT.R, config={align = "cm", minw = 2.8 * 0.6, minh = 1.6, r=0.15,colour = G.C.RGMC_LUXURY, button = 'reroll_luxury_shoppe', func = 'can_reroll_luxury_shoppe', hover = true,shadow = true}, nodes = {
        {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                {n=G.UIT.T, config={text = localize('k_reroll'), scale = 0.4, colour = G.C.WHITE, shadow = true}},
            }},
            {n=G.UIT.R, config={align = "cm", maxw = 1.3, minw = 1}, nodes={
                {n=G.UIT.T, config={text = localize('$'), scale = 0.7, colour = G.C.WHITE, shadow = true}},
                {n=G.UIT.T, config={ref_table = G.GAME.current_round, ref_value = 'reroll_cost', scale = 0.75, colour = G.C.WHITE, shadow = true}},
            }}
        }}
    }}

    local next_round_button = Madcap.Funcs.get_next_round_button()

    local shop_jokers = {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.2}, nodes={
      {n=G.UIT.O, config={object = G.shop_jokers}},
    }}
    local shop_booster = {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.L_BLACK, emboss = 0.05 }, nodes={
      {n=G.UIT.O, config={object = G.shop_booster}},
    }}

    local t = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
        UIBox_dyn_container({
                {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
                    {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
                      {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                        next_round_button,
                        can_reroll and reroll_button or nil,
                      }},
                      shop_jokers,
                    }},
                    {n=G.UIT.R, config={align = "cm", minh = 0.2}, nodes={}},
                    {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
                      shop_booster,
                    }}
                  }
        }}, false)
    }}
    return t
end


function Madcap.Funcs.get_shop_playing_card_type()
    return (G.GAME.used_vouchers["v_illusion"] and pseudorandom(pseudoseed('illusion')) > 0.6) and 'Enhanced' or 'Base'
end

function Madcap.Funcs.get_shop_playing_card(c,area)
    local card = create_card(c or 'Base', area, nil, nil, nil, nil, nil, 'sho')
    if 
        G.GAME.used_vouchers["v_illusion"] 
        and pseudorandom(pseudoseed('illusion')) > 0.8 
    then 
        card:set_edition(poll_edition('illusion', nil, true, true))
    end

    return card
end

Madcap.Lists.LuxuryRates = {
    { value = 'Rare',           weight = 10 },
    { value = 'rgmc_unusual',   weight = 5 },
    { value = 'Legendary',      weight = 2 }
}

function Madcap.Funcs.create_card_for_luxury_shoppe(area)
    local forced_tag = nil
    for k, v in ipairs(G.GAME.tags) do
        if not forced_tag then
            forced_tag = v:apply_to_run({type = 'store_joker_create', area = area})
            if forced_tag then
                for _, v2 in ipairs(G.GAME.tags) do
                    if v2:apply_to_run({ type = 'store_joker_modify', card = forced_tag }) then break end
                end
            return forced_tag end
        end
    end
    
    G.GAME.spectral_rate = G.GAME.spectral_rate or 0
    
    local total_rate = G.GAME.joker_rate + G.GAME.playing_card_rate
    
    MadLib.loop_func(SMODS.ConsumableType.ctype_buffer, function(v)
        total_rate = total_rate + G.GAME[v:lower()..'_rate']
    end)
    
    local polled_rate = pseudorandom(pseudoseed('cdt' .. G.GAME.round_resets.ante)) * total_rate
    local check_rate = 0
    
    -- need to preserve order to leave RNG unchanged
    local rates = {
        { type = 'Joker', val = G.GAME.joker_rate },
        { type = 'Tarot', val = 0 },
        { type = 'Planet', val = 0 },
        { type = Madcap.Funcs.get_shop_playing_card_type(), val = 1 + G.GAME.playing_card_rate},
        { type = 'Spectral', val = G.GAME.spectral_rate * 2 },
        { type = 'CosmaTarot', val = G.GAME.cosma_rate * 2 },
        { type = 'MadcapJoker', val = G.GAME.madcap_content_rate }
    }

    local subhands_enabled = Madcap.Funcs.subhands_in_effect()
    if subhands_enabled then
        table.insert(rates, { type = 'SpatiaPlanet', val = (G.GAME.spatia_rate * 1.5) + 1 })
        table.insert(rates, { type = 'PotentiaCrystal', val = (G.GAME.potentia_rate or 0) * 2 + 1 })
    end
    
    for _, v in ipairs(SMODS.ConsumableType.ctype_buffer) do
        local pass = true
        -- rate already exists
        for _, v1 in pairs(rates) do
            if type(v1) == 'table' and v1.type == v then
                pass = false
                break
            end
        end
        if pass then
            table.insert(rates, { type = v, val = G.GAME[v:lower()..'_rate'] })
        end
    end
    
    local card = nil
    local rarity = nil

    for _, v in ipairs(rates) do
        print(v.type)
        if polled_rate > check_rate and polled_rate <= check_rate + v.val then
            if v.type == 'Joker' then
                --print('JOKER TIME!')
                local rarity = Madcap.Funcs.get_weighted_choice(Madcap.Lists.LuxuryRates)
                card = create_card(v.type, area, nil, rarity, nil, nil, nil, 'sho')
                MadLib.event({
                    func = (function()
                        for k, v in ipairs(G.GAME.tags) do if v:apply_to_run({type = 'store_joker_modify', card = card}) then break end; end
                        return true
                    end)
                })
            elseif v.type == 'Base' or v.type == 'Enhanced' then
                card = Madcap.Funcs.get_shop_playing_card(v.type, area)
            else
                card = create_card(v.type, area, nil, nil, nil, nil, nil, 'sho')
            end

            if card ~= nil then
                card.ability.force_lp = true
                create_shop_card_ui(card, v.type, area)
                return card
            end
        end
        check_rate = check_rate + v.val
    end

    -- fallback
    rarity = Madcap.Funcs.get_weighted_choice(Madcap.Lists.LuxuryRates)
    card = create_card('Joker', area, nil, rarity, nil, nil, nil, 'sho')
    return card
end

-- Calculates the Luxury Shoppe reroll coste (in Luxury Points)
function Madcap.Funcs.calculate_luxury_shoppe_reroll_cost(skip_increment)
    if G.GAME.current_round.free_rerolls < 0 then G.GAME.current_round.free_rerolls = 0 end
    if G.GAME.current_round.free_rerolls > 0 then G.GAME.current_round.reroll_cost = 0; return end
    G.GAME.current_round.reroll_cost_increase = G.GAME.current_round.reroll_cost_increase or 0
    if not skip_increment then G.GAME.current_round.reroll_cost_increase = G.GAME.current_round.reroll_cost_increase + 1 end
    G.GAME.current_round.reroll_cost = (G.GAME.round_resets.temp_reroll_cost or G.GAME.round_resets.reroll_cost) + G.GAME.current_round.reroll_cost_increase
end

-- Rerolls the Luxury Shoppe
G.FUNCS.reroll_luxury_shoppe = function(e) 
    stop_use()
    G.CONTROLLER.locks.shop_reroll = true
    if G.CONTROLLER:save_cardarea_focus('shop_jokers') then G.CONTROLLER.interrupt.focus = true end
    
    G.GAME.current_round.lp_reroll_cost = G.GAME.current_round.lp_reroll_cost or 0
    local reroll_cost = G.GAME.current_round.lp_reroll_cost

    if G.GAME.current_round.lp_reroll_cost > 0 then 
        inc_career_stat('c_shop_rerolls', 1)
        ease_lp(-G.GAME.current_round.reroll_cost)
    end
    
    MadLib.event({
        trigger = 'immediate',
        func = function()
            local final_free = G.GAME.current_round.free_rerolls > 0
            G.GAME.current_round.free_rerolls = math.max(G.GAME.current_round.free_rerolls - 1, 0)
            G.GAME.round_scores.times_rerolled.amt = G.GAME.round_scores.times_rerolled.amt + 1

            Madcap.Funcs.calculate_luxury_shoppe_reroll_cost(final_free)
            for i = #G.shop_jokers.cards,1, -1 do
                local c = G.shop_jokers:remove_card(G.shop_jokers.cards[i])
                c:remove()
                c = nil
            end

            --save_run()
            play_sound('rgmc_luxury_slot')
            play_sound('other1')
          
            for i = 1, G.GAME.shop.joker_max - #G.shop_jokers.cards do
                local new_shop_card = Madcap.Funcs.create_card_for_luxury_shoppe(G.shop_jokers)
                G.shop_jokers:emplace(new_shop_card)
                new_shop_card:juice_up()
            end
            return true
        end
    })

    MadLib.event({
        trigger = 'after',
        delay = 0.3,
        func = function()
            MadLib.event({
                func = function()
                    G.CONTROLLER.interrupt.focus = false
                    G.CONTROLLER.locks.shop_reroll = false
                    G.CONTROLLER:recall_cardarea_focus('shop_jokers')
                    SMODS.calculate_context({reroll_shop = true, cost = reroll_cost})
                    return true
                end
            })
        return true
        end
    })
    MadLib.event({ func = function() save_run(); return true end })
end

-- Updates the Luxury Shoppe in real-time.
function Game:update_luxury_shoppe(dt)
    if not G.STATE_COMPLETE then
        stop_use()
        ease_background_colour_blind(G.STATES.RGMC_LUXURY_SHOPPE)
        local shop_exists = not not G.shop
        G.shop = G.shop or UIBox{
            definition = G.UIDEF.luxury_shoppe(),
            config = {align='tmi', offset = {x=0,y=G.ROOM.T.y+11},major = G.hand, bond = 'Weak'}
        }
        MadLib.event({
            func = function()
                G.shop.alignment.offset.y = -5.3
                G.shop.alignment.offset.x = 0
                MadLib.event({
                    trigger = 'after',
                    delay = 0.2,
                    blockable = false,
                    func = function()
                        if math.abs(G.shop.T.y - G.shop.VT.y) < 3 then
                            G.ROOM.jiggle = G.ROOM.jiggle + 3
                            play_sound('cardFan2')
                            local nosave_shop = nil
                                if not shop_exists then
                                    -- Load the Jokers
                                    if G.load_shop_jokers then 
                                        nosave_shop = true
                                        G.shop_jokers:load(G.load_shop_jokers)
                                        for _, v in ipairs(G.shop_jokers.cards) do
                                            create_shop_card_ui(v)
                                            if v.ability.consumeable then v:start_materialize() end
                                            for _, v2 in ipairs(G.GAME.tags) do
                                                if v2:apply_to_run({ type = 'store_joker_modify', card = v }) then break end
                                            end
                                        end
                                        G.load_shop_jokers = nil
                                    else
                                        for i = 1, G.GAME.shop.joker_max - #G.shop_jokers.cards do
                                            G.shop_jokers:emplace(Madcap.Funcs.create_card_for_luxury_shoppe(G.shop_jokers))
                                        end
                                    end
                                    -- Load the Boosters
                                    if G.load_shop_booster then 
                                        nosave_shop = true
                                        G.shop_booster:load(G.load_shop_booster)
                                        for k, v in ipairs(G.shop_booster.cards) do
                                            create_shop_card_ui(v)
                                            v:start_materialize()
                                        end
                                        G.load_shop_booster = nil
                                    else
                                        for i=1, G.GAME.starting_params.boosters_in_shop + (G.GAME.modifiers.extra_boosters or 0) do
                                            local pack = get_pack('shop_pack', 'booster_luxury').key
                                            local card = Card(G.shop_booster.T.x + G.shop_booster.T.w/2,
                                                G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[pack], {bypass_discovery_center = true, bypass_discovery_ui = true})
                                            create_shop_card_ui(card, 'Booster', G.shop_booster)
                                            card.ability.booster_pos = i
                                            card:start_materialize()
                                            card.ability.force_lp = true
                                            G.shop_booster:emplace(card)
                                        end
                                    end
                                end
                            if not nosave_shop then SMODS.calculate_context({starting_shop = true}) end
                            G.CONTROLLER:snap_to({node = G.shop:get_UIE_by_ID('next_round_button')})
                            if not nosave_shop then G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end})) end
                            return true
                        end
                    end
                })
                return true
            end
        })
        G.STATE_COMPLETE = true
    end  
    if self.buttons then self.buttons:remove(); self.buttons = nil end          
end

-- Reset before loading shop contents.
function Madcap.Funcs.shop_reset_before()
    G.GAME.shop_free = nil
    G.GAME.shop_d6ed = nil
    G.STATE_COMPLETE = false
    G.GAME.current_round.hands_played = 0
    G.GAME.mf_tree_three = false
end

-- Reset after loading shop contents.
function Madcap.Funcs.shop_reset_after()
    ease_chips(0)
    if G.GAME.round_resets.blind_states.Boss == 'Defeated' then 
        G.GAME.round_resets.blind_ante = G.GAME.round_resets.ante
        G.GAME.round_resets.blind_tags.Small = get_next_tag_key()
        G.GAME.round_resets.blind_tags.Big = get_next_tag_key()
      end
end

function Madcap.add_missed_jokers()
    G.GAME.missed_jokers = G.GAME.missed_jokers or {}
    if G.shop_jokers then
        MadLib.loop_func(G.shop_jokers.cards, function(v,i)
            table.insert(G.GAME.missed_jokers,v.config.center.key)
        end)
    end
end

-- Goes from regular Shop to Luxury Shoppe
G.FUNCS.goto_luxury_shoppe = function(e)
    stop_use()
    G.CONTROLLER.locks.toggle_shop = true
        if G.shop then 
            SMODS.calculate_context({ending_shop = true})
            Madcap.add_missed_jokers()
            MadLib.event({
                trigger = 'immediate',
                func = function()
                    G.shop.alignment.offset.y = G.ROOM.T.y + 29
                    G.SHOP_SIGN.alignment.offset.y = -15
                    return true
                end
            })
            MadLib.event({
                trigger = 'after',
              delay = 0.5,
              func = function()
                  G.shop:remove()
                  G.shop = nil
                  G.SHOP_SIGN:remove()
                  G.SHOP_SIGN = nil
                  G.STATE_COMPLETE = false
                  G.STATE = G.STATES.RGMC_LUXURY_SHOPPE
                  G.CONTROLLER.locks.toggle_shop = nil
                  return true
              end
          })
        G.GAME.shops_visited['luxury'] = true
    end
end




--G.shop:get_UIE_by_ID('next_round_button'),

