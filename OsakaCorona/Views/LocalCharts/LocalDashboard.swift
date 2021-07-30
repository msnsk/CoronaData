//
//  Infected.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/19.
//

import SwiftUI

struct LocalDashboard: View {
    @EnvironmentObject var model: AreaViewModel
    @ObservedObject var locationVM = LocationViewModel()
    @State var selection = 0
    let pigments = ["24ヶ月間", "12週間", "7日間"]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("\(model.currentLocation)のコロナ関連データ")
                .font(.title)
            
            HStack(spacing: 10){
                HeaderComponentView(
                    lastUpdate: model.latestDateOfPatients,
                    title: "新規感染者",
                    isComulative: false,
                    mainNum: model.newPatientsNumLastDay,
                    additionalNum: model.newPatientsNumComparedPrevDay,
                    subAdditionalNum: model.newPatientsRateComparedPrevDay
                )
                HeaderComponentView(
                    lastUpdate: model.latestDateOfPatients,
                    title: "累積感染者",
                    isComulative: true,
                    mainNum: model.comulPatientsNumLastDay,
                    additionalNum: model.comulPatientsNumLastDay,
                    subAdditionalNum: model.comulPatientsRateComparedPrevDay
                )
            }
            .padding(.horizontal)
            .padding(.vertical, 25)
            Picker(selection: $selection, label: Text("期間を選択")){
                ForEach(0..<pigments.count) { index in
                    Text(self.pigments[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 40)
            .padding(.bottom, 16)
            
            if model.latestDateOfPatients != "Loading..." {
                switch selection {
                case 0:
                    LocalMonthlySummaryView()
                case 1:
                    LocalWeeklySummaryView()
                case 2:
                    LocalDailySummaryView()
                default:
                    LocalMonthlySummaryView()
                }
            }
            Spacer()
        }
        .padding(.vertical, 25)
        .onAppear() {
            model.isCurrentArea = true
            model.convertLocationName(area: locationVM.area)
            //print("location status: \(locationVM.statusString)")
            //print("area: \(locationVM.area ?? "")")
        }
        .onDisappear() {
            locationVM.stopUpdatingLocation()
        }
    }
}

struct Infected_Previews: PreviewProvider {
    static var previews: some View {
        LocalDashboard()
    }
}
