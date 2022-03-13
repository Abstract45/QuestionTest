//
//  ViewController.swift
//  QuestionTest
//
//  Created by Najafe, Miwand on 2022-03-12.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    
    private var videosURLs: [String] = [
        "ElephantsDream2", "ElephantsDream", "ElephantsDream", "ElephantsDream", "ElephantsDream", "ElephantsDream", "ElephantsDream", "ElephantsDream", "ElephantsDream", "ElephantsDream", "ElephantsDream", "ElephantsDream", "ElephantsDream", "ElephantsDream",
        "ElephantsDream", "ElephantsDream", "ElephantsDream", "ElephantsDream",
        "ElephantsDream", "ElephantsDream", "ElephantsDream", "ElephantsDream",
        "ElephantsDream", "ElephantsDream", "ElephantsDream", "ElephantsDream"
    ]
    
    var cacheItem = [String: (cell: CustomCell, player: AVPlayer)]()

    override func viewDidLoad() {
        super.viewDidLoad()
            
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: ColumnFlowLayout())
        view.addSubview(collectionView)

        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomCell else { return }
        let item = videosURLs[indexPath.row]
        let viewModel = PlayerViewModel(fileName: item)
        cell.setupPlayerView(viewModel.player)
        cacheItem[item] = (cell, viewModel.player)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        videosURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = videosURLs[indexPath.row]
        if let cachedItem = cacheItem[item], indexPath.row == 0 {
            print(indexPath)
            print(item)
            cachedItem.cell.setUpFromCache(cachedItem.player)
            return cachedItem.cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCell else { return UICollectionViewCell() }
            cell.contentView.backgroundColor = .orange
            let url = Bundle.main.url(forResource: item, withExtension: "mp4")
            cell.playerItem = AVPlayerItem(url: url!)
            return cell
        }
    }
}

