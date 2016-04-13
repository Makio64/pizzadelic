Scene = require 'makio/core/Scene'
Pizza = require 'pizza/Pizza'
Stage3d = require 'makio/core/Stage3d'
VJ = require 'makio/audio/VJ'
MidiPad = require 'makio/audio/MidiPad'
Midi = require 'makio/audio/Midi'

class PizzaDelic extends Scene

	constructor:()->
		super('Pizza Delic')
		@move = false
		@pizza = new Pizza()
		Stage3d.add @pizza
		
		# MidiPad.add '5', VJ.add(@,'move',85,Midi.PAD,true)
		# console.log MidiPad

		return

	eatPizza: () =>
		@pizza.eat()
		return

	update:(dt)=>
		if(!@move) then return
		speed = dt / 16
		s = Math.max(0.01,VJ.volume)
		s = @pizza.scale.x += (s - @pizza.scale.x)*.35
		@pizza.scale.set s,s,s
		@pizza.rotation.y += speed*0.01
		return

	dispose:()=>
		# MidiPad.remove '5'
		# VJ.remove(@,'move',85,Midi.PAD,true)
		Stage3d.remove @pizza
		@pizza.dispose()
		return

module.exports = PizzaDelic
