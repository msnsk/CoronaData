//
//  Infected.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/19.
//

import SwiftUI
import SwiftUICharts

struct LocalDashboard: View {
    @EnvironmentObject var model: LocalViewModel
    @ObservedObject var locationVM = LocationViewModel()
    @State var selection = 0
    let pigments = ["24ヶ月間", "12週間", "7日間"]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("\(model.currentLocation)のコロナ関連データ")
                .font(.title)
            
            Text("location status: \(locationVM.statusString)")
            Text("area: \(locationVM.adminArea ?? "")")
            
            HeaderView(
                newlyPatients: model.getNewlyPatientsOnLastDay(),
                newlyPatientslastUpdate: model.getLocalPatientsLatestDate(),
                comulativePatients: model.getComulativePatientsOnLastDay(),
                comulativePatientsLastUpdate: model.getLocalPatientsLatestDate()
            )
            
            Picker(selection: $selection, label: Text("期間を選択")){
                ForEach(0..<pigments.count) { index in
                    Text(self.pigments[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 40)
            .padding(.bottom, 16)
            
            if model.getLocalPatientsLatestDate() != "Loading..." {
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
            model.convertLocationName(area: locationVM.adminArea)
            model.loadPatientsData()
        }
        .onDisappear() {
            locationVM.stopUpdatingLocation()
        }
    }
}

struct Infected_Previews: PreviewProvider {
    //static let locationViewModel = LocationViewModel(model: LocationDataSource())
    static var previews: some View {
        LocalDashboard()
    }
}
