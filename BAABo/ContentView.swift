//
//  ContentView.swift
//  BAABo
//
//  Created by chaem on 8/4/25.
//

import SwiftUI

enum Tab {
    case home
    case createRoom
    case myPage
}

struct ContentView: View {
    
    @State private var selectedTab: Tab = .home
    @State private var createdRoomId: String? = nil
    @State private var isNavigation = false
    
    var body: some View {
        NavigationStack {
            // Tab
            ZStack(alignment: .bottom) {
                
                // 콘텐츠 영역
                Group {
                    switch selectedTab {
                    case .home:
                        HomeView()
                    case .createRoom:
                        Color.clear
                            .onAppear {
                                
                                selectedTab = .home
                                
                                RoomService.createRoom { roomId in
                                    if let id = roomId {
                                        self.createdRoomId = id
                                        self.isNavigation = true
                                    } else {
                                        print("방 생성 실패")
                                    }
                                }
                            }
                    case .myPage:
                        MypageView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // 커스텀 탭바 (selectedTab: $selectedTab)
                if selectedTab == .home || selectedTab == .myPage {
                    CustomTabBar(selectedTab: $selectedTab)
                }
            }
            
            .navigationDestination(isPresented: .constant(createdRoomId != nil)) {
                if let roomId = createdRoomId {
                    MapView(roomId: roomId)
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
