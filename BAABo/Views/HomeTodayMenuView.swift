//
//  HomeTodayMenuView.swift
//  BAABo
//
//  Created by Wren on 8/11/25.
//

import SwiftUI

struct HomeTodayMenuView: View {
    private let todayMenu: TodayMenuItem
    
    init() {
            let todayString = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)

            // UserDefaults에서 마지막 저장 날짜 확인
            let savedDate = UserDefaults.standard.string(forKey: "todayMenuDate")

            if savedDate == todayString {
                // 오늘 날짜면 메뉴를 그대로 유지
                let savedName = UserDefaults.standard.string(forKey: "todayMenuName") ?? ""
                if let matchedMenu = menuItems.first(where: { $0.name == savedName }) {
                    self.todayMenu = matchedMenu
                } else {
                    // 데이터 손상 시 새로 선택
                    let newMenu = menuItems.randomElement()!
                    self.todayMenu = newMenu
                    UserDefaults.standard.set(newMenu.name, forKey: "todayMenuName")
                    UserDefaults.standard.set(todayString, forKey: "todayMenuDate")
                }
            } else {
                // 날짜가 바뀌었으면 새로 선택
                let newMenu = menuItems.randomElement()!
                self.todayMenu = newMenu
                UserDefaults.standard.set(newMenu.name, forKey: "todayMenuName")
                UserDefaults.standard.set(todayString, forKey: "todayMenuDate")
            }
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
    private static var dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd" // 하루 단위 비교용
           return formatter
       }()
}
