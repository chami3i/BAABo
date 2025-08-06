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
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack (spacing: 20){
                    
                    Text("식당 선택")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        NavigationLink(destination: Text("포항 순이 상세 페이지")) {
                            ImageCardView(imageName: "포항순이", title: "포항 순이", category: "일본식라멘",status: "영업 중", hours: "11:30 - 20:30",  rating: "5.0", destination:  { AnyView(Text("포항순이 상세 페이지"))} )
                        }
                        
                        NavigationLink(destination: Text("소노이에 상세 페이지")) {
                            ImageCardView(imageName: "소노이에", title: "소노이에", category: "일식당",status: "영업 중", hours: "11:0    0 - 20:30", rating: "4.7", destination: {AnyView(Text("소노이에 상세 페이지"))} )
                        }
                        
                        NavigationLink(destination: Text("효자동수우동 상세 페이지")) {
                            ImageCardView(imageName: "효자동수우동", title: "효자동수우동", category: "우동, 소바",status: "영업 중", hours: "11:30 - 20:00", rating: "4.1", destination:  {AnyView(Text("효자동수우동 상세 페이지"))} )
                        }
                        
                        NavigationLink(destination: Text("포항 순이 상세 페이지")) {
                            ImageCardView(imageName: "포항순이", title: "포항 순이", category: "일본식라멘",status: "영업 중", hours: "11:30 - 20:30",  rating: "5.0", destination:  { AnyView(Text("포항순이 상세 페이지"))} )
                        }
                        
                        NavigationLink(destination: Text("소노이에 상세 페이지")) {
                            ImageCardView(imageName: "소노이에", title: "소노이에", category: "일식당",status: "영업 중", hours: "11:0    0 - 20:30", rating: "4.7", destination: {AnyView(Text("소노이에 상세 페이지"))} )
                        }
                        
                        NavigationLink(destination: Text("효자동수우동 상세 페이지")) {
                            ImageCardView(imageName: "효자동수우동", title: "효자동수우동", category: "우동, 소바",status: "영업 중", hours: "11:30 - 20:00", rating: "4.1", destination:  {AnyView(Text("효자동수우동 상세 페이지"))} )
                        }
                    }
                    
                    Button("나의 선택 끝!"){
                    }
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(20)
                    
                    // Spacer()
                }
                .padding()
                //.navigationTitle("식당")
            }
            
        }
    }
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
                
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 8) {
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
