Food = require "./Food"
Bacon			= require('pizza/Bacon')
Cheese			= require('pizza/Cheese')
Chorizo			= require('pizza/Chorizo')
Egg			= require('pizza/Egg')
Tomato			= require('pizza/Tomato')

module.exports = class Slice extends Food
	constructor:(options = {}) ->
		super("slice")

		if options.noFood
			return

		randomizePosition = (food, options = {}) =>
			angle = options.angle || Math.PI * .5 + Math.random() * Math.PI * .25 - Math.PI * .125
			distance = options.distance || 20 + Math.random() * 140

			food.position.x = Math.cos(angle) * distance
			food.position.y = Math.sin(angle) * distance - 100
			food.rotation.z = Math.random() * Math.PI * 2
			food.scale.multiplyScalar(Math.random() * .4 + .8)

		if !options.noCheeze
			for i in [0...40]
				cheese = new Cheese(i * (Math.PI / 10))
				randomizePosition(cheese)
				@add cheese

		num = Math.ceil(Math.random() * 3)
		for i in [0...num]
			tomato = new Tomato()
			randomizePosition(tomato)
			@add tomato

		num = Math.ceil(Math.random() * 3)
		for i in [0...num]
			chorizo = new Chorizo()
			randomizePosition(chorizo)
			@add chorizo

		if(Math.random() > .5)
			bacon = new Bacon()
			randomizePosition(bacon, {distance: Math.random() * 50 + 60})
			bacon.rotation.z = Math.random() * 1 - .5
			@add bacon

	dispose:()->
		for i in [@children.length-1..0] by -1
			@remove(@children[i])
		return
