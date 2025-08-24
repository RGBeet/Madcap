return {
    categories = {
        'Tags',
        'Experimental'
    },
    data = {
        object_type = "Tag",
        key     = "concept",
        atlas   = "tags",
        pos     = MLIB.coords(2,0),
        config = { target = nil },
        in_pool = function()
            return G.jokers and #G.jokers.cards > 0
        end,
        apply = function(self, tag, context)
            if target == nil and context.type == "tag_add" and context.tag.key ~= self.config.key then
                target = context.tag -- mark the tag used
            end
            -- if the target tag is removed, then get the next tag above it
            if context.type == "tag_remove" and context.tag == self.config.target then
                for i=1,#G.GAME.tags-1 do
                    if G.GAME.tags[i] == self and G.GAME.tags[i].key ~= self.config.key then
                        target = G.GAME.tags[i+1]
                        break
                    end
                end
            end
            -- copy
            if target ~= nil and context.type == G.GAME.tags[self.config.target].config.type then
                add_tag(Tag(self.config.key))
            end
        end,
    }
}
