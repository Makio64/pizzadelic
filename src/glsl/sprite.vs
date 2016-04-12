varying vec2 vUv;

uniform float widthPercent;
uniform float heightPercent;
uniform float xPercent;
uniform float yPercent;
uniform float ratio;

void main() {
	vUv = uv;
	vec3 pos = position;
	pos.x *= widthPercent*.5/ratio;
	pos.y *= heightPercent*.5;
	pos.x += xPercent;
	pos.y += yPercent;

	gl_Position = vec4(pos, .4 );
}
