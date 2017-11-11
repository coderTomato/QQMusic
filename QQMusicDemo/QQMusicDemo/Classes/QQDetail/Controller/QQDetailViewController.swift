//
//  QQDetailViewController.swift
//  QQMusicTest
//
//  Created by 李军 on 2017/3/3.
//  Copyright © 2017年 李军. All rights reserved.
//

import UIKit

class QQDetailViewController: UIViewController {
    
    /** 背景图片 */
    @IBOutlet weak var bgImgView: UIImageView!
    
    /** 歌曲名称 */
    @IBOutlet weak var songNameLabel: UILabel!
    /** 歌手名称 */
    @IBOutlet weak var singerNameLabel: UILabel!
    
    // 歌词的视图
    lazy var lrcViewController : QQLrcViewController = {
        return QQLrcViewController();
    }()
    /** 歌词动画背景 */
    @IBOutlet weak var lrcScrollView: UIScrollView!
    /** 前背景图片*/
    @IBOutlet weak var foreImgView: UIImageView!
    /** 歌词label  */
    @IBOutlet weak var lrcLabel: QQLrcLabel!
    
    /** 进度条 */
    @IBOutlet weak var progressSlider: UISlider!
    /** 已经播放时长 */
    @IBOutlet weak var costTimeLabel: UILabel!
    /** 总时长 */
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    @IBOutlet weak var playOrPauseBtn: UIButton!
    // 负责更新的timer
    var timer: Timer?;
    
    var updateLink : CADisplayLink?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI();
        
        NotificationCenter.default.addObserver(self, selector: #selector(nextMusic), name: NSNotification.Name(rawValue: kplayEnd), object: nil);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        addTimer();
        addDisplayLink();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        removeTimer();
        removeDisplayLink();
    }
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    // 关闭控制器
    @IBAction func close() {
        navigationController?.popViewController(animated: true);
    }
    // 播放或者暂停
   
    @IBAction func playOrpause(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected;
        if (sender.isSelected){
            QQMusicOperationTool.shareInstance.playCurrentMusic();
            resumeRotationAnimation();
        }else{
            QQMusicOperationTool.shareInstance.pauseCurrentMusic();
            pauseRotationAnimation();
        }
    }
    
    // 上一首
    @IBAction func preMusic() {
        QQMusicOperationTool.shareInstance.preMusic();
        setUpOnce();
    }
    
    // 下一首
    @IBAction func nextMusic() {
        QQMusicOperationTool.shareInstance.nextMusic();
        setUpOnce();
    }
    
