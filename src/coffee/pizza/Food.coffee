Stage3d 		= require('makio/core/Stage3d')

module.exports = class Food extends THREE.Object3D
  constructor: (type) ->
    super()
    @add Stage3d.models[type].clone()
