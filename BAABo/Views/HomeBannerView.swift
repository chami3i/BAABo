//
//  HomeBannerView.swift
//  BAABo
//
//  Created by Wren on 8/12/25.
//

import SwiftUI

struct HomeBannerView: View {
    
    @State private var createdRoomId: String? = nil
    @State private var isNavigation = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(Color.orange)
                    .frame(height: 130)
                    .cornerRadius(16)
                
                HStack {
                    Text("식당 정하러\n떠나자!")
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        RoomService.createRoom() { roomId in
                            if let id = roomId {
                                self.createdRoomId = id
                                self.isNavigation = true
                            }
                        }
                    }) {
                        HStack(spacing: 6) {
                            Text("방 만들기")
                                .font(.body)
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 30)
                
            }
            .navigationDestination(isPresented: .constant(createdRoomId != nil)) {
                if let roomId = createdRoomId {
                    MapView(roomId: roomId)
                }
            }
        }
    }
}