    func addTimer(){
        timer = Timer(timeInterval: 1, target: self, selector: #selector(setUpTimes), userInfo: nil, repeats: true);
        RunLoop.current.add(timer!, forMode: .commonModes);
    }
    
    // 移除定时器
    func removeTimer(){
        timer?.invalidate();
        timer = nil
    }

    func setupUI(){
        addLrcView();
        setUpLrcScrollView();
        setupSlider();
        setUpOnce();
        //创建毛玻璃效果
        let blur = UIBlurEffect(style: UIBlurEffectStyle.light);
        //创建毛玻璃视图
        let effectView = UIVisualEffectView(effect: blur);
        effectView.frame = self.bgImgView.bounds;
        //毛玻璃视图加入图片view上
        self.bgImgView .addSubview(effectView);
    }
    
    func addDisplayLink(){
        updateLink = CADisplayLink(target: self, selector: #selector(updateLrcData));
        updateLink?.add(to: RunLoop.current, forMode: .commonModes);
    }
    
    func removeDisplayLink(){
        updateLink?.invalidate();
        updateLink = nil;
    }
}

extension QQDetailViewController{
    // 当歌曲切换时, 需要更新一次的操作
    func setUpOnce(){
        let musicMsgModel = QQMusicOperationTool.shareInstance.getMusicMessageModel();
        guard let musicModel = musicMsgModel.musicModel else {
            return;
        }
        if musicModel.icon != nil{
            /** 背景图片 */
            bgImgView.image = UIImage(named: musicModel.icon!);
            /** 前背景图片*/
            foreImgView.image = UIImage(named: musicModel.icon!);
        }
        
        /** 歌曲名称 */
        songNameLabel.text = musicModel.name;
        /** 歌手名称 */
        singerNameLabel.text = musicModel.singer;
        /** 总时长 1*/
        totalTimeLabel.text =  QQTimeTool.getFormatTime(timeInterval: musicMsgModel.totalTime);
        
        addRotationAnimation();
        if (musicMsgModel.isPlaying){
            resumeRotationAnimation();
        }else{
            pauseRotationAnimation();
        }
        let lrcModels = QQMusicDataTool.getLrcModels(musicModel.lrcname!);
        lrcViewController.lrcModelArr = lrcModels;
    }
    
    // 当歌曲切换时, 需要更新N次的操作
    func setUpTimes(){
        let musicMsgModel = QQMusicOperationTool.shareInstance.getMusicMessageModel();
        /** 进度条 */
        progressSlider.value = Float(CGFloat(musicMsgModel.costTime / musicMsgModel.totalTime));
        /** 已经播放时长 */
        costTimeLabel.text = QQTimeTool.getFormatTime(timeInterval: musicMsgModel.costTime);
        playOrPauseBtn.isSelected = musicMsgModel.isPlaying;
    }
    func updateLrcData(){
        let musicMsgModel = QQMusicOperationTool.shareInstance.getMusicMessageModel();
        //获取当前播放时间
        let time = musicMsgModel.costTime;
        //歌词数组
        let rowLrcModel = QQMusicDataTool.getRowLrcModel(lrcViewController.lrcModelArr, currentTime: time);
        
        //滚动到对应行
        lrcViewController.scrollRow = rowLrcModel.row;
        // 给歌词label, 赋值
        lrcLabel.text = rowLrcModel.lrcM?.lrcContent;
        
        //更新歌词进度
        if (rowLrcModel.lrcM != nil){
            let progressTime = CGFloat(musicMsgModel.costTime - (rowLrcModel.lrcM?.startTime)!);
            let totalTime = CGFloat((rowLrcModel.lrcM?.endTime)! - (rowLrcModel.lrcM?.startTime)!);
            
            let progress = progressTime / totalTime;
            
            lrcViewController.progress = progress;
            lrcLabel.progress = progress;
        }
        
        // 更新锁屏界面信息
        if UIApplication.shared.applicationState == .background
        {
            QQMusicOperationTool.shareInstance.setUpLockMessage()
        }
    }
}

// 界面操作
extension QQDetailViewController{
    
    // 设置进度条图标
    func setupSlider(){
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: .normal);
        
    }
    // 设置前景图片的圆角效果
    func setUpForeImageView(){
        foreImgView.layer.cornerRadius = foreImgView.width * 0.5;
        foreImgView.layer.masksToBounds = true;
    }
    
    // 添加歌词视图
    func addLrcView(){
        lrcViewController.tableView.backgroundColor = UIColor.clear;
        lrcScrollView.addSubview(lrcViewController.tableView);
    }
    
    // 调整歌词视图frame
    func setLrcViewFrame(){
        lrcViewController.tableView.frame = lrcScrollView.bounds;
        lrcViewController.tableView.x = lrcScrollView.width;
        lrcScrollView.contentSize = CGSize(width: lrcScrollView.width * 2, height: 0);
    }
    
    func setUpLrcScrollView(){
        lrcScrollView.isPagingEnabled = true;
        lrcScrollView.showsHorizontalScrollIndicator = false;
    }
    // 系统重新布局子控件的方法(在这个方法里面, 可以获取到最后正确的frame, 所以, 一般把控件的布局, 写到这个位置)
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        setLrcViewFrame();
        setUpForeImageView();
    }
    // 设置状态栏显示
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

extension QQDetailViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x;
        let radio = 1 - x / scrollView.width;
        foreImgView.alpha = radio;
        lrcLabel.alpha = radio;
    }
    
    func addRotationAnimation(){
        foreImgView.layer.removeAnimation(forKey: "rotation");
        let animation = CABasicAnimation(keyPath: "transform.rotation.z");
        animation.fromValue = 0;
        animation.toValue = M_PI * 2;
        animation.duration = 30;
        animation.isRemovedOnCompletion = false;
        animation.repeatCount = MAXFLOAT;
        foreImgView.layer.add(animation, forKey: "rotation");
    }
    
    func pauseRotationAnimation(){
        foreImgView.layer.pauseAnimate();
    }
    
    func resumeRotationAnimation(){
        foreImgView.layer.resumeAnimate();
    }
}

// 远程事件
extension QQDetailViewController{
    override func remoteControlReceived(with event: UIEvent?) {
        switch (event?.subtype)! {
        case .remoteControlPlay:
            print("播放")
            QQMusicOperationTool.shareInstance.playCurrentMusic()
        case .remoteControlPause:
            print("暂停")
            QQMusicOperationTool.shareInstance.pauseCurrentMusic()
        case .remoteControlNextTrack:
            print("下一首")
            QQMusicOperationTool.shareInstance.nextMusic()
        case .remoteControlPreviousTrack:
            print("上一首")
            QQMusicOperationTool.shareInstance.preMusic()
        default:
            print("none")
        }
        setUpOnce()
    }
    
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        QQMusicOperationTool.shareInstance.nextMusic()
        setUpOnce()
    }
}


