//
//  LocalSummaryView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/23.
//

import SwiftUI

struct JapanDashboard: View {
    @EnvironmentObject var model: JapanViewModel
    let pigments = ["24ヶ月間", "12週間", "7日間"]
    @State var selection = 0
    @State var isShowingHeader = true {
        didSet {
            UserDefaults.standard.set(isShowingHeader, forKey:"isShowingHeaderJapan")
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: 0) {
                Text("全国")
                    .font(.title)
                Text("のコロナウイルスの影響")
                    .font(.title2)
            }
            Text("Impact of COVID-19 Nationwide")
                .font(.footnote.weight(.light))
                .padding(.bottom, 5)
            
            if !isShowingHeader {
                ZStack {
                    Divider()
                    Button(action: {
                        isShowingHeader.toggle()
                    }, label: {
                        Image(systemName: "chevron.down.circle.fill")
                            .font(.title.weight(.thin))
                            .foregroundColor(Color(.tertiarySystemBackground))
                            .shadow(radius: 4)
                    })
                }
            }
            
            if isShowingHeader {
                ScrollView(.horizontal) {
                    HStack(spacing: 16){
                        HeaderComponentView(
                            lastUpdate: model.latestDateOfPatientsData,
                            title: "新規感染者",
                            isComulative: false,
                            mainNum: model.newPatientsNumLastDay,
                            additionalNum: model.newPatientsNumComparedPrevDay,
                            subAdditionalNum: model.newPatientsRateComparedPrevDay
                        )
                        HeaderComponentView(
                            lastUpdate: model.latestDateOfPatientsData,
                            title: "累積感染者",
                            isComulative: true,
                            mainNum: model.comulPatientsNumsLastDay,
                            additionalNum: model.comulPatients7DaysTotal,
                            subAdditionalNum: model.comulPatients7DaysAverage
                        )
                        HeaderComponentView(
                            lastUpdate: model.latestDateOfDeathsData,
                            title: "新規死亡者",
                            isComulative: false,
                            mainNum: model.newDeathsLastDay,
                            additionalNum: model.newDeathsComparedPrevDay,
                            subAdditionalNum: model.newDeathsRateComparedPrevDay
                        )
                        HeaderComponentView(
                            lastUpdate: model.latestDateOfDeathsData,
                            title: "累積死亡者",
                            isComulative: true,
                            mainNum: model.comulDeathsLastDay,
                            additionalNum: model.comulDeaths7DaysTotal,
                            subAdditionalNum: model.comulDeaths7DaysAverage
                        )
                    }
                    .padding()
                }
                
                ZStack {
                    Divider()
                    Button(action: {
                        isShowingHeader.toggle()
                    }, label: {
                        Image(systemName: "chevron.up.circle.fill")
                            .font(.title.weight(.thin))
                            .foregroundColor(Color(.tertiarySystemBackground))
                            .shadow(radius: 4)
                    })
                }
            }
            
            Picker(selection: $selection, label: Text("期間を選択")){
                ForEach(0..<pigments.count) { index in
                    Text(self.pigments[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .shadow(color: Color(.tertiarySystemBackground), radius: 4)
            .padding(.horizontal, 40)
            .padding(.vertical, 12)
            
            if model.latestDateOfPatientsData != "Loading..." {
                switch selection {
                case 0:
                    JapanMonthlySummaryView()
                case 1:
                    JapanWeeklySummaryView()
                case 2:
                    JapanDaylySummaryView()
                default:
                    JapanMonthlySummaryView()
                }
            }
            Spacer()
        }
        .padding(.vertical, 25)
        .onAppear() {
            self.isShowingHeader = UserDefaults.standard.bool(forKey: "isShowingHeaderJapan")
            print("model.latestDateOfPatientsData\(model.latestDateOfPatientsData)")
        }
    }
}

struct JapanDashboard_Previews: PreviewProvider {
    static var previews: some View {
        JapanDashboard()
    }
}
