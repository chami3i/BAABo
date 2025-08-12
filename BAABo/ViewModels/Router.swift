//
//  Router.swift
//  BAABo
//
//  Created by Wren on 8/12/25.
//

import Foundation

class Router: ObservableObject {
    @Published var isHost: Bool = false
    @Published var navigateToMapView: Bool = false
    @Published var navigateToInviteView: Bool = false
    
    @Published var selectedLocation: String = ""
    @Published var currentRoomId: String? = nil
    
//    @Published var isShowingInviteView = false
//    @Published var currentRoomId: String? = nil
//    @Published var isHost: Bool = false
//    
//    // 초대자가 직접 InviteView로 들어왔는지 여부
//    @Published var isInviteDirectAccess = false
//
//    func navigateToInviteView(roomId: String, directAccess: Bool = false) {
//        currentRoomId = roomId
//        isShowingInviteView = true
//        isInviteDirectAccess = directAccess
//    }
//    
//    func dismissInviteView() {
//        isShowingInviteView = false
//        currentRoomId = nil
//        isInviteDirectAccess = false
//    }
}

