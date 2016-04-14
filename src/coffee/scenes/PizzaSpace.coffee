Scene = require 'makio/core/Scene'
Pizza = require 'pizza/Pizza'
Stage3d = require 'makio/core/Stage3d'
VJ = require 'makio/audio/VJ'
Stars = require 'space/stars'

class PizzaSpace extends Scene

	constructor:()->
		super('PizzaSpace')

		# Main Pizza
		@pizza = new Pizza()
		Stage3d.add @pizza

		# Create Stars
		@stars = new Stars(80000)
		Stage3d.add @stars

		# Create Planet


		return

	update:(dt)=>
		speed = dt / 16
		return

	dispose:()=>
		Stage3d.remove @pizza
		@pizza.dispose()
		return

module.exports = PizzaSpace
