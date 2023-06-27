// Source: https://www.shadertoy.com/view/wtSBW1

#define SEED 123400.
#define HNOISE .0045
#define BRIGHT 1.2
#define PIXHEIGHT 4.

precision highp float;

float rand(float s){
	return fract(sin(s)*SEED);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord/iResolution.xy);
    
    vec2 vsmpl=vec2(uv.x+rand(iTime+uv.y)*HNOISE,uv.y);
    vec4 video=texture(iChannel0,vsmpl);
    
    vec3 mask = vec3(int(clamp(mod(fragCoord.y,PIXHEIGHT),0.,1.)));
    
    vec3 rgb=vec3(.1);
    int pp=int(mod(fragCoord.x,3.)); 
    rgb[pp]=1.;
    
    fragColor = vec4(video.xyz*rgb*mask*BRIGHT,1);
}