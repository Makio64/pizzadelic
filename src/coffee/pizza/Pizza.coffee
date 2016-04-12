Stage3d        = require("makio/core/Stage3d")
Stage        = require("makio/core/Stage")

class Pizza extends THREE.Object3D

    constructor:()->
        super()
        Stage.onUpdate.add(@update)
        @generateFullPizza()
        return

    generateFullPizza:()=>
        # Base
        geometry = new THREE.CylinderGeometry(100,100,1,16)
        material = new THREE.MeshBasicMaterial({wireframe:true,color:0xFFFFFF})
        @add @base = new THREE.Mesh(geometry, material)

        # Croute
        geometry = new THREE.TorusGeometry(100,10,10,16)
        m = new THREE.Matrix4()
        m.makeRotationX(Math.PI/2)
        geometry.applyMatrix(m)
        material = new THREE.MeshBasicMaterial({wireframe:true,color:0xFFFFFF})
        @add @croute = new THREE.Mesh(geometry, material)
        return

    changeColor:()=>
        return

    update:(dt)=>
        return

module.exports = Pizza
