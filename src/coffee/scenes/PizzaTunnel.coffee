PizzaScene = require 'scenes/PizzaScene'
Slice = require 'pizza/Slice'
Stage3d = require 'makio/core/Stage3d'
VJ = require 'makio/audio/VJ'
Constants = require 'Constants'

class PizzaTunnel extends PizzaScene

	constructor:()->
		super('Pizza Tunnel')
		@slices = []
		@time = 0
		radiusStep = 20
		radius = 400
		length = 10
		for i in [0...length] by 1
			for step in [0...radiusStep] by 1
				slice = new Slice({noCheese: true,noFood:true})
				angle = Math.PI*2*step/radiusStep+Math.PI/4
				slice.position.x = Math.cos(angle)*radius
				slice.position.y = Math.sin(angle)*radius
				slice.lookAt(Constants.ZERO)
				slice.position.z = i*radius + step*15
				slice.initial = {}
				slice.initial.angle = step
				slice.initial.z = slice.position.z
				slice.scale.multiplyScalar(.5)
				Stage3d.add slice
				@slices.push slice

		@buddha = Stage3d.models.buddha
		@buddha.position.z = -100
		@buddha.position.y = -40
		Stage3d.add @buddha

		VJ.onBeat.add(@onBeat)

		return

	onBeat: =>
		@buddha.rotation.set(
			-Math.PI * .5 + (Math.random() - .5) * .1
			(Math.random() - .5) * .1
			-Math.PI + (Math.random() - .5) * .1
		)
		return

	transitionIn:()->
		super()
		Stage3d.control.phi = Math.PI/2
		Stage3d.control.theta = Math.PI/2*3
		Stage3d.control.radius = 600
		Stage3d.scene.fog = new THREE.Fog(0x000000, 500, 4000)
		return

	update:(dt)=>
		@time += dt
		radiusStep = 20
		radius = 400

		@buddha.rotation.x += (-Math.PI * .5 - @buddha.rotation.x) * .1
		@buddha.rotation.y += - @buddha.rotation.y * .1
		@buddha.rotation.z += - (-Math.PI - @buddha.rotation.z) * .1
		#
		# @buddha.rotation.x = Math.PI * .5
		# @buddha.rotation.y = Math.PI * .5
		# @buddha.rotation.z = Math.PI * .5

		for i in [0...@slices.length]
			slice = @slices[i]
			angle = Math.PI*2*slice.initial.angle/radiusStep+Math.PI/4+@time/500
			slice.position.x = Math.cos(angle)*radius
			slice.position.y = Math.sin(angle)*radius
			slice.position.z = 0
			slice.lookAt(Constants.ZERO)
			slice.position.z = slice.initial.z-@time%400

			# slice.position.z -= 10
			# for child in slice.children
			# 	child.rotation.set(
			# 		Math.PI * 2 * Math.cos(@time * .0001 + i * 100)
			# 		Math.PI * 2 * Math.cos(@time * .0001 + i * 100)
			# 		Math.PI * 2 * Math.cos(@time * .0001 + i * 100)
			# 	)
		# do rotation, ask damien for quaternion TIPS
		return

	dispose:()=>
		VJ.onBeat.remove(@onBeat)
		Stage3d.remove @buddha
		for p in @slices
			Stage3d.remove p
			p.dispose()
		return

module.exports = PizzaTunnel
