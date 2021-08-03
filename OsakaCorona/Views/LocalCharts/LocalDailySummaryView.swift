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
                    data: model.newPatientsNumInDays,
                    title: "新規感染者数の推移",
                    legend: "1日おき\(model.latestDateOfPatients)まで",
                    form: ChartForm.large,
                    rateValue: model.newPatientsPrevRateInDays,
                    valueSpecifier: "%.0f"
                )
                BarChartView(
                    data: ChartData(values: self.model.comulPatientsNumInDays),
                    title: "累積感染者数の推移",
                    legend: "1日おき\(model.latestDateOfPatients)まで",
                    form: ChartForm.extraLarge,
                    cornerImage: nil,
                    valueSpecifier: "%.0f",
                    animatedToBack: true
                )
            }
            .padding(.vertical)
        }
    }
}

struct LocalNewlyPatientsOnDayView_Previews: PreviewProvider {
    static var previews: some View {
        LocalDailySummaryView()
    }
}
