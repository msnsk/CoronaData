//
//  OtherPaitientsViewModel.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/27.
//

import Foundation
import Combine

class OtherViewModel: ObservableObject {
    
    @Published var loadedData = [ItemData]()
    @Published var selectedLocation: String {
        didSet {
            UserDefaults.standard.set(selectedLocation, forKey:"sLocation")
            loadPatientsData()
        }
    }
    
    init() {
        selectedLocation = UserDefaults.standard.string(forKey: "sLocation") ?? "北海道"
        loadPatientsData()
    }
    
    func convertLocationName(area: String?) {
        if let areaName = area {
            selectedLocation = areaNameDict[areaName] ?? "北海道"
        }
    }
    // ここから累積感染者数
    // 累積感染者数のJSONデータをデコードして取得する
    func loadPatientsData() {
        guard let encodedLocation = self.selectedLocation.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return
        }
        let completeURL = "https://opendata.corona.go.jp/api/Covid19JapanAll" + "?dataName=" + encodedLocation
        //print("completeURL: \(completeURL)")
        guard let url = URL(string: completeURL) else {
            print("Local Patients - Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("Local Patients: Status Code: \(statusCode)")
            guard let jsonData = data else { return }
            do {
                let fetchedData = try JSONDecoder().decode(LocalPatientsDataModel.self, from: jsonData)
                DispatchQueue.main.async {
                    self.loadedData = fetchedData.itemList.reversed()
                }
            } catch {
                fatalError("Local Patients: Failed loading \(error)")
            }
        }.resume()
    }
    
    // 感染者データの最終日を取得する
    func getLocalPatientsLatestDate() -> String {
        var latestDate = "Loading..."
        if let date = self.loadedData.last?.date {
            latestDate = String(date)
        }
        return latestDate
    }
    
    // 最終日の累積感染者数を取得する
    func getComulativePatientsOnLastDay() -> String {
        var comulativePatientsLastDay = "Loading..."
        if let patients = self.loadedData.last?.npatients {
            comulativePatientsLastDay = patients
        }
        return comulativePatientsLastDay
    }
    
    // 全期間の累積感染者数を出力する
    func getLocalComulativePatients() -> [(String, Double)] {
        var localComulativePatients = [(String, Double)]()
        for item in self.loadedData {
            guard let num = Double(item.npatients) else { continue }
            localComulativePatients.append((item.date, num))
        }
        return localComulativePatients
    }
    //　24ヶ月間の累積感染者数を取得する
    func getLocalComulativePatientsInMonths() -> [(String, Double)] {
        let patientsData = self.loadedData
        
        var patientsAll = [(String, Double)]()
        for item in patientsData {
            guard let patients = Double(item.npatients) else { continue }
            patientsAll.append((item.date, patients))
        }
        
        var patientsInMonths = [(String, Double)]()
        let lastDatesExceptFeb = ["-04-30", "-06-30", "-09-30", "-11-30"]
        for (index, item) in patientsAll.enumerated() {
            // 最新の日付と月違いの同じ日にちだったら配列に追加する
            if item.0.hasSuffix(getLocalPatientsLatestDate().suffix(3)) {
                patientsInMonths.append(item)
                // 最新の日付が31日か30日で、かつループのitemの日付が2月28日だった場合
            } else if (getLocalPatientsLatestDate().hasSuffix("-31") || getLocalPatientsLatestDate().hasSuffix("-30")) && item.0.hasSuffix("-02-28") {
                // 閏年で2月29日のデータがある場合は2月29日のデータを配列に追加
                if (patientsAll[index + 1].0.hasSuffix("-02-29")) {
                    patientsInMonths.append(patientsAll[index + 1])
                    // 閏年ではなく2月29日のデータがない場合は2月28日のデータを配列に追加
                } else {
                    patientsInMonths.append(item)
                }
                // 最新の日付が31日で、かつループのitemの日付が月末が30日までの月の末日の場合は30日のデータを配列に追加
            } else {
                for date in lastDatesExceptFeb {
                    if getLocalPatientsLatestDate().hasSuffix("-31") && item.0.hasSuffix(date) {
                        patientsInMonths.append(item)
                    }
                }
            }
        }
        if patientsInMonths.count >= 24 {
            return Array(patientsInMonths.suffix(24))
        } else {
            return patientsInMonths
        }
    }
    // 12週間の累積感染者数を取得する
    func getLocalComulativePatientsInWeeks()  -> [(String, Double)] {
        var patients = [(String, Double)]()
        for (index, item) in self.getLocalComulativePatients().enumerated() {
            if index == 0 || (index + 1) % 7 == 0 {
                patients.append(item)
            }
        }
        if patients.count >= 12 {
            return Array(patients.suffix(12))
        } else {
            return patients
        }
    }
    // 7日間の累積感染者数を取得する
    func getLocalComulativePatientsInDays()  -> [(String, Double)] {
        let patients = self.getLocalComulativePatients()
        if patients.count >= 7 {
            return Array(patients.suffix(7))
        } else {
            return patients
        }
    }
    
