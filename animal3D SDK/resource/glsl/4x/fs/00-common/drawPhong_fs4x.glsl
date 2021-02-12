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
	
	drawPhong_fs4x.glsl
	Output Phong shading.
*/

/*
	Project 1 Edits
	By Brandon L'Abbe & Olli Machina
	
	drawPhong_fs4x.glsl
	Output Phong shading.
*/

#version 450

// ****DONE: 
//	-> start with list from "drawLambert_fs4x"
//		(hint: can put common stuff in "utilCommon_fs4x" to avoid redundancy)
//	-> calculate view vector, reflection vector and Phong coefficient
//	-> calculate Phong shading model for multiple lights

layout (location = 0) out vec4 rtFragColor;
in vec2 vTexcoord;

in vec4 vPosition;
in vec4 vNormal;

uniform sampler2D uTex_dm;
uniform sampler2D uTex_sm;
uniform vec4 uColor;

uniform vec4 uLightPos; // world/camera

vec4 blendVectors(vec4 a, vec4 b);
vec3 blendVectors(vec3 a, vec3 b);

void main()
{
	
	//diffuse coeff = dot(unit surface normal,
	//						unit light vector)
	vec4 N = normalize(vNormal);
	vec4 L = normalize(uLightPos - vPosition);
	float kd = dot(N,L);

	vec4 tex = texture(uTex_dm, vTexcoord);

	//DEBUGGING
	//rtFragColor = vec4(kd, kd, kd, 1.0);

	vec4 spec = texture(uTex_sm, vTexcoord);

	vec4 colorTexture = blendVectors(tex, uColor);

	vec4 light = vec4(kd, kd, kd, 1.0);
	vec4 lightColorTexture = blendVectors(colorTexture, light);

	vec4 specLightColorTexture = blendVectors(lightColorTexture, spec);

	rtFragColor = specLightColorTexture;
}
