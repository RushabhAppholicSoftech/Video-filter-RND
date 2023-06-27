// Source: https://www.shadertoy.com/view/ldX3Ds

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	float scaleX = 60.0;
	vec2 scale = vec2(scaleX, scaleX / iResolution.x * iResolution.y);
	float width = 0.3;
	float scaleY = scaleX / iResolution.x * iResolution.y;
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec2 pos = fract(uv * scale);
	vec2 coord = floor(uv * scale) / scale;
	float xb = dot(texture(iChannel0, vec2(coord.x, uv.y)).xyz, vec3(1.0 / 3.0));
	float yb = dot(texture(iChannel0, vec2(uv.x, coord.y)).xyz, vec3(1.0 / 3.0));
	float lit = float(abs(pos.y - width / 2.0 - (1.0 - width) * yb) < width / 2.0 || abs(pos.x - width / 2.0 - (1.0 - width) * xb) < width / 2.0);
	float b = (yb + xb) / 2.0;
	fragColor = vec4(0.0, lit * b + (1.0 - lit) * b * 0.3, 0.0, 1.0);
}