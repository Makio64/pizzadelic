Scene = require 'makio/core/Scene'
Pizza = require 'pizza/Pizza'
Stage3d = require 'makio/core/Stage3d'
VJ = require 'makio/audio/VJ'

class PizzaBond extends Scene

	constructor:()->
		super()
		@pizza = new Pizza()
		Stage3d.add @pizza
		return

	update:(dt)=>
		speed = dt / 16
		s = Math.max(0.01,VJ.volume)
		s = @pizza.scale.x += (s - @pizza.scale.x)*.35
		@pizza.scale.set s,s,s
		@pizza.rotation.y += speed*0.01
		return

	dispose:()=>
		Stage3d.remove @pizza
		@pizza.dispose()
		return

module.exports = PizzaBond
