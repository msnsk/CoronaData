//
//  NewlyLocalInfectedNum.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/21.
//

import SwiftUI
import SwiftUICharts

struct LocalMonthlySummaryView: View {
    @EnvironmentObject var model: LocalViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 30) {
                LineChartView(
                    data: model.newPatientsNumInMonths,
                    title: "新規感染者数",
                    legend: "過去24ヶ月間",
                    form: ChartForm.large,
                    rateValue: model.newPatientsPrevRateInMonths,
                    valueSpecifier: "%.0f"
                )
                BarChartView(
                    data: ChartData(values: model.comulPatientsNumInMonths),
                    title: "累積感染者数",
                    legend: "過去24ヶ月間",
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

struct LocalMonthlySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        LocalMonthlySummaryView()
    }
}
