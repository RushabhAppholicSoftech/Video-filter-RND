// The MIT License
// Copyright © 2013 Jianing Zhang
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#define _Amount 0.13
#define _Frequency 1.5
#define _JitterIntensity 0.45
    
float randomNoise(float x, float y)
{
	return fract(sin(dot(vec2(x, y), vec2(12.9898, 78.233))) * 43758.5453);
}
    
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

	float strength = 0.5 + 0.5 * cos(iTime * _Frequency);	
	float jitter = randomNoise(uv.y, iTime) * 2.0 - 1.0;
    float threshold = clamp(1.0f - _JitterIntensity * 1.2f, 0.0, 1.0);
	jitter *= step(threshold, abs(jitter)) * _Amount * strength;	

    // Output to screen
    fragColor = texture(iChannel0, fract(uv + vec2(jitter, 0)));	
}