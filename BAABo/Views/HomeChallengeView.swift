//
//  HomeChallengeView.swift
//  BAABo
//
//  Created by Wren on 8/11/25.
//

import SwiftUI

struct HomeChallengeView: View {
    
    @State private var collected: [Bool] = Array(repeating: false, count: 9) // 퀘스트 상태 저장 (획득 여부)
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text("챌린지")
                .font(.headline)
                .foregroundColor(.black)
            
            Spacer()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                ForEach(0..<quests.count, id: \.self) { index in
                    VStack(spacing: 8) {
                        Button(action: {
                            collected[index].toggle()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(collected[index] ? Color.orange : Color.gray.opacity(0.1))
                                    .frame(width: 100, height: 100)
                                    .shadow(radius: collected[index] ? 4 : 0)
                                
                                if collected[index] {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.white)
                                        .font(.title)
                                }
                            }
                        }
                        
                        // 퀘스트 텍스트
                        Text(quests[index])
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .frame(width: 80, height: 34)
                    }
                }
            }
        }
        
    }
}
