#version 460 core

in vec2 fragCoord;
in float uvScale;
in vec2 uvPosition;
in vec4 sTypes;
in float sDeleted;
in float sResolution;
in float seed;

in float u_time;

out vec4 fragColor;

vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p,vec2(seed,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
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

float littleStar(float m_dist, float fbmCoef, float density) {
    m_dist += fbmCoef * 0.5;
    m_dist = (0.01 * density)/ m_dist;
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
    return color * m_dist * (31.-uvScale);
}

vec3 stars(vec2 uv, float coef) {
    vec3 sky = vec3(0.);  
    
    uv *= coef;
    
    vec2 i_st = floor(uv);
    vec2 f_st = fract(uv);  

    float m_dist = 1.;
    vec2 m_point = vec2(0.);
    vec2 m_diff = vec2(0.);

    for (int y= -1; y <= 1; y++) {
        for (int x= -1; x <= 1; x++) {
            
            vec2 neighbor = vec2(float(x) ,float(y));  
            
            vec2 point = random2(i_st + neighbor);         
            vec2 diff = neighbor + point - f_st;          
            float dist = 0.;
            dist = length(diff);

            if (dist < m_dist){
                m_dist = dist;
                m_point = point;    
                m_diff = diff;                
            }        
        }
    }
    float fbmCoef = 0.0;      
    float density = 1.0;
    if (uvScale > 25.){
        density = clamp(sin(u_time * 10. * m_point.y) + cos(u_time * 10.) + m_point.x, 1., 2.0);
    }
    m_dist = littleStar(m_dist, fbmCoef, density);       
    sky += m_dist;   

    float starNoise = fract(sin(dot(i_st, vec2(12.9898, 78.233))) * 43758.5453);
    if (starNoise < sDeleted)
        return vec3(0.);   
    else
        return sky *= getColor(m_point.x * m_point.y, m_dist);   
}


void main(){   
    vec2 uv = fragCoord.xy;
    uv += uvPosition;
    vec3 col = vec3(1., 0., 0.);
    float uvScaleCoef = uvScale - 0.5;
    vec3 galaxyTemp = galaxy(uv * 1./uvScaleCoef) * 1./((uvScale * uvScale) - 0.75);
    vec3 starSky = vec3(0.);
    if (uvScale < 27.)
        starSky = stars(uv, sResolution * 0.1/(uvScale));   
    else
        starSky = stars(uv, 31. - uvScale);   

    if (uvScale > 5.)
        col = starSky;
    else
        col = galaxyTemp * starSky + galaxyTemp / 10.;
    fragColor = vec4(col,1.0);
}