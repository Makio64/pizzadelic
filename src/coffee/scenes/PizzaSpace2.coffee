Scene = require 'makio/core/Scene'
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

class PizzaSpace2 extends Scene

	constructor:()->
		super('PizzaSpace')

		# Create Stars
		@stars = new Stars(80000)
		Stage3d.add @stars

		# Create Food

		@foods = []

		for i in [0...50]
			for FoodClass in [Slice, Bacon, Cheese, Chorizo, Egg, Tomato]
				console.log FoodClass
				params = if FoodClass is Slice then {noFood: true} else undefined
				food = new FoodClass(params)
				food.position.x = Math.random() * 2000 - 1000
				food.position.y = Math.random() * 2000 - 1000
				food.position.z = -Math.random() * 20000
				food._velocity = 1 + Math.random() * 5
				food._rotation = new THREE.Vector3(
					(Math.random() - .5) * .1
					(Math.random() - .5) * .1
					(Math.random() - .5) * .1
				)
				food.scale.multiplyScalar(1 + Math.random() * 1)
				food.rotation.set(
					Math.random() * Math.PI * 2
					Math.random() * Math.PI * 2
					Math.random() * Math.PI * 2
				)
				Stage3d.add food
				@foods.push food
		return

	update:(dt)=>
		speed = dt / 16
		for food in @foods
			food.position.z += 50 * food._velocity
			food.rotation.x += food._rotation.x
			food.rotation.y += food._rotation.y
			food.rotation.z += food._rotation.z
			if(food.position.z > 500)
				food.position.z = -20000
		return

	dispose:()=>
		for food in @foods
			Stage3d.remove food
		return

module.exports = PizzaSpace2
