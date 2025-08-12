//
//  CategoryView.swift
//  BAABo
//
//  Created by 김찬영 on 8/4/25.
//

import SwiftUI

struct Category:Identifiable {       // 버튼마다 다른 이미지 할당
    let id = UUID()
    let name: String
    let imageName: String
}


let sampleCategories : [Category] = [
    Category(name: "족발·보쌈", imageName: "보쌈"),
    Category(name: "돈가스·회·일식", imageName: "초밥"),
    Category(name: "고기·구이", imageName: "고기"),
    Category(name: "피자·치킨·버거", imageName: "버거"),
    Category(name: "찜·탕·찌개", imageName: "수프"),
    Category(name: "양식", imageName: "파스타"),
    Category(name: "중식", imageName: "핫팟"),
    Category(name: "아시안", imageName: "아시안"),
    Category(name: "분식", imageName: "떡볶이")
]

// MARK: CategoryView
struct CategoryView: View {
    @State private var timeRemaining: Int = 30      // 남은 시간 변수 설정(타이머)
    @State private var timerEnded: Bool = false     // 타이머 상태 변수 설정(끝났다면 화면 바꾸기)
    @State private var selectedCategories: [Category] = []      // 사용자가 선택한 카테고리 저장
    @State private var isAllLikedSelected: Bool = false     // 다 좋아 버튼 눌렸는지 여부
    @State private var navigateToResult: Bool = false       // CategoryResultView로 전환
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
    
    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: 상단바
                HStack {
                    Text("카테고리 선택")     // 페이지 이름
                        //.font(.system(size: 30, weight: .bold))
                        //.bold()
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    ZStack {    // 타이머
                        Circle()
                            .fill(timerEnded ? Color(.accent) : Color("2_greenColor"))  // 타이머 활성화 여부에 따라 버튼 색 변경
                            .frame(width:35, height:35)
                        Image(systemName: "timer")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width:20, height:20)
                    }
                    Text(String(format:"00:%02d", timeRemaining))   // 남은 시간
                        .font(.system(size: 27, weight: .semibold))
                        .foregroundColor(timerEnded ? Color(.accent) : Color("2_greenColor"))
                }
                .padding(.horizontal)
                .padding(.bottom, 30)   // 상단바와 선택버튼 사이 간격 조정
                
                // MARK: 카테고리 선택 버튼 (정렬)
                LazyVGrid(columns: columns, spacing:17) {
                    ForEach(sampleCategories) {category in
                        let isSelected = selectedCategories.contains(where: { $0.name == category.name })
                        let selectionIndex = selectedCategories.firstIndex(where: { $0.name == category.name })
                        
                        CategoryBox(     // 카테고리 이름 순서대로 붙여줌
                            category :category,
                            isSelected: selectedCategories.contains(where: {$0.name == category.name}),
                            isAllLikedSelected: isAllLikedSelected,
                            selectionIndex: selectionIndex,
                            timerEnded: timerEnded,
                            onTap: {
                                handleCategoryTap(category)
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                
                
                // MARK: 다좋아 버튼
                Button(action:{
                    // 버튼 기능
                    isAllLikedSelected.toggle()     // 버튼 선택과 해제를 자유롭게 할 수 있도록 토글 사용
                    
                    if isAllLikedSelected {
                        selectedCategories = []     // 다좋아 버튼 활성화되면 이전 선택들은 초기화
                    }
                }) {
                    HStack {
                        Image("배려")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 67, height: 67)
                        Text("다~좋아!")
                            //.font(.system(size: 32))
                            .font(.title)
                            
                    }
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 337, height: 101)
                    .background(timerEnded ? Color("1_grayColor") : Color(.accent).opacity(0.2))    // 타이머 완료되면 버튼 색 바꾸기
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isAllLikedSelected ? Color("6_pinkColor") : Color.clear, lineWidth: 7)
                    )
                }
                .disabled(timerEnded)       // 타이머 끝나면 버튼 비활성화
                
                .onReceive(timer) { _ in    // 타이머 기능 구현
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                        if timeRemaining == 0 {
                            timerEnded = true  // 시간 끝났으면 타이머 상태 변수 변경
                        }
                    }
                }
                
                .padding(.bottom, 80)
                
                // MARK: 결과 보기 버튼
                Button(action:{
                    navigateToResult = true
                }) {
                    HStack {
                        Text(timerEnded ? "결과 보기" : String(format: "00:%02d 후 결과 보기", timeRemaining))   // 버튼에서 남은 시간 텍스트로 보여주기
                          //  .font(.system(size: 30, weight: .bold))
                            .font(.title)
                            .bold()
                        Image(systemName: "arrow.right.circle")
                            .resizable()
                            .scaledToFit()
                            .bold()
                            .frame(width:30, height:30)
                    }
                    .foregroundColor(.black)
                    .frame(width: 337, height: 101)
                    .background(timerEnded ? Color(.accent) : Color("1_grayColor"))
                    .cornerRadius(20)
                    
                }
                .disabled(!timerEnded)  // 타이머 끝나야 버튼 활성화
            }
            .padding(.horizontal, 20)   // 전체 화면에서 좌우 여백 조정
            .navigationDestination(isPresented: $navigateToResult) {
                CategoryResultView()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    // MARK: 카테고리 선택 처리 함수
    func handleCategoryTap(_ category: Category) {
        // 다 좋아 버튼 선택 상태에서는 카테고리 선택 불가
        if isAllLikedSelected {
                isAllLikedSelected = false
            }
        
        if selectedCategories.contains(where: { $0.name == category.name }) {
            selectedCategories.removeAll{ $0.name == category.name }
        } else {
            if selectedCategories.count < 3 {
                selectedCategories.append(category)
            }
        }
    }
}
   
// MARK: CategoryBox
struct CategoryBox: View {      // 카테고리 선택버튼 (세부설정)
    let category: Category
    let isSelected: Bool
    let isAllLikedSelected: Bool
    let selectionIndex: Int?
    let borderColors: [Color] = [Color("3_goldColor"), Color("4_silverColor"), Color("5_bronzeColor")]
    let timerEnded: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action:{
            onTap()
        }) {
            ZStack {        // 이미지, 텍스트를 버튼 가운데 정렬
                VStack(spacing:8) {
                    Image(category.imageName)
                        .resizable()
                        .frame(width: 56, height: 56)
                        .foregroundColor(.black)
                    Text(category.name)
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                }
                .frame(width:101, height: 101)  // 선택버튼 크기
                .background(timerEnded ? Color("1_grayColor") : Color(.accent).opacity(0.2))    // 타이머 완료되면 버튼 색 바꾸기
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            (!isAllLikedSelected && selectionIndex != nil && selectionIndex! < borderColors.count)
                                        ? borderColors[selectionIndex!]
                                        : Color.clear,
                                        lineWidth: 7
                                    )
                        )
                if let selectionIndex = selectionIndex, selectionIndex < 3 {    // 카테고리 우선순위 표시
                        Text("\(selectionIndex + 1)")
                        .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                            .frame(width: 30, height: 30)
                            .background(borderColors[selectionIndex])
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                            .offset(x: -45, y: -45) // 위치 조정
                    }
            }
        }
        .disabled(timerEnded)       // 타이머 끝나면 버튼 비활성화
    }
}

#Preview {
    CategoryView()
}