    // ここから新規感染者数
    // 最終日の新規感染者数を取得
    func getNewlyPatientsOnLastDay() -> String {
        var newlyPatientsLastDay = "Loading..."
        if let patients = self.loadedData.last?.npatients {
            guard let comulativeLastDay = Int(patients) else {
                return newlyPatientsLastDay
            }
            guard let comulativePreviousDay = Int(self.loadedData[self.loadedData.count-2].npatients) else {
                return  newlyPatientsLastDay
            }
            newlyPatientsLastDay = String(comulativeLastDay - comulativePreviousDay)
            return newlyPatientsLastDay
        }
        return newlyPatientsLastDay
    }
    // 全期間の新規患者数を出力する
    func getLocalNewlyPatients() -> [Double] {
        // 累積陽性患者数の配列を作成
        var comulativePatinets = [Double]()
        for item in self.loadedData {
            guard let num = Double(item.npatients) else { continue }
            comulativePatinets.append(num)
        }
        var newlyPatients = [Double]()
        for (index, item) in comulativePatinets.enumerated() {
            if index + 1 < comulativePatinets.count {
                let nextItem = comulativePatinets[index + 1]
                let newlyPatient = nextItem - item
                newlyPatients.append(newlyPatient)
            }
        }
        return newlyPatients
    }
    // 24ヶ月間の新規感染者数を取得する
    func getLocalNewylyPatientsInMonths() -> [Double] {
        let comulativePatients = self.loadedData
        
        var patients = [(String, Double)]()
        for (index, item) in comulativePatients.enumerated() {
            if index + 1 < comulativePatients.count {
                let nextItem = comulativePatients[index + 1]
                guard let lastPatients = Double(item.npatients) else { continue }
                guard let nextPatients = Double(nextItem.npatients) else { continue }
                let difference = nextPatients - lastPatients
                patients.append((nextItem.date, difference))
            }
        }
        
        var patientsInMonths = [(String, Double)]()
        let lastDatesExceptFeb = ["-04-30", "-06-30", "-09-30", "-11-30"]
        for (index, item) in patients.enumerated() {
            // データの最新の日付と月違いの同じ日にちだったら配列に追加する
            if item.0.hasSuffix(getLocalPatientsLatestDate().suffix(3)) {
                patientsInMonths.append(item)
                // データの最新の日にちが31日か30日で、かつループitemの日付が2月28日の場合
            } else if (getLocalPatientsLatestDate().hasSuffix("-31") || getLocalPatientsLatestDate().hasSuffix("-30")) && item.0.hasSuffix("-02-28") {
                // 閏年で2月29日のデータが見つかったら2月29日のデータを配列に追加
                if (patients[index + 1].0.hasSuffix("-02-29")) {
                    patientsInMonths.append(patients[index + 1])
                    // 閏年ではなく2月29日のデータが見つからない場合は2月28日のデータを配列に追加
                } else {
                    patientsInMonths.append(item)
                }
            } else {
                for date in lastDatesExceptFeb {
                    // データの最新の日付が31日で、かつループitemの日付が月末が30日の月の末日の場合は、その末日のデータを配列に追加
                    if getLocalPatientsLatestDate().hasSuffix("-31") && item.0.hasSuffix(date) {
                        patientsInMonths.append(item)
                    }
                }
            }
        }
        var newlyPatientsInMonthsDouble = [Double]()
        for item in patientsInMonths {
            newlyPatientsInMonthsDouble.append(item.1)
        }
        if newlyPatientsInMonthsDouble.count >= 24 {
            return Array(newlyPatientsInMonthsDouble.suffix(24))
        } else {
            return newlyPatientsInMonthsDouble
        }
    }
    // 12週間の新規感染者数を取得する
    func getLocalNewlyPatientsInWeeks() -> [Double] {
        var patients = [Double]()
        for (index, item) in getLocalNewlyPatients().enumerated() {
            if index == 0 || (index + 1) % 7 == 0 {
                patients.append(item)
            }
        }
        if patients.count >= 12 {
            return Array(patients.suffix(12))
        } else {
            return patients
        }
    }
    // 7日間の新規感染者数を取得する
    func getLocalNewlyPatientsInDays() -> [Double] {
        let patients = getLocalNewlyPatients()
        if patients.count >= 7 {
            return Array(patients.suffix(7))
        } else {
            return patients
        }
    }
}
