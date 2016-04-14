# All great stories start with a Main.coffee

Stage 			= require('makio/core/Stage')
Stage3d 		= require('makio/core/Stage3d')
SceneTraveler	= require('makio/core/SceneTraveler')
OrbitControl 	= require('makio/3d/OrbitControls')
Sprite 			= require('makio/3d/Sprite')
AudioTexture 	= require('makio/3d/AudioTexture')
VJ 				= require('makio/audio/VJ')
Midi			= require('makio/audio/Midi')
MidiPad			= require('makio/audio/MidiPad')
gui 			= require('makio/core/GUI')
Pizza			= require('pizza/Pizza')

PizzaDelic		= require('scenes/PizzaDelic')
PizzaBond		= require('scenes/PizzaBond')
PizzaPattern	= require('scenes/PizzaPattern')
PizzaSpace		= require('scenes/PizzaSpace')
PizzaSpace2		= require('scenes/PizzaSpace2')
PizzaTunnel		= require('scenes/PizzaTunnel')
PizzaTunnel2		= require('scenes/PizzaTunnel2')

require('TGALoader.js')
require('MMDLoader.js')
require('CCDIKSolver.js')
require('MMDPhysics.js')

class Main

	# Entry point
	constructor:(@callback)->

		@callback(.5)

		# ---------------------------------------------------------------------- INIT STAGE 2D / 3D

		Stage3d.init({background:0x000000})
		Stage3d.initPostProcessing()
		Stage3d.control = new OrbitControl(Stage3d.camera,300)

		# ---------------------------------------------------------------------- INIT ENVMAP
		@envMap = new THREE.TextureLoader().load("images/SynthetikSky-Sky2.jpg")
		@envMap.minFilter = THREE.LinearFilter;
		@envMap.generateMipmaps = false;
		@envMap.mapping = THREE.SphericalReflectionMapping;
		@envMap.needsUpdate = true;

		# ---------------------------------------------------------------------- POSTFX
		@custom = new WAGNER.Pass()
		@custom.shader = WAGNER.processShader( WAGNER.basicVs, require('postFX.fs') )
		@custom.shader.uniforms.noiseAmount.value = 0.1
		@custom.shader.uniforms.noiseSpeed.value = 1
		@custom.shader.uniforms.vignetteAmount.value = 0.5
		Stage3d.addPass(@custom)

		gui.add(@custom.shader.uniforms.noiseAmount,'value',0,1).name('noiseAmount').listen()
		gui.add(@custom.shader.uniforms.noiseSpeed,'value',0,1).name('noiseSpeed').listen()
		gui.add(@custom.shader.uniforms.bwRatio,'value',0,1).name('bwRatio').listen()
		gui.add(@custom.shader.uniforms.vignetteAmount,'value',0,1).name('vignetteAmount').listen()
		gui.add(@custom.shader.uniforms.vignetteFallOff,'value',0,1).name('vignetteFallOff').listen()
		gui.add(@custom.shader.uniforms.invertRatio,'value',0,1).name('invertRatio').listen()
		gui.add(@custom.shader.uniforms.mirrorX,'value',0,1).step(1).name('mirrorX').listen()
		gui.add(@custom.shader.uniforms.mirrorY,'value',0,1).step(1).name('mirrorY').listen()
		# gui.add(@custom.shader.uniforms.divide4,'value',0,1).step(1).name('divide4')

		# @glitchs = new WAGNER.Pass()
		# @glitchs.shader = WAGNER.processShader( WAGNER.basicVs, require('postFX.fs') )

		# ---------------------------------------------------------------------- VJ
		@context = new AudioContext()
		@masterGain = @context.createGain()
		@masterGain.gain.value = 1
		live = true

		if(!live)
			# @masterGain.connect(@context.destination)
			a = document.createElement('audio')
			a.src = "audio/galvanize.mp3"
			a.loop = true
			a.play()
			audioSource = @context.createMediaElementSource( a )
			audioSource.connect( @masterGain )
			@callback(1)
		else
			navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia;
			navigator.getUserMedia(
				audio: true
				(e)=>
					mediaStream = @context.createMediaStreamSource(e);
					mediaStream.connect( @masterGain )
					console.log('mediaStream created')
					@callback(1)
				(e)=>
					console.log('mediaStream error')
			)

		VJ.init(@context,@masterGain)
		VJ.onBeat.add(@onBeat)
		@audioTexture = new AudioTexture(VJ.binCount,256)


		# ---------------------------------------------------------------------- UPDATE / RESIZE LISTENERS
		Stage.onUpdate.add(@update)
		Stage.onResize.add(@resize)

		# ---------------------------------------------------------------------- DEBUG
		Stage3d.add new Sprite(@audioTexture)
		Stage.stats.addCustom('DrawCall',Stage3d.renderer.info.render,'calls')
		Stage.stats.addCustom('Faces',Stage3d.renderer.info.render,'faces')
		Stage.stats.addCustom('Points',Stage3d.renderer.info.render,'points')
		Stage.stats.addCustom('Vertices',Stage3d.renderer.info.render,'vertices')
		Stage.stats.addCustom('Geometries',Stage3d.renderer.info.memory,'geometries')
		Stage.stats.addCustom('Textures',Stage3d.renderer.info.memory,'textures')

		# ---------------------------------------------------------------------- LIGHTS
		Stage3d.ambient = new THREE.AmbientLight(0xAAAAAA)
		Stage3d.directional = new THREE.DirectionalLight(0xffffff, .9 );
		Stage3d.directional.position.set( .5, 1, 0 );
		Stage3d.directional2 = new THREE.DirectionalLight(0xffffff, .9 );
		Stage3d.directional2.position.set( .5, .5, .5 );
		Stage3d.add Stage3d.ambient
		Stage3d.add Stage3d.directional
		Stage3d.add Stage3d.directional2
		@useLight = true

		# ---------------------------------------------------------------------- START LOADING
		@loadMiku()

		return

	# -------------------------------------------------------------------------- LOADING
	loadMiku:()=>
		loader = new THREE.MMDLoader()
		loader.setDefaultTexturePath( '3d/' )
		loader.load( '3d/miku_v2.pmd', ['3d/wavefile_v2.vmd'], ( object )=>
			Stage3d.models.miku = object
			@loadPizza()
		)
		return

	loadPizza:()=>
		Stage3d.models.foods = {}
		new THREE.ObjectLoader().load "models/pizza.json", (scene) =>
			for child in scene.children
				for mesh in child.children
					mesh.geometry.scale(20, 20, 20)
					color = 0xFFFFFF*Math.random()
					mesh.material = new THREE.MeshLambertMaterial({color:color})
					mesh.material.emissive.set color
					mesh.material.emissiveIntensity = 0
					# mesh.material.lights = true
				Stage3d.models.foods[child.name] = child
			@loadSound()

			# ---------------------------------------------------------------------- CREATE 3D SCENE ELEMENTS

			@scene7()
			@camera1()

		return

	loadSound:()=>
		Midi.onInit.add(()=>
			MidiPad = new MidiPad()

			# FX
			MidiPad.add '1', VJ.add(@custom.shader.uniforms.bwRatio,'value',81,Midi.PAD,true)
			MidiPad.add '2', VJ.add(@custom.shader.uniforms.invertRatio,'value',82,Midi.PAD,true)
			MidiPad.add '3', VJ.add(@custom.shader.uniforms.mirrorX,'value',83,Midi.PAD,true)
			MidiPad.add '4', VJ.add(@custom.shader.uniforms.mirrorY,'value',84,Midi.PAD,true)
			MidiPad.add '5', VJ.add(@,'useLight',85,Midi.PAD,true).onChange((value)=>
				if value
					Stage3d.add Stage3d.ambient
					Stage3d.add Stage3d.directional
					Stage3d.add Stage3d.directional2
					for key, food of Stage3d.models.foods
						for mesh in food.children
							mesh.material.emissiveIntensity = 0
				else
					Stage3d.remove Stage3d.ambient
					Stage3d.remove Stage3d.directional
					Stage3d.remove Stage3d.directional2
					for key, food of Stage3d.models.foods
						for mesh in food.children
							mesh.material.emissiveIntensity = 1
			)

			# CAMERA
			# VJ.addGroup([
			MidiPad.add 'q', VJ.add({v:0},'v',71,Midi.PAD,true).onChange(@camera1)
			MidiPad.add 'w', VJ.add({v:0},'v',72,Midi.PAD,true).onChange(@camera2)
			MidiPad.add 'e', VJ.add({v:0},'v',73,Midi.PAD,true).onChange(@camera3)
			MidiPad.add 'r', VJ.add({v:0},'v',74,Midi.PAD,true).onChange(@camera4)
			# ])

			# SCENE VARIATION
			# VJ.addGroup([
			MidiPad.add 'a', VJ.add({v:0},'v',61,Midi.PAD,true).onChange(@scene1)
			MidiPad.add 's', VJ.add({v:0},'v',62,Midi.PAD,true).onChange(@scene2)
			MidiPad.add 'd', VJ.add({v:0},'v',63,Midi.PAD,true).onChange(@scene3)
			MidiPad.add 'f', VJ.add({v:0},'v',64,Midi.PAD,true).onChange(@scene4)
			MidiPad.add 'g', VJ.add({v:0},'v',65,Midi.PAD,true).onChange(@scene5)
			MidiPad.add 'h', VJ.add({v:0},'v',66,Midi.PAD,true).onChange(@scene6)
			MidiPad.add 'j', VJ.add({v:0},'v',67,Midi.PAD,true).onChange(@scene7)
			# ])

			# COOL SHIT
			# VJ.addGroup([
			MidiPad.add 'z', VJ.add({v:0},'v',51,Midi.PAD,true).onChange(@changeMaterialToGold)
			MidiPad.add 'x', VJ.add({v:0},'v',52,Midi.PAD,true).onChange(@changeMaterialToSilver)
			MidiPad.add 'c', VJ.add({v:0},'v',53,Midi.PAD,true).onChange(@changeMaterialColor)
			MidiPad.add 'v', VJ.add({v:0},'v',54,Midi.PAD,true).onChange(@eatSlice)
			# ])
		)
		Midi.init()
		@audioTexture = new AudioTexture(VJ.binCount,256)
		return

	# -------------------------------------------------------------------------- ACTION
	eatSlice: =>
		if(SceneTraveler.currentScene.eatSlice)
			SceneTraveler.currentScene.eatSlice()

	changeMaterialToGold: () =>
		@changeMaterial("gold")
		return

	changeMaterialToSilver: () =>
		@changeMaterial("silver")
		return

	changeMaterialColor: () =>
		@changeMaterial("color")
		return

	changeMaterial: (type) =>
		for key, food of Stage3d.models.foods
			for mesh in food.children
				if type is "silver"
					mesh.material.color.set(0xffffff)
					mesh.material.envMap = @envMap
				else if type is "gold"
					mesh.material.color.set(0xffe000) # #ffe000
					mesh.material.envMap = @envMap
				else
					mesh.material.envMap = null
					mesh.material.color.set(0xffffff * Math.random())
				mesh.material.needsUpdate = true
		return

	# -------------------------------------------------------------------------- CAMERA
	camera1:(value)=>
		@cameraState = 1
		Stage3d.control.phi = 2.9
		Stage3d.control.theta = Stage3d.control.theta
		Stage3d.control.radius = 500
		return

	camera2:(value)=>
		@cameraState = 2
		Stage3d.control.phi = 0.001
		Stage3d.control.theta = 0
		Stage3d.control.radius = 50
		return

	camera3:(value)=>
		@cameraState = 3
		Stage3d.control.phi = 1.1
		Stage3d.control.theta = 0.001
		Stage3d.control.radius = 200
		return

	camera4:(value)=>
		@cameraState = 4
		Stage3d.control.phi = 1.1
		Stage3d.control.theta = Math.random()*Math.PI*2
		Stage3d.control.radius = 200
		return

	# -------------------------------------------------------------------------- PIZZA SCENE VARIATION
	scene1:(value)=>
		SceneTraveler.to(new PizzaDelic())
		return

	scene2:(value)=>
		SceneTraveler.to(new PizzaSpace())
		return

	scene3:(value)=>
		SceneTraveler.to(new PizzaPattern())
		return

	scene4:(value)=>
		SceneTraveler.to(new PizzaBond())
		return

	scene5:(value)=>
		SceneTraveler.to(new PizzaTunnel())
		return

	scene6:(value)=>
		SceneTraveler.to(new PizzaTunnel2())
		return

	scene7:(value)=>
		SceneTraveler.to(new PizzaSpace2())
		return

	# -------------------------------------------------------------------------- UPDATE

	update:(dt)=>
		# console.log Stage3d.control.phi, Stage3d.control.theta
		VJ.update()
		@audioTexture.update(VJ.freqByteData)
		# s = Math.max(0.01,VJ.volume)
		# s = @pizza.scale.x += (s - @pizza.scale.x)*.35
		# @pizza.scale.set s,s,s
		# @pizza.rotation.y += speed*0.01
		return

	# -------------------------------------------------------------------------- ON BEAT
	onBeat:()=>
		# do something
		return

	# -------------------------------------------------------------------------- RESIZE

	resize:()=>
		return

module.exports = Main
