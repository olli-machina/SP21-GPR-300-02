/*
	Copyright 2011-2021 Daniel S. Buckstein

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

/*
	animal3D SDK: Minimal 3D Animation Framework
	By Daniel S. Buckstein
	
	drawPhong_shadow_fs4x.glsl
	Output Phong shading with shadow mapping.
*/

#version 450

// ****TO-DO:
// 1) Phong shading
//	*-> identical to outcome of last project
// 2) shadow mapping
//	*-> declare shadow map texture
//	*-> declare shadow coordinate varying
//	-> perform manual "perspective divide" on shadow coordinate
//	-> perform "shadow test" (explained in class)

layout (location = 0) out vec4 rtFragColor;

in vec2 vTexcoord;
in vec4 vPosition;
in vec4 vNormal;
in vec4 vShadow;

uniform sampler2D uTex_dm;
uniform sampler2D uTex_sm;
uniform sampler2D uTex_shadow;

uniform vec4 uLightPos; // world/camera

vec4 blendVectors(vec4 a, vec4 b);
vec3 blendVectors(vec3 a, vec3 b);

uniform int uCount;

void main()
{
	// DUMMY OUTPUT: all fragments are OPAQUE MAGENTA
	//rtFragColor = vec4(1.0, 0.0, 1.0, 1.0);

	//diffuse coeff = dot(unit surface normal,
	//						unit light vector)
	vec4 N = normalize(vNormal);
	vec4 L = normalize(uLightPos - vPosition);
	float kd = dot(N,L);

	//Perspective divide
	vec4 projScreen = vShadow / vShadow.w;

	//Test to see if it's in shadow
	float shadowSample = texture2D(uTex_shadow, projScreen.xy).r;
	bool fragIsShadowed = (projScreen.z > (shadowSample + 0.0025));

	if(fragIsShadowed)
		kd *= 0.2;

	vec4 tex = texture(uTex_dm, vTexcoord);

	vec4 spec = texture(uTex_sm, vTexcoord);

	vec4 light = vec4(kd, kd, kd, 1.0);
	vec4 lightTexture = blendVectors(tex, light);

	vec4 specLightTexture = blendVectors(lightTexture, spec);


	

	rtFragColor = specLightTexture;
	
	
	

		
}
