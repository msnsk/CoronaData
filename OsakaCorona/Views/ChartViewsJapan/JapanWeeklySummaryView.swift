//
//  JapanWeeklySummaryView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/23.
//

import SwiftUI
import SwiftUICharts

struct JapanWeeklySummaryView: View {
    @ObservedObject var model = JapanPatientsViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 30) {
                LineChartView(
                    data: self.model.getJapanNewlyPatientsInWeeks(),
                    title: "新規陽性者数",
                    legend: "過去12週間",
                    //style: <#T##ChartStyle#>,
                    form: ChartForm.large,
                    //rateValue: <#T##Int?#>,
                    //dropShadow: <#T##Bool?#>,
                    valueSpecifier: "%.0f"
                )
                BarChartView(
                    data: ChartData(values: model.getJapanComulativePatientsInWeeks()),
                    title: "累積陽性者数",
                    legend: "過去12週間",
                    //style: <#T##ChartStyle#>,
                    form: ChartForm.extraLarge,
                    cornerImage: Image(systemName: "chart.bar.fill"),
                    //dropShadow: <#T##Bool?#>
                    //cornerImage: Image(systemName: "chart.bar.fill"),
                    valueSpecifier: "%.0f",
                    animatedToBack: true
                )
                LineChartView(
                    data: self.model.getJapanNewlyDeathsInWeeks(),
                    title: "新規死亡者数",
                    legend: "過去12週間",
                    //style: <#T##ChartStyle#>,
                    form: ChartForm.large,
                    //rateValue: <#T##Int?#>,
                    //dropShadow: <#T##Bool?#>,
                    valueSpecifier: "%.0f"
                )
                BarChartView(
                    data: ChartData(values: model.getJapanComulativeDeathsInWeeks()),
                    title: "累積死亡者数",
                    legend: "過去12週間",
                    //style: <#T##ChartStyle#>,
                    form: ChartForm.extraLarge,
                    cornerImage: Image(systemName: "chart.bar.fill"),
                    //dropShadow: <#T##Bool?#>
                    //cornerImage: Image(systemName: "chart.bar.fill"),
                    valueSpecifier: "%.0f",
                    animatedToBack: true
                )
                LineChartView(
                    data: self.model.getJapanPatientsNeedInpatientInWeeks(),
                    title: "入院治療等を要する者",
                    legend: "過去12週間",
                    //style: <#T##ChartStyle#>,
                    form: ChartForm.large,
                    //rateValue: <#T##Int?#>,
                    //dropShadow: <#T##Bool?#>,
                    valueSpecifier: "%.0f"
                )
                BarChartView(
                    data: ChartData(values: model.getPrefectureComulativePatients()),
                    title: "都道府県別累積陽性者数",
                    legend: "最終更新日の15位まで",
                    //style: <#T##ChartStyle#>,
                    form: ChartForm.extraLarge,
                    //dropShadow: <#T##Bool?#>,
                    valueSpecifier: "%.0f"
                )
            }
            .padding()
        }
    }
}

struct JapanWeeklySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        JapanWeeklySummaryView()
    }
}
