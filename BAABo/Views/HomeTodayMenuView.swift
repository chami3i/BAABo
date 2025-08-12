//
//  HomeTodayMenuView.swift
//  BAABo
//
//  Created by Wren on 8/11/25.
//

import SwiftUI

struct HomeTodayMenuView: View {
    private var todayMenu: TodayMenuItem {
        menuItems.randomElement()!
    }
    
    var body: some View {
        
        
        
        VStack(alignment: .leading, spacing: 8) {
            Text("오늘의 메뉴 추천")
                .font(.headline)
                .foregroundColor(.black)
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .frame(height: 120)
                .overlay(
                    HStack(spacing: 16) {
                        
                        // 음식 이모지
                        Text(todayMenu.emoji)
                            .font(.system(size: 48))
                        
                        VStack(alignment: .leading, spacing: 6) {
                            // 메뉴 이름
                            Text(todayMenu.name)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            
                            // 간단한 설명
                            Text(todayMenu.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(2)
                        }
                    }
                        .padding(.horizontal, 20)
                )
        }
        
    }
}
