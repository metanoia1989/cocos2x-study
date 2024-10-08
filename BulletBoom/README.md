# 爆破点点 

《爆破点点》是一款非常有趣的反应小游戏。在游戏开始后，屏幕中会出现一个左右移动的敌人，玩家需要看准时机向敌人发射子弹，通过子弹消灭敌人并不断获取更高的分数。为了增加游戏的挑战性，在每次刷新敌人之后玩家只能获得一枚子弹，当子弹击中敌人时玩家将会获得1分，同时再次刷新敌人并分配给玩家一枚子弹，反之则会直接结束游戏。



# 事件机制 
在Cocos Creator中，事件是游戏中触发特定行为时发出的消息，例如用户产生的输入行为：键盘、鼠标、触摸等，都会以事件的形式发送到程序。

在代码中，我们可以监听对应的事件消息，并在事件发生时调用函数。事件系统是Cocos Creator内置的委派机制，它允许事件监听者对事件发送者发出的消息进行响应，且无须相互引用。通过使用事件系统，可以降低代码的耦合度，使代码更加地灵活。

例如，在一些RPG游戏中，我们可以通过事件系统来制作经验获取模块，将经验值的获取作为事件，而在经验升级的代码处判断监听，当收到经验增加的消息时， 则对经验值进行累加，并判断是否可以升级。通过这种方式将经验值的获取解耦，可以极大地提高经验系统的灵活性。在游戏开始时，我们只需要处理经验升级并判断监听，而不管以后增加多少个获取经验值的方式，都可以通过推送事件来完成处理。


## EventTarget
Cocos 通过 EventTarget 类实现事件的监听和发射。 
```js
import { EventTarget } from 'cc'

const eventTarget = new EventTarget();

eventTarget.on(type, func, target); // 监听事件，需要手动取消 
eventTarget.off(type);  // 取消所有此事件的监听 
eventTarget.off(type, func, target); // 取消单个回调及其目标的的监听处理 
// target 为事件接受对象，未指定则回调函数的this指向执行回调函数的对象。

eventTarget.emit(type, ...args); // 事件发射，最多支持5个事件参数   
```


## 输入事件系统 

在Cocos Creator 3.4.0中，input 对象实现了 EventTarget 的事件监听接口，通过 input 对象可以直接监听全局的系统输入事件。全局输入事件是指与节点树不相关的各种输入事件，由 input统一派发，目前支持的事件有：鼠标事件、触摸事件、键盘事件、设备重力传感事件。

所有的全局输入事件都可以通过接口 `input.on(type, callback, target)` 注册。
通过 `input.off(type, callback, target)` 来取消注册。   

鼠标事件 
Input.EventType.MOUSE       
MOVE Input.EventType.MOUSE_DOWN     
Input. EventType.MOUSE_UP       
Input.EventType.MOUSE_WHEEL     

触摸事件        
Input.EventType.TOUCH_START     
Input.EventType.TOUCH_MOVE      
Input.EventType.TOUCH_END       
Input.EventType.TOUCH_CANCEL        

键盘事件    
Input.EventType.KEY_DOWN    
Input.EventType.KEY_PRESSING    
Input.EventType.KEY_UP  

设备重力传感事件        
Input.EventType.DEVICEMOTION    


# 缓动系统

缓动系统（Tween）可以对目标对象的任意属性进行缓动。缓动系统可以让我们轻松地实现对象的位移、缩放、旋转等各种动作。得益于其方便的API接口，在实际项目中，缓动系统常被用于简单形变和位移动画的制作。 

例如，在这个小游戏中，我们可以使用缓动系统来制作子弹的位移动画，让子弹从初始位置向上移动到游戏场景外，从而实现子弹发射的效果。 

* to 添加一个对属性进行绝对值计算的间隔动作
* by 添加一个对属性进行相对值计算的间隔动作
* set 添加一个直接设置目标属性的瞬时动作
* delay 添加一个延迟时间的瞬时动作
* call 添加一个调用回调的瞬时动作
* target 添加一个直接设置缓动目标的瞬时动作
* union 将上下文的缓动动作打包成一个
* then 插入一个Tween到缓动队列中
* repeat 重复执行次数
* repeatForever 一直重复执行
* sequence 添加一个顺序执行的缓动
* parallel 添加一个同时执行的缓动
* start 启动缓动
* stop 停止缓动
* clone 克隆缓动
* show 启用节点链上的渲染，缓动目标需要为Node
* hide 禁用节点链上的渲染，缓动目标需要为Node
* removeSelf 将节点移出场景树，缓动目标需要为Node


缓动系统使用示例 
```js
let bulletTween =  tween(this.bulletNode) // 指定缓动对象 
    .to(0.6, (position: new Vec3(0, 600, 0))) // 对象在0.6s内移动到目标位置 
    .start() // 启动缓动 

bulletTween.stop()
```


# ParticleSystem2D 粒子组件 

2D粒子组件用于读取粒子资源数据，并对其进行一系列操作，例如播放、暂停、销毁。    

属性 -> 功能说明    
* CustomMaterial 自定义材质
* Color 粒子颜色
* Preview 在编辑器模式下预览粒子，启用后，在选中粒子时，粒子将在场景编辑器中自动播放
* PlayOnLoad 若勾选该项，则运行时会自动播放粒子
* AutoRemoveOnFinish 粒子播放完毕时自动销毁所在的节点
* Fileplist 格式的粒子配置文件
* Custom 自定义粒子属性。开启该属性后可以自定义以下部分的粒子属性
* SpriteFrame 自定义粒子贴图
* Duration 粒子系统的运行时间。单位为秒，-1表示持续发射
* EmissionRate 每秒发射的粒子数目
* Life 粒子的运行时间以及变化范围
* TotalParticle 粒子的最大数量
* StartColor 粒子的初始颜色
* EndColor 粒子结束时的颜色
* Angle 粒子的角度及变化范围
* StartSize 粒子的初始大小及变化范围
* EndSize 粒子结束时的大小及变化范围
* StartSpin 粒子开始时的自旋角度及变化范围 
* EndSpin 粒子结束时的自旋角度及变化范围
* PosVar 发射器位置的变化范围（横向和纵向）
* PositionType 粒子的位置类型，包括 FREE、RELATIVE、GROUPED 三种
* EmitterMode 发射器类型，包括 GRAVITY、RADIUS 两种
* Gravity 重力。仅在 EmitterMode 为 GRAVITY 时生效
* Speed 速度及变化范围。仅在 EmitterMode 为 GRAVITY 时生效
* TangentialAccel 每个粒子的切向加速度及变化范围，即垂直于重力方向的加速度。仅在 EmitterMode 为GRAVITY时生效
* RadialAccel 粒子径向加速度及变化范围，即平行于重力方向的加速度。仅在 EmitterMode为 GRAVITY 时生效
* RotationIsDir 每个粒子的旋转是否等于其方向。仅在 EmitterMode 为 GRAVITY 时生效。
* StartRadius 初始半径及变化范围，表示粒子发射时相对发射器的距离。仅在 EmitterMode为 RADIUS时生效
* EndRadius 结束半径及变化范围。仅在 EmitterMode 为 RADIUS 时生效
* RotatePerS 粒子每秒围绕起始点的旋转角度及变化范围。仅在 EmitterMode 为 RADIUS 时生效

