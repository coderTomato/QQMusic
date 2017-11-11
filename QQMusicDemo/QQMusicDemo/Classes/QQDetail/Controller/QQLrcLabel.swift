//
//  QQLrcLabel.swift
//  QQMusicDemo
//
//  Created by 李军 on 2017/3/3.
//  Copyright © 2017年 李军. All rights reserved.
//

import UIKit

class QQLrcLabel: UILabel {

    var progress : CGFloat = 0.0 {
        didSet {
            setNeedsDisplay();
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect);
        
        UIColor.green.set();
        
       UIRectFillUsingBlendMode(CGRect(x: 0, y: 0, width: rect.width * progress, height: rect.height), CGBlendMode.sourceIn);
    }
}
