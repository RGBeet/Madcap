return {
    categories = {
        'Tags',
        'New Suits'
    },
    data = {
        object_type = "Tag",
        key     = "punisher",
        atlas   = "tags",
        pos     = MLIB.coords(0,5),
        config = { dollars = 15, extra = 2, },
        loc_vars = function(self, info_queue, tag)
            return MadLib.collect_vars(number_format(self.config.dollars or 15), number_format(self.config.extra))
        end,
        in_pool = function()
            -- appears if ante 3 or greater (gotta give some time because it's a DOOZY!)
            return Madcap.Data.devmode or G.GAME.round_resets.ante > 2
        end,
        apply = function(self, tag, context)
            if context.type == 'round_start_bonus' and not G.GAME.punisher_mode then
                G.GAME.punisher_mode = true -- find a better variable, just do this for now

                tag:yep('+', G.C.MONEY, function() return true end)
                ease_dollars(self.config.dollars)
                local hand_diff = math.min(G.GAME.current_round.hands_left, self.config.extra)

                ease_hands_played(hand_diff - G.GAME.current_round.hands_left)
                ease_discard(-G.GAME.current_round.discards_left) -- bye bye discards

                tag.triggered = true
                return true
            end
        end
    }
}
