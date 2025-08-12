//
//  HomeVisitedView.swift
//  BAABo
//
//  Created by Wren on 8/12/25.
//

import SwiftUI

struct HomeVisitedView: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text("최근에 결정한 식당")
                .font(.headline)
                .foregroundColor(.black)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 16) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(height: 60)
                    .shadow(radius: 3)
                    .overlay(
                        VStack(alignment: .leading, spacing: 4) {
                            Text("버거킹 포항공대점")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            Text("경북 포항시 남구 청암로 77 · 11:00 - 20:00")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8),
                        alignment: .leading
                    )
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(height: 60)
                    .shadow(radius: 3)
                    .overlay(
                        VStack(alignment: .leading, spacing: 4) {
                            Text("탐솥 효자점")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            Text("경북 포항시 남구 효자동길5번길 17 · 11:00 - 21:00")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8),
                        alignment: .leading
                    )
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(height: 60)
                    .shadow(radius: 3)
                    .overlay(
                        VStack(alignment: .leading, spacing: 4) {
                            Text("수가성")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            Text("경북 포항시 북구 상대로 31 · 00:00 - 24:00")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8),
                        alignment: .leading
                    )
            }
        }
        
    }
}
