// Source: https://www.shadertoy.com/view/4sVcWK

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = vec2(fragCoord.x + tan(fragCoord.y * iTime * 1000.0 * rand(vec2(iTime))) * 1.0, fragCoord.y) / iResolution.xy;
    
    vec4 t = texture(iChannel0, uv);
    
    vec4 tt = t;
    
    tt.r *= texture(iChannel0, uv - 0.01 * tan(fragCoord.y * 500.0 * rand(vec2(iTime)))).r * t.r * 1.5;
    tt.b *= texture(iChannel0, uv + 0.01 * tan(fragCoord.y * 500.0 * rand(vec2(iTime)))).b * t.b * 1.5;
    tt.g /= 2.0;
    
    fragColor = tt * 2.0;
}