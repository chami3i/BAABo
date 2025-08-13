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
    @EnvironmentObject var router: Router
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        NavigationStack {
            
            // MARK: - TabBar
            ZStack(alignment: .bottom) {
                
                switch selectedTab {
                case .home:
                    HomeView()
                case .createRoom:
                    Color.clear
                        .onAppear {
                            selectedTab = .home
                            RoomService.createRoom { roomId in
                                if let id = roomId {
                                    DispatchQueue.main.async {
                                        router.currentRoomId = id
                                        router.isHost = true
                                        router.navigateToMapView = true
                                    }
                                }
                            }
                        }
                case .myPage:
                    MypageView()
                }
                
                if selectedTab == .home || selectedTab == .myPage {
                    CustomTabBar(selectedTab: $selectedTab)
                }
            }
            
            // 방장
            .navigationDestination(isPresented: $router.navigateToMapView) {
                if let roomId = router.currentRoomId {
                    MapView(roomId: roomId)
                }
            }
            
            // 참가자
            .navigationDestination(isPresented: $router.navigateToInviteView) {
                if let roomId = router.currentRoomId {
                    InviteView(roomCode: roomId, location: router.selectedLocation)
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Router())
}
