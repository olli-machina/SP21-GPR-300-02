#version 450

layout (location = 0) out vec4 rtFragColor;

void main()
{
	// DUMMY OUTPUT: all fragments are OPAQUE PURPLE
	rtFragColor = vec4(1.0, 0.0, 1.0, 1.0);
}
