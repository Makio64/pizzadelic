Scene = require 'makio/core/Scene'
Pizza = require 'pizza/Pizza'
Stage3d = require 'makio/core/Stage3d'
VJ = require 'makio/audio/VJ'
Constants = require 'Constants'

class PizzaTunnel2 extends Scene

	constructor:()->
		super('Pizza Tunnel')
		@pizzas = []
		@time = 0

		for i in [0...6]
			pizza = new Pizza({noEgg: true})
			pizza.position.z = -i * 100
			Stage3d.add pizza
			@pizzas.push pizza

		return

	update:(dt)=>
		@time += dt
		for i in [0...@pizzas.length]
			pizza = @pizzas[i]
			pizza.position.z += 4
			pizza.rotation.z += .03
			if pizza.position.z > 300
				pizza.position.z = -@pizzas.length * 100 + 300
			for j in [0...8]
				slice = pizza.slices[j]
				angle = -j * (Math.PI / 4)
				ratio = Math.pow(Math.max(pizza.position.z - j * 10, 0) / 300, 4)
				slice.position.x = -Math.cos(angle) * (100 + 1000 * ratio)
				slice.position.y = Math.sin(angle) * (100 + 1000 * ratio)
		return

	dispose:()=>
		for p in @pizzas
			Stage3d.remove p
			p.dispose()
		return

module.exports = PizzaTunnel2
