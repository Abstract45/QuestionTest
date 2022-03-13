//
//  PlayerView.swift
//  QuestionTest
//
//  Created by Najafe, Miwand on 2022-03-12.
//

import AVKit
import Combine
import UIKit

enum PlayerGravity {
    case aspectFill
    case resize
}

class PlayerView: UIView, AVPlayerPlaybackCoordinatorDelegate {
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    let gravity: PlayerGravity
    
    init(player: AVPlayer, gravity: PlayerGravity) {
        self.gravity = gravity
        super.init(frame: .zero)
        self.player = player
        self.backgroundColor = .black
        setupLayer()
    }
    
    func setupLayer() {
        switch gravity {
            
        case .aspectFill:
            playerLayer.contentsGravity = .resizeAspectFill
            playerLayer.videoGravity = .resizeAspectFill
            
        case .resize:
            playerLayer.contentsGravity = .resize
            playerLayer.videoGravity = .resize
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}

class PlayerViewModel: ObservableObject {
    
    lazy var player: AVPlayer = {
       AVPlayer(url: url)
    }()

    private var cancelBag: Set<AnyCancellable> = []
    private let url: URL
    
    init(fileName: String) {
        let url = Bundle.main.url(forResource: fileName, withExtension: "mp4")
        self.url = url!
    }
    
    @Published var isPlaying: Bool = false {
        didSet {
            if isPlaying {
                play()
            } else {
                pause()
            }
        }
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        let currentItem = player.currentItem
        currentItem?.seek(to: .zero, completionHandler: nil)
        player.pause()
    }
}

enum PlayerAction {
    case play
    case pause
}
