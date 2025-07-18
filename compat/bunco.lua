-- cryptid mod compat
local list = {} -- loads a blank list if mod is not added
local mod_id, mod_name = "Bunco", "Bunco"
local loaded = mod_loaded(mod_id)

if loaded then -- load the items
end

return {
    name = mod_name .. " Compatability",
    init = function() -- does the non item stuff ig?
		if not mod_loaded(mod_id) then
			tell(mod_name .. "is not loaded - skipping!")
			return false
		end

		return true
    end,
    items = list
}
