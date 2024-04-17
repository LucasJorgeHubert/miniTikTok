//
//  FeedCell.swift
//  miniTikTok
//
//  Created by Lucas Hubert on 16/04/24.
//

import SwiftUI
import AVKit

struct FeedCell: View {
    let video: Video
    let player: AVPlayer
    
    init(video: Video, player: AVPlayer) {
        self.video = video
        self.player = player
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            VStack {
                SwipeAction(direction: .left) {
                    FeedViewController(player: player)
                } actions: {
                    Action(icon: "heart") {
                        print("Like")
                    }
                }
                .containerRelativeFrame(.horizontal)
            }
            
            .onTapGesture {
                switch player.timeControlStatus {
                case .paused:
                    player.play()
                case .waitingToPlayAtSpecifiedRate:
                    break
                case .playing:
                    player.pause()
                @unknown default:
                    break
                }
            }
        }
        
    }
   
}

struct SwipeAction<Content: View>: View {
    var direction: SwipeDirection = .left
    @ViewBuilder var content: Content
    @ActionBuilder var actions: [Action]
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    content
                        .containerRelativeFrame(.horizontal)
                    
                    self.actionButtons()
                }
                .scrollTargetLayout()
                .visualEffect { content, geometryProxy in
                    content
                        .offset(x: scrollOffset(geometryProxy))
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
        }
    }
    
    
    func actionButtons() -> some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: CGFloat(actions.count) * 100)
            .overlay(alignment: direction.alignment) {
                HStack(spacing: 0) {
                    ForEach(actions) { button in
                        Button(action: {
                            button.action()
                        }, label: {
                            Image(systemName: button.icon)
                                .frame(width: 100)
                                .foregroundStyle(.black)
                                .frame(maxHeight: .infinity)
                                .contentShape(Rectangle())
                        })
                        .buttonStyle(PlainButtonStyle())
                        .background(Color.red)
                    }
                }
            }
    }
    
    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        
        return direction == .right ? (minX > 0 ? -minX : 0) : (minX < 0 ? -minX : 0)
    }
}


enum SwipeDirection {
    case left
    case right
    
    var alignment: Alignment {
        switch self {
        case .left:
            return .leading
        case .right:
            return .trailing
        }
    }
}

struct Action: Identifiable {
    private(set) var id = UUID()
    var icon: String
    var action: () -> ()
}

@resultBuilder
struct ActionBuilder {
    static func buildBlock(_ components: Action...) -> [Action] {
        return components
    }
}

#Preview {
    FeedCell(video: Video.mockVideos()[0], player: AVPlayer(url: Video.mockVideos()[0].compressedForIOSURL))
}
