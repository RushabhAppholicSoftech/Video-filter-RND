// The MIT License
// Copyright © 2013 Jianing Zhang
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#define _TimeX 0.5
#define _Offset 5.0
#define _Fade 0.5
#define _BlockLayer1_U 2.0
#define _BlockLayer1_V 16.0
#define _BlockLayer1_Indensity 8.0
#define _RGBSplit_Indensity 2.0
    
float randomNoise(vec2 seed)
{
	return fract(sin(dot(seed * floor(iTime * 30.0), vec2(127.1, 311.7))) * 43758.5453123);
}
	
float randomNoise(float seed)
{
	return randomNoise(vec2(seed, 1.0));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
		
	vec2 blockLayer1 = floor(uv * vec2(_BlockLayer1_U, _BlockLayer1_V));
		
    float lineNoise = pow(randomNoise(blockLayer1), _BlockLayer1_Indensity) * _Offset - pow(randomNoise(5.1379), 7.1) * _RGBSplit_Indensity;
		
	vec4 colorR = texture(iChannel0, uv);
	vec4 colorG = texture(iChannel0, uv + vec2(lineNoise * 0.05 * randomNoise(5.0), 0));
	vec4 colorB = texture(iChannel0, uv - vec2(lineNoise * 0.05 * randomNoise(31.0), 0));
		
	vec4 result = vec4(vec3(colorR.r, colorG.g, colorB.b), colorR.a + colorG.a + colorB.a);
	result = mix(colorR, result, _Fade);

    // Output to screen
    fragColor = result;
}