float rand(vec2 co){
    return fract(sin(iTime * dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float contrast( float Value, float Contrast, float Brightness) {
    return (Value - 0.5) * Contrast + Brightness;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
    
    float vignette = distance( vec4(uv.x, uv.y, 0,1) , vec4(0.5,0.5,0,1));
    vignette = 1. - vignette + sin(iTime * 2.) / 16.;
    
    float noise = rand(uv);
    float tex = texture(iChannel0, vec2(uv.x, uv.y)).r;
    
    vec4 color = vec4(0.4,0.8,0.6,1);
    
    float bars = 1.;
    if((1. - sin(uv.y * 10000. + iTime)) < 0.1) {
    	bars = 0.9;   
    }
    
    float multiplier = vignette * noise * tex * bars;
    multiplier = contrast(multiplier,1.5,0.6);
    
	fragColor = color * multiplier * 2.;
}