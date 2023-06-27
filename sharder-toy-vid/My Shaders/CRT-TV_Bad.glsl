// Source: https://www.shadertoy.com/view/WtVXRw

vec2 freak(vec2 uv) {
    float f = sin(3. * iTime + uv.y * 9.0122);
    f *= sin(uv.y * 11.96124) * 1.122;
    f *= sin(uv.y * 17.514) * 1.113;
    f *= sin(uv.y * 23.7345) * 1.76252;
    f *= .1 + sin(f + iTime * 122.) * .04123;
    f *= 0.084;
    return vec2(uv.x + f, uv.y);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord / iResolution.xy;
    uv += .1 * length(uv - .5);
    uv = freak(uv);
    vec3 c = texture(iChannel0, uv).rgb;
    c = (.8 + .2 * abs(sin(uv.y * 256.))) * vec3(c.g * 0.9, c.g * 1.1, pow(abs(sin(-4. * iTime + uv.y * 13.)), 6.) * c.g);
    c *= pow(length(c), 3.);
    fragColor = vec4(c, 1.);
}