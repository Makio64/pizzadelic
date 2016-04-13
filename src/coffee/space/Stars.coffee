Stage3d 		= require('makio/core/Stage3d')
Stage 			= require('makio/core/Stage')
gui				= require('makio/core/GUI')
VJ				= require('makio/audio/VJ')
Midi			= require('makio/audio/Midi')

class Stars extends THREE.Points

	constructor:(vertices=40000, radius=1000)->
		material = @createMaterial()
		geometry = @createGeometry(vertices, radius)
		super(geometry,material)
		Stage3d.setClearColor 0
		@frustumCulled = false
		return

	update:(dt)=>
		@uniforms.time.value += dt/10;
		return

	createMaterial:()->
		loader = new THREE.TextureLoader()
		@uniforms = {
			texture:   { type: "t", value: loader.load( "img/particle.jpg" ) }
			opacity:   { type: "f", value: 1 }
			color:     { type: "v3", value: new THREE.Vector3(1,1,1) }
			size: 	   { type: "f", value: 5*(window.devicePixelRatio/2) }
			time: 	   { type: "f", value: 0 }
		}

		material = new THREE.ShaderMaterial( {
			uniforms:       @uniforms
			vertexShader:   require('vj/space/star.vs')
			fragmentShader: require('vj/space/star.fs')
			depthTest:      true
			depthWrite:     false
			transparent:    true
			blending: 		THREE.AdditiveBlending
		})
		return material

	createGeometry:(vertices, radius)->
		geometry = new THREE.BufferGeometry()
		size = vertices
		positions = new Float32Array( size*3 )
		times = new Float32Array( size )
		pi2 = Math.PI * 2

		for index in [0...size*3] by 3
			positions[ index + 0 ] = radius * (Math.random()-.5)*2
			positions[ index + 1 ] = radius * (Math.random()-.5)*2
			positions[ index + 2 ] = radius * (Math.random()-.5)*2
			times[index/3] = 1000*Math.random()

		geometry.addAttribute( 'aTime', new THREE.BufferAttribute( times, 1 ) )
		geometry.addAttribute( 'position', new THREE.BufferAttribute( positions, 3 ) )
		return geometry

module.exports = Stars
