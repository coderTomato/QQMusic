//
//  QQTimeTool.swift
//  QQMusicTest
//
//  Created by 李军 on 2017/3/3.
//  Copyright © 2017年 李军. All rights reserved.
//

import UIKit

class QQTimeTool: NSObject {
    
    class func getFormatTime(timeInterval: TimeInterval) ->String{
        let min = Int(timeInterval) / 60;
        let sec = Int(timeInterval) % 60;
        return String(format: "%02d: %02d", min,sec);
    }
    
    class func getTime(_ formatTime:String) -> TimeInterval{
       // 00:00.00
        let minsecs = formatTime.components(separatedBy: ":");
        if minsecs.count == 2{
            let min = Double(minsecs[0]);
            let sec = Double(minsecs[1]);
            return min! * 60 + sec!;
        }
        return 0;
    }

}
