Scene = require 'makio/core/Scene'
Stage3d = require 'makio/core/Stage3d'

class PizzaScene extends Scene

		constructor:(name='PizzaScene')->
				super(name)
				return

		transitionIn:()->
				super()
				Stage3d.scene.fog = null
				Stage3d.postFX.uniforms.boost.value = 0
				Stage3d.changeMaterialBasicColor()
				return

module.exports = PizzaScene
