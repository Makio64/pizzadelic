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

		# Create Stars
		@stars = new Stars(80000)
		Stage3d.add @stars

		# MIKU
		mesh = Stage3d.models.miku
		@helper = new THREE.MMDHelper( Stage3d.renderer )
		@helper.add( mesh )
		@helper.setAnimation( mesh )
		# @helper.setPhysics( mesh )
		# mesh.position.y -= 20
		obj = new THREE.Object3D()
		obj.scale.multiplyScalar(8)
		obj.add mesh
		obj.add @pizza
		obj.rotation.x += Math.PI/2
		@spaceship = new THREE.Object3D()
		@spaceship.add obj
		@spaceship.add @pizza
		Stage3d.add @spaceship
		return

	update:(dt)=>
		@stars.update(dt)
		@time += dt/10000
		speed = dt / 16
		@helper.animate( dt/600 );
		@spaceship.rotation.z += speed *VJ.volume
		s = 1 + VJ.volume*3
		@pizza.scale.set s,s,1
		return

	dispose:()=>
		Stage3d.remove @spaceship
		Stage3d.remove @stars
		@pizza.dispose()
		return

module.exports = PizzaSpace
