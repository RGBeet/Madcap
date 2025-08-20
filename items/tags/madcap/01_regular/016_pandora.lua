return {
    categories = {
        'Tags',
        'Mayhem',
    },
    data = {
        object_type = "Tag",
        key     = "pandora",
        atlas   = "tags",
        pos     = MLIB.coords(1,1),
        config = { type 	= "new_blind_choice", extra = 1 },
        loc_vars = function(self, info_queue)
            return MadLib.collect_vars(number_format(self.config.extra))
        end,
        in_pool = function()
            -- will easing the mayhem exceed the max mayhem
            return not G.GAME.mayhem or (G.GAME.mayhem + 1 <= G.GAME.max_mayhem)
        end,
        apply = function(self, tag, context)
            local lock = tag.ID
            if context.type == self.config.type then
                tag:yep('+', G.C.PURPLE, function() return true end) -- Money
                show_tag_effect_text("Mayhem Increased!")
                Madcap.Funcs.ease_mayhem(mayhem)
                tag.triggered = true
                return true
            end
        end,
    }
}
