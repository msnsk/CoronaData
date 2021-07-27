//
//  DataFetcher.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/19.
//

// TODO: 計測期間の一番新しい日付を含める！！！！！

import Foundation
import Combine

class LocalViewModel: ObservableObject {
    
    @Published var localPatientsData = [ItemData]()
    @Published var currentLocation: String {
        didSet {
            UserDefaults.standard.set(currentLocation, forKey:"location")
            loadPatientsData()
        }
    }
    
    init() {
        currentLocation = UserDefaults.standard.string(forKey: "location") ?? "青森県"
        loadPatientsData()
    }
    
    func convertLocationName(area: String?) {
        if let areaName = area {
            currentLocation = areaNameDict[areaName] ?? "青森県"
        }
    }
    // ここから累積感染者数
    // 累積感染者数のJSONデータをデコードして取得する
    func loadPatientsData() {
        guard let encodedLocation = self.currentLocation.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
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
                    self.localPatientsData = fetchedData.itemList.reversed()
                }
            } catch {
                fatalError("Local Patients: Failed loading \(error)")
            }
        }.resume()
    }
    
    // 感染者データの最終日を取得する
    func getLocalPatientsLatestDate() -> String {
        var latestDate = "Loading..."
        if let date = self.localPatientsData.last?.date {
            latestDate = String(date)
        }
        return latestDate
    }
    
    // 最終日の累積感染者数を取得する
    func getComulativePatientsOnLastDay() -> String {
        var comulativePatientsLastDay = "Loading..."
        if let patients = self.localPatientsData.last?.npatients {
            comulativePatientsLastDay = patients
        }
        return comulativePatientsLastDay
    }
    
    // 全期間の累積感染者数を出力する
    func getLocalComulativePatients() -> [(String, Double)] {
        var localComulativePatients = [(String, Double)]()
        for item in self.localPatientsData {
            guard let num = Double(item.npatients) else { continue }
            localComulativePatients.append((item.date, num))
        }
        return localComulativePatients
    }
    //　24ヶ月間の累積感染者数を取得する
    func getLocalComulativePatientsInMonths() -> [(String, Double)] {
        let patientsData = self.localPatientsData
        
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
        if let patients = self.localPatientsData.last?.npatients {
            guard let comulativeLastDay = Int(patients) else {
                return newlyPatientsLastDay
            }
            guard let comulativePreviousDay = Int(self.localPatientsData[self.localPatientsData.count-2].npatients) else {
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
        for item in self.localPatientsData {
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
        let comulativePatients = self.localPatientsData
        
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
    
//    // ここから累積死亡者数
//    // 累積死亡者数のJSONデータをデコードして取得
//    func loadLocalDeathsData() {
//    guard let encodedLocation = self.currentLocation.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return }
//        let endpoint = "https://opendata.corona.go.jp/api/Covid19JapanNdeaths?dataName=" + encodedLocation
//        guard let url = URL(string: endpoint) else {
//            print("Invalid URL")
//            return
//        }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else { return }
//            do {
//                let fetchedData = try JSONDecoder().decode(localDeathsDataModel.self, from: data)
//                DispatchQueue.main.async {
//                    print(fetchedData.itemList[0])
//                    self.localDeathsData = fetchedData.itemList
//                }
//            } catch {
//                fatalError("Failed loading \(error)")
//            }
//        }.resume()
//    }
//    // 累積死亡者の最終更新日を取得する
//    func getLocalDeathsLatestDate() -> String {
//        var latestDate = "Loading..."
//        if let ndeaths = self.localDeathsData.last?.date {
//            latestDate = ndeaths
//        }
//        return latestDate
//    }
//    // 最終更新日の累積死亡者数を取得する
//    func getLocalComulativeDeathsOnLastDay() -> String {
//        var deathsLastDay = "Loading..."
//        if let ndeaths = self.localDeathsData.last?.ndeaths {
//            deathsLastDay = ndeaths
//        }
//        return deathsLastDay
//    }
//    // 全期間の累積死亡者数を取得する
//    func getLocalLocalComulativeDeathsAll() -> [(String, Double)] {
//        var deathsAll = [(String, Double)]()
//        for item in self.localDeathsData {
//            guard let ndeaths = Double(item.ndeaths) else { continue }
//            deathsAll.append((item.date, ndeaths))
//        }
//        return deathsAll
//    }
//    // 24ヶ月の累積死亡者数を取得する
//    func getLocalComulativeDeathsInMonths() -> [(String, Double)] {
//        let deathData = self.localDeathsData
//        let latestDate = self.getLocalDeathsLatestDate()
//
//        var deathsAll = [(String, Double)]()
//        for item in deathData {
//            guard let ndeaths = Double(item.ndeaths) else { continue }
//            deathsAll.append((item.date, ndeaths))
//        }
//
//        var deathsInMonths = [(String, Double)]()
//        let lastDatesExceptFeb = ["-04-30", "-06-30", "-09-30", "-11-30"]
//        for (index, item) in deathsAll.enumerated() {
//            // 最新の日付と月違いの同じ日にちだったら配列に追加する
//            if item.0.hasSuffix(latestDate.suffix(3)) {
//                deathsInMonths.append(item)
//                // 最新の日付が31日か30日で、かつループのitemの日付が2月28日だった場合
//            } else if (latestDate.hasSuffix("-31") || latestDate.hasSuffix("-30")) && item.0.hasSuffix("-02-28") {
//                // 閏年で2月29日のデータがある場合は2月29日のデータを配列に追加
//                if (deathsAll[index + 1].0.hasSuffix("-02-29")) {
//                    deathsInMonths.append(deathsAll[index + 1])
//                    // 閏年ではなく2月29日のデータがない場合は2月28日のデータを配列に追加
//                } else {
//                    deathsInMonths.append(item)
//                }
//                // 最新の日付が31日で、かつループのitemの日付が月末が30日までの月の末日の場合は30日のデータを配列に追加
//            } else {
//                for date in lastDatesExceptFeb {
//                    if latestDate.hasSuffix("-31") && item.0.hasSuffix(date) {
//                        deathsInMonths.append(item)
//                    }
//                }
//            }
//        }
//        if deathsInMonths.count >= 24 {
//            return Array(deathsInMonths.suffix(24))
//        } else {
//            return deathsInMonths
//        }
//    }
//    // 12週間の累積死亡者数を取得する
//    func getLocalComulativeDeathsInWeeks()  -> [(String, Double)] {
//        var deathsInWeeks = [(String, Double)]()
//        for (index, item) in self.getLocalLocalComulativeDeathsAll().enumerated() {
//            if index == 0 || (index + 1) % 7 == 0 {
//                deathsInWeeks.append(item)
//            }
//        }
//        if deathsInWeeks.count >= 12 {
//            return Array(deathsInWeeks.suffix(12))
//        } else {
//            return deathsInWeeks
//        }
//    }
//    // 7日間の累積死亡者数を取得する
//    func getLocalComulativeDeathsInDays()  -> [(String, Double)] {
//        let deathsInDays = self.getLocalLocalComulativeDeathsAll()
//        if deathsInDays.count >= 7 {
//            return Array(deathsInDays.suffix(7))
//        } else {
//            return deathsInDays
//        }
//    }
//    // ここから新規死亡者
//    // 最終更新日の新規死亡者数を取得する
//    func getLocalNewlyDeathsOnLastDay() -> String {
//        var newlyDeathsLastDay = "Loading..."
//        if let deaths = self.localDeathsData.last?.ndeaths {
//            guard let deathsLastDay = Int(deaths) else {
//                return newlyDeathsLastDay
//            }
//            guard let deathsPreviousDay = Int(self.localDeathsData[self.localDeathsData.count-2].ndeaths) else {
//                return newlyDeathsLastDay
//            }
//            newlyDeathsLastDay = String(deathsLastDay - deathsPreviousDay)
//            return newlyDeathsLastDay
//        }
//        return newlyDeathsLastDay
//    }
//    // 全期間の新規死亡者数を出力する
//    func getLocalNewlyDeaths() -> [Double] {
//        let deathsData = self.localDeathsData
//
//        var deathAll = [Double]()
//        for item in deathsData {
//            guard let deaths = Double(item.ndeaths) else { continue }
//            deathAll.append(deaths)
//        }
//        var newlyDeaths = [Double]()
//        for (index, item) in deathAll.enumerated() {
//            if index + 1 < deathAll.count {
//                let nextItem = deathAll[index + 1]
//                let newlyPatient = nextItem - item
//                newlyDeaths.append(newlyPatient)
//            }
//        }
//        return newlyDeaths
//    }
//    // 24ヶ月間の新規死亡者数を取得する
//    func getLocalNewylyDeathsInMonths() -> [Double] {
//        let deathsData = self.localDeathsData
//        let latestDate = self.getLocalDeathsLatestDate()
//
//        var deathsAll = [(String, Double)]()
//        for (index, item) in deathsData.enumerated() {
//            if index + 1 < deathsData.count {
//                let nextItem = deathsData[index + 1]
//                guard let previousDeaths = Double(item.ndeaths) else { continue }
//                guard let nextDeaths = Double(nextItem.ndeaths) else { continue }
//                let difference = nextDeaths - previousDeaths
//                deathsAll.append((nextItem.date, difference))
//            }
//        }
//
//        var deathsInMonths = [(String, Double)]()
//        let lastDatesExceptFeb = ["-04-30", "-06-30", "-09-30", "-11-30"]
//        for (index, item) in deathsAll.enumerated() {
//            // データの最新の日付と月違いの同じ日にちだったら配列に追加する
//            if item.0.hasSuffix(latestDate.suffix(3)) {
//                deathsInMonths.append(item)
//                // データの最新の日にちが31日か30日で、かつループitemの日付が2月28日の場合
//            } else if (latestDate.hasSuffix("-31") || latestDate.hasSuffix("-30")) && item.0.hasSuffix("-02-28") {
//                // 閏年で2月29日のデータが見つかったら2月29日のデータを配列に追加
//                if (deathsAll[index + 1].0.hasSuffix("-02-29")) {
//                    deathsInMonths.append(deathsAll[index + 1])
//                    // 閏年ではなく2月29日のデータが見つからない場合は2月28日のデータを配列に追加
//                } else {
//                    deathsInMonths.append(item)
//                }
//            } else {
//                for date in lastDatesExceptFeb {
//                    // データの最新の日付が31日で、かつループitemの日付が月末が30日の月の末日の場合は、その末日のデータを配列に追加
//                    if latestDate.hasSuffix("-31") && item.0.hasSuffix(date) {
//                        deathsInMonths.append(item)
//                    }
//                }
//            }
//        }
//        var newlyDeathsInMonthsDouble = [Double]()
//        for item in deathsInMonths {
//            newlyDeathsInMonthsDouble.append(item.1)
//        }
//        if newlyDeathsInMonthsDouble.count >= 24 {
//            return Array(newlyDeathsInMonthsDouble.suffix(24))
//        } else {
//            return newlyDeathsInMonthsDouble
//        }
//    }
//    // 12週間の新規死亡者数を取得する
//    func getLocalNewlyDeathsInWeeks() -> [Double] {
//        var deathsInWeeks = [Double]()
//        for (index, item) in getLocalNewlyDeaths().enumerated() {
//            if index == 0 || (index + 1) % 7 == 0 {
//                deathsInWeeks.append(item)
//            }
//        }
//        if deathsInWeeks.count >= 12 {
//            return Array(deathsInWeeks.suffix(12))
//        } else {
//            return deathsInWeeks
//        }
//    }
//    // 7日間の新規死亡者数を取得する
//    func getLocalNewlyDeathsInDays() -> [Double] {
//        let patients = getLocalNewlyDeaths()
//        if patients.count >= 7 {
//            return Array(patients.suffix(7))
//        } else {
//            return patients
//        }
//    }
}
