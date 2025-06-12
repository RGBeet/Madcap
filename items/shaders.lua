-- no vars here, kind of not needed?

local ext, list = 'fs', {}

local shaders = {
    'iridescent',
    'infernal',
    'chrome',
    'disco',
    'phasing'
}

for i=1, #shaders do
    local obj = key_path_simple(shaders[i],ext)
    obj.object_type = "Shader"
    list[#list+1] = obj
end

return {
    name = "Shaders",
    init = function() print("Shaders!") end,
    items = list
}
