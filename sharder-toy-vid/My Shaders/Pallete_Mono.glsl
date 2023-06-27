// Simply do a dithered quantization using a palette and an input brightness
// RGB one: https://www.shadertoy.com/view/fsBXWm

// #define NEAREST
#define BAYER
// #define BLUE

#define saturate(i) clamp(i,0.,1.)

#define PALETTE_COLORS 6

// picked the most sweet part from SWEETIE 16 - The palette by GrafxKid
// Ref: https://lospec.com/palette-list/sweetie-16
const vec3 palette[ PALETTE_COLORS ] = vec3[](
    vec3( 0x1a, 0x1c, 0x2c ) / 255.0, // 0
    vec3( 0x5d, 0x27, 0x5d ) / 255.0, // 1
    vec3( 0xb1, 0x3d, 0x53 ) / 255.0, // 2
    vec3( 0xef, 0x7d, 0x57 ) / 255.0, // 3
    vec3( 0xff, 0xcd, 0x75 ) / 255.0, // 4
    vec3( 0xf4, 0xf4, 0xf4 ) / 255.0 // 12
);

const vec3 LUMA = vec3( 0.2126, 0.7152, 0.0722 );

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 uv = fragCoord / iResolution.xy;
    
    vec4 tex = texture( iChannel0, uv );
    float luma = dot( tex.rgb, LUMA );

    vec3 col = vec3( 0.0 );

#ifdef NEAREST
    col = palette[ int( luma * float( PALETTE_COLORS - 1 ) + 0.5 ) ];
#endif

#ifdef BAYER
    float bayer = texture( iChannel1, fragCoord / 8.0 ).x;
    col = palette[ int( luma * float( PALETTE_COLORS - 1 ) + bayer ) ];
#endif

#ifdef BLUE
    float blue = texture( iChannel2, fragCoord / 1024.0 ).x;
    col = palette[ int( luma * float( PALETTE_COLORS - 1 ) + blue ) ];
#endif
    
    fragColor = vec4( col, 1.0 );
}
