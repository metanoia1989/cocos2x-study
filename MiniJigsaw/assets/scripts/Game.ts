import { _decorator, Component, director, instantiate, Node, Prefab, resources, Sprite, SpriteFrame, Texture2D, Vec2, Vec3 } from 'cc';
import { Block } from './Block';
import { AudioManager } from './AudioManager';
const { ccclass, property } = _decorator;

@ccclass('Game')
export class Game extends Component {

    @property({ type: Prefab })
    private blockPrefab: Prefab = null; // 拼图块预制体

    @property({ type: Node })
    private bgNode: Node = null; // 背景节点

    @property({ type: AudioManager })
    private audioManager: AudioManager = null;

    private blockNum: number = 3; // 拼图块数量
    private picNodeArr = []; // 拼图块节点数组
    private hideBlockNode: Node = null; // 隐藏的拼图块节点

    start() {
        this.loadPicture();
        director.on('click_pic', this.onClickPic, this);
    }

    update(deltaTime: number) {
        
    }

    private loadPicture() {
        // 随机读取一个拼图素材 
        let pic_num = Math.floor(Math.random() * 2) + 1; // 1-2

        // 动态加载图片资源 
        resources.load(`pic_${pic_num}/texture`, Texture2D, (err, data) => {
            if (err) {
                console.log(err);
                return;
            }
            this.initGame(data);
            this.removeOnePic();
            this.randPic();
        });
    }

    private initGame(texture: Texture2D) {
        this.picNodeArr = [];

        // 计算拼图块边长
        const blockSide = texture.image.width / this.blockNum;
        // 生成 NxN 的拼图块，N为blockNum
        for (let i = 0; i < this.blockNum; i++) {
            this.picNodeArr[i] = [];

            for (let j = 0; j < this.blockNum; j++) {
                const blockNode = instantiate(this.blockPrefab);
                const blockScript = blockNode.getComponent('Block') as Block;
                blockNode.setPosition(new Vec3(j * blockSide, -i * blockSide, 0));
                blockScript.init(texture, blockSide, new Vec2(j, i));
                this.picNodeArr[i][j] = blockNode;
                this.bgNode.addChild(blockNode);
            }
        }
    }

    // 挖空右下角的拼图块
    private removeOnePic() {
        let pos = new Vec2(this.blockNum - 1, this.blockNum - 1);
        this.hideBlockNode = this.picNodeArr[pos.y][pos.x];
        this.hideBlockNode.active = false;
    }

    // 随机打乱拼图块
    private randPic() {
        let swapTimes = 100; // 随机交换次数

        for (let i = 0; i < swapTimes; i++) {
            let dirs = [
                new Vec2(0, 1), // 右
                new Vec2(0, -1), // 左
                new Vec2(1, 0), // 下
                new Vec2(-1, 0), // 上
            ];

            let randDir = dirs[Math.floor(Math.random() * dirs.length)];
            let hideBlockNodeScript = this.hideBlockNode.getComponent('Block') as Block;
            let nearIndex = hideBlockNodeScript.nowIndex.clone().add(randDir);

            // 越界检测
            if (nearIndex.x < 0 || nearIndex.x >= this.blockNum || nearIndex.y < 0 || nearIndex.y >= this.blockNum) {
                continue;
            }

            // 交换拼图块
            this.swapPicByPos(hideBlockNodeScript.nowIndex, nearIndex);
        }
    }

    // 交换两个位置的拼图块
    private swapPicByPos(nowPos: Vec2, desPos: Vec2) {
        let nowPicNode = this.picNodeArr[nowPos.y][nowPos.x];
        let desPicNode = this.picNodeArr[desPos.y][desPos.x];

        // 交换拼图块位置
        let tempPos = nowPicNode.getPosition();
        nowPicNode.setPosition(desPicNode.getPosition());
        desPicNode.setPosition(tempPos);

        // 交换拼图块索引
        let nowPicNodeScript = nowPicNode.getComponent('Block') as Block;
        let desPicNodeScript = desPicNode.getComponent('Block') as Block;
        let tempIndex = nowPicNodeScript.nowIndex;
        nowPicNodeScript.nowIndex = desPicNodeScript.nowIndex;
        desPicNodeScript.nowIndex = tempIndex;

        // 交换数组标记位置
        let tempNode = nowPicNode;
        this.picNodeArr[nowPos.y][nowPos.x] = desPicNode;
        this.picNodeArr[desPos.y][desPos.x] = tempNode;
    }

    // 点击拼图块
    private onClickPic(nowIndex: Vec2) {
        let dirs = [
            new Vec2(0, 1), // 右
            new Vec2(0, -1), // 左
            new Vec2(1, 0), // 下
            new Vec2(-1, 0), // 上
        ];

        let nearBlockNode;

        // 检查上、下、左、右是否有位置可以移动 
        for (let dir of dirs) {
            let nearIndex = nowIndex.clone().add(dir);

            // 越界检测
            if (nearIndex.x < 0 || nearIndex.x >= this.blockNum || nearIndex.y < 0 || nearIndex.y >= this.blockNum) {
                continue;
            }

            // 检查是否可以移动
            let blockNode = this.picNodeArr[nearIndex.y][nearIndex.x];
            if (!blockNode || blockNode.active) {
                continue;
            }

            nearBlockNode = blockNode;
        }

        // 如果存在可以移动的拼图块，则交换位置
        if (nearBlockNode) {
            this.swapPicByPos(nowIndex, nearBlockNode.getComponent('Block').nowIndex);
            this.completeCheck(); // 检查是否完成拼图
        }

        this.audioManager.playSound();
    }

    // 检查是否完成拼图
    private completeCheck() {
        let cnt = 0;
        for (let i = 0; i < this.blockNum; i++) {
            for (let j = 0; j < this.blockNum; j++) {
                const blockNode = this.picNodeArr[i][j];
                const blockScript = blockNode.getComponent('Block') as Block;
                if (blockScript.nowIndex.equals(blockScript.stIndex)) {
                    cnt++;
                }
            }
        }

        if (cnt == this.blockNum * this.blockNum) {
            this.hideBlockNode.active = true;
            console.log("游戏结束")
        }
            
    }
}

