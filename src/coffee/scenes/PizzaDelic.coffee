PizzaScene = require 'scenes/PizzaScene'
Pizza = require 'pizza/Pizza'
Stage3d = require 'makio/core/Stage3d'
VJ = require 'makio/audio/VJ'
MidiPad = require 'makio/audio/MidiPad'
Midi = require 'makio/audio/Midi'

class PizzaDelic extends PizzaScene

	constructor:()->
		super('Pizza Delic')
		@pizza = new Pizza()
		Stage3d.add @pizza

		@foods = []
		if(@pizza.egg)
			@foods.push @pizza.egg
		for slice in @pizza.slices
			for child in slice.children
				if (child instanceof THREE.Mesh)
					continue
				@foods.push child

		@rotationBonus = 0

		# MidiPad.add '5', VJ.add(@,'move',85,Midi.PAD,true)
		# console.log MidiPad

		VJ.onBeat.add(@onBeat)

		return

	eatSlice: () =>
		@pizza.eatSlice()
		Stage3d.setClearColor(0xFFFFFF*Math.random())
		Stage3d.changeMaterialBasicColor()
		return

	onBeat: =>
		@rotationBonus = .1
		for food in @foods
			food.position.z = Math.random() * 60
		@eatSlice()
		if(Math.random())
			@pizza.rotation.z += Math.random()*Math.PI*2
		Stage3d.postFX.uniforms.boost.value = 1
		return

	update:(dt)=>
		Stage3d.postFX.uniforms.boost.value += (0.4-Stage3d.postFX.uniforms.boost.value)*.05
		# if(!@move) then return
		speed = dt / 16
		@rotationBonus *= .15
		s = Math.max(0.3,VJ.volume*1.2)
		s = @pizza.scale.x += (s - @pizza.scale.x)*.3
		@pizza.scale.set s,s,s
		@pizza.rotation.z += speed*(0.01+@rotationBonus)*(.5+VJ.volume)
		# @pizza.scale.set(s)
		# if Math.random() > .95

		for food in @foods
			food.position.z += (0 - food.position.z) * .1
		return

	transitionIn: () =>
		super()
		# BaseCamera
		Stage3d.setClearColor(0xFFFFFF*Math.random())
		Stage3d.control.radius = 250
		Stage3d.control.phi = Math.PI/2
		Stage3d.control.theta = Math.PI/2
		return

	dispose:()=>
		# MidiPad.remove '5'
		# VJ.remove(@,'move',85,Midi.PAD,true)
		VJ.onBeat.remove(@onBeat)
		Stage3d.remove @pizza
		@pizza.dispose()
		return

module.exports = PizzaDelic
