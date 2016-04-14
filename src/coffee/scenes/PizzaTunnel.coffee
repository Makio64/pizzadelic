Scene = require 'makio/core/Scene'
Slice = require 'pizza/Slice'
Stage3d = require 'makio/core/Stage3d'
VJ = require 'makio/audio/VJ'
Constants = require 'Constants'

class PizzaTunnel extends Scene

	constructor:()->
		super('Pizza Tunnel')
		@slices = []
		@time = 0
		radiusStep = 7
		radius = 400
		length = 10
		for i in [0...length] by 1
			for step in [0...radiusStep] by 1
				slice = new Slice({noCheese: true})
				angle = Math.PI*2*step/radiusStep+Math.PI/4
				slice.position.x = Math.cos(angle)*radius
				slice.position.y = Math.sin(angle)*radius
				slice.lookAt(Constants.ZERO)
				slice.position.z = i*radius
				slice.scale.multiplyScalar(.5)
				Stage3d.add slice
				@slices.push slice

		return

	update:(dt)=>
		@time += dt
		for i in [0...@slices.length]
			slice = @slices[i]

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
		for p in @slices
			Stage3d.remove p
			p.dispose()
		return

module.exports = PizzaTunnel
