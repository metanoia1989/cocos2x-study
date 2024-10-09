import { _decorator, Component, director, find, Node } from 'cc';
const { ccclass, property } = _decorator;

@ccclass('Menu')
export class Menu extends Component {
    start() {
        // 复杂项目中，使用一个全局的脚本来统一管理节点，而不会用属性检查器拖动管理 
        let btnNode = find('Canvas/bg/startBtn');
        console.log('测试', btnNode);
        btnNode.on(Node.EventType.TOUCH_END, this.gameStart, this);
    }

    update(deltaTime: number) {
        
    }

    gameStart() {
        console.log("没反应吗？？？")
        director.loadScene('Game');
    }
}

