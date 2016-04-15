PizzaScene = require 'scenes/PizzaScene'
Pizza = require 'pizza/Pizza'
Stage3d = require 'makio/core/Stage3d'
VJ = require 'makio/audio/VJ'
Stars = require 'space/stars'
Slice			= require('pizza/Slice')
Bacon			= require('pizza/Bacon')
Cheese			= require('pizza/Cheese')
Chorizo			= require('pizza/Chorizo')
Egg				= require('pizza/Egg')
Tomato			= require('pizza/Tomato')

class PizzaSpace2 extends PizzaScene

	constructor:()->
		super('PizzaSpace2')


		# Create Stars
		@stars = new Stars(80000)
		@stars.setDirection(0,0,1)
		Stage3d.add @stars

		# Create FX
		# @zoomBlurPass = new WAGNER.ZoomBlurPass()
		# Stage3d.addPass(@zoomBlurPass)
		# @zoomBlurPass.params.center.set(-.5,0)

		# Create Food
		@turbo = 0
		@foods = []

		for i in [0...100]
			for FoodClass in [Slice, Bacon, Cheese, Chorizo, Egg, Tomato]
				params = if FoodClass is Slice then {noFood: true} else undefined
				food = new FoodClass(params)
				food.position.x = Math.random() * 10000 - 5000
				food.position.y = Math.random() * 10000 - 5000
				food.position.z = -Math.random() * 40000
				food._velocity = .2 + Math.random() * 5
				food._rotation = new THREE.Vector3(
					(Math.random() - .5) * .1
					(Math.random() - .5) * .1
					(Math.random() - .5) * .1
				)
				food._scale = 1 + Math.random() * 5
				food.scale.set(food._scale, food._scale, food._scale)
				food.rotation.set(
					Math.random() * Math.PI * 2
					Math.random() * Math.PI * 2
					Math.random() * Math.PI * 2
				)
				Stage3d.add food
				@foods.push food
		VJ.onBeat.add(@onBeat)
		return

	onBeat:()=>
		@turbo = 1.4
		# for food in @foods
		# 	scale = food._scale + Math.random()
		# 	food.scale.set(scale, scale, scale)
		return

	update:(dt)=>
		speed = dt / 16
		@turbo *= .94
		@stars.update(dt)
		# @zoomBlurPass.params.strength = @turbo
		# @zoomBlurPass.params.delta.x = 5*@turbo
		# @zoomBlurPass.params.delta.y = 5*@turbo
		# Stage3d.camera.fov += (40+50*@turbo-Stage3d.camera.fov)*.15
		# Stage3d.camera.updateProjectionMatrix()

		for i in [0...@foods.length]
			food = @foods[i]
			food.position.z += 80 * (food._velocity+@turbo*(25+VJ.volume+VJ.volume)+VJ.volume) * speed
			food.rotation.x += food._rotation.x
			food.rotation.y += food._rotation.y
			food.rotation.z += food._rotation.z

			scale = food._scale + VJ.levelsData[i] * 20
			food.scale.set scale, scale, scale

			if(food.position.z > 500)
				food.position.z = -40000
		return

	transitionIn: () =>
		super()

		# BaseCamera
		Stage3d.control.phi = Math.PI/2
		Stage3d.control.theta = Math.PI/2
		Stage3d.scene.fog = new THREE.Fog(0x000000, 10000, 40000)

		# Stage3d.camera.fov = 30
		# Stage3d.camera.updateProjectionMatrix()

		return

	dispose:()=>
		VJ.onBeat.remove(@onBeat)
		@stars.dispose()
		Stage3d.remove @stars
		for food in @foods
			food.dispose()
			Stage3d.remove food
		return

module.exports = PizzaSpace2
