//
//  OtherDailySummaryView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/27.
//

import SwiftUI
import SwiftUICharts

struct OtherDailySummaryView: View {
    @EnvironmentObject var model: AreaViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 30) {
                LineChartView(
                    data: model.newPatientsNumInDays,
                    title: "新規感染者数",
                    legend: "過去7日間",
                    form: ChartForm.large,
                    rateValue: model.newPatientsPrevRateInDays,
                    valueSpecifier: "%.0f"
                )
                BarChartView(
                    data: ChartData(values: self.model.comulPatientsNumInDays),
                    title: "累積感染者数",
                    legend: "過去7日間",
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

struct OtherDailySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        OtherDailySummaryView()
    }
}
