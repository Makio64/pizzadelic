PizzaScene = require 'scenes/PizzaScene'
Pizza = require 'pizza/Pizza'
Stage3d = require 'makio/core/Stage3d'
VJ = require 'makio/audio/VJ'
Stars = require 'space/stars'

class PizzaSpace extends PizzaScene

	constructor:()->
		super('PizzaSpace')

		# Main Pizza
		@pizza = new Pizza()

		# Create Stars
		@stars = new Stars(80000)
		Stage3d.add @stars

		# MIKU
		mesh = Stage3d.models.miku
		mm = new THREE.MultiMaterial()
		for m in mesh.material.materials
			material = new THREE.MeshBasicMaterial({color:m.color})
			material.skinning = true
			# material.wireframe = true
			mm.materials.push(material)
			# m.shininess = 0
			# m.reflectivity = 0
			# m.lightMapIntensity = 0
			# m.refractionRatio = 0
			# m.shading = 0
			# m.lights = false
			# m.emissiveIntensity = 0
			# m.emissive.set(0,0,0)
		mesh.material = mm
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
		@gundam = Stage3d.models.gundam
		@gundam.visible = false
		@spaceship.add @gundam
		@spaceship.add @miku
		@spaceship.add @pizza
		Stage3d.add @spaceship
		@angle = 0

		VJ.onBeat.add(@onBeat)
		return

	onBeat:()=>
		# if(Math.random()>.2)
		# 	Stage3d.changeMaterialToWireframe()

		if(@gundam.visible && Math.random() < .5 or @miku.visible && Math.random() < .05)
			@miku.visible = !@miku.visible
			@gundam.visible = !@gundam.visible

		if(Math.random()>.5)
			Stage3d.changeMaterialColor()
		if(Stage3d.isAuto)
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
		Stage3d.control._radius = 500+Math.random()*1000
		Stage3d.postFX.uniforms.boost.value = 1
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
		@spaceship.rotation.z += speed * VJ.volume *.2
		s = 1 + VJ.volume*3
		@pizza.scale.set s,s,1
		@angle+=speed*0.03
		Stage3d.control.theta = Math.PI/2 + Math.sin(@angle)*.15
		Stage3d.control.phi = 2.9 + Math.cos(@angle)*.1
		Stage3d.control.radius = 500 + 1000*VJ.volume
		Stage3d.postFX.uniforms.boost.value += (0.4-Stage3d.postFX.uniforms.boost.value)*.05
		return

	transitionIn:()->
		super()
		Stage3d.changeMaterialColor()
		return

	dispose:()=>
		VJ.onBeat.remove(@onBeat)
		Stage3d.remove @spaceship
		Stage3d.remove @stars
		@pizza.dispose()
		@spaceship = null
		@stars = null
		@pizza = null
		return

module.exports = PizzaSpace
