//
//  InviteView.swift
//  BAABo
//
//  Created by 김찬영 on 8/4/25.
//

import SwiftUI

// MARK: - 모델 정의
struct Friend: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var foodToAvoid: String
    var showFood: Bool = true
    var imageName: String
}

let foodList = ["고수", "회", "없음", "양고기", "없음", "우유", "피망", "없음", "땅콩", "없음", "당근"]
let memojiImages = ["memoji1", "memoji2", "memoji3", "memoji4", "memoji5", "memoji6"]

// MARK: - 메인 뷰
struct InviteView: View {
    @Environment(\.dismiss) var dismiss

    let location: String

    @State private var invitedFriends: [Friend] = []
    @State private var friendCount: Int = 1
    @State private var timer: Timer?

    @State private var selectedFriendIndex: Int? = nil
    @State private var isPopupPresented: Bool = false
    
    @State private var isNavigatingToCategory = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 1.0, green: 0.91, blue: 0.82).ignoresSafeArea()

                VStack(spacing: 20) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
//                            Image(systemName: "arrow.left")
//                                .font(.title2)
//                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .padding(.leading, 20)

                    HStack(spacing: 5) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.black)
                        Text("\(location)에서 식당 찾는중")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 5)

                    HStack {
                        Image(systemName: "link")
                        Text("https://BAABo.com")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, -10)

                    HStack(spacing: -10) {
                        Image("memoji1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .offset(x: -1, y: 15)

                        Image("memoji2")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }

                    ZStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Spacer()
                                Text("입장인원 \(invitedFriends.count)")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            .padding(.top, 40)
                            .padding(.horizontal)

                            ScrollView {
                                VStack(spacing: 12) {
                                    ForEach(invitedFriends.indices, id: \.self) { index in
                                        let friend = invitedFriends[index]
                                        HStack {
                                            Image(friend.imageName)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())

                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(friend.name)
                                                    .fontWeight(.semibold)
                                                Text("못먹는 음식: \(friend.showFood ? friend.foodToAvoid : "비공개")")
                                                    .font(.caption)
                                            }
                                            Spacer()
                                            Image(systemName: "gearshape.fill")
                                                .onTapGesture {
                                                    selectedFriendIndex = index
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                        isPopupPresented = true
                                                    }
                                                }
                                        }
                                        .padding()
                                        .background(Color(.systemGray5))
                                        .cornerRadius(16)
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                        .cornerRadius(30, corners: [.topLeft, .topRight])
                        .shadow(radius: 5)
                        .ignoresSafeArea(edges: .bottom)

                        HStack {
                            Spacer()
                            NavigationLink(destination: CategoryView(), isActive: $isNavigatingToCategory) {
                                EmptyView()
                            }.hidden()
                            
                            Button(action: {
                                isNavigatingToCategory = true
                            }) {
                                HStack {
                                    Text("떠나자")
                                    Image(systemName: "arrow.right.circle")
                                }
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: 160)
                                .background(Color.orange)
                                .cornerRadius(12)
                                .shadow(radius: 3)
                            }
                            Spacer()
                        }
                        .offset(y: -30)
                    }
                    .padding(.top, 50)
                }
            }
            .onAppear {
                timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                    if invitedFriends.count < 6 {
                        withAnimation {
                            let randomFood = foodList.randomElement() ?? "없음"
                            let randomImage = memojiImages.randomElement() ?? "memoji1"
                            let newFriend = Friend(name: "바보 \(friendCount)", foodToAvoid: randomFood, imageName: randomImage)
                            invitedFriends.append(newFriend)
                            friendCount += 1
                        }
                    } else {
                        timer?.invalidate()
                        timer = nil
                    }
                }
            }
            .sheet(isPresented: $isPopupPresented) {
                if let index = selectedFriendIndex {
                    FriendSettingView(friend: $invitedFriends[index], isPresented: $isPopupPresented)
                }
            }
        }
    }
}

// MARK: - 설정 팝업 뷰
struct FriendSettingView: View {
    @Binding var friend: Friend
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Text("마이페이지")
                    .font(.title)
                    .fontWeight(.bold)

                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal)

            Image(friend.imageName)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .shadow(radius: 5)
                .padding()

            VStack(alignment: .leading, spacing: 12) {
                Text("이름")
                    .font(.headline)
                TextField("이름 입력", text: $friend.name)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(12)

                Toggle("못 먹는 음식 설정", isOn: $friend.showFood)
                    .font(.headline)

                if friend.showFood {
                    TextField("못 먹는 음식 입력", text: $friend.foodToAvoid)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)

            Button("저장") {
                isPresented = false
            }
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.orange)
            .foregroundColor(.black)
            .cornerRadius(12)
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

// MARK: - 둥근 모서리 확장
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        self.clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// MARK: - 프리뷰
#Preview {
    // InviteView()
}

