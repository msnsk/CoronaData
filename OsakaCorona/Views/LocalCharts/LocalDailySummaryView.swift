//
//  LocalNewlyPatientsOnDayView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/22.
//

import SwiftUI
import SwiftUICharts

struct LocalDailySummaryView: View {
    @EnvironmentObject var model: LocalViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 30) {
                LineChartView(
                    data: self.model.newPatientsNumInDays,
                    title: "新規感染者数",
                    legend: "過去7日間",
                    form: ChartForm.large,
                    valueSpecifier: "%.0f"
                )
                BarChartView(
                    data: ChartData(values: self.model.comulPatientsNumInDays),
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

struct LocalNewlyPatientsOnDayView_Previews: PreviewProvider {
    static var previews: some View {
        LocalDailySummaryView()
    }
}
