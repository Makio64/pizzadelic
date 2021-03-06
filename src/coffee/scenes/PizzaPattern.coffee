PizzaScene = require 'scenes/PizzaScene'
Pizza = require 'pizza/Pizza'
Stage3d = require 'makio/core/Stage3d'
VJ = require 'makio/audio/VJ'
Constants = require 'Constants'

class PizzaPattern extends PizzaScene

	constructor:()->
		super('PizzaPattern')
		@pizzas = []
		@time = 0
		radiusStep = 8
		radius = 350
		for step in [0...radiusStep] by 1
			pizza = new Pizza()
			angle = Math.PI*2*step/radiusStep+Math.PI/4
			pizza.position.x = Math.cos(angle)*radius
			pizza.position.y = Math.sin(angle)*radius
			# pizza.lookAt(Constants.ZERO)
			Stage3d.add pizza
			@pizzas.push pizza

		return

	update:(dt)=>
		@time += dt
		for i in [0...@pizzas.length]
			pizza = @pizzas[i]
			pizza.position.z -= 10
			for child in pizza.children
				child.rotation.set(
					Math.PI * 2 * Math.cos(@time * .0001 + i * 100)
					Math.PI * 2 * Math.cos(@time * .0001 + i * 100)
					Math.PI * 2 * Math.cos(@time * .0001 + i * 100)
				)
		# do rotation, ask damien for quaternion TIPS
		return

	dispose:()=>
		for p in @pizzas
			Stage3d.remove p
			p.dispose()
		return

module.exports = PizzaPattern
