#version 450 core

in vec2 fragCoord;
in float uvScale;
in vec2 uvPosition;
in vec4 sTypes;
in float sDeleted;
in float sResolution;

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

float random1 (float uv) {
    return fract(sin(dot(uv,
                         12.9898))*
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
	dens *= 0.7*spires;
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

vec3 getColor(float star, float m_dist){
    vec3 color = vec3(0.);
    if (star >= 0. && star <= 0.25)
        color = vec3(2.0, 1.0, 0.5) * sTypes.x;
    if (star > 0.25 && star <= 0.5)
        color = vec3(2.0, 2.0, 0.5) * sTypes.y;
    if (star > 0.5 && star <= 0.75)
        color = vec3(0.25, 0.25, 2.0) * sTypes.z;
    if (star > 0.75 && star <= 1.0)
        color = vec3(1.0, 1.0, 1.0) * sTypes.w;   
    return color * m_dist * (11.-uvScale);
}




vec3 stars(vec2 uv, float coef) {
    vec3 sky = vec3(0.);  
    
    uv *= coef;
    
    vec2 i_st = floor(uv);
    vec2 f_st = fract(uv);  

    //if ( mod(i_st.x + i_st.y, sDeleted) == 0 && sDeleted != 0)
    //    return vec3(0.);
    float starNoise = fract(sin(dot(i_st, vec2(12.9898, 78.233))) * 43758.5453);
    if (starNoise < sDeleted)
        return vec3(0.0);

    float m_dist = 1.;
    vec2 m_point = vec2(0.);

    for (int y= -1; y <= 1; y++) {
        for (int x= -1; x <= 1; x++) {
            
            vec2 neighbor = vec2(float(x) ,float(y));  
            
            vec2 point = random2(i_st + neighbor);         
            vec2 diff = neighbor + point - f_st;     
            //m_point = diff;      
            float dist = 0.;
            if (coef < 5.)
                dist = length(diff) - bigStarFBM(diff, point) * 0.25 + 0.075;
            else
                dist = length(diff);

            if (dist < m_dist){
                m_dist = dist;
                m_point = point;    
            }        
        }
    }
    float fbmCoef = 0.0;    
    m_dist = littleStar(m_dist, fbmCoef);       
    sky += m_dist; 
    sky *= getColor(m_point.x * m_point.y, m_dist);   
    return sky;
}


void main(){   
    vec2 uv = fragCoord.xy;
    uv += uvPosition;
    vec3 col = vec3(1., 0., 0.);
    float uvScaleCoef = uvScale - 0.5;
    vec3 galaxyTemp = galaxy(uv * 1./uvScaleCoef) * 1./((uvScale * uvScale) - 0.75); //первая половина - зум, вторая - фейд
    vec3 starSky = stars(uv, sResolution * 0.1/(uvScale));
   
    if (uvScale > 5.)
        col = starSky;
    else
        col = galaxyTemp * starSky + galaxyTemp / 10.;
    fragColor = vec4(col,1.0);
}