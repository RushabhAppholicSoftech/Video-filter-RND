// Source: https://www.shadertoy.com/view/fd3XWj
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 suv = fragCoord/iResolution.xy;

    fragColor = vec4(1.5 * sin(suv.y * iResolution.y/3. + iTime * 20.));
    fragColor = 1.- floor(abs(fragColor));
    fragColor *= vec4(sin(suv.y), 0, cos( 1. - suv.y * 2.) , 1);
    fragColor *= texture(iChannel0, suv);
}