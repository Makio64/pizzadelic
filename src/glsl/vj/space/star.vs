uniform float size;
uniform float time;

void main() {
	vec3 pos = position;
	pos.y += time;
	pos.y = -1000. + mod(pos.y,2000.);
	vec4 mvPosition = modelViewMatrix * vec4( pos, 1.0 );
	gl_PointSize = size * ( 400. / - mvPosition.z);
	gl_Position = projectionMatrix * mvPosition;
}
