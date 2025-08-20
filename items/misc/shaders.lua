-- This is where I add LOVE2D Shaders. The magic and the mystery, of LOVE2D Shaders.

local ext, list = 'fs', {}

local shaders = {
    'iridescent',
    'infernal',
    'chrome',
    'disco',
    'phasing',
    'galactic',
    'abyssal',
    'luxury',
    'flipped'
}

for i=1, #shaders do
    local obj = MadLib.keypath_simple(shaders[i],ext)
    obj.object_type = "Shader"
    list[#list+1] = obj
end

return {
    name = "Shaders",
    init = function() print("Shaders!") end,
    items = list
}
