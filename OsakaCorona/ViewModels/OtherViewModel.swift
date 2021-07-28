//
//  OtherPaitientsViewModel.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/27.
//

import Foundation
import Combine

class OtherViewModel: ObservableObject {
    //MARK: - Properties
    @Published var loadedData = [ItemData]() {
        didSet {
            getLatestDateOfPatients()
            getComulPatientsNumLastDay()
            getComulPatientsAll()
            getComulPatientsNumInMonths()
            getComulPatientsNumInWeeks()
            getComulPatientsNumInDays()
            getNewPatientsNumLastDay()
            getNewPatientsAll()
            getNewPatientsNumInMonths()
            getNewPatientsNumInWeeks()
            getNewPatientsNumInDays()
        }
    }
    
    @Published var selectedLocation: String {
        didSet {
            UserDefaults.standard.set(selectedLocation, forKey:"sLocation")
            loadPatientsData()
        }
    }
    
    @Published var latestDateOfPatients = "Loading..."
    @Published var comulPatientsNumLastDay = "Loading..."
    private var comulPatientsAll = [(String, Double)]()
    @Published var comulPatientsNumInMonths = [(String, Double)]()
    @Published var comulPatientsNumInWeeks = [(String, Double)]()
    @Published var comulPatientsNumInDays = [(String, Double)]()
    
    @Published var newPatientsNumLastDay = "Loading..."
    @Published var newPatientsAll = [Double]()
    @Published var newPatientsNumInMonths = [Double]()
    @Published var newPatientsNumInWeeks = [Double]()
    @Published var newPatientsNumInDays = [Double]()
    
    //MARK: - Functions
    //MARK: - Initialize
    init() {
        selectedLocation = UserDefaults.standard.string(forKey: "sLocation") ?? "北海道"
        loadPatientsData()
    }
    
    //MARK: - 感染者数のJSONデータをデコードして取得
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
    
    //MARK: - 感染者データの最終日を取得する
    func getLatestDateOfPatients() {
        if let date = self.loadedData.last?.date {
            self.latestDateOfPatients = String(date)
        }
    }
    
    //MARK: - 累積感染者
    // 最終日の累積感染者数を取得する
    func getComulPatientsNumLastDay() {
        if let patients = self.loadedData.last?.npatients {
            comulPatientsNumLastDay = patients
        }
    }
    
