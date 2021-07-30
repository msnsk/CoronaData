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
                HStack(spacing: 10){
                    HeaderComponentView(
                        lastUpdate: model.latestDateOfPatientsData,
                        title: "新規感染者",
                        isComulative: false,
                        mainNum: model.newPatientsNumLastDay,
                        additionalNum: model.newPatientsNumComparedPrevDay,
                        subAdditionalNum: model.newPatientsRateComparedPrevDay
                    )
                    HeaderComponentView(
                        lastUpdate: model.latestDateOfPatientsData,
                        title: "累積感染者",
                        isComulative: true,
                        mainNum: model.comulPatientsNumsLastDay,
                        additionalNum: model.comulPatients7DaysTotal,
                        subAdditionalNum: model.comulPatients7DaysAverage
                    )
                    HeaderComponentView(
                        lastUpdate: model.latestDateOfDeathsData,
                        title: "新規死亡者",
                        isComulative: false,
                        mainNum: model.newDeathsLastDay,
                        additionalNum: model.newDeathsComparedPrevDay,
                        subAdditionalNum: model.newDeathsRateComparedPrevDay
                    )
                    HeaderComponentView(
                        lastUpdate: model.latestDateOfDeathsData,
                        title: "累積死亡者",
                        isComulative: true,
                        mainNum: model.comulDeathsLastDay,
                        additionalNum: model.comulDeaths7DaysTotal,
                        subAdditionalNum: model.comulPatients7DaysAverage
                    )
                }
                .padding(.horizontal)
                .padding(.vertical, 25)
            }
            
            Picker(selection: $selection, label: Text("期間を選択")){
                ForEach(0..<pigments.count) { index in
                    Text(self.pigments[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 40)
            .padding(.bottom, 16)
            
            if model.latestDateOfPatientsData != "Loading..." {
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
