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
	
	postBlend_fs4x.glsl
	Blending layers, composition.
*/

/*
	animal3D SDK: Project 2 Edits
	By Brandon L'Abbe & Olli Machina
	
	postBlend_fs4x.glsl
	Blending layers, composition.
*/

#version 450

// ****DONE:
//	-> declare texture coordinate varying and set of input textures
//	-> implement some sort of blending algorithm that highlights bright areas
//		(hint: research some Photoshop blend modes)

layout (location = 0) out vec4 rtFragColor;

in vec4 vTexcoord_atlas;

uniform sampler2D uImage00;
uniform sampler2D uImage01;
uniform sampler2D uImage02;
uniform sampler2D uImage03;

void main()
{

	
	vec4 tex4 = texture(uImage00, vTexcoord_atlas.xy);
	vec4 tex3 = texture(uImage01, vTexcoord_atlas.xy);
	vec4 tex2 = texture(uImage02, vTexcoord_atlas.xy);
	vec4 tex1 = texture(uImage03, vTexcoord_atlas.xy);

	rtFragColor = tex1 + tex2 + tex3 + tex4;
}
