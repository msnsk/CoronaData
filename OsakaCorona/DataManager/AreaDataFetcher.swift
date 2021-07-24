//
//  DataFetcher.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/19.
//

import Foundation
import Combine

class AreaPatientsDataFetcher: ObservableObject {
    @Published var loadedAreaData: AreaPatientsDataModel?
    
    func loadAreaData(url: String, date: String, location: String) {
        var fixedURL = ""
        if date == "" && location == "" {
            fixedURL = url
        } else if date == "" {
            fixedURL = url + "?dataName=" + location
        } else if location == "" {
            fixedURL = url + "?date=" + location
        } else {
            fixedURL = url + "?date=" + location + "&dataName=" + location
        }
        print("fixedURL\(fixedURL)")
        guard let url = URL(string: fixedURL) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let resData = try JSONDecoder().decode(AreaPatientsDataModel.self, from: data)
                //print(resData)
                DispatchQueue.main.async {
                    self.loadedAreaData = resData
                }
            } catch {
                fatalError("Failed loading \(error)")
            }
        }.resume()
    }
}
