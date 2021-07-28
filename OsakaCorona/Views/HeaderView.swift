//
//  HeaderView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/23.
//

import SwiftUI

struct HeaderView: View {
    let newPatients: Int
    let newPatientslastUpdate: String
    let newPatientsComparison: Int
    let newPatientsComparisonRate: Double
    let comulPatients: Int
    let comulPatientsLastUpdate: String
    var newDeaths: String? = nil
    var newDeathsLastUpdate: String? = nil
    var comulDeaths: String? = nil
    var comulDeathsLastUpdate: String? = nil
    
    var body: some View {
        HStack(spacing: 10){
            VStack(spacing: 3) {
                HStack(spacing: 1) {
                    Image(systemName: "waveform.path.ecg")
                    Text("新規感染者")
                }
                Text("\(newPatients)")
                    .font(.system(size: 40, weight: .bold, design: .default))
                HStack {
                    Image(systemName: newPatientsComparison > 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                        .font(.title2)
                        .foregroundColor(newPatientsComparison > 0 ? .red : Color(.systemGreen))
                    Text("\(newPatientsComparison)")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(String(format: "%.2f", "\(newPatientsComparisonRate)%"))
                        .font(.caption)
                        .fontWeight(.light)
                }
                Text(newPatientslastUpdate)
                    .font(.caption)
                    .fontWeight(.light)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
            )
            VStack(spacing: 3) {
                HStack(spacing: 1) {
                    Image(systemName: "chart.bar.fill")
                    Text("累積感染者")
                        .fontWeight(.regular)
                }
                Text("\(comulPatients)")
                    .font(.system(size: 40, weight: .bold, design: .default))
                HStack {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(newPatientsComparisonRate >= 50 ? .red : Color(.systemGreen))
                    Text("\(newPatients)")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(String(format: "%.2f", "\(newPatientsComparisonRate)%"))
                        .font(.caption)
                        .fontWeight(.light)
                }
                Text(comulPatientsLastUpdate)
                    .font(.caption)
                    .fontWeight(.light)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
            )
            if let newlyDeaths = self.newDeaths {
                VStack {
                    HStack {
                        Image(systemName: "waveform.path.ecg")
                        Text("新規死亡者")
                            .fontWeight(.regular)
                    }
                    Text(newlyDeaths)
                        .font(.system(size: 40, weight: .bold, design: .default))
                    Text(self.newDeathsLastUpdate ?? "")
                        .font(.caption)
                        .fontWeight(.light)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                )
            }
            if let comulativeDeaths = self.comulDeaths {
                VStack {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                        Text("累積死亡者")
                            .fontWeight(.regular)
                    }
                    Text(comulativeDeaths)
                        .font(.system(size: 40, weight: .bold, design: .default))
                    Text(self.comulDeathsLastUpdate ?? "")
                        .font(.caption)
                        .fontWeight(.light)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                )
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 25)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(newPatients: 456, newPatientslastUpdate: "2021-07-23", newPatientsComparison: 121, newPatientsComparisonRate: 1.1, comulPatients: 123456, comulPatientsLastUpdate: "2021-07-23", newDeaths: "81" , newDeathsLastUpdate: "2021-07-23" , comulDeaths: "15101" , comulDeathsLastUpdate: "2021-07-23" )
    }
}

struct HeaderView_Previews2: PreviewProvider {
    static var previews: some View {
        HeaderView(newPatients: 456, newPatientslastUpdate: "2021-07-23", newPatientsComparison: 121, newPatientsComparisonRate: 1.1, comulPatients: 123456, comulPatientsLastUpdate: "2021-07-23")
    }
}
