import { _decorator, AudioClip, AudioSource, Component, Node } from 'cc';
const { ccclass, property } = _decorator;

@ccclass('AudioManager')
export class AudioManager extends Component {

    @property({ type: AudioClip })
    public clickClip: AudioClip = null;

    private audioSource: AudioSource = null;

    start() {
        this.audioSource = this.node.getComponent(AudioSource);
    }

    update(deltaTime: number) {
        
    }

    // 播放点击音效 
    playSound() {
        this.audioSource.playOneShot(this.clickClip, 1);
    }
}

