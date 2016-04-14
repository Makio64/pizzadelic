Stage3d			= require("makio/core/Stage3d")
Stage			= require("makio/core/Stage")
Slice			= require('pizza/Slice')
Bacon			= require('pizza/Bacon')
Cheese			= require('pizza/Cheese')
Chorizo			= require('pizza/Chorizo')
Egg				= require('pizza/Egg')
Tomato			= require('pizza/Tomato')

module.exports = class Pizza extends THREE.Object3D

	constructor:(options = {})->
		super()

		@slices = []
		@egg = null

		for i in [0...8]
			slice = new Slice({noCheese: options.noCheese})
			angle = -i * (Math.PI / 4)
			slice.position.x = -Math.cos(angle) * 100
			slice.position.y = Math.sin(angle) * 100
			slice.rotation.z = Math.PI * .5 - angle
			@add slice
			@slices.push(slice)

		if(!options.noEgg and Math.random() < .5)
			@egg = new Egg()
			@egg.position.x = Math.random() * 20 - 10
			@egg.position.y = Math.random() * 20 - 10
			@add @egg
		return

	eatSlice: () =>
		numOfVisibleSlices = 0
		for slice in @slices
			if(slice.visible)
				numOfVisibleSlices++
			else
				break

		if numOfVisibleSlices > 0
			@slices[numOfVisibleSlices - 1].visible = false
			if numOfVisibleSlices < 4 and @egg
				@egg.visible = false
		else
			for slice in @slices
				slice.visible = true
				if @egg
					@egg.visible = true
		return

	dispose:()=>
		@slices = null
		@egg = null
		return
