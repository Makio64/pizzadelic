varying vec2 vUv;
uniform sampler2D map;

void main(void) {
	gl_FragColor = texture2D(map, vUv);
}
