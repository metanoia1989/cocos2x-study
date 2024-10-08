import { _decorator, Component,  director,  EventTarget, input, Input, Label, Node, ParticleSystem2D, Sprite, Tween, tween, Vec3 } from 'cc';
const { ccclass, property } = _decorator;

const eventTarget = new EventTarget();

@ccclass('Game')
export class Game extends Component {
    private user_exp = 0;
    private gameState = 0; // 0 子弹未发射，1 子弹已发射 
    private bulletTween: Tween<Node> = null; // 子弹缓动对象 
    private enemyTween: Tween<Node> = null; // 敌人缓动对象 
    private expTimer = null;
    private score = 0; // 游戏得分 

    @property({ type: Node })
    private bulletNode: Node = null; // 绑定bullet节点 

    @property({ type: Node })
    private enemyNode: Node = null; // 绑定enemy节点 

    @property({ type: Label })
    private scoreLabel: Label = null; // 计分节点 

    @property({ type: Node })
    private boomNode: Node = null; // 绑定 boom节点 

    onLoad() {
        eventTarget.on('incr_exp', exp => {
            this.user_exp += exp;
            console.log(`获得了${exp}点经验，当前经验为${this.user_exp}`);
        });

    }

    onDestroy() {
        input.off(Input.EventType.TOUCH_START, this.fire, this);
        eventTarget.off('incr_exp');
        
        if (this.expTimer) {
            clearInterval(this.expTimer);
            this.expTimer = null;
        }
    }

    start() {
        eventTarget.emit('incr_exp', 5);

        this.expTimer = setInterval(() => {
            eventTarget.emit('incr_exp', 1);
        }, 1000);

        input.on(Input.EventType.TOUCH_START, this.fire, this);

        this.newLevel();

    }



    update(deltaTime: number) {
        // 对比子弹和目标位置的距离，小于指定值则视为发生了碰撞 
        this.checkCollision();
    }

    // 初始化游戏
    newLevel() {
        this.initEnemy();
        this.bulletInit();

        this.gameState = 0; // 重制游戏状态
    }

    // 敌人初始化，让敌人在屏幕中左右有异动
    initEnemy() {
        let st_pos = new Vec3(300, 260, 0); // 初始化位置 
        let duration; // 让运动时间随机，添加难度 // 从屏幕右边移动到左边所需的时间 
        duration = 1.5 - Math.random() * 0.5 ; // 1s 到 1.5s 之间 
        st_pos.y = st_pos.y - Math.random() * 40; // 初始y坐标随机范围 220-260 
        // 50%概率改变初始位置到对侧 
        if (Math.random() < 0.5) {
            st_pos.x = -st_pos.x;
        }
        console.log(st_pos.x, st_pos.y);

        this.enemyNode.setPosition(st_pos.x, st_pos.y);
        this.enemyNode.active = true;

        this.enemyTween = tween(this.enemyNode)
            .to(duration, { position: new Vec3(-st_pos.x, st_pos.y, 0) }) // 移动到左侧
            .to(duration, { position: new Vec3(st_pos.x, st_pos.y, 0) }) // 移动到右侧
            .union() // 将上下文的缓动动作打包为一个 
            .repeatForever()
            .start()
    }

    // 初始化子弹
    bulletInit() {
        let st_pos = new Vec3(0, -340, 0);
        this.bulletNode.setPosition(st_pos);
        this.bulletNode.active = true;
    }

    // 增加得分
    incrScore() {
        this.score += 1;
        this.scoreLabel.string = `${this.score}`;
    }

    fire() {
        // 如果子弹已经发射，则不执行发射逻辑
        if (this.gameState != 0) {
            return;
        }

        this.gameState = 1;
        console.log('fire');

        this.bulletTween = tween(this.bulletNode)
            .to(0.6, { position: new Vec3(0, 600, 0) }) // 对象在0.6s内移动到目标位置 
            .call(() => {
                this.gameOver()
            })
            .start() // 启动缓动 
    }

    gameOver() {
        this.gameState = 2; // 2 子弹击中目标，游戏结束 

        // 播放爆炸效果
        let bulletColor = this.bulletNode.getComponent(Sprite).color;
        this.boom(this.bulletNode.position, bulletColor);

        this.bulletTween.stop();
        this.enemyTween.stop();

        console.log('game over');
        setTimeout(() => {
            director.loadScene('Game'); // 重新加载Game场景 
        }, 1000);
    }

    checkCollision() {
        // 如果子弹未发射，则不执行碰撞检测
        if (this.gameState != 1) {
            return;
        }

        // 获取子弹与敌人的距离 
        let dis = Vec3.distance(this.bulletNode.position, this.enemyNode.position);

        // 碰撞时，停止子弹缓动动画，隐藏子弹和敌人节点，从而达到击中敌人的效果 
        if (dis < 50) {
            this.bulletTween.stop();
            this.enemyTween.stop();
            this.gameState = 2; // 2 子弹击中目标，游戏结束 

            this.bulletNode.active = false;
            this.enemyNode.active = false;

            // 播放爆炸效果
            let enemyColor = this.enemyNode.getComponent(Sprite).color;
            this.boom(this.bulletNode.position, enemyColor);

            this.incrScore(); // 增加得分
            this.newLevel(); // 重新开始游戏
        }
    }

    // 爆炸效果 💥   
    boom(pos, color) {
        this.boomNode.setPosition(pos);
        let particle = this.boomNode.getComponent(ParticleSystem2D);
        if (color) {
            particle.startColor = particle.endColor = color;
        }
        particle.resetSystem();
    }

}

