//
//  QQListViewController.swift
//  QQMusicTest
//
//  Created by 李军 on 2017/3/3.
//  Copyright © 2017年 李军. All rights reserved.
//

import UIKit

class QQListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        QQMusicDataTool.getMusicModels { (models:[QQMusicModel]) in
            print(models);
        }
    }

   

}
