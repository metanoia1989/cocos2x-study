import { _decorator, Component, director, Label, Node } from 'cc';
const { ccclass, property } = _decorator;

@ccclass('Game')
export class Game extends Component {
    @property({ type: Node })
    private enemySkillNode: Node = null; // 绑定 enemy_skill 节点

    @property({ type: Label })
    private hintLabel: Label = null; // 绑定 hint 节点

    private enemyAttackType = 0; // 敌人招式 0:弓箭 1:流星锤 2:盾牌
    private timer = null; // 计时器 

    start() {
        // 启动计时器，每0.1秒执行一次 
        this.timer = setInterval(() => {
            this.randEnemyAttack()
        }, 100)
    }

    update(deltaTime: number) {
        
    }

    // 敌人随机攻击
    randEnemyAttack() {
        this.enemyAttackType = Math.floor(Math.random() * 3); // 随机招式 0-2
        let children = this.enemySkillNode.children;
        // 获取 enemy_skill 节点下的所有子节点，如果节点名字与随机招式相同则显示，否则隐藏
        children.forEach((child) => {
            if (child.name === this.enemyAttackType.toString()) {
                child.active = true;
            } else {
                child.active = false;
            }
        })
    }

    // 玩家出招按钮响应函数 
    attack(event, customEventData) {
        if (!this.timer) return;    

        clearInterval(this.timer);
        this.timer = null;

        let pkResult = 0; // 0:平局 1:玩家赢 -1:玩家输
        let attackType = parseInt(customEventData);

        const resultMatrix = [
            [0, 1, -1], // 玩家出0弓箭
            [-1, 0, 1], // 玩家出1流星锤
            [1, -1, 0] // 玩家出2盾牌 
        ];
        pkResult = resultMatrix[attackType][this.enemyAttackType];

        if (pkResult == -1) {
            this.hintLabel.string = "战败"
        } else if (pkResult == 0) {
            this.hintLabel.string = "平局"
        } else if (pkResult == 1) {
            this.hintLabel.string = "胜利"
        }
    }

    // 重新加载场景 
    restartGame() {
        director.loadScene('Game')
    }
}

