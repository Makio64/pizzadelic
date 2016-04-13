# All great stories start with a Main.coffee

Stage 			= require('makio/core/Stage')
Stage3d 		= require('makio/core/Stage3d')
OrbitControl 	= require('makio/3d/OrbitControls')
Sprite 			= require('makio/3d/Sprite')
AudioTexture 	= require('makio/3d/AudioTexture')
VJ 				= require('makio/audio/VJ')
Midi			= require('makio/audio/Midi')
MidiPad			= require('makio/audio/MidiPad')
gui 			= require('makio/core/GUI')
Pizza			= require('pizza/Pizza')

class Main

	# Entry point
	constructor:(@callback)->

		@callback(.5)

		# ---------------------------------------------------------------------- INIT STAGE 2D / 3D

		Stage3d.init({background:0x000000})
		Stage3d.initPostProcessing()
		Stage3d.control = new OrbitControl(Stage3d.camera,500)

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
			@masterGain.connect(@context.destination)
			a = document.createElement('audio')
			a.src = "audio/daddy.mp3"
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
		Midi.onInit.add(()=>
			MidiPad = new MidiPad()
			MidiPad.add '1', false, VJ.add(@custom.shader.uniforms.bwRatio,'value',81,Midi.PAD,true)
			MidiPad.add '2', false, VJ.add(@custom.shader.uniforms.invertRatio,'value',82,Midi.PAD,true)
			MidiPad.add '3', false, VJ.add(@custom.shader.uniforms.mirrorX,'value',83,Midi.PAD,true)
			MidiPad.add '4', false, VJ.add(@custom.shader.uniforms.mirrorY,'value',84,Midi.PAD,true)
		)
		@audioTexture = new AudioTexture(VJ.binCount,256)


		# ---------------------------------------------------------------------- LOAD MODELS
		Stage3d.models = {}
		new THREE.ObjectLoader().load "models/pizza.json", (scene) =>
			for child in scene.children
				for mesh in child.children
				  mesh.scale.multiplyScalar(100)
				Stage3d.models[child.name] = child
			console.log	Stage3d.models
			@addElements()

		# ---------------------------------------------------------------------- UPDATE / RESIZE LISTENERS
		Stage.onUpdate.add(@update)
		Stage.onResize.add(@resize)

		# ---------------------------------------------------------------------- DEBUG
		Stage3d.add new Sprite(@audioTexture)
		return

	# ---------------------------------------------------------------------- CREATE 3D SCENE ELEMENTS
	addElements: =>
		Stage3d.add @pizza = new Pizza()
		# Stage3d.add @slice = new foodClasses[0]()
		# Stage3d.add @tomato = new Tomato()
		# Stage3d.add @egg = new Egg()
		# Stage3d.add @chorizo = new Chorizo()
		# Stage3d.add @cheese = new Cheese()
		# Stage3d.add @bacon = new Bacon()

	# -------------------------------------------------------------------------- UPDATE

	update:(dt)=>
		speed = dt/16
		VJ.update()
		@audioTexture.update(VJ.freqByteData)
		s = Math.max(0.01,VJ.volume)
		s = @pizza.scale.x += (s - @pizza.scale.x)*.35
		@pizza.scale.set s,s,s
		@pizza.rotation.y += speed*0.01
		return

	# -------------------------------------------------------------------------- ON BEAT
	onBeat:()=>
		# do something
		return




	# -------------------------------------------------------------------------- RESIZE

	resize:()=>
		return

module.exports = Main
