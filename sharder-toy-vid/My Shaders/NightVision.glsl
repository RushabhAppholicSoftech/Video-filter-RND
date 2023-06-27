// Source: https://www.shadertoy.com/view/XlsGzs

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec4 color;
    
	vec2 uv = fragCoord.xy / iResolution.xy;
    
    float distanceFromCenter = length( uv - vec2(0.5,0.5) );
    
    float vignetteAmount;
    
    float lum;
    
    vignetteAmount = 1.0 - distanceFromCenter;
    vignetteAmount = smoothstep(0.1, 1.0, vignetteAmount);
    
    color = texture( iChannel0, uv);
    
    // luminance hack, responses to red channel most
    lum = dot(color.rgb, vec3( 0.85, 0.30, 0.10) );
    
    color.rgb = vec3(0.0, lum, 0.0);
    
    // scanlines
    color += 0.1*sin(uv.y*iResolution.y*2.0);
    
    // screen flicker
    color += 0.005 * sin(iTime*16.0);
    
    // vignetting
    color *=  vignetteAmount*1.0;
    
	fragColor = color;
}