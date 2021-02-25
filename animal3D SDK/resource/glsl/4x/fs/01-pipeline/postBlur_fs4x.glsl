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
	
	postBlur_fs4x.glsl
	Gaussian blur.
*/

#version 450

// ****TO-DO:
//	-> declare texture coordinate varying and input texture
//	-> declare sampling axis uniform (see render code for clue)
//	-> declare Gaussian blur function that samples along one axis
//		(hint: the efficiency of this is described in class)

in vec4 vTexcoord_atlas;

uniform vec2 uAxis;

uniform sampler2D inputTex;

layout (location = 0) out vec4 rtFragColor;

void main()
{
	// DUMMY OUTPUT: all fragments are OPAQUE AQUA
	

	//blurring along an axis:
	// -> sample neighboring pixels, output weighted average
	// -----> coordinate offset by some amount (add/sub displacement vector)
	// ---------> example: horizontal, dv = vec2(1.0 / resolution (width), 0.0)
	// ---------> example: vertical, dv = vec2(0.0, 1.0 / resoluction (height))
	// 1/uv = resolution

	vec2 vTexcoord = vTexcoord_atlas.xy;

	float[5] weight = float[](1.0/16.0, 4.0/16.0, 6.0/16.0, 4.0/16.0, 1.0/16.0);

	vec2 textureOff = 1.0 / textureSize( inputTex, 0);
	vec3 finalImage = texture(inputTex, vTexcoord).rgb * weight[2];

	if(uAxis.x == 1.0)
	{

		for(int i = 1; i <= 2; i++)
		{

			finalImage += texture(inputTex, vTexcoord + vec2(textureOff.x * i, 0.0)).rgb * weight[2+i];
			finalImage += texture(inputTex, vTexcoord - vec2(textureOff.x * i, 0.0)).rgb * weight[2-i];

		}

	}
	else if(uAxis.y == 1.0)
	{

		for(int i = 1; i <= 2; i++)
		{

			finalImage += texture(inputTex, vTexcoord + vec2(0.0, textureOff.y * i)).rgb * weight[2+i];
			finalImage += texture(inputTex, vTexcoord - vec2(0.0, textureOff.y * i)).rgb * weight[2-i];

		}

	}

	rtFragColor = vec4(finalImage, 1.0);
}
