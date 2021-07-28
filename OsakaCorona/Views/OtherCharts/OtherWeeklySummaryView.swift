//
//  OtherWeeklySummaryView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/27.
//

import SwiftUI
import SwiftUICharts

struct OtherWeeklySummaryView: View {
    @EnvironmentObject var model: AreaViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 30) {
                LineChartView(
                    data: self.model.newPatientsNumInWeeks,
                    title: "新規感染者数",
                    legend: "過去12週間",
                    form: ChartForm.large,
                    valueSpecifier: "%.0f"
                )
                BarChartView(
                    data: ChartData(values: self.model.comulPatientsNumInWeeks),
                    title: "累積感染者数",
                    legend: "過去12週間",
                    form: ChartForm.extraLarge,
                    cornerImage: Image(systemName: "chart.bar.fill"),
                    valueSpecifier: "%.0f"
                )
            }
            .padding()
        }
    }
}

struct OtherWeeklySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        OtherWeeklySummaryView()
    }
}
