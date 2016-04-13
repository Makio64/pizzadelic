Scene = require 'makio/core/Scene'
Pizza = require 'pizza/Pizza'
Stage3d = require 'makio/core/Stage3d'
VJ = require 'makio/audio/VJ'

# require('MMDLoader.js')
# require('CCDIKSolver.js')
# require('MMDPhysics.js')

class PizzaBond extends Scene

	constructor:()->
		super('Pizza Bond')
		@pizza = new Pizza()
		Stage3d.add @pizza
		mesh = Stage3d.models.miku
		@helper = new THREE.MMDHelper( Stage3d.renderer )
		@helper.add( mesh )
		@helper.setAnimation( mesh )
		# @helper.setPhysics( mesh )
		@helper.unifyAnimationDuration( { afterglow: 1.0 } )
		Stage3d.add( mesh )
		return

	update:(dt)=>
		# speed = dt / 16
		# s = Math.max(0.01,VJ.volume)
		# s = @pizza.scale.x += (s - @pizza.scale.x)*.35
		# @pizza.scale.set s,s,s
		# @pizza.rotation.y += speed*0.01
		@helper.animate( dt );
		@helper.render( Stage3d.scene, Stage3d.camera );
		return


	dispose:()=>
		Stage3d.remove @pizza
		@pizza.dispose()
		return

module.exports = PizzaBond
