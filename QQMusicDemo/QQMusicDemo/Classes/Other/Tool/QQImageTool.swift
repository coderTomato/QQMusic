//
//  QQImageTool.swift
//  QQMusicDemo
//
//  Created by 李军 on 2017/3/3.
//  Copyright © 2017年 李军. All rights reserved.
//

import UIKit

class QQImageTool: NSObject {
    class func getImage(_ sourceImage: UIImage, text:String?) ->UIImage{
        
        if text == nil || text! == "" {
            return sourceImage
        }
        // 1. 开启上下文
        UIGraphicsBeginImageContext(sourceImage.size);
        // 2. 绘制大图片
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: sourceImage.size.width, height: sourceImage.size.height));
        // 3. 绘制文字
        let style : NSMutableParagraphStyle = NSMutableParagraphStyle();
        style.alignment = .center;
        let dic: [String : AnyObject] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 18),
            NSForegroundColorAttributeName: UIColor.white,
            NSParagraphStyleAttributeName: style
        ]
        // 4. 获取合成图片
        (text! as NSString).draw(in: CGRect(x:0, y:0, width: sourceImage.size.width, height: 28), withAttributes: dic);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        // 5. 关闭上下文
        UIGraphicsEndImageContext();
        return image!;
    }
}
