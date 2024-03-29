//
//  OtherDailySummaryView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/27.
//

import SwiftUI
import SwiftUICharts

struct OtherDailySummaryView: View {
    @EnvironmentObject var model: OtherViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 30) {
                LineChartView(
                    data: self.model.getLocalNewlyPatientsInDays(),
                    title: "新規感染者数",
                    legend: "過去7日間",
                    form: ChartForm.large,
                    valueSpecifier: "%.0f"
                )
                BarChartView(
                    data: ChartData(values: self.model.getLocalComulativePatientsInDays()),
                    title: "累積感染者数",
                    legend: "過去7日間",
                    form: ChartForm.extraLarge,
                    cornerImage: Image(systemName: "chart.bar.fill"),
                    valueSpecifier: "%.0f"
                )
            }
            .padding()
        }
    }
}

struct OtherDailySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        OtherDailySummaryView()
    }
}
