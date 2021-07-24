//
//  DataFetcher.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/19.
//

import Foundation
import Combine

class DataManager: ObservableObject {
    @Published var AreaPatientsData: AreaPatientsDataModel?
    let endpoint = "https://opendata.corona.go.jp/api/Covid19JapanAll"
    @Published var selectedLocation = "大阪府"//"%E5%A4%A7%E9%98%AA%E5%BA%9C"
    @Published var selectedDate = "20210718"
    
    func loadAreaPatientsData() {
        let completeURL = endpoint + "?dataName=" + selectedLocation
        print("completeURL: \(completeURL)")
        guard let url = URL(string: completeURL) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let resData = try JSONDecoder().decode(AreaPatientsDataModel.self, from: data)
                //print(resData)
                DispatchQueue.main.async {
                    self.AreaPatientsData = resData
                }
            } catch {
                fatalError("Failed loading \(error)")
            }
        }.resume()
    }
    
    func loadDateAreaPatientsData() {
        let completeURL = endpoint + "?date=" + selectedDate + "&dataName=" + selectedLocation
        print("completeURL: \(completeURL)")
        guard let url = URL(string: completeURL) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let resData = try JSONDecoder().decode(AreaPatientsDataModel.self, from: data)
                //print(resData)
                DispatchQueue.main.async {
                    self.AreaPatientsData = resData
                }
            } catch {
                fatalError("Failed loading \(error)")
            }
        }.resume()
    }
}
