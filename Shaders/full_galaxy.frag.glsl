#version 450 core

in vec2 fragCoord;
out vec4 fragColor;

uniform vec2 u_resolution;

vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

vec3 galaxy(vec2 uv){
    float rho = length(uv); 
	float ang = atan(uv.y,uv.x);
	float shear = 2.*log(rho); 
    float c = cos(shear), s=sin(shear);
	mat2 R = mat2(c,-s,s,c);
	
	float r; 
	r = rho/1.0; 
    float dens = exp(-r*r);
	r = rho/.25;	  
    float bulb = exp(-r*r);
	float phase = 5.*(ang-shear);	
	
	float spires = 1.+5.0*0.1*sin(phase);	
	dens *= .7*spires;
    return vec3(dens);
}

vec3 stars(vec2 uv)
{
    vec3 sky = vec3(0.);
    
    
    uv *= 1.5;
    
    vec2 i_st = floor(uv);
    vec2 f_st = fract(uv);    
   
    float m_dist = 1.;

    for (int y= -1; y <= 1; y++) {
        for (int x= -1; x <= 1; x++) {
            
            vec2 neighbor = vec2(float(x) ,float(y));  
            
            vec2 point = random2(i_st + neighbor);           

            vec2 diff = neighbor + point - f_st;           
    
            float dist = length(diff);
            m_dist = min(m_dist, dist);
        }
    }
    
    m_dist = 0.01 / m_dist;
    m_dist = abs(m_dist); 
    
    sky += m_dist;
    //sky += skyColor;
    return sky;
}


void main(){
    //vec2 uv = (fragCoord.xy * 2. - u_resolution.xy) / u_resolution.y;    
    vec2 uv = fragCoord.xy;
    vec3 col = vec3(1., 0., 0.);
    
    //uv *= sin(iTime);
    col = galaxy(uv);
    col *= stars(uv * 100.);
    fragColor = vec4(col,1.0);
}