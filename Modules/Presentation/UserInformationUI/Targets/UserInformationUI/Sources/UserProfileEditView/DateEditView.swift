//
//  DateEditView.swift
//  UserInformationUI
//
//  Created by 최준영 on 2/26/24.
//

import SwiftUI

struct DateEditView: View {
    
    @ObservedObject var configureModel: ConfigurationScreenModel
    
    @Environment(\.dismiss) private var dismiss
    
    private var prevDate: Date
    
    private var dateRange: ClosedRange<Date> {
        // 최소 생일년도는 작성일 기준 80년전
        let min = Calendar.current.date(
          byAdding: .year,
          value: -80,
          to: Date.now
        )!
        
        // 생일년도는 현재년도부터 가능
        let max = Calendar.current.date(
            byAdding: .day,
            value: 0,
            to: Date.now
        )!
        
        return min...max
    }
    
    init(configureModel: ConfigurationScreenModel) {
        self.configureModel = configureModel
        
        self.prevDate = configureModel.userBirthDay
    }
    
    var body: some View {
        
        ZStack {
            
            Color.white.ignoresSafeArea(.all, edges: .top)
            
            EditViewNavBar(title: "생년월일") {
                
                configureModel.userBirthDay = prevDate
                
                dismiss()
                
            } onComplete: {
                
                dismiss()
            }

            
            VStack(spacing: 0) {
                
                Spacer(minLength: 0)
                
                // Date Picker
                DatePicker("", selection: $configureModel.userBirthDay, in: dateRange ,displayedComponents: [.date])
                    .labelsHidden()
                    .datePickerStyle(.wheel)
                
                Spacer(minLength: 0)
            }
            .padding(.top, 56)
        }
    }
}


