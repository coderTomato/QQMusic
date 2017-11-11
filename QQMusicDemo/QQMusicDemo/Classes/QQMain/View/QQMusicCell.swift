//
//  QQMusicCell.swift
//  QQMusicTest
//
//  Created by 李军 on 2017/3/3.
//  Copyright © 2017年 李军. All rights reserved.
//

import UIKit

enum AnimationType{
    case rotation
    case scale
}

class QQMusicCell: UITableViewCell {

    @IBOutlet weak var singerIconImageView: UIImageView!
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    @IBOutlet weak var singerNameLabel: UILabel!
    
   
    var musicModel : QQMusicModel?{
        didSet{
            singerIconImageView.image = UIImage(named: (musicModel?.singerIcon)!);
            songNameLabel.text = musicModel?.name;
            singerNameLabel.text = musicModel?.singer;
        }
    }
    
    class func cellWithTableView(tableView:UITableView) ->QQMusicCell{
        let cellId = "music";
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil{
            cell = Bundle.main.loadNibNamed("QQMusicCell", owner: nil, options: nil)?.first as! QQMusicCell?;
            
        }
        return cell as! QQMusicCell;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func aniation(type: AnimationType){
        if type == .rotation{
            self.layer.removeAnimation(forKey: "rotation");
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z");
            animation.values = [-1/6 * M_PI, 0, 1/6 * M_PI, 0];
            animation.duration = 0.2;
            animation.repeatCount = 3;
            self.layer.add(animation, forKey: "rotation");
        }
        if type == .scale{
            self.layer.removeAnimation(forKey: "scale");
            let animation = CABasicAnimation(keyPath: "transform.scale");
            animation.fromValue = 0.5;
            animation.toValue = 1;
            animation.duration = 1;
            animation.repeatCount = 1;
            self.layer.add(animation, forKey: "scale");
        }
    }
    
}
