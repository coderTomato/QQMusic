//
//  QQMusicTool.swift
//  QQMusicTest
//
//  Created by 李军 on 2017/3/3.
//  Copyright © 2017年 李军. All rights reserved.
//

import UIKit
import AVFoundation

let kplayEnd = "playEnd"

class QQMusicTool: NSObject {
    
    override init() {
        super.init()
        
        // 不要忘记勾选后台模式
        // 1. 获取音频会话
        let session = AVAudioSession.sharedInstance()
        // 2. 设置会话类别
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            // 3. 激活会话
            try session.setActive(true)
        }catch {
            return
        }
    }
    
    var player : AVAudioPlayer?

    func playMusic(musicName: String){
        //1.获取需要播放的音乐文件路径
        guard let url = Bundle.main.url(forResource: musicName, withExtension: nil)else{
            return;
        }
        if (player?.url == url){
            player?.play();
            return;
        }
        //2.根据路径创建一个播放器
        do{
            player = try AVAudioPlayer(contentsOf: url);
            player?.delegate = self;
        }catch{
            return;
        }
        
        //3.准备播放
        player?.prepareToPlay();
        //4.开始播放
        player?.play();
    }
    
    func pauseMusic(){
        player?.pause();
    }
}

extension QQMusicTool : AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: kplayEnd), object: nil);
    }
}
