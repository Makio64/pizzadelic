Scene = require 'makio/core/Scene'
Pizza = require 'pizza/Pizza'
Stage3d = require 'makio/core/Stage3d'
VJ = require 'makio/audio/VJ'
MidiPad = require 'makio/audio/MidiPad'
Midi = require 'makio/audio/Midi'

class PizzaDelic extends Scene

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

		# MidiPad.add '5', VJ.add(@,'move',85,Midi.PAD,true)
		# console.log MidiPad

		VJ.onBeat.add(@onBeat)

		return

	eatSlice: () =>
		@pizza.eatSlice()
		return

	onBeat: =>
		for food in @foods
			food.position.z = Math.random() * 40
		return

	update:(dt)=>
		# if(!@move) then return
		speed = dt / 16
		# s = Math.max(0.01,VJ.volume)
		# s = @pizza.scale.x += (s - @pizza.scale.x)*.35
		# @pizza.scale.set s,s,s
		@pizza.rotation.z += speed*0.01

		for food in @foods
			food.position.z += (0 - food.position.z) * .1
		return

	dispose:()=>
		# MidiPad.remove '5'
		# VJ.remove(@,'move',85,Midi.PAD,true)
		VJ.onBeat.remove(@onBeat)
		Stage3d.remove @pizza
		@pizza.dispose()
		return

module.exports = PizzaDelic
