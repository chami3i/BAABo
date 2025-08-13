//
//  Router.swift
//  BAABo
//
//  Created by Wren on 8/12/25.
//

import Foundation
import SwiftUI

final class Router: ObservableObject {
    @Published var currentRoomId: String? = nil
    @Published var isHost: Bool = true
    @Published var selectedLocation: String = ""
    
    // 화면 이동 상태들
    @Published var navigateToInviteView: Bool = false
    @Published var navigateToMapView: Bool = false
    
    func resetRoom() {
        currentRoomId = nil
        isHost = true
        selectedLocation = ""
        navigateToInviteView = false
        navigateToMapView = false
    }
}


