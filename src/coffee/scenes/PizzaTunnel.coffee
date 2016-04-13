Scene = require 'makio/core/Scene'
Pizza = require 'pizza/Pizza'
Stage3d = require 'makio/core/Stage3d'
VJ = require 'makio/audio/VJ'
Constants = require 'Constants'

class PizzaTunnel extends Scene

	constructor:()->
		super()
		@pizzas = []
		radiusStep = 8
		radius = 350
		length = 20
		for i in [0...length] by 1
			for step in [0...radiusStep] by 1
				pizza = new Pizza()
				angle = Math.PI*2*step/radiusStep+Math.PI/4
				pizza.position.x = Math.cos(angle)*radius
				pizza.position.y = Math.sin(angle)*radius
				pizza.lookAt(Constants.ZERO)
				pizza.position.z = i*radius
				Stage3d.add pizza
				@pizzas.push pizza

		return

	update:(dt)=>
		# do rotation, ask damien for quaternion TIPS
		return

	dispose:()=>
		for p in @pizzas
			Stage3d.remove p
			p.dispose()
		return

module.exports = PizzaTunnel
