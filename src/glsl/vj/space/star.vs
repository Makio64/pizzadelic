uniform float size;
uniform float time;
uniform vec3 direction;

void main() {
	vec3 pos = position;
	pos += time*direction;
	pos = (-1000. + mod(pos,2000.));
	vec4 mvPosition = modelViewMatrix * vec4( pos, 1.0 );
	gl_PointSize = size * ( 400. / - mvPosition.z);
	gl_Position = projectionMatrix * mvPosition;
}
