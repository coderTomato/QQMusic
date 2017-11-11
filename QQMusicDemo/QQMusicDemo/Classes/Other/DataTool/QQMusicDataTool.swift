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
    
    class func getLrcModels(_ lrcName:String) ->[QQLrcModel]{
        // 1. 获取歌词文件的路径
        guard let path = Bundle.main.path(forResource: lrcName, ofType: nil) else {
            return [QQLrcModel]()
        }
        // 2. 获取歌词文件的内容
        var lrcContent : String?
        do{
            lrcContent = try String(contentsOfFile: path)
        }catch{
            
            return [QQLrcModel]()
        }
        
        if lrcContent == nil{
            return [QQLrcModel]()
        }
        
        // 3. 解析歌词
        var lrcModelArray = [QQLrcModel]()
        
        let timeContentArray = lrcContent?.components(separatedBy: "\n");
        
        for timeContentStr in timeContentArray!{
            if (timeContentStr.contains("[ti:") || timeContentStr.contains("[ar:") || timeContentStr.contains("[al:")){
                continue;
            }
            let resultLrcStr = timeContentStr.replacingOccurrences(of: "[", with: "");
            let timeAndLrc = resultLrcStr.components(separatedBy: "]");
            if (timeAndLrc.count == 2){
                let time = timeAndLrc[0];
                let lrc = timeAndLrc[1];
                let lrcModel = QQLrcModel();
                lrcModel.startTime = QQTimeTool.getTime(time);
                lrcModel.lrcContent = lrc;
                lrcModelArray.append(lrcModel);
            }
        }
        
        for i in 0..<lrcModelArray.count {
            if (i == lrcModelArray.count - 1){
                break;
            }
            lrcModelArray[i].endTime = lrcModelArray[i+1].startTime;
        }
        return lrcModelArray;
    }
    
    class func getRowLrcModel(_ lrcModels:[QQLrcModel], currentTime:TimeInterval) -> (row:Int, lrcM:QQLrcModel?){
        for i in 0..<lrcModels.count {
            if (currentTime > lrcModels[i].startTime && currentTime < lrcModels[i].endTime){
                return (i,lrcModels[i]);
            }
        }
        return (0,nil);
    }

}
