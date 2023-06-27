// The MIT License
// Copyright © 2013 Jianing Zhang
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#define NOISE_SIMPLEX_1_DIV_289 0.00346020761245674740484429065744f
#define _Frequency 2.3
#define _RGBSplit 37.8
#define _Speed 0.32
#define _Amount 1.0

vec3 taylorInvSqrt(vec3 r){return 1.79284291400159 - 0.85373472095314 * r;}

vec2 mod289(vec2 x)
{
	return x - floor(x * NOISE_SIMPLEX_1_DIV_289) * 289.0;
}

vec3 mod289(vec3 x)
{
	return x - floor(x * NOISE_SIMPLEX_1_DIV_289) * 289.0;
}

vec3 permute(vec3 x)
{
	return mod289(x * x * 34.0 + x);
}


float snoise(vec2 v)
{
	const vec4 C = vec4(0.211324865405187, // (3.0-sqrt(3.0))/6.0
	0.366025403784439, // 0.5*(sqrt(3.0)-1.0)
	- 0.577350269189626, // -1.0 + 2.0 * C.x
	0.024390243902439); // 1.0 / 41.0
	// First corner
	vec2 i = floor(v + dot(v, C.yy));
	vec2 x0 = v - i + dot(i, C.xx);
	
	// Other corners
	vec2 i1;
	i1.x = step(x0.y, x0.x);
	i1.y = 1.0 - i1.x;
	
	// x1 = x0 - i1  + 1.0 * C.xx;
	// x2 = x0 - 1.0 + 2.0 * C.xx;
	vec2 x1 = x0 + C.xx - i1;
	vec2 x2 = x0 + C.zz;
	
	// Permutations
	i = mod289(i); // Avoid truncation effects in permutation
	vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0))
	+ i.x + vec3(0.0, i1.x, 1.0));
	
	vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x1, x1), dot(x2, x2)), 0.0);
	m = m * m;
	m = m * m;
	
	// Gradients: 41 points uniformly over a line, mapped onto a diamond.
	// The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)
	vec3 x = 2.0 * fract(p * C.www) - 1.0;
	vec3 h = abs(x) - 0.5;
	vec3 ox = floor(x + 0.5);
	vec3 a0 = x - ox;
	
	// Normalise gradients implicitly by scaling m
	m *= taylorInvSqrt(a0 * a0 + h * h);
	
	// Compute final noise value at P
	vec3 g;
	g.x = a0.x * x0.x + h.x * x0.y;
	g.y = a0.y * x1.x + h.y * x1.y;
	g.z = a0.z * x2.x + h.z * x2.y;
	return 130.0 * dot(m, g);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float strength = 1.0;
    vec2 uv = fragCoord/iResolution.xy;
    float noise_wave_1 = snoise(vec2(uv.y, iTime * _Speed * 20.0)) * (strength * _Amount * 32.0);
    float noise_wave_2 = snoise(vec2(uv.y, iTime * _Speed * 10.0)) * (strength * _Amount * 4.0);
	float noise_wave_x = noise_wave_1 * noise_wave_2 / iResolution.x;
	float uv_x = uv.x + noise_wave_x;
    
    float rgbSplit_uv_x = (_RGBSplit * 50.0 + (20.0 * strength + 1.0)) * noise_wave_x / iResolution.x;;
    
    vec4 colorG = texture(iChannel0, vec2(uv_x, uv.y));
    vec4 colorRB = texture(iChannel0, vec2(uv_x + rgbSplit_uv_x, uv.y));


    // Output to screen
    fragColor = vec4(colorRB.r, colorG.g, colorRB.b, colorRB.a + colorG.a);
}