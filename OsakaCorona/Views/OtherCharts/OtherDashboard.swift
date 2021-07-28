//
//  OtherDashboard.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/27.
//

import SwiftUI

struct OtherDashboard: View {
    @EnvironmentObject var model: OtherViewModel
    @State var selection = 0
    let pigments = ["24ヶ月間", "12週間", "7日間"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                AreaPickerView()
                Text("のコロナ関連データ")
                    .font(.title)
            }
            
            
            HeaderView(
                newlyPatients: model.getNewlyPatientsOnLastDay(),
                newlyPatientslastUpdate: model.latestDateOfPatients,
                comulativePatients: model.getComulativePatientsOnLastDay(),
                comulativePatientsLastUpdate: model.latestDateOfPatients
            )
            
            Picker(selection: $selection, label: Text("期間を選択")){
                ForEach(0..<pigments.count) { index in
                    Text(self.pigments[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 40)
            .padding(.bottom, 16)
            
            if model.latestDateOfPatients != "Loading..." {
                switch selection {
                case 0:
                    LocalMonthlySummaryView()
                case 1:
                    LocalWeeklySummaryView()
                case 2:
                    LocalDailySummaryView()
                default:
                    LocalMonthlySummaryView()
                }
            }
            Spacer()
        }
        .padding(.vertical, 25)
    }
}

struct OtherDashboard_Previews: PreviewProvider {
    static var previews: some View {
        OtherDashboard()
    }
}
