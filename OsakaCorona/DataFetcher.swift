//
//  DataFetcher.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/19.
//

import Foundation
import Combine

class AreaDataFetcher: ObservableObject {
    @Published var loadedData: DataModelForLocal?
    
    func loadData(url: String, date: String, location: String, completion: @escaping (DataModelForLocal) -> ()) {
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
        print(fixedURL)
        guard let url = URL(string: fixedURL) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let resData = try JSONDecoder().decode(DataModelForLocal.self, from: data)
                //print(resData)
                DispatchQueue.main.async {
                    self.loadedData = resData
                }
            } catch {
                fatalError("Failed loading \(error)")
            }
        }.resume()
    }
}
