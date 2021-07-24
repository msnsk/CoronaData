//
//  JapanDataFetcher.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/21.
//

import Foundation
import Combine

class JapanPatientsDataFetcher: ObservableObject {
    @Published var loadedJapanaData: [JapanDataModel]?
    let endpoint = "https://data.corona.go.jp/converted-json/covid19japan-npatients.json"
    
    func loadJapanData() {
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let resData = try JSONDecoder().decode([JapanDataModel].self, from: data)
                //print(resData)
                DispatchQueue.main.async {
                    self.loadedJapanaData = resData
                }
            } catch {
                fatalError("Failed loading \(error)")
            }
        }.resume()
    }
}
