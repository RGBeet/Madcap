function Madcap.Funcs.impound_cards(cards)
    if not G.impound then
        tell('Impound area not active!')
        return false
    end
    local count = #cards
    local it = 1
    SMODS.calculate_context({ impounding_cards = true, cards = cards })
    MadLib.loop_func(cards, function(v)
        local area = v.area
        MadLib.event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local c1 = area:remove_card(v)
                local c2 = copy_card(c1, nil, nil, nil, false)
                c1:remove()
                c1 = nil
                draw_card(area, G.impound, nil, nil, nil, c2)
                return true
            end
        })
        
        it = it + 1
    end)
    return true
end

function Madcap.Funcs.impound_card(card)
    return Madcap.Funcs.impound_cards({ card })
end

function Madcap.Funcs.create_card_for_impound_shop(area)
    local card = pseudorandom_element(G.impound.cards, pseudoseed('impound'))
    return card
end

-- Updates the Impound Center in real-time.
function Game:update_impound_shop(dt)
    if not G.STATE_COMPLETE then
        stop_use()
        ease_background_colour_blind(G.STATES.RGMC_IMPOUND_SHOP)
        local shop_exists = not not G.shop
        G.shop = G.shop or UIBox{
            definition = G.UIDEF.impound_shop(),
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
                                        end
                                        G.load_shop_jokers = nil
                                    else
                                        local num = math.min(#G.impound.cards, 5)
                                        pseudoshuffle(G.impound.cards, pseudoseed('impound'))
                                        for i = 1, num do
                                            draw_card(G.impound, G.shop_jokers, nil, nil, nil, G.impound.cards[i])
                                            create_shop_card_ui(G.impound.cards[i])
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

-- Goes from regular Shop to Luxury Shoppe
G.FUNCS.goto_impound_shop = function(e)
    stop_use()
    G.CONTROLLER.locks.toggle_shop = true
        if G.shop then 
            SMODS.calculate_context({ending_shop = true})
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
                  G.STATE = G.STATES.RGMC_IMPOUND_SHOP
                  G.CONTROLLER.locks.toggle_shop = nil
                  return true
              end
          })
        G.GAME.shops_visited['impound'] = true
    end
end

function Madcap.Funcs.impound_shop_enabled()
    if G.impound and (#G.impound.cards > 0) then
        return true
    end
    return false
end


-- Luxury Shoppe definition
function G.UIDEF.impound_shop()
    G.shop_jokers = CardArea(
        G.hand.T.x+0,
        G.hand.T.y+G.ROOM.T.y + 9,
        4.9*G.CARD_W,
        0.95*G.CARD_H, 
        {card_limit = 5, type = 'shop', highlight_limit = 1, card_w = (1.27/4)*G.CARD_W})

    local shop_sign = AnimatedSprite(0,0, 4.4, 2.2, G.ANIMATION_ATLAS['rgmc_impound_shop_sign'])
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
    local reroll_button = {n=G.UIT.R, config={align = "cm", minw = 2.8 * 0.6, minh = 1.6, r=0.15,colour = G.C.RGMC_LUXURY, button = 'reroll_impound_shop', func = 'can_reroll', hover = true, shadow = true}, nodes = {
        {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                {n=G.UIT.T, config={text = localize('k_reroll'), scale = 0.4, colour = G.C.WHITE, shadow = true}},
            }},
            {n=G.UIT.R, config={align = "cm", maxw = 1.3, minw = 1}, nodes={
                {n=G.UIT.T, config={text = localize('£'), scale = 0.7, colour = G.C.WHITE, shadow = true}},
                {n=G.UIT.T, config={ref_table = G.GAME.current_round, ref_value = 'reroll_cost', scale = 0.75, colour = G.C.WHITE, shadow = true}},
            }}
        }}
    }}

    local next_round_button = Madcap.Funcs.get_next_round_button()

    local shop_jokers = {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.2}, nodes={
      {n=G.UIT.O, config={object = G.shop_jokers}},
    }}

    local t = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
        UIBox_dyn_container({
            {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
                {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
                    {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                        next_round_button,
                        can_reroll and reroll_button or nil,
                    }},
                }},
                {n=G.UIT.R, config={align = "cm", minh = 0.2}, nodes={}},
                {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
                    shop_jokers,
                }}
            }
        }}, false)
    }}
    return t
end



G.FUNCS.reroll_impound = function(e) 
    stop_use()
    G.CONTROLLER.locks.shop_reroll = true
    if G.CONTROLLER:save_cardarea_focus('shop_jokers') then G.CONTROLLER.interrupt.focus = true end

    local reroll_cost = G.GAME.current_round.reroll_cost
    if G.GAME.current_round.reroll_cost > 0 then 
      inc_career_stat('c_shop_dollars_spent', G.GAME.current_round.reroll_cost)
      inc_career_stat('c_shop_rerolls', 1)
      ease_dollars(-G.GAME.current_round.reroll_cost)
    end
    
    MadLib.event({
        trigger = 'immediate',
        func = function()
            local final_free = G.GAME.current_round.free_rerolls > 0
            G.GAME.current_round.free_rerolls = math.max(G.GAME.current_round.free_rerolls - 1, 0)
            G.GAME.round_scores.times_rerolled.amt = G.GAME.round_scores.times_rerolled.amt + 1

            calculate_reroll_cost(final_free)
            for i = #G.shop_jokers.cards,1, -1 do
                draw_card(G.shop_jokers, G.impound, nil, nil, nil, G.impound.cards[i])
            end

            play_sound('coin2')
            play_sound('other1')
          
            local num = math.min(#G.impound.cards, 5)
            pseudoshuffle(G.impound.cards, pseudoseed('impound'))
            for i = 1, num do
                draw_card(G.impound, G.shop_jokers, nil, nil, nil, G.impound.cards[i])
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
    MadLib.event({ func = function() save_run(); return true end})
end