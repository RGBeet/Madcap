return {
    categories = {
        'Tags',
        'Unusual',
        'Chaotic'
    },
    data = {
        object_type = "Tag",
        key     = "jackpot",
        atlas   = "tags",
        pos     = MLIB.coords(2,7),
        config = { type = "new_blind_choice", odds = 8 },
        min_ante = 2,
        loc_vars = function(self, info_queue)
            MadLib.add_to_queue({ set = "Tag", key = "tag_rgmc_cogito" })
            local _numer, _denom = SMODS.get_probability_vars(card, 1, self.config.odds, 'jackpot')
            return MadLib.collect_vars(number_format(_numer), number_format(_denom))
        end,
        apply = function(self, tag, context)
            if context.type == "new_blind_choice" then
                if SMODS.pseudorandom_probability(card, 'jackpot', 1, self.config.odds) then
                    local lock = tag.ID
                    G.CONTROLLER.locks[lock] = true
                    tag:yep("+", G.C.SECONDARY_SET.Spectral, function()
                        local cog = Tag("tag_rgmc_cogito")
                        if self.config.shiny then cog.ability.shiny = Cryptid.is_shiny() end
                        add_tag(cog)
                        tag.triggered = true
                        cog:apply_to_run({ type = "new_blind_choice" })
                        G.CONTROLLER.locks[lock] = nil
                        return true
                    end)
                else
                    tag:nope()
                    tag.triggered = true
                    for i = 1, #G.GAME.tags do
                        if G.GAME.tags[i] ~= tag then
                            if G.GAME.tags[i]:apply_to_run({ type = "new_blind_choice" }) then
                                break
                            end
                        end
                    end
                end
                tag.triggered = true
                return true
            end
		end
    }
}
