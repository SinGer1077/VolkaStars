#version 460 core

layout(location = 0) in vec2 pos;
layout(location = 1) in vec3 uvData;
layout(location = 2) in vec4 starsTypes;

out vec2 fragCoord;
out float uvScale;
out vec2 uvPosition;
out vec4 sTypes;


void main(){
    gl_Position = vec4(pos, 1.0, 1.0);
    fragCoord = gl_Position.xy;
    uvScale = uvData.z;
    uvPosition = uvData.xy;
    sTypes = starsTypes;
}