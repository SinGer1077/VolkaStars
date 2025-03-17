#version 450 core

in vec2 fragCoord;
in float uvScale;
in vec2 uvPosition;

out vec4 fragColor;

uniform vec2 u_resolution;
uniform float u_time;

vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
                         vec2(12.9898,79.321)))*
        51758.54);
}

float noise (vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

float fbm (vec2 uv) {
    int octaves = 2;
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100.0);
    mat2 rot = mat2(cos(0.5), sin(0.5),
                    -sin(0.5), cos(0.5));
    for (int i = 0; i < octaves; i++) {
        v += a * noise(uv);
        uv = rot * uv * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}

vec3 galaxy(vec2 uv) {
    float rho = length(uv); 
	float ang = atan(uv.y,uv.x);
	float shear = 2.*log(rho); 
    float c = cos(shear), s=sin(shear);
	mat2 R = mat2(c,-s,s,c);
	
	float r; 
	r = rho/1.0; 
    float dens = exp(-r*r);
	r = rho/0.25; 	  
    float bulb = exp(-r*r);
	float phase = 5.*(ang-shear);	
	
	float spires = 1.+5.0*0.1*sin(phase);	
	dens *= .7*spires;
    return vec3(dens);
}

float bigStarFBM(vec2 uv, vec2 point){
    vec2 q = vec2(0.);
    q.x = fbm( uv + 0.1 * u_time) + point.x;
    q.y = fbm( uv + vec2(1.0)) + point.y;
    vec2 r = vec2(0.);
    r.x = fbm( uv + 1.0*q + vec2(1.7,9.2)+ 0.1 * u_time );
    r.y = fbm( uv + 1.0*q + vec2(8.3,2.8)+ 0.126 * u_time);
    float f = fbm(uv+r);      
    return f;
}

float littleStar(float m_dist, float fbmCoef) {
    m_dist += fbmCoef * 0.5;
    m_dist = 0.01/ m_dist;
    m_dist = abs(m_dist); 
    return m_dist;
}

vec3 stars(vec2 uv, float coef) {
    vec3 sky = vec3(0.);  
    
    uv *= coef;
    
    vec2 i_st = floor(uv);
    vec2 f_st = fract(uv);    
   
    float m_dist = 1.;

    for (int y= -1; y <= 1; y++) {
        for (int x= -1; x <= 1; x++) {
            
            vec2 neighbor = vec2(float(x) ,float(y));  
            
            vec2 point = random2(i_st + neighbor);           

            vec2 diff = neighbor + point - f_st;           
            float dist = 0.;
            if (coef < 5.)
                dist = length(diff) - bigStarFBM(diff, point) * 0.25 + 0.075;
            else
                dist = length(diff);

            m_dist = min(m_dist, dist);
        }
    }
    
    float fbmCoef = 0.0;    
    m_dist = littleStar(m_dist, fbmCoef);       
    sky += m_dist;
    return sky;
}


void main(){
    //vec2 uv = (fragCoord.xy * 2. - u_resolution.xy) / u_resolution.y;    
    vec2 uv = fragCoord.xy;
    vec3 col = vec3(1., 0., 0.);
    
    //uv *= sin(iTime);
    vec3 galaxyTemp = galaxy(uv * 0.1/uvScale) * 1./(uvScale * 3.0);
    vec3 starSky = stars(uv, 100 * (1./(uvScale * 5.)));
    galaxyTemp *= (starSky + 1.5);
    //col = mix(galaxyTemp, sta), uvScale/0.1 - 1);
    
    //col *= stars(uv, uvScale * 10.);
    //vec3 brightGalaxy = mix(galaxyTemp, stars(uv, 50.), 0.5);
    //col = mix(brightGalaxy, stars(uv, 11.-uvScale), uvScale / 10.);
    col = galaxyTemp;
    col *= vec3(2.0, 1.0, 0.5); 
    fragColor = vec4(col,1.0);
}