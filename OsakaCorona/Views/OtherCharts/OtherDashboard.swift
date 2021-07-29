//
//  OtherDashboard.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/27.
//

import SwiftUI

struct OtherDashboard: View {
    @EnvironmentObject var model: AreaViewModel
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
                isJapanViewModel: false,
                newPatients: model.newPatientsNumLastDay,
                newPatientslastUpdate: model.latestDateOfPatients,
                newPatientsComparison: model.newPatientsNumComparedPrevDay,
                newPatientsComparisonRate: model.newPatientsRateComparedPrevDay,
                comulPatients: model.comulPatientsNumLastDay,
                comulPatientsLastUpdate: model.latestDateOfPatients,
                comulPatientsComparisonRate: model.comulPatientsRateComparedPrevDay
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
                    OtherMonthlySummaryView()
                case 1:
                    OtherWeeklySummaryView()
                case 2:
                    OtherDailySummaryView()
                default:
                    OtherMonthlySummaryView()
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
