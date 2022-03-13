//
//  CustomCell.swift
//  QuestionTest
//
//  Created by Najafe, Miwand on 2022-03-12.
//

import Foundation
import UIKit
import AVFoundation
import Combine

class CustomCell: UICollectionViewCell {
    private var cancelBag: Set<AnyCancellable> = []
    private(set) var playerView: PlayerView?
    var playerItem: AVPlayerItem?
    
    override var reuseIdentifier: String?{
        "cell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        playerView = nil
        playerView?.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    func setUpFromCache(_ player: AVPlayer) {
        playerView?.player = player
    }
    
    func setupPlayerView(_ player: AVPlayer) {
        if self.playerView == nil {
            self.playerView = PlayerView(player: player, gravity: .aspectFill)
            contentView.addSubview(playerView!)
            
            playerView?.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                playerView!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                playerView!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                playerView!.topAnchor.constraint(equalTo: contentView.topAnchor),
                playerView!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
            
            playerView?.player?.play()
            
            NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime).sink { [weak self] notification in
                if let p = notification.object as? AVPlayerItem, p == player.currentItem {
                    self?.playerView?.removeFromSuperview()
                    guard let self = self else { return }
                    NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
                }
            }.store(in: &cancelBag)
        } else {
            playerView?.player?.pause()
            playerView?.removeFromSuperview()
            playerView = nil
        }
    }
}
