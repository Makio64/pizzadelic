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
		@miku = new THREE.Object3D()
		@miku.scale.multiplyScalar(8)
		@miku.add mesh
		@miku.add @pizza
		@miku.rotation.x += Math.PI/2
		@spaceship = new THREE.Object3D()
		@spaceship.add @miku
		@spaceship.add @pizza
		Stage3d.add @spaceship
		@angle = 0

		VJ.onBeat.add(@onBeat)
		return

	onBeat:()=>
		if(Stage3d.isAuto)
			if(Math.random()>.2)
				Stage3d.changeMaterialToWireframe()
			if(Math.random()>.5)
				Stage3d.changeMaterialBasicColor()
			if(Math.random()<.1)
				if Math.random()>.5
					Stage3d.changeMaterialToGold()
				else
					Stage3d.changeMaterialToSilver()
			if(Math.random()<.2)
				@blackAndWhite = !@blackAndWhite
				VJ.MidiPad.switchOn('1')
			if(Math.random()<.3)
				@invert = Math.random()*150+150
				VJ.MidiPad.switchOn('2')
		Stage3d.control.radius = 500+Math.random()*1000
		return

	update:(dt)=>
		if(Stage3d.isAuto)
			@blackAndWhite -= dt
			if @blackAndWhite < 0
				VJ.MidiPad.switchOff('1')
			@invert -= dt
			if @invert < 0
				VJ.MidiPad.switchOff('2')
		@stars.update(dt)
		@time += dt/10000
		speed = dt / 16
		@helper.animate( dt/600 );
		@spaceship.rotation.z += speed *VJ.volume
		s = 1 + VJ.volume*3
		@pizza.scale.set s,s,1
		@angle+=speed*0.03
		Stage3d.control.theta = Math.PI/2 + Math.sin(@angle)*.15
		Stage3d.control.phi = 2.9 + Math.cos(@angle)*.1
		return

	dispose:()=>
		VJ.onBeat.remove(@onBeat)
		Stage3d.remove @spaceship
		Stage3d.remove @stars
		@pizza.dispose()
		return

module.exports = PizzaSpace
