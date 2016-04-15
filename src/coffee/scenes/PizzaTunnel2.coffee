PizzaScene = require 'scenes/PizzaScene'
Pizza = require 'pizza/Pizza'
Stage3d = require 'makio/core/Stage3d'
VJ = require 'makio/audio/VJ'
Constants = require 'Constants'

class PizzaTunnel2 extends PizzaScene

	constructor:()->
		super('Pizza Tunnel2')
		@pizzas = []
		@time = 0
		@slicesOffset = 0

		for i in [0...4]
			pizza = new Pizza({noEgg: true})
			pizza.position.z = -i * 300
			Stage3d.add pizza
			@pizzas.push pizza

		VJ.onBeat.add(@onBeat)

		return

	onBeat: =>
		if Math.random()>.7
			@slicesOffset = 1
		# pizza.scale.set(scale, scale, scale)
		if(Math.random()<.3)
			r = Math.random()
			if(r<.5)
				@camera1()
			else
				@camera2()
		return

	update:(dt)=>
		@time += dt
		speed = dt/16

		@slicesOffset -= .04
		if @slicesOffset <= 0
			@slicesOffset = 0

		for i in [0...@pizzas.length]
			pizza = @pizzas[i]
			pizza.position.z += 4*speed
			pizza.rotation.z += .03*speed

			# pizza.scale.x += (1 - pizza.scale.x) * .1
			# pizza.scale.set(pizza.scale.x, pizza.scale.x, pizza.scale.x)

			if pizza.position.z > 300
				pizza.position.z = -@pizzas.length * 300 + 300
			for j in [0...8]
				slice = pizza.slices[j]
				angle = -j * (Math.PI / 4)
				ratio = Math.pow(Math.max(pizza.position.z - j * 10, 0) / 300, 4)
				slice.position.x = -Math.cos(angle) * (100 + 1000 * ratio)
				slice.position.y = Math.sin(angle) * (100 + 1000 * ratio)
				slice.rotation.x = @slicesOffset * Math.PI * 2
				# slice.rotation.y = @slicesOffset * Math.PI * 2

		return

	transitionIn:()->
		super()
		r = Math.random()
		if(r<.5)
			@camera1()
		else
			@camera2()
		return

	camera1:()->
		Stage3d.control.phi = 2.428115605099083
		Stage3d.control.theta = 1.3146014049358146
		Stage3d.control.radius = 700
		Stage3d.changeMaterialColor()
		return

	camera2:()->
		Stage3d.control.phi = Math.PI/2
		Stage3d.control.theta = Math.PI/2
		Stage3d.control.radius = 900
		Stage3d.changeMaterialBasicColor()
		return

	dispose:()=>
		VJ.onBeat.remove(@onBeat)
		for p in @pizzas
			Stage3d.remove p
			p.dispose()
		return

module.exports = PizzaTunnel2
