// Source: https://www.shadertoy.com/view/3ddczH

#define Amplitude .05
#define Frequency 7.

bool uvRect(vec2 uv, vec4 bound) {
    return bool(min(step(bound.x, uv.x), 
                min(step(bound.y, uv.y), 
                min(step(uv.x, bound.z), step(uv.y, bound.w)))));
}

float hash11(float x) {
    return fract(129.*sin(339.1*x));
}

float noise(float x) {
    float i = floor(x);
    float f = fract(x);
    return mix(hash11(i), hash11(i+1.), f); 
}

float fbm(float x) {
    float t = 0.;
    float f = 1.;
    float a = 1.;
    for (int i = 0; i < 8+1; ++i) {
        t += a*noise(x*f);
        a /= 2.; f*=2.;
    }
    return t;
}
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;

    vec3 col = vec3(0.);
    vec4 bound = vec4(0.);
    bound = vec4(0., 0., .5, .5);
    if (uvRect(uv, bound)) {
        vec2 p = (uv - bound.xy) * 2.;
        col = vec3(texture(iChannel0, p).r, 0., 0.);
    }
    bound = vec4(0., .5, .5, 1.);   
    if (uvRect(uv, bound)) {
        vec2 p = (uv - bound.xy) * 2.;
        col = vec3(0., texture(iChannel0, p).g, 0.);
    }
    bound = vec4(.5, .5, 1., 1.);
    if (uvRect(uv, bound)) {
        vec2 p = (uv - bound.xy) * 2.;
        col = vec3(0., 0., texture(iChannel0, p).b);
    }
    bound = vec4(.5, 0., 1., .5);      
    if (uvRect(uv, bound)) {
        vec2 p = (uv - bound.xy) * 2.;
        float var = Frequency * iTime;
        float on = step(.8, noise(var));
        p.x += hash11(iTime+p.y)*.09*on;
        col = texture(iChannel0, p).rgb;
        vec2 offset = vec2(2.*noise(var+43.)-1., 2.*noise(var-77.)-1.)*Amplitude*on;
        col.r = texture(iChannel0, p+offset).r;
        col.g = texture(iChannel0, p-offset).g;
    }
    

    // Output to screen
    fragColor = vec4(col,1.0);
}