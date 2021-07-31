//
//  JapanDaylySummaryView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/23.
//

import SwiftUI
import SwiftUICharts

struct JapanDaylySummaryView: View {
    @EnvironmentObject var model: JapanViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 30) {
                LineChartView(
                    data: model.newPatientsNumsInDays,
                    title: "新規陽性者数",
                    legend: "過去7日間",
                    //style: <#T##ChartStyle#>,
                    form: ChartForm.large,
                    rateValue: model.newPatientsPrevRateInDays,
                    //dropShadow: <#T##Bool?#>,
                    valueSpecifier: "%.0f"
                )
                BarChartView(
                    data: ChartData(values: model.comulPatientsNumsInDays),
                    title: "累積陽性者数",
                    legend: "過去7日間",
                    //style: <#T##ChartStyle#>,
                    form: ChartForm.extraLarge,
                    //dropShadow: <#T##Bool?#>
                    cornerImage: nil,
                    valueSpecifier: "%.0f",
                    animatedToBack: true
                )
                LineChartView(
                    data: model.newDeathsInDays,
                    title: "新規死亡者数",
                    legend: "過去7日間",
                    //style: <#T##ChartStyle#>,
                    form: ChartForm.large,
                    rateValue: model.newDeathsPrevRateInDays,
                    //dropShadow: <#T##Bool?#>,
                    valueSpecifier: "%.0f"
                )
                BarChartView(
                    data: ChartData(values: model.comulDeathsInDays),
                    title: "累積死亡者数",
                    legend: "過去7日間",
                    //style: <#T##ChartStyle#>,
                    form: ChartForm.extraLarge,
                    //dropShadow: <#T##Bool?#>
                    cornerImage: nil,
                    valueSpecifier: "%.0f",
                    animatedToBack: true
                )
                LineChartView(
                    data: model.needInpatientNumsInDays,
                    title: "入院治療等を要する者",
                    legend: "過去7日間",
                    //style: <#T##ChartStyle#>,
                    form: ChartForm.large,
                    rateValue: model.needInpatientPrevRateInDays,
                    //dropShadow: <#T##Bool?#>,
                    valueSpecifier: "%.0f"
                )
                BarChartView(
                    data: ChartData(values: model.prefectureComulPatientsNum),
                    title: "都道府県別累積陽性者数",
                    legend: "最終更新日の15位まで",
                    //style: <#T##ChartStyle#>,
                    form: ChartForm.extraLarge,
                    //dropShadow: <#T##Bool?#>,
                    cornerImage: nil,
                    valueSpecifier: "%.0f",
                    animatedToBack: true
                )
            }
            .padding()
        }
    }
}

struct JapanDaylySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        JapanDaylySummaryView()
    }
}
