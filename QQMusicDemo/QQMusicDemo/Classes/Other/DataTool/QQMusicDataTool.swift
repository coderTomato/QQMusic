//
//  QQMusicDataTool.swift
//  QQMusicTest
//
//  Created by 李军 on 2017/3/3.
//  Copyright © 2017年 李军. All rights reserved.
//

import UIKit

class QQMusicDataTool: NSObject {
    
    class func getMusicModels(models result: ([QQMusicModel])->()){
        //1.获取文件路径
        guard let path = Bundle.main.path(forResource: "Musics.plist", ofType: nil) else{
            result([QQMusicModel]());
            return ;
        }
        //2.读取文件内容
        guard let array = NSArray(contentsOfFile: path) else{
            result([QQMusicModel]());
            return;
        }
        //3.解析：转换成歌曲模型
        var models = [QQMusicModel]();
        for dict in array{
            let model = QQMusicModel(dic:dict as! [String : AnyObject])
            models.append(model)
        }
        
        //4.返回结果
        result(models)
    }

}
