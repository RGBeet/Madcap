Madcap.JokerLists = Madcap.JokerLists or {}
Madcap.JokerLists.Meme = {
	'rgmc_thorium_joker'
}
MadLib.list_append(Madcap.JokerLists.Meme,'j_',nil)

local function create_joker_spam(_area,i)
	local is_spam = not i or i < 4 	-- either digihal'd or orignally spawned
	local _joker_id = 'j_rgmc_spam' -- get SPAM!

	if not is_spam then
        _joker_id = pseudorandom_element(Madcap.JokerLists.Meme, pseudoseed('madlib_counterpart'))
	elseif G.GAME.spams_killed and G.GAME.spams_killed > 8 and SMODS.pseudorandom_probability(card, 'lobster', 1, 8) then
		_joker_id = 'j_rgmc_lobster_thermidor'
	end
	local _temp = {
		set = "Joker",
		area = _area or G.jokers,
		key = _joker_id,
	}
	local _card = SMODS.create_card(_temp)
	return _card
end

return {
    categories = {
        'Boosters',
        'Gimmick',
    },
    data = {
        object_type = 'Booster',
        key     = "oops_all_spam",
        weight  = 1,
        kind    = 'Variety',
        cost    = 5,
        atlas   = 'boosters',
        pos     = MLIB.coords(4,1),
        config      = { extra = 3, choose = 1 },
        group_key   = 'k_rgmc_variety_pack',
        draw_hand   = false,
        loc_vars = function(self, info_queue, card)
            local cfg = (card and card.ability) or self.config
            return MadLib.collect_vars(cfg.choose, cfg.extra)
        end,
        ease_background_colour = function(self)
            Madcap.Funcs.booster_ease_bg(self, G.C.GOLD, G.C.BLUE)
        end,
        particles = function(self)
            G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
                timer = 0.015,
                scale = 0.2,
                initialize = true,
                lifespan = 1,
                speed = 1.1,
                padding = -1,
                attach = G.ROOM_ATTACH,
                colours = { G.C.WHITE, lighten(G.C.BLUE, 0.4), lighten(G.C.BLUE, 0.2), lighten(G.C.GOLD, 0.1) },
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
		create_card		= function(self, card, i)
            return create_joker_spam(G.pack_cards,i)
		end,
        cry_digital_hallucinations = {
            colour = G.C.GREEN,
            loc_key = "k_plus_joker",
            create = function()
                -- TODO: maybe add chance for meme joker?
                return digihal_prepare(create_joker_spam(G.jokers.cards,4), G.jokers) -- digihal gets meme joker instead
            end,
        },
    }
}
