//
//  HomeReviewView.swift
//  BAABo
//
//  Created by Wren on 8/12/25.
//

import SwiftUI

struct HomeReviewView: View {
    
    let nickname = "홍길동"
    let place = "오모오모 신세계점"
    
    @State private var didLike: Bool? = nil
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text("\(nickname)님, 최근에 방문하신\n\(place) 어떠셨어요?")
                .font(.headline)
                .foregroundColor(.black)
            
            Spacer()
            
            HStack(spacing: 30) {
                // 👍 좋았다 버튼
                Button(action: {
                    didLike = true
                }) {
                    HStack {
                        Text("👍")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(didLike == true ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(didLike == true ? Color.green : Color.clear, lineWidth: 1)
                    )
                }
                
                // 👎 싫었다 버튼
                Button(action: {
                    didLike = false
                }) {
                    HStack {
                        Text("👎")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(didLike == false ? Color.red.opacity(0.2) : Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(didLike == false ? Color.red : Color.clear, lineWidth: 1)
                    )
                }
            }
        }
        
    }
}
