Stage3d				= require("makio/core/Stage3d")
Stage				= require("makio/core/Stage")
Slice			= require('pizza/Slice')
Bacon			= require('pizza/Bacon')
Cheese			= require('pizza/Cheese')
Chorizo			= require('pizza/Chorizo')
Egg			= require('pizza/Egg')
Tomato			= require('pizza/Tomato')

module.exports = class Pizza extends THREE.Object3D

	constructor:()->
		super()
		Stage.onUpdate.add(@update)
		@generateFullPizza()
		return

	generateFullPizza:()=>
		# # Base
		# geometry = new THREE.CylinderGeometry(100,100,1,16)
		# material = new THREE.MeshBasicMaterial({wireframe:true,color:0xFFFFFF})
		# @add @base = new THREE.Mesh(geometry, material)
		#
		# # Croute
		# geometry = new THREE.TorusGeometry(100,10,10,16)
		# m = new THREE.Matrix4()
		# m.makeRotationX(Math.PI/2)
		# geometry.applyMatrix(m)
		# material = new THREE.MeshBasicMaterial({wireframe:true,color:0xFFFFFF})
		# @add @croute = new THREE.Mesh(geometry, material)

		for FoodClass in [Slice, Tomato, Egg, Chorizo, Cheese, Bacon]
			food = new FoodClass()
			@add food
			# food.position.set(
  		# 	Math.random() * 100 - 50
  		# 	Math.random() * 100 - 50
  		# 	Math.random() * 100 - 50
			# )

		return

	changeColor:()=>
		return

	update:(dt)=>
		return
