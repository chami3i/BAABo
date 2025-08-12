//
//  AvatarStack.swift
//  BAABo
//
//  Created by Wren on 8/13/25.
//

// BAABo/Components/BubbleAvatarStack.swift
import SwiftUI

struct AvatarStack: View {
    let friends: [Friend]
    var maxBubbles: Int = 8
    var overlapSpacing: CGFloat = -16
    
    /// 크기 계산 - 인원 늘어날수록 전체 비율 축소
    private func size(for index: Int, totalCount: Int) -> CGFloat {
        let baseSize: CGFloat = 120 // 1~2명일 때 크기
        let minSize: CGFloat = 48   // 최소 크기
        // 축소 비율 계산 (2명일 땐 1.0, maxBubbles 이상이면 최소 크기)
        let ratio = max(0, min(1, 1 - CGFloat(totalCount - 2) / CGFloat(maxBubbles - 2)))
        // 비율에 맞춰 크기 보간
        let currentSize = minSize + (baseSize - minSize) * ratio
        return currentSize * (1 - CGFloat(index) * 0.05) // 뒤로 갈수록 살짝 더 작게
    }
    
    private func shadow(for size: CGFloat) -> CGFloat {
        max(2, size * 0.05)
    }
    
    private func bubble(imageName: String, size: CGFloat) -> some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 3))
            .shadow(radius: shadow(for: size), y: 2)
            .transition(.asymmetric(
                insertion: .scale.combined(with: .opacity),
                removal: .opacity
            ))
    }
    
    var body: some View {
        let shown = Array(friends.prefix(maxBubbles))
        let extra = max(friends.count - shown.count, 0)
        
        HStack(spacing: overlapSpacing) {
            ForEach(Array(shown.enumerated()), id: \.offset) { (idx, friend) in
                let sz = size(for: idx, totalCount: shown.count)
                bubble(imageName: friend.imageName, size: sz)
                    .zIndex(Double(idx))
            }
            
            if extra > 0 {
                Text("+\(extra)")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(width: 48, height: 48)
                    .background(
                        Circle()
                            .fill(Color.orange)
                            .overlay(Circle().stroke(.white, lineWidth: 3))
                            .shadow(radius: 3, y: 2)
                    )
                    .transition(.opacity)
                    .zIndex(Double(shown.count))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: friends.count)
        .frame(height: 130, alignment: .center)
    }
}

