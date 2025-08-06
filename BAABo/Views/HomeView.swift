//
//  HomeView.swift
//  BAABo
//
//  Created by Wren on 8/5/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Int = 1
    @State private var didLike: Bool? = nil
    // 퀘스트 상태 저장 (획득 여부)
    @State private var collected: [Bool] = Array(repeating: false, count: 9)
    
    let nickname = "홍길동"
    let place = "오모오모 신세계점"
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 16) {
                ZStack {
                    Rectangle()
                        .fill(Color.orange)
                        .frame(height: 130)
                        .cornerRadius(16)
                    
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

                
                // 🥘 오늘의 메뉴 추천
                VStack(alignment: .leading, spacing: 8) {
                    Text("오늘의 메뉴 추천")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 120)
                        .overlay(
                            Text("내용 표시 영역")
                                .foregroundColor(.gray)
                        )
                }
                
                Spacer()
                
                // 🥘 맛집 퀘스트
                VStack(alignment: .leading, spacing: 8) {
                    Text("랜덤 맛집 퀘스트")
                        .font(.headline)
                        .foregroundColor(.black)
                    
        
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 20) {
                                    ForEach(0..<9) { index in
                                        Button(action: {
                                            collected[index].toggle() // 상태 토글
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .fill(collected[index] ? Color.orange : Color.gray.opacity(0.1))
                                                    .frame(width: 80, height: 80)
                                                    .shadow(radius: collected[index] ? 4 : 0)

                                                if collected[index] {
                                                    Image(systemName: "star.fill")
                                                        .foregroundColor(.white)
                                                        .font(.title)
                                                } else {
                                                    Text("🎯")
                                                        .font(.largeTitle)
                                                }
                                            }
                                        }
                                    }
                                }
                                

                }
                
                Spacer()
                
                // 📝 최근 방문 식당 리뷰
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
                
                Spacer()
                
                // 📌 최근에 결정한 식당
                VStack(alignment: .leading, spacing: 8) {
                    Text("최근에 결정한 식당")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 60)
                        .overlay(
                            Text(" 내용 표시 영역")
                                .foregroundColor(.gray)
                        )
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 60)
                        .overlay(
                            Text(" 내용 표시 영역")
                                .foregroundColor(.gray)
                        )
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 60)
                        .overlay(
                            Text(" 내용 표시 영역")
                                .foregroundColor(.gray)
                        )
                }
                
                Spacer().frame(height: 100)
                
            }
            .padding(.horizontal, 30)
            .padding(.top, 10)
        }
    }
}

#Preview {
    HomeView()
}
