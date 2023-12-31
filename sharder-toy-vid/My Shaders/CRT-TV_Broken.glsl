// Source: https://www.shadertoy.com/view/wslcD8

// Created by Frank Force
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

const float scanlines = 0.3;
const float fuzz = .005;
const float fuzzDensity = 999.;
const float chromatic = .005;
const float staticNoise = .9;
const float ghost = 0.2;
const float verticalMovement = 2.;
const float verticalMovementPercent = .2;
const float vignette = 1.1;
const float pi = 3.14159265359;

// https://www.shadertoy.com/view/lsf3WH Noise by iq
float hash(vec2 p)
{
    p  = 50.0*fract( p*0.3183099 + vec2(0.71,0.113));
    return -1.0+2.0*fract( p.x*p.y*(p.x+p.y) );
}

float noise( in vec2 p )
{
    vec2 i = floor( p );
    vec2 f = fract( p );
	vec2 u = f*f*(3.0-2.0*f);
    return mix( mix( hash( i + vec2(0.0,0.0) ), 
                     hash( i + vec2(1.0,0.0) ), u.x),
                mix( hash( i + vec2(0.0,1.0) ), 
                     hash( i + vec2(1.0,1.0) ), u.x), u.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    
    // noise
    vec4 c = vec4(0);
    c += staticNoise * ((sin(iTime)+2.)*.3)*sin(.8-uv.y+sin(iTime*3.)*.1) *
        noise(vec2(uv.y*999. + iTime*999., (uv.x+999.)/(uv.y+.1)*19.));
    
    // fuzz on edges
    uv.x += fuzz*noise(vec2(uv.y*fuzzDensity, iTime*9.));
    
    // vertical movement
    uv.y += mix(0., sin(iTime*.2)*5.0,
    	step(noise(vec2(iTime*.5,0.))*.5+.5, verticalMovementPercent));
    uv.y = fract(uv.y);
    
    // ghosting
    uv.x += mix(0., sin(iTime/5.0)*0.5, 
    	step(hash(vec2(uv.x+sin(iTime), uv.y)), ghost - 1.));
    
    // chromatic aberration
    c += vec4
    (
        texture(iChannel0, uv + vec2(-chromatic, 0)).r,
        texture(iChannel0, uv + vec2( 0        , 0)).g,
        texture(iChannel0, uv + vec2( chromatic, 0)).b,
        1.
    );
    
    // scanlines
    uv = fragCoord/iResolution.xy;
    c *= 1. + scanlines*sin(uv.y*iResolution.y*pi/2.);
  
    // vignette
	float dx = vignette * abs(uv.x - .5);
	float dy = vignette * abs(uv.y - .5);
    c *= (1.0 - dx * dx - dy * dy);
    
    fragColor = c;
}