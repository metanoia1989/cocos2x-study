import { _decorator, Component, director, Input, input, Node, Vec3, Prefab, instantiate, RigidBody, Collider } from 'cc';
const { ccclass, property } = _decorator;

@ccclass('Game')
export class Game extends Component {
    @property({ type: Node })
    private ballNode: Node = null; // ball 节点 

    @property({ type: Node })
    private blocksNode: Node = null; // blocks 节点 

    @property({ type: Prefab })
    private blockPrefab: Prefab = null; // block 预制体 

    private bounceSpeed: number = 0; // 小球第一次落地速度 
    private gameState: number = 0; // 游戏状态 0: 等待开始; 1: 游戏中; 2: 游戏结束; 
    private blockGap: number = 2.4; // 跳板之间的间距 
    private score: number = 0; // 分数 


    start() {
        input.on(Input.EventType.TOUCH_START, this.onTouchStart, this);
        this.collisionHandler();
        this.initBlocks();
    }

    update(deltaTime: number) {
        if (this.gameState === 1) {
            let speed = -2 * deltaTime; // 移动速度

            for (let block of this.blocksNode.children) {
                let pos = block.position.clone();
                pos.x += speed;
                block.setPosition(pos);

                this.checkBlockOut(block); // 跳板出界处理 
            }
        }

        // 检测小球是否掉出屏幕 
        if (this.ballNode.position.y < -4) {
            this.gameState = 2;
            director.loadScene("Game");
        }
    }

    // 跳板出界处理 
    checkBlockOut(block) {
        if (block.position.x < -3) {
            // 将跳板的坐标修改为下一块跳板出现的位置 
            let nextBlockPosX = this.getLasBlockPosX() + this.blockGap;
            let nextBlockPos = new Vec3(nextBlockPosX, 0, 0);
            block.setPosition(nextBlockPos);
            this.score++;
        }
    }

    // 获取最后一块跳板的 x 坐标 
    getLasBlockPosX() {
        let lastBlockPosX = 0;
        for (let block of this.blocksNode.children) {
            if (block.position.x > lastBlockPosX) {
                lastBlockPosX = block.position.x;
            }
        }
        return lastBlockPosX;
    }

    // 初始化跳板 
    initBlocks() {
        let posX = 0;

        for (let i = 0; i < 8; i++) {
            if (i == 0) {
                posX = this.ballNode.position.x; // 第一个跳板位置在小球下方 
            } else {
                posX += this.blockGap; // 其他跳板位置在小球右边 
            }
            console.log('测试', posX);
            this.createNewBlock(new Vec3(posX, 0, 0)); // 创建新跳板 
        }
    }

    // 创建新跳板 
    createNewBlock(pos) {
        let block = instantiate(this.blockPrefab); // 创建预制节点 
        block.setPosition(pos); // 设置位置 
        this.blocksNode.addChild(block); // 添加到blocks节点中 
    }

    onTouchStart() {
        // 只有小球落地后才可以操作 
        if (this.bounceSpeed == 0) return; 

        let rigidBody = this.ballNode.getComponent(RigidBody);
        // 将小球的下落速度设置为反弹速度的1.5倍，从而加速 
        rigidBody.setLinearVelocity(new Vec3(0, -this.bounceSpeed * 1.5, 0));

        this.gameState = 1; // 游戏状态设置为游戏中 
    }

    // 碰撞处理 
    collisionHandler() {
        let collider = this.ballNode.getComponent(Collider);
        let rigidBody = this.ballNode.getComponent(RigidBody);

        collider.on('onCollisionEnter', () => {
            // 首次落地前bounceSpeed为0，直接赋值为小球的速度绝对值 
            let vc = new Vec3(0, 0, 0);
            rigidBody.getLinearVelocity(vc);

            if (this.bounceSpeed == 0) {
                this.bounceSpeed = Math.abs(vc.y);
            } else {
                // 此后将落地反弹速度锁定为第一次落地时的速度 
                rigidBody.setLinearVelocity(new Vec3(0, this.bounceSpeed, 0));
            }
        }, this);
    }

}

