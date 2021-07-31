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
                    data: model.newPatientsNumInWeeks,
                    title: "新規感染者数",
                    legend: "過去12週間",
                    form: ChartForm.large,
                    rateValue: model.newPatientsPrevRateInWeeks,
                    valueSpecifier: "%.0f"
                )
                BarChartView(
                    data: ChartData(values: model.comulPatientsNumInWeeks),
                    title: "累積感染者数",
                    legend: "過去12週間",
                    form: ChartForm.extraLarge,
                    cornerImage: nil,
                    valueSpecifier: "%.0f",
                    animatedToBack: true
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
