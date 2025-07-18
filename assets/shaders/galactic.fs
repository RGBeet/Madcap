#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define MY_HIGHP_OR_MEDIUMP highp
#else
    #define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 galactic;
extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a * 0.3 : tex.a);
    }

    float adjusted_dissolve = (dissolve * dissolve * (3. - 2. * dissolve)) * 1.02 - 0.01;

    float t = time * 10.0 + 2003.;
    vec2 floored_uv = (floor((uv * texture_details.ba))) / max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);

    vec2 field_part1 = uv_scaled_centered + 50. * vec2(sin(-t / 143.6340), cos(-t / 99.4324));
    vec2 field_part2 = uv_scaled_centered + 50. * vec2(cos(t / 53.1532), cos(t / 61.4532));
    vec2 field_part3 = uv_scaled_centered + 50. * vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1. + (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92))) / 2.;

    vec2 borders = vec2(0.2, 0.8);

    float res = (.5 + .5 * cos((adjusted_dissolve) / 82.612 + (field + -.5) * 3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y) * (5. + 5. * dissolve) : 0.) * (dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y) * (5. + 5. * dissolve) : 0.) * (dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x) * (5. + 5. * dissolve) : 0.) * (dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y) * (5. + 5. * dissolve) : 0.) * (dissolve);

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8 * (0.5 - abs(adjusted_dissolve - 0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5 * (0.5 - abs(adjusted_dissolve - 0.5)) && res > adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            tex.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0., 0., 0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a * 0.3 : tex.a) : 0.);
}

number hue(number s, number t, number h)
{
	number hs = mod(h, 1.)*6.;
	if (hs < 1.) return (t-s) * hs + s;
	if (hs < 3.) return t;
	if (hs < 4.) return (t-s) * (4.-hs) + s;
	return s;
}

vec4 RGB(vec4 c)
{
	if (c.y < 0.0001)
		return vec4(vec3(c.z), c.a);

	number t = (c.z < .5) ? c.y*c.z + c.z : -c.y*c.z + (c.y+c.z);
	number s = 2.0 * c.z - t;
	return vec4(hue(s,t,c.x + 1./3.), hue(s,t,c.x), hue(s,t,c.x - 1./3.), c.w);
}

vec4 HSL(vec4 c)
{
	number low = min(c.r, min(c.g, c.b));
	number high = max(c.r, max(c.g, c.b));
	number delta = high - low;
	number sum = high+low;

	vec4 hsl = vec4(.0, .0, .5 * sum, c.a);
	if (delta == .0)
		return hsl;

	hsl.y = (hsl.z < .5) ? delta / sum : delta / (2.0 - sum);

	if (high == c.r)
		hsl.x = (c.g - c.b) / delta;
	else if (high == c.g)
		hsl.x = (c.b - c.r) / delta + 2.0;
	else
		hsl.x = (c.r - c.g) / delta + 4.0;

	hsl.x = mod(hsl.x / 6., 1.);
	return hsl;
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 tex = Texel(texture, texture_coords);
    vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;

    // === Galactic field: soft blue-purple background ===
    float t = galactic.y * 2.221 + time;
    vec2 floored_uv = floor(uv * texture_details.ba) / texture_details.ba;
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 50.;

    vec2 field_part1 = uv_scaled_centered + 50. * vec2(sin(-t / 17.0), cos(-t / 13.0));
    vec2 field_part2 = uv_scaled_centered + 50. * vec2(cos( t / 11.0),  cos( t / 9.0));
    vec2 field_part3 = uv_scaled_centered + 50. * vec2(sin(-t / 7.0), sin(-t / 6.0));

    float void_field = (1. + (
        cos(length(field_part1) / 8.0) + sin(length(field_part2) / 14.0) * cos(field_part2.y / 8.0) +
        cos(length(field_part3) / 10.0) * sin(field_part3.x / 7.0) )) / 2.;

    // Remove color inversion, apply dark blue tint
    vec3 darkBlueTint = vec3(0.1, 0.2, 0.5); // core color of the void
    vec3 blueShaded = tex.rgb * vec3(0.4, 0.4, 1.0); // slightly suppress R/G, enhance B
    tex.rgb = mix(blueShaded, darkBlueTint, 0.6); // stronger blue lean

    // Add galactic void field tint on top
    tex.rgb = mix(tex.rgb, vec3(0.0, 0.0, 0.05), void_field * 0.3);

    // === STAR LAYERS ===
    vec3 starColor = vec3(0.0);
    float layers[3] = float[](20.0, 30.0, 40.0);
    vec3 starColors[3] = vec3[](vec3(1.0), vec3(0.8, 0.8, 1.0), vec3(1.0, 0.9, 0.7));

    for (int i = 0; i < 3; i++) {
        float scale = layers[i];
        vec2 star_uv = floor((uv + vec2(t * 0.01 * float(i+1))) * scale);
        float seed = dot(star_uv, vec2(12.9898 + float(i)*15.33, 78.233 + float(i)*37.42));
        float noise = fract(sin(seed) * 43758.5453);
        float presence = step(0.985, noise);
        float twinkle = 0.4 + 0.6 * sin(t * 0.5 + seed);
        starColor += starColors[i] * presence * twinkle;
    }

    // Rare red stars
    vec2 rare_uv = floor((uv + vec2(t * 0.002)) * 12.0);
    float rare_seed = dot(rare_uv, vec2(91.22, 31.37));
    float rare_noise = fract(sin(rare_seed) * 75341.222);
    float rare_presence = step(0.995, rare_noise);
    float rare_twinkle = 0.4 + 0.6 * sin(t * 0.3 + rare_seed);
    starColor += vec3(1.0, 0.4, 0.4) * rare_presence * rare_twinkle;

    tex.rgb += clamp(starColor * 0.4, 0.0, 1.0);

    // === Color correction and dissolve ===
    tex.rgb = RGB(HSL(tex)).rgb;
    tex.rgb = clamp(tex.rgb, 0.0, 1.0);

    if (tex[3] < 0.7)
        tex[3] = tex[3]/3.;

    return dissolve_mask(tex * colour, texture_coords, uv);
}

extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    if (hovering <= 0.) {
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5 * love_ScreenSize.xy) / length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy) / screen_scale;
    float scale = 0.2 * (-0.03 - 0.3 * max(0.0, 0.3 - mid_dist))
                * hovering * (length(mouse_offset) * length(mouse_offset)) / (2. - mid_dist);

    return transform_projection * vertex_position + vec4(0, 0, 0, scale);
}
#endif
