import { _decorator, Animation, Component, Label, Node } from 'cc';
const { ccclass, property } = _decorator;

@ccclass('Game')
export class Game extends Component {
    private playerMaxHp: number = 25; // 玩家最大血量 
    private playerMaxAp: number = 3; // 玩家最大行动点数
    private playerMaxMp: number = 10; // 玩家法力值上限
    private playerAtk: number = 5; // 玩家攻击力

    private healMpCost: number = 8; // 恢复术消耗法力值
    private healHp: number = 5; // 恢复术恢复血量
    private increaseMp: number = 2; // 法力值恢复速度

    private enemyMaxHp: number = 25; // 敌人最大血量
    private enemyAtk: number = 3; // 敌人攻击力

    private playerHp: number = 0; // 玩家当前血量 
    private playerAp: number = 0; // 玩家当前行动点
    private playerMp: number = 0; // 玩家当前法力值 
    private enemyHp: number = 0; // 敌人当前血量 

    private turnNum: number = 0; // 0:玩家回合 1:敌人回合

    @property({ type: Node })
    private enemyAreaNode: Node = null; // 敌人区域节点
    @property({ type: Label })
    private enemyHpLabel: Label = null; // 敌人血量文本

    @property({ type: Label })
    private playerHpLabel: Label = null; // 玩家血量文本
    @property({ type: Label })
    private playerApLabel: Label = null; // 玩家行动点文本
    @property({ type: Label })
    private playerMpLabel: Label = null; // 玩家法力值文本

    @property({ type: Node })
    private nextBtnNode: Node = null; // 下一关按钮节点

    @property({ type: Animation })
    private bgAnimation: Animation = null; // 背景动画
    
    start() {
        this.initEnemy();
        this.initPlayer();

        this.bgAnimation.on(Animation.EventType.FINISHED, this.onBgAnimationFinished, this);

        let enemyAnimation = this.enemyAreaNode.getComponent(Animation);
        enemyAnimation.on(Animation.EventType.FINISHED, () => {
            this.turnNum = 0;
        }, this);
    }

    update(deltaTime: number) {
        
    }

    // 初始化敌人 
    initEnemy() {
        this.updateEnemyHp(this.enemyMaxHp);
        this.enemyAreaNode.active = true;
    }

    // 更新敌人血量
    updateEnemyHp(hp: number) {
        this.enemyHp = hp;
        this.enemyHpLabel.string = `${this.enemyHp}hp`;
    }

    // 初始化玩家
    initPlayer() {
        this.updatePlayerHp(this.playerMaxHp);
        this.updatePlayerAp(this.playerMaxAp);
        this.updatePlayerMp(this.playerMaxMp);
    }

    // 更新玩家血量
    updatePlayerHp(hp: number) {
        this.playerHp = hp;
        this.playerHpLabel.string = `HP\n${this.playerHp}`;
    }
    
    // 更新玩家行动点
    updatePlayerAp(ap: number) {
        this.playerAp = ap;
        this.playerApLabel.string = `AP\n${this.playerAp}`;
    }

    // 更新玩家法力值
    updatePlayerMp(mp: number) {
        this.playerMp = mp; 
        this.playerMpLabel.string = `MP\n${this.playerMp}`;
    }
    
    // 玩家发起攻击 
    playerAttack() {
        if (this.turnNum != 0) return; 
        if (this.playerAp <= 0) return;

        this.playerAp--; // 消耗行动点

        this.playerMp += this.increaseMp; // 自然恢复法力值
        if (this.playerMp > this.playerMaxMp) {
            this.playerMp = this.playerMaxMp;
        }

        // 播放敌人受击动画 
        let animation = this.enemyAreaNode.getComponent(Animation);
        animation.play('hurt');

        this.enemyHp -= this.playerAtk;
        if (this.enemyHp <= 0) {
            this.enemyDie();
            return;
        }
        this.updateEnemyHp(this.enemyHp);
        this.updatePlayerAp(this.playerAp);
        this.updatePlayerMp(this.playerMp);
        this.checkEnemyAction();

    }

    // 敌人死亡
    enemyDie() {
        this.enemyAreaNode.active = false;

        // this.nextRoom();
        this.nextBtnNode.active = true;
    }   

    // 进入下一关
    nextRoom() {
        console.log('进入下一关');
        let enemyAnimation = this.enemyAreaNode.getComponent(Animation);
        enemyAnimation.stop();
        this.bgAnimation.play('interlude');
        this.nextBtnNode.active = false;
    }

    onBgAnimationFinished() {
        console.log('下一关动画播放完毕');
        this.initEnemy();
        this.turnNum = 0;
        this.updatePlayerAp(this.playerMaxAp);
    }

    // 回合轮换检测
    checkEnemyAction() {
        if (this.turnNum == 0 && this.playerAp <= 0) {
            console.log('敌人回合');
            this.turnNum = 1;
            this.enemyAttack(this.enemyAtk);
        }
    }

    // 敌人发起攻击 
    enemyAttack(atk) {
        if (this.turnNum != 1) return;
        this.playerHp -= atk;
        this.updatePlayerHp(this.playerHp);

        // 播放玩家攻击动画
        let animation = this.enemyAreaNode.getComponent(Animation);
        animation.play('attack');

        if (this.playerHp <= 0) {
            console.log('玩家死亡，游戏结束');
            return;
        }

        this.updatePlayerAp(this.playerMaxAp);
    }

    // 恢复术
    playerHeal() {
        if (this.turnNum != 0) return; // 不是玩家回合
        if (this.playerAp <= 0 || this.playerMp < this.healMpCost) return; // 没有行动点或法力值不足

        this.playerAp--; // 消耗行动点
        this.playerMp -= this.healMpCost; // 消耗法力值

        this.playerHp += this.healHp; // 恢复血量
        if (this.playerHp > this.playerMaxHp) {
            this.playerHp = this.playerMaxHp;
        }

        this.updatePlayerHp(this.playerHp);
        this.updatePlayerAp(this.playerAp);
        this.updatePlayerMp(this.playerMp);

        this.checkEnemyAction();
    }
}

