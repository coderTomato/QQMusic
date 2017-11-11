//
//  QQLrcCell.swift
//  QQMusicDemo
//
//  Created by Robin on 17/11/11.
//  Copyright © 2017年 lijun. All rights reserved.
//

import UIKit

class QQLrcCell: UITableViewCell {

    @IBOutlet weak var lrcLabel: QQLrcLabel!
    
    var progress: CGFloat = 0 {
        didSet {
            lrcLabel.progress = progress
        }
    }
    
    var lrcM: QQLrcModel? {
        didSet {
            lrcLabel.text = lrcM?.lrcContent
        }
    }
    
    class func cellWithTableView(_ tableView: UITableView) -> QQLrcCell{
        let ID = "lrc";
        var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? QQLrcCell;
        if (cell == nil){
            cell = Bundle.main.loadNibNamed("QQLrcCell", owner: nil, options: nil)?.first as? QQLrcCell;
        }
        return cell!;
    }

}
