# MeshRenderer 组件 属性 

* Materials   网格资源允许使用多个材质资源，所有的材质资源都在materials数组中。如果网格资源中有多个子网格，那么 MeshRenderer 会从 materials 数组中获取对应的材质来渲染此子网格
* LightmapSettings    用于烘焙 Lightmap
* ShadowCastingMode   指定当前模型是否会投射阴影，需要先在场景中开启阴影
* ReceiveShadow   指定当前模型是否会接收并显示其他物体产生的阴影效果，需要先在场景中开启阴影。该属性仅在阴影类型为ShadowMap时生效
* Mesh    指定渲染所用的网格资源


# 3D 的一些基本操作

选中 Main Camera 节点，即可预览实际运行效果。 
选中 Main Camera 节点，然后按 Option + Shift + F 可以将视窗对其摄像机。

Option + 鼠标左键可以调整视窗。 


# 几种3D物理引擎 

builtin 仅有碰撞检测的功能，相对于其他的物理引擎，它没有复杂的物理模拟计算。如果项目不需要这一部分的物理模拟，那么可以考虑使用builtin，这将使得游戏的包体更小

cannon.js 是一个开源的物理引擎，它使用JavaScript语言开发并实现了比较全面的物理功能。如果项目需要更多复杂的物理功能，那么可以考虑使用它

bullet(ammo.js) 是 bullet 物理引擎的 asm.js/wasm 版本，由 emscripten 工具编译而来 

PhysX 是由英伟达公司开发的开源实时商业物理引擎，它具有完善的功能特性和极高的稳定性，同时兼具极佳的性能表现。目前 Cocos Creator 支持的PhysX是4.1版本的，允许在绝大部分原生和Web平台中使用