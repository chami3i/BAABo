//
//  HomeView.swift
//  BAABo
//
//  Created by Wren on 8/5/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Int = 1
    
    var body: some View {
        
        VStack(spacing: 16) {
            ZStack {
                Rectangle()
                        .fill(Color("MainOrange"))
                        .frame(height: 130)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                
                HStack {
                    Text("식당 정하러\n떠나자")
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                            .multilineTextAlignment(.leading)
                    
                    Spacer()

                    Button(action: {
                        print("방 만들기 버튼 눌림")
                    }) {
                        HStack(spacing: 6) {
                            Text("방 만들기")
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 15)
        .padding(.top, 10)
    }
}

#Preview {
    HomeView()
}
