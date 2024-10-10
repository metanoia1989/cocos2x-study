# MeshRenderer 组件 属性 

* Materials   网格资源允许使用多个材质资源，所有的材质资源都在materials数组中。如果网格资源中有多个子网格，那么 MeshRenderer 会从 materials 数组中获取对应的材质来渲染此子网格
* LightmapSettings    用于烘焙 Lightmap
* ShadowCastingMode   指定当前模型是否会投射阴影，需要先在场景中开启阴影
* ReceiveShadow   指定当前模型是否会接收并显示其他物体产生的阴影效果，需要先在场景中开启阴影。该属性仅在阴影类型为ShadowMap时生效
* Mesh    指定渲染所用的网格资源

