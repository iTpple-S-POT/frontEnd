//
//  SelectBirthDayView.swift
//
//
//  Created by 최준영 on 2023/11/24.
//

import SwiftUI

struct SelectBirthDayView: View {
    
    let userNickName = "닉네임"
    
    @State private var birthDay: Date = .now
    
    private var dateRange: ClosedRange<Date> {
        // 최소 생일년도는 작성일 기준 80년전
        let min = Calendar.current.date(
          byAdding: .year,
          value: -80,
          to: birthDay
        )!
        
        // 생일년도는 현재년도부터 가능
        let max = Calendar.current.date(
            byAdding: .day,
            value: 0,
            to: birthDay
        )!
        
        return min...max
      }

    
    var body: some View {
        VStack(spacing: 0) {
            // Text1
            //  TODO: 추후 닉네임임 데이터 로드 후 수정
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    (
                        Text(userNickName)
                            .font(.suite(type: .SUITE_SemiBold, size: 28))
                    +
                        Text("님의")
                    )
                    Text("생년월일을 알려주세요")
                }
                .font(.suite(type: .SUITE_Regular, size: 28))
                .frame(height: 75)
                
                Spacer(minLength: 0)
            }
            
            // Date Picker
            DatePicker("", selection: $birthDay, in: dateRange ,displayedComponents: [.date])
                .labelsHidden()
                .datePickerStyle(.wheel)
            .padding(.top, 42)
            
            Spacer(minLength: 0)
        }
    }
}

#Preview {
    PreviewForProcessView {
        SelectBirthDayView()
    }
}
