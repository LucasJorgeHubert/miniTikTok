//
//  PlayerController.swift
//  miniTikTok
//
//  Created by Lucas Hubert on 16/04/24.
//

import SwiftUI
import AVKit

struct FeedViewController: UIViewControllerRepresentable {
    
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> UIViewController {
        let ctrl = AVPlayerViewController()
        ctrl.player = player
        ctrl.showsPlaybackControls = false
        ctrl.exitsFullScreenWhenPlaybackEnds = false
        ctrl.allowsPictureInPicturePlayback = false
        ctrl.videoGravity = .resizeAspectFill
        return ctrl
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
