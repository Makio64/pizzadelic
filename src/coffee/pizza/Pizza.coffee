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

		@slices = []

		@generateFullPizza()
		return

	generateFullPizza:()=>
		for i in [0...8]
			slice = new Slice()
			angle = i * (Math.PI / 4)
			slice.position.x = -Math.cos(angle) * 100
			slice.position.y = Math.sin(angle) * 100
			slice.rotation.z = Math.PI * .5 - angle
			@add slice
			@slices.push(slice)

		if(Math.random() < .5)
			@egg = new Egg()
			@egg.position.x = Math.random() * 20 - 10
			@egg.position.y = Math.random() * 20 - 10
			@add @egg
		return

	eat: () =>
		for slice in @slices
			if slice.visible
				slice.visible = false
				@egg.visible = false
				break
		return

	changeColor:()=>
		return

	dispose:()=>
		return
