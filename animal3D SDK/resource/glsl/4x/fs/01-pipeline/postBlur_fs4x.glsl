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

in vec2 vTexcoord;

uniform vec2 uAxis;

layout (location = 0) out vec4 rtFragColor;

void main()
{
	// DUMMY OUTPUT: all fragments are OPAQUE AQUA
	rtFragColor = vec4(0.0, 1.0, 0.5, 1.0);

	//blurring along an axis:
	// -> sample neighboring pixels, output weighted average
	// -----> coordinate offset by some amount (add/sub displacement vector)
	// ---------> example: horizontal, dv = vec2(1.0 / resolution (width), 0.0)
	// ---------> example: vertical, dv = vec2(0.0, 1.0 / resoluction (height))
	// 1/uv = resolution
}
