//
//  QQLrcViewController.swift
//  QQMusicDemo
//
//  Created by 李军 on 2017/3/3.
//  Copyright © 2017年 李军. All rights reserved.
//

import UIKit

class QQLrcViewController: UITableViewController {

    var lrcModelArr : [QQLrcModel] = [QQLrcModel](){
        didSet{
            tableView.reloadData();
        }
    }
    
    var scrollRow : Int = -1 {
        didSet {
            if scrollRow == oldValue{
                return;
            }
            tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: .fade);
            let indexPath = IndexPath(row: scrollRow, section: 0);
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true);
        }
    }
    
    var progress: CGFloat = 0 {
        didSet {
            // 修改cell ,里面歌词标签的进度
            let indexPath = IndexPath(row: scrollRow, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as? QQLrcCell
            cell?.progress = progress
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // 设置tablview背景色为空
        tableView.backgroundColor = UIColor.clear;
        tableView.separatorStyle = .none;
        //是否允许tableView选中
        tableView.allowsSelection = false;
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        tableView.contentInset = UIEdgeInsetsMake(tableView.height * 0.5, 0, tableView.height * 0.5, 0);
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return lrcModelArr.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = QQLrcCell.cellWithTableView(tableView);
        if scrollRow == indexPath.row {
            cell.progress = progress
        }else {
            cell.progress = 0
        }
       
        cell.lrcLabel.text = lrcModelArr[indexPath.row].lrcContent;
        return cell;
    }

}
