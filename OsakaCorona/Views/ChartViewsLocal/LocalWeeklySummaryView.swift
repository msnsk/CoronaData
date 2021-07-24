//
//  LocalNewlyPatientsInWeekView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/22.
//

import SwiftUI
import SwiftUICharts

struct LocalWeeklySummaryView: View {
    @ObservedObject var model = LocalPatientsViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 30) {
                LineChartView(
                    data: self.model.getLocalNewlyPatientsInWeeks(),
                    title: "新規感染者数",
                    legend: "過去12週間",
                    form: ChartForm.large,
                    valueSpecifier: "%.0f"
                )
                BarChartView(
                    data: ChartData(values: self.model.getLocalComulativePatientsInWeeks()),
                    title: "累積感染者数",
                    legend: "過去12週間",
                    form: ChartForm.extraLarge,
                    cornerImage: Image(systemName: "chart.bar.fill"),
                    valueSpecifier: "%.0f"
                )
//                LineChartView(
//                    data: self.model.getLocalNewlyDeathsInWeeks(),
//                    title: "新規死亡者数",
//                    legend: "過去12週間",
//                    form: ChartForm.large,
//                    valueSpecifier: "%.0f"
//                )
//                BarChartView(
//                    data: ChartData(values: self.model.getLocalComulativeDeathsInWeeks()),
//                    title: "累積死亡者数",
//                    legend: "過去12週間",
//                    form: ChartForm.extraLarge,
//                    cornerImage: Image(systemName: "chart.bar.fill"),
//                    valueSpecifier: "%.0f"
//                )
            }
            .padding()
        }
    }
}

struct LocalNewlyPatientsInWeekView_Previews: PreviewProvider {
    static var previews: some View {
        LocalWeeklySummaryView()
    }
}
