#version 460 core

layout(location = 0) in vec2 pos;
layout(location = 1) in vec3 uvData;
layout(location = 2) in vec4 starsTypes;
layout(location = 3) in float starsDeletedCount;
layout(location = 4) in float starsResolution;
layout(location = 5) in float timer;
layout(location = 6) in float newSeed;

out vec2 fragCoord;
out float uvScale;
out vec2 uvPosition;
out vec4 sTypes;
out float sDeleted;
out float sResolution;
out float u_time;
out float seed;

void main(){
    gl_Position = vec4(pos, 1.0, 1.0);
    fragCoord = gl_Position.xy;
    uvScale = uvData.z;
    uvPosition = uvData.xy;
    sTypes = starsTypes;
    sDeleted = starsDeletedCount;
    sResolution = starsResolution;
    u_time = timer;
    seed = newSeed;
}