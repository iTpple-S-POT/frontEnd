//
//  SwiftUIView.swift
//  
//
//  Created by 최유빈 on 1/26/24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var tags = ["#고양이", "#스위스"]
    @State private var relatedWords = [String]()
    @State private var isShowingSearchDetail = false

    var body: some View {
        VStack(alignment: .leading) {
            // 검색창
            TextField("#관심있는 해시태그를 입력해 보세요!", text: $searchText)
                .onChange(of: searchText) { newValue in
                    search(for: newValue)
                }
                .padding(10)
                .font(.system(size: 16))
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .overlay(
                    HStack{
                        Spacer()
                        
                        Button(action: {
                            isShowingSearchDetail = true
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.trailing, 30)
                                .frame(width: 50, height: 50)
                        }
                    }
                )
            
            if !relatedWords.isEmpty {
                List {
                    Section(header: Text("연관 단어")) {
                        ForEach(relatedWords, id: \.self) { word in
                            Text(word)
                        }
                    }
                }
            }
            
            // 선택된 태그 목록
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("최근 검색어")
                        .font(.system(size: 18))
                        .padding([.top, .horizontal, .bottom])
                
                    Spacer()
                    
                    Button(action: {
                    self.tags.removeAll()
                    }) {
                        Text("모두 지우기")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding([.top, .horizontal, .bottom])
                    }
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(tags, id: \.self) { tag in
                            TagView(tagName: tag, tags: $tags, onDelete: {
                                if let index = tags.firstIndex(of: tag) {
                                    tags.remove(at: index)
                                }
                            })
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $isShowingSearchDetail) {
                    SearchDetailView()
                }

        .navigationBarTitle("검색", displayMode: .inline)
    }
    
    private func search(for query: String) {
            // Here you would have your actual search logic, which updates the `relatedWords` array
            // For example, if the user types "마라탕", show related words:
            if query.contains("마라탕") {
                relatedWords = ["마라탕면", "마라탕전문점", "마라탕레시피"]
            } else {
                relatedWords = []
            }
        }
}

// 태그 뷰
struct TagView: View {
    var tagName: String
    @Binding var tags: [String]
    var onDelete: () -> Void
    
    var body: some View {
        Button(action: onDelete) {
                    HStack {
                        Text(tagName)
                            .font(.system(size: 14))
                            .padding(.vertical, 8)
                            .padding(.leading, 16)
                        Image(systemName: "xmark")
                            .imageScale(.small)
                            .padding(.trailing, 12)
                    }
                    .background(Color.gray.opacity(0.2)) // 투명도를 조정하여 배경색 설정
                    .foregroundColor(.black)
                    .cornerRadius(15) // 모서리를 둥글게
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, lineWidth: 0.5)
                    )
                }    }
}

public struct SearchScreen: View {
    public init() { }
    
    public var body: some View {
        NavigationView {
            SearchView()
        }
    }
}


#Preview {
    SearchScreen()
}
