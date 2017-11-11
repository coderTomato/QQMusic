//
//  QQListViewController.swift
//  QQMusicTest
//
//  Created by 李军 on 2017/3/3.
//  Copyright © 2017年 李军. All rights reserved.
//

import UIKit

class QQListViewController: UITableViewController {

    var musics : [QQMusicModel] = [QQMusicModel](){
        didSet{
            tableView.reloadData();
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInit();
        
        QQMusicDataTool.getMusicModels { (models:[QQMusicModel]) in
            self.musics = models;
            QQMusicOperationTool.shareInstance.musics = models;
        }
    }
}

extension QQListViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musics.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = QQMusicCell.cellWithTableView(tableView: tableView);
        cell.musicModel = musics[indexPath.row];
        cell.aniation(type:.scale);
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = musics[indexPath.row];
        QQMusicOperationTool.shareInstance.playMusic(musicModel: model);
        performSegue(withIdentifier: "listToDetail", sender: nil);
    }
}

extension QQListViewController{
    func setTableView(){
        let imageView = UIImageView(image: UIImage(named: "QQListBack.jpg"))
        tableView.backgroundView = imageView;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
    }
    
    func setupInit(){
        navigationController?.isNavigationBarHidden = true;
        setTableView();
    }
    
    // 设置状态栏显示
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
