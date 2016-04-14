uniform sampler2D texture;
uniform vec3 color;
uniform float opacity;

void main() {
	float alpha = opacity;// * smoothstep(0., 20., vPosY);
	gl_FragColor = vec4( color, alpha ) * texture2D( texture, gl_PointCoord );
}
