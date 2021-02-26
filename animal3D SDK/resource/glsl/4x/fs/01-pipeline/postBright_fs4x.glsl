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
	
	postBright_fs4x.glsl
	Bright pass filter.
*/

/*
	animal3D SDK: Projects 2 Edits
	By Brandon L'Abbe & Olli Machina
	
	postBright_fs4x.glsl
	Bright pass filter.
*/

#version 450

// ****DONE:
//	*-> declare texture coordinate varying and input texture
//	*-> implement relative luminance function
//	-> implement simple "tone mapping" such that the brightest areas of the 
//		image are emphasized, and the darker areas get darker

layout (location = 0) out vec4 rtFragColor;



uniform sampler2D inputTex;


void main()
{
	// Tried approach in Blue Book, just made everything whiter for some reason
	
	int i;
	float lum[25];
	vec2 tex_scale = vec2(1.0) / textureSize(inputTex, 0);

	for(i = 0; i < 25; i++)
	{

		vec2 tc = (2.0 * gl_FragCoord.xy + 3.5 * vec2(i % 5 - 2, i / 5 - 2));
		vec3 col = texture(inputTex, tc * tex_scale).rgb;
		lum[i] = dot(col, vec3(0.3, 0.59, 0.11));

	}

	vec3 vColor = texelFetch(inputTex, 2 * ivec2(gl_FragCoord.xy), 0).rgb;

	float kernelLuminance = (
		(1.0 * (lum[0] + lum[4] + lum[20] + lum[24])) +
		(4.0 * (lum[1] + lum[3] + lum[5] + lum[9] +
				lum[15] + lum[19] + lum[21] + lum[23])) +
		(7.0 * (lum[2] + lum[10] + lum[14] + lum[22])) +
		(16.0 * (lum[6] + lum[8] + lum[16] + lum[18])) +
		(26.0 * (lum[7] + lum[11] + lum[13] + lum[17])) +
		(41.0 * lum[12])
		) / 273.0;

	float exposure = sqrt(8.0 / (kernelLuminance + 0.25));

	rtFragColor.rgb = 1.0 - exp2(-vColor * exposure);
	rtFragColor.a = 1.0f;
	


}
