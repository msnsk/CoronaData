//
//  LocalSummaryView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/23.
//

import SwiftUI

struct JapanDashboard: View {
    @EnvironmentObject var model: JapanViewModel
    let pigments = ["24ヶ月間", "12週間", "7日間"]
    @State var selection = 0
    
    var body: some View {
        VStack(spacing: 0) {
            Text("全国のコロナ関連データ")
                .font(.title)
            
            ScrollView(.horizontal) {
                HeaderView(
                    newPatients: model.getNewlyPatientsOnLastDay(),
                    newPatientslastUpdate: model.getJapanPatientsLatestDate(),
                    newPatientsComparison: 0,
                    newPatientsComparisonRate: 0.0,
                    comulPatients: model.getComulativePatientsOnLastDay(),
                    comulPatientsLastUpdate: model.getJapanPatientsLatestDate(),
                    newDeaths: model.getJapanaNewlyDeathsOnLastDay(),
                    newDeathsLastUpdate: model.getJapanDeathsLatestDate(),
                    comulDeaths: model.getJapanComulativeDeathsOnLastDay(),
                    comulDeathsLastUpdate: model.getJapanDeathsLatestDate()
                )
            }
            
            Picker(selection: $selection, label: Text("期間を選択")){
                ForEach(0..<pigments.count) { index in
                    Text(self.pigments[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 40)
            .padding(.bottom, 16)
            
            if model.getJapanPatientsLatestDate() != "Loading..." {
                switch selection {
                case 0:
                    JapanMonthlySummaryView()
                case 1:
                    JapanWeeklySummaryView()
                case 2:
                    JapanDaylySummaryView()
                default:
                    JapanMonthlySummaryView()
                }
            }
            Spacer()
        }
        .padding(.vertical, 25)
    }
}

struct JapanDashboard_Previews: PreviewProvider {
    static var previews: some View {
        JapanDashboard()
    }
}
