//
//  QQMusicMessageModel.swift
//  QQMusicTest
//
//  Created by 李军 on 2017/3/3.
//  Copyright © 2017年 李军. All rights reserved.
//

import UIKit

class QQMusicMessageModel: NSObject {
    
    var musicModel : QQMusicModel?;
    // 已经播放时间
    var costTime: TimeInterval = 0
    
    // 总时长
    var totalTime: TimeInterval = 0
    
    // 播放状态
    var isPlaying: Bool = false
}
