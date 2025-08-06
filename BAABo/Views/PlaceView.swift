//
//  PlaceView.swift
//  BAABo
//
//  Created by chaem on 8/4/25.
//

import SwiftUI

struct PlaceView: View {
    
    //    init() {
    //        print("식당 선택 화면 생성")
    //    }
    
    @State private var remainingTime: Int = 180
    @State private var timerActive: Bool = true
    
    // 나의 선택 끝! 버튼 눌렀는지
    @State private var selectedPlace: Bool = false
    // 결과 페이지로 이동
    @State private var moveToResultView: Bool = false
    
    // 타이머 생성
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack (spacing: 20){
                    
                    HStack {
                        Text("식당 선택")
                            .font(.largeTitle)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        Image(systemName:   "timer.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                            
                        Text(timeString(from: remainingTime))
                            .font(.title)
                            .monospacedDigit()
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal)
                    
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        NavigationLink(destination: Text("이미지 보는 걸로? 메뉴판?")) {
                            ImageCardView(imageName: "포항순이", title: "포항 순이", category: "일본식라멘",status: "영업 중", hours: "11:30 - 20:30",  rating: "5.0", destination:  { AnyView(Text("포항순이 상세 페이지"))} )
                        }
                        
                        NavigationLink(destination: Text("소노이에 상세 페이지")) {
                            ImageCardView(imageName: "소노이에", title: "소노이에", category: "일식당",status: "영업 중", hours: "11:00 - 20:30", rating: "4.7", destination: {AnyView(Text("소노이에 상세 페이지"))} )
                        }
                        
                        NavigationLink(destination: Text("효자동수우동 상세 페이지")) {
                            ImageCardView(imageName: "효자동수우동", title: "효자동수우동", category: "우동, 소바",status: "영업 중", hours: "11:30 - 20:00", rating: "4.1", destination:  {AnyView(Text("효자동수우동 상세 페이지"))} )
                        }
                        
                        NavigationLink(destination: Text("포항 순이 상세 페이지")) {
                            ImageCardView(imageName: "포항순이", title: "포항 순이", category: "일본식라멘",status: "영업 중", hours: "11:30 - 20:30",  rating: "5.0", destination:  { AnyView(Text("포항순이 상세 페이지"))} )
                        }
                        
                        NavigationLink(destination: Text("소노이에 상세 페이지")) {
                            ImageCardView(imageName: "소노이에", title: "소노이에", category: "일식당",status: "영업 중", hours: "11:00 - 20:30", rating: "4.7", destination: {AnyView(Text("소노이에 상세 페이지"))} )
                        }
                        
                        NavigationLink(destination: Text("효자동수우동 상세 페이지")) {
                            ImageCardView(imageName: "효자동수우동", title: "효자동수우동", category: "우동, 소바",status: "영업 중", hours: "11:30 - 20:00", rating: "4.1", destination:  {AnyView(Text("효자동수우동 상세 페이지"))} )
                        }
                    }
                    HStack {
                        Button("나의 선택 끝!") {
                            selectedPlace = true
                        }
                            .font(.title)
                            .bold()
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(20)
                            //.disabled(!timerActive)
                        
                        Button("결과 보기") {
                            // moveToResultView = true
                        }
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(20)
                        .disabled(timerActive)
                    }
                    
                    if selectedPlace {
                        Text("선택 완료! \(timeString(from: remainingTime)) 후 오늘의 식당이 공개됩니다!")
                    }
                    
                    // Spacer()
                }
                .padding()
                //.navigationTitle("식당")
            }
            
        }
        .onReceive(timer) { _ in
            guard timerActive else { return }
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                timerActive = false
                //moveToResultView() = true
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
    var destination: ()-> AnyView
    
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
                    
                    NavigationLink(destination: destination()) {
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.title)
                            .foregroundColor(.orange)
                            .background(Color.orange.opacity(0.5))
                            .clipShape(Circle())
                            
                    }
                }
                .padding(10)
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .frame(maxWidth: .infinity, minHeight: 60)
                .padding([.horizontal, .bottom], 10)
                
            }
        }
    }
}


#Preview {
    PlaceView()
}
