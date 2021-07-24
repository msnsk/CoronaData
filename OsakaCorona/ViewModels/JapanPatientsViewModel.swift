//
//  JapanPatientsViewModel.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/23.
//

import Foundation
import Combine

class JapanPatientsViewModel: ObservableObject {
    @Published var japanPatientsData = [JapanPatientsDataModel]()
    @Published var japanPatientsNeedInpatient = [JapanPatientsNeedInpatientModel]()
    @Published var japanDeathsData = [JapanDeathsModel]()
    @Published var prefecturePatientsData = [Area]()
    
    init() {
        self.loadJapanPatientsData()
        self.loadJapanPatientsNeedInpatientData()
        self.loadJapanDeathsData()
        self.loadPrefectureComulativePatients()
    }
    
    func loadJapanPatientsData() {
        guard let url = URL(string: "https://data.corona.go.jp/converted-json/covid19japan-npatients.json") else {
            print("Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("Status Code: \(statusCode)")
            guard let jsonData = data else { return }
            do {
                let fetchedData = try JSONDecoder().decode([JapanPatientsDataModel].self, from: jsonData)
                DispatchQueue.main.async {
                    self.japanPatientsData = fetchedData
                }
            } catch {
                fatalError("Failed loading \(error)")
            }
        }.resume()
        
    }
    // 累積感染者数のデータの最終更新日を取得する
    func getJapanPatientsLatestDate() -> String {
        var latestDate = "Loading..."
        if let date = self.japanPatientsData.last?.date {
            latestDate = String(date)
        }
        return latestDate
    }
    // 最終更新日の累積感染者数を取得する
    func getComulativePatientsOnLastDay() -> String {
        var comulativePatientsLastDay = "Loading..."
        if let patients = self.japanPatientsData.last?.npatients {
            comulativePatientsLastDay = String(patients)
        }
        return comulativePatientsLastDay
    }
    // 12ヶ月間の累積感染者数を取得する
    func getJapanComulativePatientsInMonths() -> [(String, Double)] {
        let comulativePatients = self.japanPatientsData
        let lastDatesExceptFeb = ["-04-30", "-06-30", "-09-30", "-11-30"]
        var newlyPatientsInMonths = [(String, Double)]()
        
        for (index, item) in comulativePatients.enumerated() {
            // データの最新の日付と月違いの同じ日にちだったら配列に追加する
            if item.date.hasSuffix(getJapanPatientsLatestDate().suffix(3)) {
                newlyPatientsInMonths.append((item.date, Double(item.npatients)))
            // データの最新の日にちが31日か30日で、かつループitemの日付が2月28日の場合
            } else if (getJapanPatientsLatestDate().hasSuffix("-31") || getJapanPatientsLatestDate().hasSuffix("-30")) && item.date.hasSuffix("-02-28") {
                // 閏年で2月29日のデータが見つかったら2月29日のデータを配列に追加
                if comulativePatients[index + 1].date.hasSuffix("-02-29") {
                    newlyPatientsInMonths.append((comulativePatients[index + 1].date, Double(comulativePatients[index + 1].npatients)))
                // 閏年ではなく2月29日のデータが見つからない場合は2月28日のデータを配列に追加
                } else {
                    newlyPatientsInMonths.append((item.date, Double(item.npatients)))
                }
            } else {
                for date in lastDatesExceptFeb {
                    // データの最新の日付が31日で、かつループitemの日付が月末が30日の月の末日の場合は、その末日のデータを配列に追加
                    if getJapanPatientsLatestDate().hasSuffix("-31") && item.date.hasSuffix(date) {
                        newlyPatientsInMonths.append((item.date, Double(item.npatients)))
                    }
                }
            }
        }
        if newlyPatientsInMonths.count >= 24 {
            return Array(newlyPatientsInMonths.suffix(24))
        } else {
            return newlyPatientsInMonths
        }
    }
    // 12週間の累積感染者数を取得する
    func getJapanComulativePatientsInWeeks() -> [(String, Double)] {
        var japanComulativePatientsInWeeks = [(String, Double)]()
        for (index, item) in self.japanPatientsData.reversed().enumerated() {
            if index == 0 || (index + 1) % 7 == 0 {
                japanComulativePatientsInWeeks.append((item.date, Double(item.npatients)))
            }
        }
        if japanComulativePatientsInWeeks.count >= 12 {
            return Array(japanComulativePatientsInWeeks.reversed().suffix(12))
        } else {
            return japanComulativePatientsInWeeks.reversed()
        }
    }
    // 7日間の累積感染者数を取得する
    func getJapanComulativePatientsInDays() -> [(String, Double)] {
        var japanComulativePatientsInDays = [(String, Double)]()
        for item in self.japanPatientsData {
            japanComulativePatientsInDays.append((item.date, Double(item.npatients)))
        }
        if japanComulativePatientsInDays.count >= 7 {
            return Array(japanComulativePatientsInDays.suffix(7))
        } else {
            return japanComulativePatientsInDays
        }
    }
    
    // ここから新規感染者
    // 最終更新日の新規感染者数を取得する
    func getNewlyPatientsOnLastDay() -> String {
        var NewlyPatientsLastDay = "Loading..."
        if let patients = self.japanPatientsData.last?.adpatients {
            NewlyPatientsLastDay = String(patients)
        }
        return NewlyPatientsLastDay
    }
    // 24ヶ月間の新規感染者数を取得する
    func getJapanNewlyPatientsInMonths() -> [Double] {
        let comulativePatients = self.japanPatientsData
        let lastDatesExceptFeb = ["-04-30", "-06-30", "-09-30", "-11-30"]
        var newlyPatientsInMonths = [Double]()
        
        for (index, item) in comulativePatients.enumerated() {
            // データの最新の日付と月違いの同じ日にちだったら配列に追加する
            if item.date.hasSuffix(getJapanPatientsLatestDate().suffix(3)) {
                newlyPatientsInMonths.append((Double(item.npatients)))
            // データの最新の日にちが31日か30日で、かつループitemの日付が2月28日の場合
            } else if (getJapanPatientsLatestDate().hasSuffix("-31") || getJapanPatientsLatestDate().hasSuffix("-30")) && item.date.hasSuffix("-02-28") {
                // 閏年で2月29日のデータが見つかったら2月29日のデータを配列に追加
                if comulativePatients[index + 1].date.hasSuffix("-02-29") {
                    newlyPatientsInMonths.append(Double(comulativePatients[index + 1].npatients))
                // 閏年ではなく2月29日のデータが見つからない場合は2月28日のデータを配列に追加
                } else {
                    newlyPatientsInMonths.append(Double(item.npatients))
                }
            } else {
                for date in lastDatesExceptFeb {
                    // データの最新の日付が31日で、かつループitemの日付が月末が30日の月の末日の場合は、その末日のデータを配列に追加
                    if getJapanPatientsLatestDate().hasSuffix("-31") && item.date.hasSuffix(date) {
                        newlyPatientsInMonths.append(Double(item.npatients))
                    }
                }
            }
        }
        if newlyPatientsInMonths.count >= 24 {
            return Array(newlyPatientsInMonths.suffix(24))
        } else {
            return newlyPatientsInMonths
        }
    }
    // 12週間の新規感染者数を取得する
    func getJapanNewlyPatientsInWeeks() -> [Double] {
        var japanNewlyPatientsInWeeks = [Double]()
        // 最新の日付から逆算して7日間隔のデータを取得するため .reversed() を使っている
        for (index, item) in self.japanPatientsData.reversed().enumerated() {
            if index == 0 || (index + 1) % 7 == 0 {
                japanNewlyPatientsInWeeks.append(Double(item.adpatients))
            }
        }
        // .reversed()した配列をまた.reversed()で元に戻している
        if japanNewlyPatientsInWeeks.count >= 12 {
            return Array(japanNewlyPatientsInWeeks.reversed().suffix(12))
        } else {
            return japanNewlyPatientsInWeeks.reversed()
        }
    }
    // 7日間の新規感染者数を取得する
    func getJapanNewlyPatientsInDays() -> [Double] {
        var japanNewlyPatientsInDays = [Double]()
        for item in self.japanPatientsData {
            japanNewlyPatientsInDays.append(Double(item.adpatients))
        }
        if japanNewlyPatientsInDays.count >= 7 {
            return Array(japanNewlyPatientsInDays.suffix(7))
        } else {
            return japanNewlyPatientsInDays
        }
    }
    // ここから全国の入林治療等を要する者
    // 全国の入林治療等を要する者のJSONデータをデコードして取得する
    func loadJapanPatientsNeedInpatientData() {
        guard let url = URL(string: "https://data.corona.go.jp/converted-json/covid19japan-ncures.json") else {
            print("Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("Status Code: \(statusCode)")
            guard let jsonData = data else { return }
            do {
                let fetchedData = try JSONDecoder().decode([JapanPatientsNeedInpatientModel].self, from: jsonData)
                DispatchQueue.main.async {
                    self.japanPatientsNeedInpatient = fetchedData
                }
            } catch {
                fatalError("Failed loading \(error)")
            }
        }.resume()
    }
    
    func getJapanaPatientsNeedInpatientLatestDate() -> String {
        var latestDate = "Loading..."
        if let date = self.japanPatientsNeedInpatient.last?.date {
            latestDate = String(date)
        }
        return latestDate
    }
    
    func getJapanPatientsNeedInpatientInMonths() -> [Double] {
        let patients = self.japanPatientsNeedInpatient
        let lastDatesExceptFeb = ["-04-30", "-06-30", "-09-30", "-11-30"]
        var patientsNeedInpatientInMonths = [Double]()
        
        for (index, item) in patients.enumerated() {
            // データの最新の日付と月違いの同じ日にちだったら配列に追加する
            if item.date.hasSuffix(getJapanaPatientsNeedInpatientLatestDate().suffix(3)) {
                patientsNeedInpatientInMonths.append(Double(item.ncures))
            // データの最新の日にちが31日か30日で、かつループitemの日付が2月28日の場合
            } else if (getJapanaPatientsNeedInpatientLatestDate().hasSuffix("-31") || getJapanaPatientsNeedInpatientLatestDate().hasSuffix("-30")) && item.date.hasSuffix("-02-28") {
                // 閏年で2月29日のデータが見つかったら2月29日のデータを配列に追加
                if patients[index + 1].date.hasSuffix("-02-29") {
                    patientsNeedInpatientInMonths.append(Double(patients[index + 1].ncures))
                // 閏年ではなく2月29日のデータが見つからない場合は2月28日のデータを配列に追加
                } else {
                    patientsNeedInpatientInMonths.append(Double(item.ncures))
                }
            } else {
                for date in lastDatesExceptFeb {
                    // データの最新の日付が31日で、かつループitemの日付が月末が30日の月の末日の場合は、その末日のデータを配列に追加
                    if getJapanaPatientsNeedInpatientLatestDate().hasSuffix("-31") && item.date.hasSuffix(date) {
                        patientsNeedInpatientInMonths.append(Double(item.ncures))
                    }
                }
            }
        }
        if patientsNeedInpatientInMonths.count >= 24 {
            return Array(patientsNeedInpatientInMonths.suffix(24))
        } else {
            return patientsNeedInpatientInMonths
        }
    }
    
    func getJapanPatientsNeedInpatientInWeeks() -> [Double] {
        let patients = self.japanPatientsNeedInpatient
        var patientsNeedInpatientInWeeks = [Double]()
        
        for (index, item) in patients.reversed().enumerated() {
            if index == 0 || (index + 1) % 7 == 0 {
                patientsNeedInpatientInWeeks.append(Double(item.ncures))
            }
        }
        if patientsNeedInpatientInWeeks.count >= 12 {
            return Array(patientsNeedInpatientInWeeks.reversed().suffix(12))
        } else {
            return patientsNeedInpatientInWeeks.reversed()
        }
    }
    
    func getJapanPatientsNeedInpatientInDays() -> [Double] {
        let patients = self.japanPatientsNeedInpatient
        var patientsNeedInpatientInDays = [Double]()
        
        for item in patients {
            patientsNeedInpatientInDays.append(Double(item.ncures))
        }
        if patientsNeedInpatientInDays.count >= 7 {
            return Array(patientsNeedInpatientInDays.suffix(7))
        } else {
            return patientsNeedInpatientInDays
        }
    }
    
    // ここから全国の累積死亡者数
    // 累積死亡者数のJSONデータをデコードして取得
    func loadJapanDeathsData() {
        guard let url = URL(string: "https://data.corona.go.jp/converted-json/covid19japan-ndeaths.json") else {
            print("Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("Status Code: \(statusCode)")
            guard let jsonData = data else { return }
            do {
                let fetchedData = try JSONDecoder().decode([JapanDeathsModel].self, from: jsonData)
                DispatchQueue.main.async {
                    self.japanDeathsData = fetchedData
                }
            } catch {
                fatalError("Failed loading \(error)")
            }
        }.resume()
    }
    // 累積死亡者数の最終更新日を取得する
    func getJapanDeathsLatestDate() -> String {
        var latestDate = "Loading..."
        if let date = self.japanDeathsData.last?.date {
            latestDate = String(date)
        }
        return latestDate
    }
    // 最終更新日の累積死亡者数を取得する
    func getJapanComulativeDeathsOnLastDay() -> String {
        var deathsOnLastDay = "Loading..."
        if let deaths = self.japanDeathsData.last?.ndeaths {
            deathsOnLastDay = String(deaths)
        }
        return deathsOnLastDay
    }
    // 24ヶ月間の累積死亡者数を取得する
    func getJapanComulativeDeathsInMonths() -> [(String, Double)] {
        let deaths = self.japanDeathsData
        let lastDatesExceptFeb = ["-04-30", "-06-30", "-09-30", "-11-30"]
        var deathsInMonths = [(String, Double)]()
        
        for (index, item) in deaths.enumerated() {
            // データの最新の日付と月違いの同じ日にちだったら配列に追加する
            if item.date.hasSuffix(getJapanDeathsLatestDate().suffix(3)) {
                deathsInMonths.append((item.date, Double(item.ndeaths)))
            // データの最新の日にちが31日か30日で、かつループitemの日付が2月28日の場合
            } else if (getJapanDeathsLatestDate().hasSuffix("-31") || getJapanDeathsLatestDate().hasSuffix("-30")) && item.date.hasSuffix("-02-28") {
                // 閏年で2月29日のデータが見つかったら2月29日のデータを配列に追加
                if deaths[index + 1].date.hasSuffix("-02-29") {
                    deathsInMonths.append((deaths[index+1].date, Double(deaths[index+1].ndeaths)))
                // 閏年ではなく2月29日のデータが見つからない場合は2月28日のデータを配列に追加
                } else {
                    deathsInMonths.append((item.date, Double(item.ndeaths)))
                }
            } else {
                for date in lastDatesExceptFeb {
                    // データの最新の日付が31日で、かつループitemの日付が月末が30日の月の末日の場合は、その末日のデータを配列に追加
                    if getJapanDeathsLatestDate().hasSuffix("-31") && item.date.hasSuffix(date) {
                        deathsInMonths.append((item.date, Double(item.ndeaths)))
                    }
                }
            }
        }
        if deathsInMonths.count >= 24 {
            return Array(deathsInMonths.suffix(24))
        } else {
            return deathsInMonths
        }
    }
    // 12週間の累積死亡者数を取得する
    func getJapanComulativeDeathsInWeeks() -> [(String, Double)] {
        let deaths = self.japanDeathsData
        var deathsInWeeks = [(String, Double)]()
        
        for (index, item) in deaths.reversed().enumerated() {
            if index == 0 || (index + 1) % 7 == 0 {
                deathsInWeeks.append((item.date, Double(item.ndeaths)))
            }
        }
        if deathsInWeeks.count >= 12 {
            return Array(deathsInWeeks.reversed().suffix(12))
        } else {
            return deathsInWeeks.reversed()
        }
    }
    // 7日間の累積死亡者数を取得する
    func getJapanComulativeDeathsInDays() -> [(String, Double)] {
        let deaths = self.japanDeathsData
        var deathsInDays = [(String, Double)]()
        
        for item in deaths {
            deathsInDays.append((item.date, Double(item.ndeaths)))
        }
        if deathsInDays.count >= 7 {
            return Array(deathsInDays.suffix(7))
        } else {
            return deathsInDays
        }
    }
    // ここから新規死亡者
    // 全期間の新規死亡者データを取得する
    func getJapanNewlyDeaths() -> [(String, Double)] {
        let data = self.japanDeathsData
        var newlyDeathsAll = [(String, Double)]()
        for (index, item) in data.enumerated() {
            if index + 1 < data.count {
                let nextItem = data[index+1]
                let previousDeaths = item.ndeaths
                let currentDeaths = nextItem.ndeaths
                let diff = Double(currentDeaths - previousDeaths)
                newlyDeathsAll.append((nextItem.date, diff))
            }
        }
        return newlyDeathsAll
    }
    // 最終更新日の新規死亡者数を取得する
    func getJapanaNewlyDeathsOnLastDay() -> String {
        var deathsOnLastDay = "Loading..."
        if let deaths = self.getJapanNewlyDeaths().last?.1 {
            deathsOnLastDay = String(Int(deaths))
        }
        return deathsOnLastDay
    }
    // 24ヶ月間の新規死亡者数を取得する
    func getJapanNewlyDeathsInMonths() -> [Double] {
        let deaths = getJapanNewlyDeaths()
        let latestDate = getJapanDeathsLatestDate()
        let lastDatesExceptFeb = ["-04-30", "-06-30", "-09-30", "-11-30"]
        var deathsInMonths = [Double]()
        
        for (index, item) in deaths.enumerated() {
            // データの最新の日付と月違いの同じ日にちだったら配列に追加する
            if item.0.hasSuffix(latestDate.suffix(3)) {
                deathsInMonths.append(Double(item.1))
            // データの最新の日にちが31日か30日で、かつループitemの日付が2月28日の場合
            } else if (latestDate.hasSuffix("-31") || latestDate.hasSuffix("-30")) && item.0.hasSuffix("-02-28") {
                // 閏年で2月29日のデータが見つかったら2月29日のデータを配列に追加
                if deaths[index + 1].0.hasSuffix("-02-29") {
                    deathsInMonths.append(Double(deaths[index+1].1))
                // 閏年ではなく2月29日のデータが見つからない場合は2月28日のデータを配列に追加
                } else {
                    deathsInMonths.append(Double(item.1))
                }
            } else {
                for date in lastDatesExceptFeb {
                    // データの最新の日付が31日で、かつループitemの日付が月末が30日の月の末日の場合は、その末日のデータを配列に追加
                    if latestDate.hasSuffix("-31") && item.0.hasSuffix(date) {
                        deathsInMonths.append(Double(item.1))
                    }
                }
            }
        }
        if deathsInMonths.count >= 24 {
            return Array(deathsInMonths.suffix(24))
        } else {
            return deathsInMonths
        }
    }
    // 12週間の新規死亡者数を取得する
    func getJapanNewlyDeathsInWeeks() -> [Double] {
        let deaths = self.getJapanNewlyDeaths()
        var deathsInWeeks = [Double]()
        
        for (index, item) in deaths.reversed().enumerated() {
            if index == 0 || (index + 1) % 7 == 0 {
                deathsInWeeks.append(Double(item.1))
            }
        }
        if deathsInWeeks.count >= 12 {
            return Array(deathsInWeeks.reversed().suffix(12))
        } else {
            return deathsInWeeks.reversed()
        }
    }
    // 7日間の新規死亡者数を取得する
    func getJapanNewlyDeathsInDays() -> [Double] {
        let deaths = self.getJapanNewlyDeaths()
        var deathsInDays = [Double]()
        
        for item in deaths {
            deathsInDays.append(Double(item.1))
        }
        if deathsInDays.count >= 7 {
            return Array(deathsInDays.suffix(7))
        } else {
            return deathsInDays
        }
    }
    
    // ここから都道府県別累積陽性者数
    // 都道府県別累積陽性者数のJSONデータをデコードして取得する
    func loadPrefectureComulativePatients() {
        let stringURL = "https://data.corona.go.jp/converted-json/covid19japan-all.json"
        print("url: \(stringURL)")
        guard let url = URL(string: stringURL) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("Status Code: \(statusCode)")
            guard let jsonData = data else { return }
            do {
                let fetchedData = try JSONDecoder().decode([PrefectureComulativePatientsModel].self, from: jsonData)
                DispatchQueue.main.async {
                    print(fetchedData)
                    self.prefecturePatientsData = fetchedData[0].area
                }
            } catch {
                fatalError("Failed loading \(error)")
            }
        }.resume()
    }
    // 最終更新日の都道府県別陽性者数を取得する
    func getPrefectureComulativePatients() -> [(String, Double)] {
        var prefecturePatients = [(String, Double)]()
        let patients = self.prefecturePatientsData
        for item in patients {
            prefecturePatients.append((item.name_jp, Double(item.npatients)))
        }
        prefecturePatients.sort { (a, b) in
            return a.1 > b.1
        }
        return Array(prefecturePatients.prefix(15))
    }
}
