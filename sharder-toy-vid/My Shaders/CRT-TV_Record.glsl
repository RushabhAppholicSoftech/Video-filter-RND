// Source: https://www.shadertoy.com/view/tsGfRz
//scan lines tv effect Photo of screen

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Convert pixel pos 0-1280+ to (0-1)
    vec2 uv = fragCoord/iResolution.xy;

	// Read the red pixels a little bit too far to the right to create distortion
    float colR = texture(iChannel0,vec2(uv.x+0.004,uv.y)).r;
    float colG = texture(iChannel0,uv).g;
    float colB = texture(iChannel0,uv).b;
    vec3 col = vec3(colR,colG,colB); // Rebuild the colour with the effect
    
    // Draw scan lines (made some better ones)
    //float spacing = 3.0; // Space between each line
    //float height = 1.0; // Height of each scan line
    //col *= 1.0-(max(spacing,mod(fragCoord.y,(spacing+height)))-spacing);
    

    // Bloom
    float samples = 3.0; // (doubled)
    for (float i = -samples; i < samples; i++) {
        for (float j = -samples; j < samples; j++) {
            col += texture(iChannel0,vec2(uv.x+i*0.01,uv.y+j*0.01)).rgb*0.008;
        }
    }
    
    // Blur
    float amount = uv.x*2.0; // (doubled)
    for (float i = -amount; i < amount; i++) {
        for (float j = -amount; j < amount; j++) {
            col += texture(iChannel0,vec2(uv.x+i*0.01,uv.y+j*0.01)).rgb*0.008;
        }
    }
    
    // Overexpose the image
    col += max(col-0.7,0.0)*1.4;
    
    // Vignette (kinda)
    float offset = 0.3; // Sinewave offset (adjust x/y pos of center)
    float intensity = 0.4; // Size of gradient (smaller = more spread)
    col *= vec3(sin((uv.x*intensity+offset)*3.14)*sin(uv.y*intensity+offset*3.14));
    
    // Those weird lines
    col -= vec3(sin(((uv.x*3.0+12.0+sin(iTime*0.09)+sin(iTime*0.03)*3.0)*uv.y*30.0)*3.14))*0.5;
    
    // Output to screen
    fragColor = vec4(col,1.0);
}