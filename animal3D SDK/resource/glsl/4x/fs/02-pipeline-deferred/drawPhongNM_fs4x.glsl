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
	
	drawPhongNM_fs4x.glsl
	Output Phong shading with normal mapping.
*/

/*
	Project 3 edits
	By Brandon L'Abbe and Olli Machina
	
	drawPhongNM_fs4x.glsl
	Output Phong shading with normal mapping.
*/

#version 450

#define MAX_LIGHTS 1024

// ****TO-DO:
//	-> *declare view-space varyings from vertex shader
//	-> *declare point light data structure and uniform block
//	-> *declare uniform samplers (diffuse, specular & normal maps)
//	-> *calculate final normal by transforming normal map sample
//	-> calculate common view vector
//	-> *declare lighting sums (diffuse, specular), initialized to zero
//	-> *implement loop in main to calculate and accumulate light
//	-> *calculate and output final Phong sum

uniform int uCount;

layout (location = 0) out vec4 rtFragColor;

uniform sampler2D uImage00; // diffuse atlas
uniform sampler2D uImage01; // specular atlas
uniform sampler2D uImage02; //normal map

// location of viewer in its own space is the origin
const vec4 kEyePos_view = vec4(0.0, 0.0, 0.0, 1.0);
void Phong(out float kd, out float ks, out vec4 vr, in vec4 n, in vec4 vl, in vec4 ve);


// declaration of Phong shading model
//	(implementation in "utilCommon_fs4x.glsl")
//		param diffuseColor: resulting diffuse color (function writes value)
//		param specularColor: resulting specular color (function writes value)
//		param eyeVec: unit direction from surface to eye
//		param fragPos: location of fragment in target space
//		param fragNrm: unit normal vector at fragment in target space
//		param fragColor: solid surface color at fragment or of object
//		param lightPos: location of light in target space
//		param lightRadiusInfo: description of light size from struct
//		param lightColor: solid light color
void calcPhongPoint(
	out vec4 diffuseColor, out vec4 specularColor,
	in vec4 eyeVec, in vec4 fragPos, in vec4 fragNrm, in vec4 fragColor,
	in vec4 lightPos, in vec4 lightRadiusInfo, in vec4 lightColor
);

in vec4 vPosition;
in vec4 vNormal;
in vec4 vTexcoord;
in vec4 vTangent;
in vec4 vBitangent;

struct sLightDataStack
{
	vec4  position;				//position in rendering target space
	vec4  worldPos;				//original position in world space
	vec4  color;				//RGB color with padding
	float radius;				//radius (distance of effect from center)
	float radiusSq;				//radius squared (if needed)
	float radiusInv;			//radius inverse (attenuation factor)
	float radiusInvSq;			//radius inverse squared (attenuation factor)
};

uniform ubLight
{
	sLightDataStack uLightDataStack[MAX_LIGHTS];
};

void main()
{
	// DUMMY OUTPUT: all fragments are OPAQUE MAGENTA
	//rtFragColor = vec4(1.0, 0.0, 1.0, 1.0);
	vec4 newNormal = vNormal;
	newNormal[3] = 1.0;

	vec4 diffuseTotal = vec4(0);
	vec4 specularTotal = vec4(0);

	vec4 normal = texture(uImage02, vTexcoord.xy) + normalize(vNormal);
	normal = normalize(normal);
	normal[3] = 1.0;

	for(int i = 0; i < uCount; i++)
	{
		vec4 diffuse, specular, radiusVec = vec4(uLightDataStack[i].radius, uLightDataStack[i].radiusSq, uLightDataStack[i].radiusInv, uLightDataStack[i].radiusInvSq);
		calcPhongPoint(diffuse, specular, kEyePos_view, vPosition, normal, 
						texture(uImage00, vTexcoord.xy), uLightDataStack[i].position, radiusVec, uLightDataStack[i].color);
		diffuseTotal += diffuse;
		specularTotal += specular;
	}

	//tFragColor = (diffuseTotal + specularTotal) + texture(uImage00, vTexcoord.xy); //specular makes trippy lava
	rtFragColor = (diffuseTotal * texture(uImage00, vTexcoord.xy)) + (specularTotal * texture(uImage01, vTexcoord.xy));

	//rtFragColor = normal;
}

