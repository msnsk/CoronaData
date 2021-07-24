//
//  HeaderView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/23.
//

import SwiftUI

struct HeaderView: View {
    let newlyPatients: String
    let newlyPatientslastUpdate: String
    let comulativePatients: String
    let comulativePatientsLastUpdate: String
    var newlyDeaths: String? = nil
    var newlyDeathsLastUpdate: String? = nil
    var comulativeDeaths: String? = nil
    var comulativeDeathsLastUpdate: String? = nil
    
    //    init(newlyPatients: String, newlyPatientslastUpdate: String, comulativePatients: String, comulativePatientsLastUpdate: String, newlyDeaths: String? = nil, newlyDeathsLastUpdate: String? = nil, comulativeDeaths: String? = nil, comulativeDeathsLastUpdate: String? = nil) {
    //
    //    }
    
    var body: some View {
        HStack(spacing: 10){
            VStack {
                HStack {
                    Image(systemName: "waveform.path.ecg")
                    Text("新規感染者")
                        .fontWeight(.light)
                }
                Text(self.newlyPatients)
                    .font(.system(size: 40, weight: .bold, design: .default))
                Text(self.newlyPatientslastUpdate)
                    .font(.caption2)
                    .fontWeight(.light)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
            )
            VStack {
                HStack {
                    Image(systemName: "chart.bar.fill")
                    Text("累積感染者")
                        .fontWeight(.light)
                }
                Text(self.comulativePatients)
                    .font(.system(size: 40, weight: .bold, design: .default))
                Text(self.comulativePatientsLastUpdate)
                    .font(.caption2)
                    .fontWeight(.light)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
            )
            if let newlyDeaths = self.newlyDeaths {
                VStack {
                    HStack {
                        Image(systemName: "waveform.path.ecg")
                        Text("新規死亡者")
                            .fontWeight(.light)
                    }
                    Text(newlyDeaths)
                        .font(.system(size: 40, weight: .bold, design: .default))
                    Text(self.newlyDeathsLastUpdate ?? "")
                        .font(.caption2)
                        .fontWeight(.light)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                )
            }
            if let comulativeDeaths = self.comulativeDeaths {
                VStack {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                        Text("累積死亡者")
                            .fontWeight(.light)
                    }
                    Text(comulativeDeaths)
                        .font(.system(size: 40, weight: .bold, design: .default))
                    Text(self.comulativeDeathsLastUpdate ?? "")
                        .font(.caption2)
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
        HeaderView(newlyPatients: "456", newlyPatientslastUpdate: "2021-07-23", comulativePatients: "123456", comulativePatientsLastUpdate: "2021-07-23", newlyDeaths: "81" , newlyDeathsLastUpdate: "2021-07-23" , comulativeDeaths: "15101" , comulativeDeathsLastUpdate: "2021-07-23" )
    }
}

struct HeaderView_Previews2: PreviewProvider {
    static var previews: some View {
        HeaderView(newlyPatients: "456", newlyPatientslastUpdate: "2021-07-23", comulativePatients: "123456", comulativePatientsLastUpdate: "2021-07-23")
    }
}
