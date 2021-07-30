//
//  HeaderView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/23.
//

import SwiftUI

struct HeaderView: View {
    var isJapanViewModel: Bool
    
    var newPatients: Int
    var newPatientslastUpdate: String
    var newPatientsComparison: Int
    var newPatientsComparisonRate: Double
    
    var comulPatients: Int
    var comulPatientsLastUpdate: String
    var comulPatientsComparisonRate: Double
    
    var newDeaths: Int = 0
    var newDeathsLastUpdate: String = ""
    var newDeathsComparison: Int = 0
    var newDeathsComparisonRate: Double = 0.00
    
    var comulDeaths: Int = 0
    var comulDeathsLastUpdate: String = ""
    var comulDeathsComparisonRate: Double = 0.00
    
    var body: some View {
        HStack(spacing: 10){
            HeaderComponentView(lastUpdate: newPatientslastUpdate, title: "新規感染者", isComulative: false, mainNum: newPatients, additionalNum: newPatientsComparison, subAdditionalNum: newPatientsComparisonRate)
            VStack(spacing: 3) {
                Text(newPatientslastUpdate)
                    .font(.caption)
                    .fontWeight(.light)
                Text("新規感染者")
                Text("\(newPatients)")
                    .font(.system(size: 32, weight: .bold, design: .default))
                ZStack {
                    Divider()
                    Text("前日比")
                        .padding(.horizontal)
                        .font(.caption.weight(.light))
                }
                HStack {
                    Text("\(newPatientsComparison)")
                        .font(.title2.weight(.light))
                    Text("\(String(format: "%.2f", newPatientsComparisonRate))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Image(systemName: newPatientsComparisonRate > 0 ? "arrow.turn.right.up" : "arrow.turn.right.down")
                        .font(.title2.bold())
                        .foregroundColor(newPatientsComparisonRate > 0 ? .red : .blue)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
            )
            .fixedSize(horizontal: true, vertical: false)
            
            VStack(spacing: 3) {
                Text(comulPatientsLastUpdate)
                    .font(.caption)
                    .fontWeight(.light)
                Text("累積感染者")
                    .fontWeight(.regular)
                Text("\(comulPatients)")
                    .font(.system(size: 32, weight: .bold, design: .default))
                ZStack {
                    Divider()
                    Text("前日比")
                        .padding(.horizontal)
                        .font(.caption.weight(.light))
                }
                HStack {
                    Text("\(newPatients)")
                        .font(.title2.weight(.light))
                    Text("\(String(format: "%.2f", comulPatientsComparisonRate))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Image(systemName: comulPatientsComparisonRate > 0 ? "arrow.turn.right.up" : "arrow.turn.right.down")
                        .font(.title2.bold())
                        .foregroundColor(comulPatientsComparisonRate > 0 ? .red : .blue)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
            )
            .fixedSize(horizontal: true, vertical: false)
            if isJapanViewModel {
                VStack(spacing: 3) {
                    Text(newDeathsLastUpdate)
                        .font(.caption)
                        .fontWeight(.light)
                    Text("新規死亡者")
                        .fontWeight(.regular)
                    Text("\(newDeaths)")
                        .font(.system(size: 32, weight: .bold, design: .default))
                    ZStack {
                        Divider()
                        Text("前日比")
                            .padding(.horizontal)
                            .font(.caption.weight(.light))
                    }
                    HStack {
                        Text("\(newDeathsComparison)")
                            .font(.title2.weight(.light))
                        Text("\(String(format: "%.2f", newDeathsComparisonRate))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Image(systemName: newDeathsComparisonRate > 0 ? "arrow.turn.right.up" : "arrow.turn.right.down")
                            .font(.title2.bold())
                            .foregroundColor(newDeathsComparisonRate > 0 ? .red : .blue)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                )
                .fixedSize(horizontal: true, vertical: false)
                VStack(spacing: 3) {
                    Text(comulDeathsLastUpdate)
                        .font(.caption)
                        .fontWeight(.light)
                    Text("累積死亡者")
                        .fontWeight(.regular)
                    Text("\(comulDeaths)")
                        .font(.system(size: 32, weight: .bold, design: .default))
                    ZStack {
                        Divider()
                        Text("前日比")
                            .padding(.horizontal)
                            .font(.caption.weight(.light))
                    }
                    HStack {
                        Text("\(newDeaths)")
                            .font(.title2.weight(.light))
                        Text("\(String(format: "%.2f", comulPatientsComparisonRate))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Image(systemName: comulPatientsComparisonRate > 0 ? "arrow.turn.right.up" : "arrow.turn.right.down")
                            .font(.title2.bold())
                            .foregroundColor(comulPatientsComparisonRate > 0 ? .red : .blue)
                    }
                    
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                )
                .fixedSize(horizontal: true, vertical: false)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 25)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(isJapanViewModel: true, newPatients: 456, newPatientslastUpdate: "2021-07-23", newPatientsComparison: 121, newPatientsComparisonRate: 1.1, comulPatients: 123456, comulPatientsLastUpdate: "2021-07-23", comulPatientsComparisonRate: 11.02, newDeaths: 81 , newDeathsLastUpdate: "2021-07-23" , comulDeaths: 15101 , comulDeathsLastUpdate: "2021-07-23", comulDeathsComparisonRate: 13.21 )
    }
}

struct HeaderView_Previews2: PreviewProvider {
    static var previews: some View {
        HeaderView(isJapanViewModel: false, newPatients: 456, newPatientslastUpdate: "2021-07-23", newPatientsComparison: 121, newPatientsComparisonRate: 1.1, comulPatients: 123456, comulPatientsLastUpdate: "2021-07-23", comulPatientsComparisonRate: 11.02, comulDeathsComparisonRate: 13.21)
    }
}
