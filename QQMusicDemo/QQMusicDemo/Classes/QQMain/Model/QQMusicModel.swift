//
//  QQMusicModel.swift
//  QQMusicTest
//
//  Created by 李军 on 2017/3/3.
//  Copyright © 2017年 李军. All rights reserved.
//

import UIKit

class QQMusicModel: NSObject {
    
    /** 歌曲名称 */
    var name: String?
    /** 歌曲文件名称 */
    var filename: String?
    /** 歌词文件名称 */
    var lrcname: String?
    /** 歌手名称 */
    var singer: String?
    /** 歌手头像名称 */
    var singerIcon: String?
    /** 专辑头像图片 */
    var icon: String?
    
    override init(){
        super.init()
    }
    
    init(dic: [String : AnyObject]){
        super.init();
        setValuesForKeys(dic);
    }
}
