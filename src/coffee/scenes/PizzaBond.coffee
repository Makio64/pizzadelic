Scene = require 'makio/core/Scene'
Pizza = require 'pizza/Pizza'
Stage3d = require 'makio/core/Stage3d'
VJ = require 'makio/audio/VJ'

# require('MMDLoader.js')
# require('CCDIKSolver.js')
# require('MMDPhysics.js')

class PizzaBond extends Scene

	constructor:()->
		@time = 0
		super('Pizza Bond')
		@pizza = new Pizza()
		Stage3d.add @pizza
		mesh = Stage3d.models.miku
		@helper = new THREE.MMDHelper( Stage3d.renderer )
		@helper.add( mesh )
		@helper.setAnimation( mesh )
		# @helper.setPhysics( mesh )
		# mesh.position.y -= 20
		@miku = new THREE.Object3D()
		@miku.scale.multiplyScalar(8)
		@miku.add mesh
		@miku.rotation.x += Math.PI/2
		# @helper.unifyAnimationDuration( { afterglow: 1.0 } )
		Stage3d.add( @miku )
		return

	update:(dt)=>
		@time += dt/10000
		# speed = dt / 16
		# s = Math.max(0.01,VJ.volume)
		# s = @pizza.scale.x += (s - @pizza.scale.x)*.35
		# @pizza.scale.set s,s,s
		# @pizza.rotation.y += speed*0.01
		@helper.animate( dt/500 );
		# @helper.render( Stage3d.scene, Stage3d.camera );
		# Stage3d.stop()
		return


	dispose:()=>
		Stage3d.remove @pizza
		Stage3d.remove @miku
		@pizza.dispose()
		return

module.exports = PizzaBond
