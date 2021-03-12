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
	
	postDeferredShading_fs4x.glsl
	Calculate full-screen deferred Phong shading.
*/

/*
	Project 3 edits
	By Brandon L'Abbe and Olli Machina
	
	postDeferredShading_fs4x.glsl
	Calculate full-screen deferred Phong shading.
*/

#version 450

#define MAX_LIGHTS 1024

// ****TO-DO:
//	-> *this one is pretty similar to the forward shading algorithm (Phong NM) 
//		except it happens on a plane, given images of the scene's geometric 
//		data (the "g-buffers"); all of the information about the scene comes 
//		from screen-sized textures, so use the texcoord varying as the UV
//	-> *declare point light data structure and uniform block
//	-> *declare pertinent samplers with geometry data ("g-buffers")
//	-> *?use screen-space coord (the inbound UV) to sample g-buffers
//	-> *calculate view-space fragment position using depth sample
//		(hint: modify screen-space coord, use appropriate matrix to get it 
//		back to view-space, perspective divide)
//	-> *calculate and accumulate final diffuse and specular shading

in vec4 vTexcoord_atlas; //also maps to screen Position 

uniform int uCount;

void calcPhongPoint(out vec4 diffuseColor, out vec4 specularColor, in vec4 eyeVec,
	in vec4 fragPos, in vec4 fragNrm, in vec4 fragColor,
	in vec4 lightPos, in vec4 lightRadiusInfo, in vec4 lightColor);

uniform sampler2D uImage00; // diffuse atlas
uniform sampler2D uImage01; // specular atlas


uniform sampler2D uImage04; //texcoord g-buffer
uniform sampler2D uImage05; //normal g-buffer
//uniform sampler2D uImage06; //position g-buffer
uniform sampler2D uImage07; //depth g-buffer

uniform mat4 uPB_inv; //inverse Bias Projection
const vec4 kEyePos_view = vec4(0.0, 0.0, 0.0, 1.0);

//testing
//uniform sampler2D uImage02, uImage03; // nrm, ht

layout (location = 0) out vec4 rtFragColor;

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

uniform ubLight //check this later
{
	sLightDataStack uLightDataStack[MAX_LIGHTS];
};

void main()
{
	// DUMMY OUTPUT: all fragments are OPAQUE ORANGE
	//rtFragColor = vec4(1.0, 0.5, 0.0, 1.0);

	vec4 sceneTexcoord = texture(uImage04, vTexcoord_atlas.xy);

	vec4 diffuseSample = texture(uImage00, sceneTexcoord.xy);
	vec4 specularSample = texture(uImage01, vTexcoord_atlas.xy);

	vec4 position_screen = vTexcoord_atlas;
	position_screen.z = texture(uImage07, vTexcoord_atlas.xy).x;

	vec4 position_view = position_screen * uPB_inv;
	position_view /= position_view.w;

	vec4 normal = texture(uImage05, vTexcoord_atlas.xy);
	normal -= 0.5;
	normal *= 2.0; //Undoes normal compression

	// Phong shading:
	// abient
	// + diffuse color * diffuse light
	// + specular color * specular light
	// have:
	// -> diffuse/specular colors 
	// have not:
	// -> light stuff
	//      -> light data -> light data struct -> uniform buffer
	//		-> normals, position -> g-buffers
	// -> texture coordinates -> g-buffers

	// DEBUGGING
//	rtFragColor = diffuseSample;
//	rtFragColor = normal;//position_screen;

	vec4 diffuseTotal, specularTotal;
		for(int i = 0; i < uCount; i++)
	{
		vec4 diffuse, specular, radiusVec = vec4(uLightDataStack[i].radius, uLightDataStack[i].radiusSq, uLightDataStack[i].radiusInv, uLightDataStack[i].radiusInvSq);
		calcPhongPoint(diffuse, specular, kEyePos_view, position_view, normal, 
						diffuseSample, uLightDataStack[i].position, radiusVec, uLightDataStack[i].color);
		diffuseTotal += diffuse;
		specularTotal += specular;
	}

	// final transparency
	//rtFragColor = diffuseTotal+specularTotal;
	rtFragColor = (diffuseTotal * diffuseSample) + (specularTotal * specularSample);
	rtFragColor.a = diffuseSample.a;

}
