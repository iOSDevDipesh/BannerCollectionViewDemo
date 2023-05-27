//
//  ViewController.swift
//  BannerCollectionViewDemo
//
//  Created by Zignuts Technolab on 18/05/23.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var btnAutoScroll: UIButton!
    
    // MARK: - Local var
    
    private let arrContentDetails:[URL] = [
        URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4")!,
        URL(string: "https://source.unsplash.com/1600x900/?nature")!,
        URL(string: "https://www.easygifanimator.net/images/samples/video-to-gif-sample.gif")!,
        URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")!,
        URL(string: "https://source.unsplash.com/1600x900/?water")!
    ]
    private var timer: Timer?
    private var autoScrollDuration:Double = 10.0
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopTimer()
    }
    
    // MARK: - Custom func
    
    private func setupUI() {
        self.setupCollectionView()
    }
    
    private func setupCollectionView() {
        self.collectionView.register(UINib(nibName: "BannerRowCell", bundle: nil), forCellWithReuseIdentifier: "BannerRowCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.isPagingEnabled = true
        self.pageControll.currentPage = 0
        self.pageControll.numberOfPages = self.arrContentDetails.count
    }
    
    private func playVideo(pageIndex: Int) {
        if let cell = self.collectionView.cellForItem(at: IndexPath(item: pageIndex, section: 0)) as? BannerRowCell {
            let url = self.arrContentDetails[pageIndex]
            let fileExtension = url.pathExtension.lowercased()
            if fileExtension == "mp4" {
                cell.playVideo()
            }
        }
    }
    
    private func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: self.autoScrollDuration, target: self, selector: #selector(scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
}


// MARK: - Actions

extension ViewController {
    
    @IBAction func btnAutoScrollAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.btnAutoScroll.setTitle(sender.isSelected ? "Disable Auto Scroll" : "Enable Auto Scroll", for: .normal)
        sender.isSelected ? self.startTimer() : self.stopTimer()
    }
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        
        guard self.arrContentDetails.count > 0 else { return }
        
        for cell in self.collectionView.visibleCells {
            if self.arrContentDetails.count == 1 {
                self.playVideo(pageIndex: 0)
                return
            }
            if let indexPath = self.collectionView.indexPath(for: cell) {
                if indexPath.row < (self.arrContentDetails.count - 1) {
                    let indexPath1 = IndexPath.init(row: indexPath.row + 1, section: indexPath.section)
                    self.collectionView.scrollToItem(at: indexPath1, at: .left, animated: false)
                    self.pageControll.currentPage = indexPath1.row
                    self.playVideo(pageIndex: indexPath1.row)
                }
                else {
                    let indexPath1 = IndexPath.init(row: 0, section: indexPath.section)
                    self.collectionView.scrollToItem(at: indexPath1, at: .left, animated: false)
                    self.pageControll.currentPage = indexPath1.row
                    self.playVideo(pageIndex: indexPath1.row)
                }
            }
        }
    }
}

// MARK: - UICollectionView dataSource and delgate methos

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrContentDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerRowCell", for: indexPath) as? BannerRowCell else { return .init() }
        
        if let previousCell = collectionView.visibleCells.first as? BannerRowCell {
            previousCell.pauseVideo()
        }
        
        cell.configure(with: self.arrContentDetails[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 30
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, shouldInvalidateLayoutForBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? BannerRowCell {
            cell.pauseVideo()
        }
    }
}

// MARK: - UIScrollView delegate method

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        self.pageControll.currentPage = pageIndex
        self.playVideo(pageIndex: pageIndex)
        print("PAGE INDEX scrollViewDidEndDecelerating: \(pageIndex)")
    }
}
