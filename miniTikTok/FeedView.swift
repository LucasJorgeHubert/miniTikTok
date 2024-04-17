//
//  FeedView.swift
//  miniTikTok
//
//  Created by Lucas Hubert on 16/04/24.
//

import SwiftUI
import AVKit

struct FeedView: View {
    var videos: [Video] = Video.mockVideos()
    @State private var scrollPosition: Int?
    @State private var player = AVPlayer()
    
    var pub = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(videos) { video in
                    FeedCell(video: video, player: player)
                        .id(video.id)
                        .onAppear { playFirst() }
                        .containerRelativeFrame([.horizontal, .vertical])
                }
            }
            .scrollTargetLayout()
        }
        .onAppear {
            player.actionAtItemEnd = .none
            player.seek(to: .zero)
            player.play()
        }
        .onReceive(pub) { (output) in
            player.seek(to: .zero)
            player.play()
        }
        .scrollPosition(id: $scrollPosition)
        .scrollTargetBehavior(.paging)
        .ignoresSafeArea()
        .onChange(of: scrollPosition) { oldValue, newValue in
            playVideoOnChange(videoId: newValue)
        }
    }
    
    func playFirst() {
        guard scrollPosition == nil, let video = videos.first, player.currentItem == nil else { return }
        let item = AVPlayerItem(url: video.compressedForIOSURL)
        player.replaceCurrentItem(with: item)
    }
    
    func playVideoOnChange(videoId: Int?) {
        guard let currentVideo = videos.first(where: { $0.id == videoId }) else { return }
        
        player.replaceCurrentItem(with: nil)
        let playerItem = AVPlayerItem(url: currentVideo.compressedForIOSURL)
        player.replaceCurrentItem(with: playerItem)
    }
}

#Preview {
    FeedView()
}
