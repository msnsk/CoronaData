//
//  JapanDataView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/21.
//

import SwiftUI
import SwiftUICharts

struct JapanMonthlySummaryView: View {
    @EnvironmentObject var model: JapanViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 30) {
                LineChartView(
                    //data: self.model.newPatientsNumsInMonths,
                    data: model.newPatientsNumsInMonths,
                    title: "新規陽性者数の推移",
                    legend: "1ヶ月おき\(model.latestDateOfPatientsData)まで",
                    //style: <#T##ChartStyle#>,
                    form: ChartForm.large,
                    rateValue: model.newPatientsPrevRateInMonths,
                    //dropShadow: <#T##Bool?#>,
                    valueSpecifier: "%.0f"
                )
                BarChartView(
                    data: ChartData(values: model.comulPatientsNumsInMonths),
                    title: "累積陽性者数の推移",
                    legend: "1ヶ月おき\(model.latestDateOfPatientsData)まで",
                    //style: <#T##ChartStyle#>,
                    form: ChartForm.extraLarge,
                    //dropShadow: <#T##Bool?#>
                    cornerImage: nil,
                    valueSpecifier: "%.0f",
                    animatedToBack: false
                )
                LineChartView(
                    data: model.newDeathsInMonths,
                    title: "新規死亡者数の推移",
                    legend: "1ヶ月おき\(model.latestDateOfPatientsData)まで",
                    //style: <#T##ChartStyle#>,
                    form: ChartForm.large,
                    rateValue: model.newDeathsPrevRateInMonths,
                    //dropShadow: <#T##Bool?#>,
                    valueSpecifier: "%.0f"
                )
                BarChartView(
                    data: ChartData(values: model.comulDeathsInMonths),
                    title: "累積死亡者数の推移",
                    legend: "\(model.latestDateOfPatientsData)までの1ヶ月間隔",
                    //style: <#T##ChartStyle#>,
                    form: ChartForm.extraLarge,
                    //dropShadow: <#T##Bool?#>
                    cornerImage: nil,
                    valueSpecifier: "%.0f",
                    animatedToBack: true
                )
                LineChartView(
                    data: model.needInpatientNumsInMonths,
                    title: "入院治療等を要する者の推移",
                    legend: "1ヶ月おき\(model.latestDateOfPatientsData)まで",
                    //style: <#T##ChartStyle#>,
                    form: ChartForm.large,
                    rateValue: model.needInpatientPrevRateInMonths,
                    //dropShadow: <#T##Bool?#>,
                    valueSpecifier: "%.0f"
                )
                BarChartView(
                    data: ChartData(values: model.prefectureComulPatientsNum),
                    title: "最新の都道府県別累積陽性者数",
                    legend: "\(model.latestDateOfPatientsData)の上位15位",
                    //style: <#T##ChartStyle#>,
                    form: ChartForm.extraLarge,
                    //dropShadow: <#T##Bool?#>,
                    cornerImage: nil,
                    valueSpecifier: "%.0f",
                    animatedToBack: true
                )
            }
            .padding(.vertical)
        }
    }
}

struct JapanDataView_Previews: PreviewProvider {
    static var previews: some View {
        JapanMonthlySummaryView()
    }
}
