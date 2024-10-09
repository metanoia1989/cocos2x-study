import { _decorator, Collider2D, Component, Contact2DType, director, Input, input, instantiate, Label, Node, Prefab, RigidBody2D, Vec2, Vec3 } from 'cc';
const { ccclass, property } = _decorator;

@ccclass('Game')
export class Game extends Component {
    @property({ type: Node })
    private ballNode: Node = null; // 小球节点

    @property({ type: Node })
    private blocksNode: Node = null; // 跳板节点

    @property({ type: Prefab })
    private blockPrefab: Prefab = null; // 跳板预制体 


    @property({ type: Label })
    private scoreLabel: Label = null; // 分数标签

    private bounceSpeed: number = 0; // 小球第一次落地速度
    private gameState: number = 0; // 游戏状态 0 等待开始 1 游戏开始 2 游戏结束
    private blockGap: number = 250; // 跳板之间的间距
    private score: number = 0; // 分数

    start() {
        input.on(Input.EventType.TOUCH_START, this.onTouchStart, this);
        this.collisionHandler(); // 碰撞回调 
        this.ballNode.setPosition(-250, 200, 0); // 设置小球初始位置 
        this.initBlock(); // 初始化跳板
    }

    update(deltaTime: number) {
        // 小球跑起来的两种实现方式：
        // 1. 摄像机跟随小球
        // 2. 相对移动，跳板整体朝小球反向移动   
        if (this.gameState == 1) {
            this.moveAllBlocks(deltaTime);
        }
    }

    onTouchStart() {
        // 只有小球落地后才可以进行操作
        if (this.bounceSpeed == 0) {
            return;
        }

        let rigidbody = this.ballNode.getComponent(RigidBody2D);
        // 小球下落速度修改为反弹速度的1.5倍，实现加速逻辑
        rigidbody.linearVelocity = new Vec2(0, -this.bounceSpeed * 1.5); 
        this.gameState = 1; // 游戏开始
    }

    collisionHandler() {
        // 修正瞬时反弹的速度 
        let collider = this.ballNode.getComponent(Collider2D);
        let rigidbody = this.ballNode.getComponent(RigidBody2D);

        collider.on(Contact2DType.BEGIN_CONTACT, () => {
            // 首次落地 bounceSpeed 为0，将小球的落地速度的绝对值进行赋值
            if (this.bounceSpeed == 0) {
                this.bounceSpeed = Math.abs(rigidbody.linearVelocity.y);
            } else {
                // 此后将落地反弹的速度锁定为第一次落地的速度
                rigidbody.linearVelocity = new Vec2(0, this.bounceSpeed);
            }
        }, this);
    }

    initBlock() {
        let posX;

        for(let i = 0; i < 5; i++) {
            if (i == 0) {
                posX = this.ballNode.position.x; // 第一块跳板生成在小球下方 
            } else {
                posX += this.blockGap; // 根据间隔获取下一块跳板的位置 
            }
            this.createNewBlock(new Vec3(posX, 0, 0));
        }
    }

    // 创建新跳板 
    createNewBlock(pos: Vec3) {
        let blockNode = instantiate(this.blockPrefab); // 创建预制节点 
        blockNode.setPosition(pos); // 设置位置 
        this.blocksNode.addChild(blockNode); // 添加到跳板节点下 
    }

    // 移动所有跳板
    moveAllBlocks(deltaTime: number) {
        let speed = -300  * deltaTime; // 移动速度 

        // 使用 Box2D 物理引擎，不能通过移动父节点来让节点整体移动 
        // 而是要遍历所有子节点，分别移动，这是因为当前引擎编辑器的设计问题      
        for (let blockNode of this.blocksNode.children) {
            let pos = blockNode.position.clone();
            pos.x += speed;
            blockNode.setPosition(pos);
            this.checkBlockOut(blockNode); // 跳板出界处理 
        }
    }

    // 获取最后一个跳板的x坐标
    getLastBlockPosX() {
        let lastBlockPosX = 0;
        for (let blockNode of this.blocksNode.children) {
            if (blockNode.position.x > lastBlockPosX) {
                lastBlockPosX = blockNode.position.x;
            }
        }
        return lastBlockPosX;
    }

    // 跳板出界处理
    checkBlockOut(blockNode: Node) {
        // 将出界的跳板坐标修改为下一块跳板的坐标
        if (blockNode.position.x < -400) {
            let nextPosX = this.getLastBlockPosX() + this.blockGap;
            let nextPosY = (Math.random() > .5 ? 1 : -1) * (10 + 40 * Math.random());
            blockNode.setPosition(new Vec3(nextPosX, nextPosY, 0));
            this.increaseScore();
        }

        // 小球掉出屏幕，结束游戏
        if (this.ballNode.position.y < -700) {
            this.gameState = 2; // 游戏结束
            director.loadScene("Game"); // 重新加载游戏场景 
        }
    }

    // 增加分数
    increaseScore() {
        this.score++;
        this.scoreLabel.string = this.score.toString();
    }
}

