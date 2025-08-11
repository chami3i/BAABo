//
//  HomeWithView.swift
//  BAABo
//
//  Created by Wren on 8/12/25.
//

import SwiftUI

struct HomeWithView: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text("최근에 함께한 사람들")
                .font(.headline)
                .foregroundColor(.black)
            
            Spacer()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
                ForEach(people, id: \.name) { person in
                    VStack(spacing: 8) {
                        if let imageName = person.imageName, !imageName.isEmpty {
                            // ✅ 이미지가 있는 경우
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else {
                            // ✅ 이미지가 없는 경우: 그라데이션 + 이니셜
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: randomGradient),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 70, height: 70)
                                
                                // 이름의 첫 글자 또는 아이콘
                                Text(String(person.name.prefix(1)))
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Text(person.name)
                            .font(.caption)
                            .lineLimit(1)
                    }
                }
            }
        }
        
    }
}
