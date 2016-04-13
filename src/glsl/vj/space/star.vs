uniform float size;
varying float vPosY;

void main() {
	vec4 mvPosition = modelViewMatrix * vec4( position, 1.0 );
	vPosY = position.y;
	gl_PointSize = size * ( 400. / - mvPosition.z);
	gl_Position = projectionMatrix * mvPosition;
}
