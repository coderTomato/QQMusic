//
//  QQMusicOperationTool.swift
//  QQMusicTest
//
//  Created by 李军 on 2017/3/3.
//  Copyright © 2017年 李军. All rights reserved.
//

import UIKit
import MediaPlayer

class QQMusicOperationTool: NSObject {
    
    // 记录上一次绘制的行号
    var lastRow = 0
    
    // 创建一个专辑图片
    var artwork: MPMediaItemArtwork?
    
    private var musicmsgModel = QQMusicMessageModel();
    func getMusicMessageModel() -> QQMusicMessageModel{
        //当前最在播放的歌曲信息
        musicmsgModel.musicModel = musics[currentIndex];
        musicmsgModel.totalTime = (tool.player?.duration)!;
        musicmsgModel.costTime = (tool.player?.currentTime)!;
        musicmsgModel.isPlaying = (tool.player?.isPlaying)!;
        return musicmsgModel;
    }
    //
    var currentIndex = -1{
        didSet{
            if (currentIndex > musics.count - 1) {
                currentIndex = 0;
            }
            if (currentIndex < 0){
                currentIndex = musics.count - 1;
            }
        }
    }
    static let shareInstance = QQMusicOperationTool();
    
    var tool : QQMusicTool = QQMusicTool();
    
    //
    var musics : [QQMusicModel] = [QQMusicModel]();
    
    func playMusic(musicModel: QQMusicModel){
        //播放数据模型对应的音乐
        tool.playMusic(musicName: musicModel.filename!);
        currentIndex = musics.index(of: musicModel)!;
    }
    
    func pauseCurrentMusic() {
        tool.pauseMusic();
    }
    
    func playCurrentMusic(){
        playMusic(musicModel: musics[currentIndex]);
    }
    
    func nextMusic(){
        currentIndex += 1;
        playMusic(musicModel: musics[currentIndex]);
    }
    
    func preMusic(){
        currentIndex -= 1;
        playMusic(musicModel: musics[currentIndex]);
    }
    
    func setUpLockMessage() {
        // 0. 取出需要展示的信息模型
        let musicMessageM = getMusicMessageModel()
        
        // 1. 获取锁屏中心
        let infoCenter = MPNowPlayingInfoCenter.default()
        
        // 1.1 创建显示信息的字典
        var name = ""
        var singer = ""
        if musicmsgModel.musicModel?.name != nil {
            name = (musicmsgModel.musicModel?.name)!
        }
        
        if musicmsgModel.musicModel?.singer != nil {
            singer = (musicmsgModel.musicModel?.singer)!
        }
        
        let imageName = musicmsgModel.musicModel?.icon
        if imageName != nil {
            let image = UIImage(named: imageName!)
            if image != nil{
                // 1. 获取歌词, 添加歌词, 到图片上, 组成一张新的图片, 来展示
                // 1. 获取当前歌曲对应的所有歌词模型组成的shuzu
                let musicM = musicmsgModel.musicModel
                if musicM?.lrcname != nil{
                    let lrcMs = QQMusicDataTool.getLrcModels((musicM?.lrcname)!)
                    // 2. 获取当前正在播放的歌词模型
                    let rowLrcM = QQMusicDataTool.getRowLrcModel(lrcMs, currentTime: musicMessageM.costTime);
                    
                    // 3. 获取当前歌词的信息
                    if lastRow != rowLrcM.row {
                        lastRow = rowLrcM.row
                        // 4. 把文字, 绘制到图片上, 生成新的图片
                        let resultImage = QQImageTool.getImage(image!, text: rowLrcM.lrcM?.lrcContent);
                        artwork = MPMediaItemArtwork(image: resultImage);
                    }
                }
            }
        }
        
        let infoDic: NSMutableDictionary = NSMutableDictionary()
        infoDic.setValue(name, forKey: MPMediaItemPropertyAlbumTitle)
        infoDic.setValue(singer, forKey: MPMediaItemPropertyArtist)
        infoDic.setValue(musicMessageM.totalTime, forKey: MPMediaItemPropertyPlaybackDuration)
        infoDic.setValue(musicMessageM.costTime, forKey: MPNowPlayingInfoPropertyElapsedPlaybackTime)
        
        if artwork != nil {
            infoDic.setValue(artwork!, forKey: MPMediaItemPropertyArtwork)
        }
        
        let infoDic2 = infoDic.copy()
        
        // 2. 设置信息
        infoCenter.nowPlayingInfo = infoDic2 as? [String: AnyObject]
        
        // 3. 接收远程事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
}