    // 全期間の累積感染者数を出力する
    func getComulPatientsAll() {
        for item in loadedData {
            guard let num = Double(item.npatients) else { continue }
            comulPatientsAll.append((item.date, num))
        }
    }
    //　24ヶ月間の累積感染者数を取得する
    func getComulPatientsNumInMonths() {
        let patientsData = loadedData
        
        var patientsAll = [(String, Double)]()
        for item in patientsData {
            guard let patients = Double(item.npatients) else { continue }
            patientsAll.append((item.date, patients))
        }
        
        var patientsInMonths = [(String, Double)]()
        let lastDatesExceptFeb = ["-04-30", "-06-30", "-09-30", "-11-30"]
        for (index, item) in patientsAll.enumerated() {
            // 最新の日付と月違いの同じ日にちだったら配列に追加する
            if item.0.hasSuffix(latestDateOfPatients.suffix(3)) {
                patientsInMonths.append(item)
                // 最新の日付が31日か30日で、かつループのitemの日付が2月28日だった場合
            } else if (latestDateOfPatients.hasSuffix("-31") || latestDateOfPatients.hasSuffix("-30")) && item.0.hasSuffix("-02-28") {
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
                    if latestDateOfPatients.hasSuffix("-31") && item.0.hasSuffix(date) {
                        patientsInMonths.append(item)
                    }
                }
            }
        }
        if patientsInMonths.count >= 24 {
            comulPatientsNumInMonths = Array(patientsInMonths.suffix(24))
        } else {
            comulPatientsNumInMonths = patientsInMonths
        }
    }
    // 12週間の累積感染者数を取得する
    func getComulPatientsNumInWeeks() {
        var patients = [(String, Double)]()
        for (index, item) in comulPatientsAll.enumerated() {
            if index == 0 || (index + 1) % 7 == 0 {
                patients.append(item)
            }
        }
        if patients.count >= 12 {
            comulPatientsNumInWeeks = Array(patients.suffix(12))
        } else {
            comulPatientsNumInWeeks = patients
        }
    }
    // 7日間の累積感染者数を取得する
    func getComulPatientsNumInDays() {
        let patients = comulPatientsAll
        if patients.count >= 7 {
            comulPatientsNumInDays = Array(patients.suffix(7))
        } else {
            comulPatientsNumInDays = patients
        }
    }
    
    //MARK: - 新規感染者
    // 最終日の新規感染者数を取得
    func getNewPatientsNumLastDay() {
        if let patients = self.loadedData.last?.npatients {
            if let comulativeLastDay = Int(patients) {
                if let comulativePreviousDay = Int(self.loadedData[self.loadedData.count-2].npatients) {
                    newPatientsNumLastDay = String(comulativeLastDay - comulativePreviousDay)
                }
            }
        }
    }
    
    // 全期間の新規患者数を出力する
    func getNewPatientsAll() {
        // 累積陽性患者数の配列を作成
        var comulativePatinets = [Double]()
        for item in loadedData {
            guard let num = Double(item.npatients) else { continue }
            comulativePatinets.append(num)
        }
        var differences = [Double]()
        for (index, item) in comulativePatinets.enumerated() {
            if index + 1 < comulativePatinets.count {
                let nextItem = comulativePatinets[index + 1]
                let diff = nextItem - item
                differences.append(diff)
            }
        }
        newPatientsAll = differences
    }
    // 24ヶ月間の新規感染者数を取得する
    func getNewPatientsNumInMonths() {
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
        
        var patientsInMonths = [Double]()
        let lastDatesExceptFeb = ["-04-30", "-06-30", "-09-30", "-11-30"]
        for (index, item) in patients.enumerated() {
            // データの最新の日付と月違いの同じ日にちだったら配列に追加する
            if item.0.hasSuffix(latestDateOfPatients.suffix(3)) {
                patientsInMonths.append(item.1)
                // データの最新の日にちが31日か30日で、かつループitemの日付が2月28日の場合
            } else if (latestDateOfPatients.hasSuffix("-31") || latestDateOfPatients.hasSuffix("-30")) && item.0.hasSuffix("-02-28") {
                let nextItem = patients[index + 1]
                // 閏年で2月29日のデータが見つかったら2月29日のデータを配列に追加
                if (nextItem.0.hasSuffix("-02-29")) {
                    patientsInMonths.append(nextItem.1)
                // 閏年ではなく2月29日のデータが見つからない場合は2月28日のデータを配列に追加
                } else {
                    patientsInMonths.append(item.1)
                }
            } else {
                for date in lastDatesExceptFeb {
                    // データの最新の日付が31日で、かつループitemの日付が月末が30日の月の末日の場合は、その末日のデータを配列に追加
                    if latestDateOfPatients.hasSuffix("-31") && item.0.hasSuffix(date) {
                        patientsInMonths.append(item.1)
                    }
                }
            }
        }
        if newPatientsNumInMonths.count >= 24 {
            newPatientsNumInMonths = Array(patientsInMonths.suffix(24))
        } else {
            newPatientsNumInMonths = patientsInMonths
        }
    }
    // 12週間の新規感染者数を取得する
    func getNewPatientsNumInWeeks() {
        var patients = [Double]()
        for (index, item) in newPatientsAll.enumerated() {
            if index == 0 || (index + 1) % 7 == 0 {
                patients.append(item)
            }
        }
        if patients.count >= 12 {
            newPatientsNumInWeeks = Array(patients.suffix(12))
        } else {
            newPatientsNumInWeeks = patients
        }
    }
    // 7日間の新規感染者数を取得する
    func getNewPatientsNumInDays() {
        let patients = newPatientsAll
        if patients.count >= 7 {
            newPatientsNumInDays = Array(patients.suffix(7))
        } else {
            newPatientsNumInDays = patients
        }
    }
}
