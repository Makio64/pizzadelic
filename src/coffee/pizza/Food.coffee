Stage3d 		= require('makio/core/Stage3d')

module.exports = class Food extends THREE.Object3D
  constructor: (type) ->
    super()
    ref = Stage3d.models[type]
    for child in ref.children
      @add new THREE.Mesh(child.geometry, child.material)
