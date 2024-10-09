import { _decorator, Component, Node, resources, SpriteFrame, Sprite, Texture2D, Vec2, director, UITransform, Rect } from 'cc';
const { ccclass, property } = _decorator;

@ccclass('Block')
export class Block extends Component {
    public stIndex = new Vec2(0, 0); // 初始位置下标 
    public nowIndex = new Vec2(0, 0); // 当前位置下标 

    start() {
        // 动态加载图片资源 
        // resources.load('pic_1/pic_1', Texture2D, (err, data) => {
        //     if (err) {
        //         console.log(err);
        //         return;
        //     }
        //     const sprite = this.getComponent(Sprite);
        //     const spriteFrame = new SpriteFrame();
        //     spriteFrame.texture = data;
        //     sprite.spriteFrame = spriteFrame;
        // });

        this.node.on(Node.EventType.TOUCH_START, this.onBlockTouch, this);
    }

    update(deltaTime: number) {
        
    }

    onBlockTouch() {
        director.emit('click_pic', this.nowIndex)
    }

    /**
     * 拼图初始化   
     * @param texture 目标纹理  
     * @param blockSide 拼图块边长
     * @param index 拼图块初始下标
     */
    init(texture, blockSide, index) {
        const sprite = this.getComponent(Sprite);
        const spriteFrame = new SpriteFrame();

        const uiTransform = this.getComponent(UITransform);
        uiTransform.setContentSize(blockSide, blockSide);

        spriteFrame.texture = texture;
        spriteFrame.rect = new Rect(index.x * blockSide, index.y * blockSide, blockSide, blockSide);
        sprite.spriteFrame = spriteFrame;

        this.nowIndex = index;
        this.stIndex = index;
    }
}

