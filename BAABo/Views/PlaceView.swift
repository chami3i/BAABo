//
//  PlaceView.swift
//  BAABo
//
//  Created by chaem on 8/4/25.
//

import SwiftUI

struct PlaceView: View {
    
    var category: String
    
    @State private var remainingTime: Int = 120
    @State private var timerActive: Bool = true
    
    // 결과 페이지로 이동
    @State private var moveToPlaceResultView: Bool = false
    
    // 타이머 생성
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack (spacing: 20){
                    
                    Text("\(category)")
                        .font(.title)
                        .underline()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom, -15)
                    
                    // 상단 타이틀, 타이머 UI
                    HStack {
                        Text("식당 선택")
                            .font(.largeTitle)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        Group {
                            Image(systemName:   "timer.circle.fill")
                                .font(.title2)
                            
                            Text(timeString(from: remainingTime))
                                .font(.title)
                                .monospacedDigit()
                        }
                        .foregroundColor(timerActive ? .orange : .gray)
                    }
                    .padding(.horizontal)
                    
                    // 식당 카드
                    VStack(alignment: .leading, spacing: 20) {
                    
                        NavigationLink(destination: Text("포항 순이 상세 페이지")) {
                            ImageCardView(imageName: "포항순이", title: "포항 순이", category: "일본식라멘",status: "영업 중", hours: "11:30 - 20:30",  rating: "5.0", isEnabled: timerActive)
                        }
                        
                        NavigationLink(destination: Text("소노이에 상세 페이지")) {
                            ImageCardView(imageName: "소노이에", title: "소노이에", category: "일식당",status: "영업 중", hours: "11:00 - 20:30", rating: "4.7", isEnabled: timerActive)
                        }
                        
                        NavigationLink(destination: Text("효자동수우동 상세 페이지")) {
                            ImageCardView(imageName: "효자동수우동", title: "효자동수우동", category: "우동, 소바",status: "영업 중", hours: "11:30 - 20:00", rating: "4.1", isEnabled: timerActive)
                        }
                        
                        NavigationLink(destination: Text("포항 순이 상세 페이지")) {
                            ImageCardView(imageName: "포항순이", title: "포항 순이", category: "일본식라멘",status: "영업 중", hours: "11:30 - 20:30",  rating: "5.0", isEnabled: timerActive)
                        }
                        
                        NavigationLink(destination: Text("소노이에 상세 페이지")) {
                            ImageCardView(imageName: "소노이에", title: "소노이에", category: "일식당",status: "영업 중", hours: "11:00 - 20:30", rating: "4.7", isEnabled: timerActive)
                        }
                        
                        NavigationLink(destination: Text("효자동수우동 상세 페이지")) {
                            ImageCardView(imageName: "효자동수우동", title: "효자동수우동", category: "우동, 소바",status: "영업 중", hours: "11:30 - 20:00", rating: "4.1", isEnabled: timerActive)
                        }
                    }
                    
                    // 결과 보기 버튼
                    Button(action : {
                        moveToPlaceResultView = true
                    }) {
                        Text(timerActive ? "\(timeString(from: remainingTime)) 후 결과 보기" : "결과 보기")
                            .font(.title)
                            .bold()
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .padding()
                            .background(
                                timerActive
                                ? Color.gray.opacity(0.4)
                                : Color.orange)
                            .cornerRadius(20)
                    }
                    .disabled(timerActive)
                    
                    // Spacer()
                }
                .padding()
                //.navigationTitle("식당")
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $moveToPlaceResultView) {
                PlaceResultView()
            }
            
        }
        // 타이머
        .onReceive(timer) { _ in
            guard timerActive else { return }
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                timerActive = false
            }
        }
    }
}

// 타이머 표시를 위한 함수
func timeString(from seconds: Int) -> String {
    let minutes = seconds / 60
    let seconds = seconds % 60
    return String(format: "%02d:%02d", minutes, seconds)
}


struct ImageCardView: View {
    var imageName: String
    var title: String
    var category: String
    var status: String
    var hours: String
    var rating: String
    var isEnabled: Bool
    
    @State private var isFavorite = false
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 370, height: 200)
                .clipped()
                .cornerRadius(20)
            
            VStack {
                HStack {
                    Text("⭐️ \(rating)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(6)
                        .background(Color.white)
                        .cornerRadius(20)
                    
                    Spacer()
                    
                    Button(action: {
                        isFavorite.toggle()
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .orange : .white)
                            .padding(6)
                            .background(Color.white.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                .padding([.horizontal, .top], 10)
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(title)
                                .font(.title)
                                .bold()
                                .foregroundColor(.black)
                            
                            Text(category)
                                .font(.footnote)
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text(status)
                                .font(.callout)
                                .foregroundColor(.black)
                            
                            Text(hours)
                                .font(.callout)
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                }
                .padding(10)
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .frame(maxWidth: .infinity, minHeight: 60)
                .padding([.horizontal, .bottom], 10)
            }
            
            if !isEnabled {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.8))
                        .cornerRadius(20)
                    Text("선택 마감")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
        }
    }
}


#Preview {
    PlaceView(category: "돈가스·회·일식")
}
