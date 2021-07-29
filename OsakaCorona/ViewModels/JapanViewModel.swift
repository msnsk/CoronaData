//
//  JapanPatientsViewModel.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/23.
//

import Foundation
import Combine

class JapanViewModel: ObservableObject {
    //MARK: - Japan Patients Properties
    @Published var japanPatientsData = [JapanPatientsDataModel]() {
        didSet {
            getLatestDateOfJapanPatients()
            // 累積感染者のfunctions
            getComulPatientsNumLastDay()
            compareComulPatientsNumFromPrevDay()
            getComulPatientsNumInMonths()
            getComulPatientsNumInWeeks()
            getComulPatientsNumInDays()
            // 新規感染者のfunctions
            getNewPatientsNumLastDay()
            compareNewPatientsNumFromPrevDay()
            getNewPatientsNumInMonths()
            getNewPatientsNumInWeeks()
            getNewPatientsNumsInDays()
        }
    }
    @Published var latestDateOfPatientsData = "...Loading"
    // 累積感染者のproperties
    @Published var comulPatientsNumsLastDay: Int = 0
    @Published var comulPatientsRateComparedPrevDay: Double = 0.00
    @Published var comulPatientsNumsInMonths = [(String, Double)]()
    @Published var comulPatientsNumsInWeeks = [(String, Double)]()
    @Published var comulPatientsNumsInDays = [(String, Double)]()
    // 新規感染者のproperties
    @Published var newPatientsNumLastDay: Int = 0
    @Published var newPatientsNumComparedPrevDay: Int = 0
    @Published var newPatientsRateComparedPrevDay: Double = 0.00
    @Published var newPatientsNumsInMonths = [Double]()
    @Published var newPatientsNumsInWeeks = [Double]()
    @Published var newPatientsNumsInDays = [Double]()
    
    //MARK: - Japan Patients Need Inpatient Properties
    @Published var needInpatientData = [JapanPatientsNeedInpatientModel]() {
        didSet {
            getLatestDateOfNeedInpatientData()
            getNeedInpatientNumsLastDay()
            compareNeedInpatientFromPrevDay()
            getNeedInpatientNumsInMonths()
            getNeedInpatientNumsInWeeks()
            getNeedInpatientNumsInDays()
        }
    }
    @Published var latestDateOfNeedInpatientData = "...Loading"
    @Published var needInpatientNumsLastDay: Int = 0
    @Published var needInpatientNumComparedPrevDay: Int = 0
    @Published var needInpatientRateComparedPrevDay: Double = 0.00
    @Published var needInpatientNumsInMonths = [Double]()
    @Published var needInpatientNumsInWeeks = [Double]()
    @Published var needInpatientNumsInDays = [Double]()
    
    //MARK: - Japan Deaths Properties
    @Published var deathsData = [JapanDeathsModel](){
        didSet {
            getLatestDateOfDeathsData()
            // 累積死亡者数のfunctions
            getComulDeathsLastDay()
            compareComulDeathsFromPrevDay()
            getComulDeathsInMonths()
            getComulDeathsInWeeks()
            getComulDeathsInDays()
            // 新規死亡者数のfunctions
            getNewDeathsAll()
            getNewDeathsLastDay()
            compareNewDeathsFromPrevDay()
            getNewDeathsInMonths()
            getNewDeathsInWeeks()
            getNewDeathsInDays()
        }
    }
    @Published var latestDateOfDeathsData = "...Loading"
    // 累積死亡者数のproperties
    @Published var comulDeathsLastDay: Int = 0
    @Published var comulDeathsRateComparedPrevDay: Double = 0
    @Published var comulDeathsInMonths = [(String, Double)]()
    @Published var comulDeathsInWeeks = [(String, Double)]()
    @Published var comulDeathsInDays = [(String, Double)]()
    // 新規死亡者数のproperties
    private var newDeathsAll = [(String, Double)]()
    @Published var newDeathsLastDay: Int = 0
    @Published var newDeathsComparedPrevDay: Int = 0
    @Published var newDeathsRateComparedPrevDay: Double = 0
    @Published var newDeathsInMonths = [Double]()
    @Published var newDeathsInWeeks = [Double]()
    @Published var newDeathsInDays = [Double]()
    
    //MARK: - Prefectures Patients Properties
    @Published var prefecturePatientsData = [Area]() {
        didSet {
            getPrefectureComulPatientsNum()
        }
    }
    @Published var prefectureComulPatientsNum = [(String, Double)]()
    
    //MARK: - Initialize
    init() {
        self.loadJapanPatientsData()
        self.loadJapanPatientsNeedInpatientData()
        self.loadJapanDeathsData()
        self.loadPrefectureComulativePatients()
    }
    
    //MARK: - Load JSON Data
    func loadJapanPatientsData() {
        guard let url = URL(string: "https://data.corona.go.jp/converted-json/covid19japan-npatients.json") else {
            print("Japan Patient: Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("Japan Patients: Status Code: \(statusCode)")
            guard let jsonData = data else { return }
            do {
                let fetchedData = try JSONDecoder().decode([JapanPatientsDataModel].self, from: jsonData)
                DispatchQueue.main.async {
                    self.japanPatientsData = fetchedData
                }
            } catch {
                fatalError("Japan Patients: Failed loading: \(error)")
            }
        }.resume()
        
    }
    
    //MARK: - Functions
    
    // 累積感染者数のデータの最終更新日を取得する
    func getLatestDateOfJapanPatients() {
        if let date = japanPatientsData.last?.date {
            latestDateOfPatientsData = String(date)
        }
    }
    
    //MARK: - 累積感染者数
    // 最終更新日の累積感染者数を取得する
    func getComulPatientsNumLastDay() {
        if let patients = japanPatientsData.last?.npatients {
            comulPatientsNumsLastDay = patients
        }
    }
    
    func compareComulPatientsNumFromPrevDay() {
        let lastNum = Double(japanPatientsData[japanPatientsData.count - 1].npatients)
        let prevNum = Double(japanPatientsData[japanPatientsData.count - 2].npatients)
        comulPatientsRateComparedPrevDay = (lastNum - prevNum) / prevNum * 100
    }
    // 12ヶ月間の累積感染者数を取得する
    func getComulPatientsNumInMonths() {
        let comulativePatients = japanPatientsData
        let lastDatesExceptFeb = ["-04-30", "-06-30", "-09-30", "-11-30"]
        var newlyPatientsInMonths = [(String, Double)]()
        
        for (index, item) in comulativePatients.enumerated() {
            // データの最新の日付と月違いの同じ日にちだったら配列に追加する
            if item.date.hasSuffix(latestDateOfPatientsData.suffix(3)) {
                newlyPatientsInMonths.append((item.date, Double(item.npatients)))
            // データの最新の日にちが31日か30日で、かつループitemの日付が2月28日の場合
            } else if (latestDateOfPatientsData.hasSuffix("-31") || latestDateOfPatientsData.hasSuffix("-30")) && item.date.hasSuffix("-02-28") {
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
                    if latestDateOfPatientsData.hasSuffix("-31") && item.date.hasSuffix(date) {
                        newlyPatientsInMonths.append((item.date, Double(item.npatients)))
                    }
                }
            }
        }
        if newlyPatientsInMonths.count >= 24 {
            comulPatientsNumsInMonths = Array(newlyPatientsInMonths.suffix(24))
        } else {
            comulPatientsNumsInMonths = newlyPatientsInMonths
        }
    }
    // 12週間の累積感染者数を取得する
    func getComulPatientsNumInWeeks() {
        var japanComulativePatientsInWeeks = [(String, Double)]()
        for (index, item) in self.japanPatientsData.reversed().enumerated() {
            if index == 0 || (index + 1) % 7 == 0 {
                japanComulativePatientsInWeeks.append((item.date, Double(item.npatients)))
            }
        }
        if japanComulativePatientsInWeeks.count >= 12 {
            comulPatientsNumsInWeeks = Array(japanComulativePatientsInWeeks.reversed().suffix(12))
        } else {
            comulPatientsNumsInWeeks = japanComulativePatientsInWeeks.reversed()
        }
    }
    // 7日間の累積感染者数を取得する
    func getComulPatientsNumInDays(){
        var japanComulativePatientsInDays = [(String, Double)]()
        for item in japanPatientsData {
            japanComulativePatientsInDays.append((item.date, Double(item.npatients)))
        }
        if japanComulativePatientsInDays.count >= 7 {
            comulPatientsNumsInDays = Array(japanComulativePatientsInDays.suffix(7))
        } else {
            comulPatientsNumsInDays = japanComulativePatientsInDays
        }
    }
    
    //MARK: - 新規感染者
    // 最終更新日の新規感染者数を取得する
    func getNewPatientsNumLastDay() {
        if let patients = japanPatientsData.last?.adpatients {
            newPatientsNumLastDay = patients
        }
    }
    
    // 最終日の感染者数の前日との差と比を出力
    func compareNewPatientsNumFromPrevDay() {
        let lastNum = japanPatientsData[0].adpatients
        let prevNum = japanPatientsData[1].adpatients
        newPatientsNumComparedPrevDay = lastNum - prevNum
        newPatientsRateComparedPrevDay = (Double(lastNum) - Double(prevNum)) / Double(prevNum) * 100
    }
    
    // 24ヶ月間の新規感染者数を取得する
    func getNewPatientsNumInMonths() {
        let lastDatesExceptFeb = ["-04-30", "-06-30", "-09-30", "-11-30"]
        var newPatients = [Double]()
        
        for (index, item) in japanPatientsData.enumerated() {
            // データの最新の日付と月違いの同じ日にちだったら配列に追加する
            if item.date.hasSuffix(latestDateOfPatientsData.suffix(3)) {
                newPatients.append((Double(item.npatients)))
            // データの最新の日にちが31日か30日で、かつループitemの日付が2月28日の場合
            } else if (latestDateOfPatientsData.hasSuffix("-31") || latestDateOfPatientsData.hasSuffix("-30")) && item.date.hasSuffix("-02-28") {
                // 閏年で2月29日のデータが見つかったら2月29日のデータを配列に追加
                if japanPatientsData[index + 1].date.hasSuffix("-02-29") {
                    newPatients.append(Double(japanPatientsData[index + 1].npatients))
                // 閏年ではなく2月29日のデータが見つからない場合は2月28日のデータを配列に追加
                } else {
                    newPatients.append(Double(item.npatients))
                }
            } else {
                for date in lastDatesExceptFeb {
                    // データの最新の日付が31日で、かつループitemの日付が月末が30日の月の末日の場合は、その末日のデータを配列に追加
                    if latestDateOfPatientsData.hasSuffix("-31") && item.date.hasSuffix(date) {
                        newPatients.append(Double(item.npatients))
                    }
                }
            }
        }
        if newPatients.count >= 24 {
            newPatientsNumsInMonths = Array(newPatients.suffix(24))
        } else {
            newPatientsNumsInMonths = newPatients
        }
    }
    // 12週間の新規感染者数を取得する
    func getNewPatientsNumInWeeks() {
        var newPatientsInWeeks = [Double]()
        // 最新の日付から逆算して7日間隔のデータを取得するため .reversed() を使っている
        for (index, item) in japanPatientsData.reversed().enumerated() {
            if index == 0 || (index + 1) % 7 == 0 {
                newPatientsInWeeks.append(Double(item.adpatients))
            }
        }
        // .reversed()した配列をまた.reversed()で元に戻している
        if newPatientsInWeeks.count >= 12 {
            newPatientsNumsInWeeks = Array(newPatientsInWeeks.reversed().suffix(12))
        } else {
            newPatientsNumsInWeeks = newPatientsInWeeks.reversed()
        }
    }
    // 7日間の新規感染者数を取得する
    func getNewPatientsNumsInDays() {
        var newPatientsInDays = [Double]()
        for item in self.japanPatientsData {
            newPatientsInDays.append(Double(item.adpatients))
        }
        if newPatientsInDays.count >= 7 {
            newPatientsNumsInDays = Array(newPatientsInDays.suffix(7))
        } else {
            newPatientsNumsInDays = newPatientsInDays
        }
    }
    
    //MARK: - 全国の入院治療等を要する者
    
    // 全国の入林治療等を要する者のJSONデータをデコードして取得する
    func loadJapanPatientsNeedInpatientData() {
        guard let url = URL(string: "https://data.corona.go.jp/converted-json/covid19japan-ncures.json") else {
            print("Japan Need Inpatient: Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("Japan Need Inpatient: Status Code: \(statusCode)")
            guard let jsonData = data else { return }
            do {
                let fetchedData = try JSONDecoder().decode([JapanPatientsNeedInpatientModel].self, from: jsonData)
                DispatchQueue.main.async {
                    self.needInpatientData = fetchedData
                }
            } catch {
                fatalError("Failed loading \(error)")
            }
        }.resume()
    }
    // 入院治療等を要する者のデータの最終更新日の日付を取得
    func getLatestDateOfNeedInpatientData() {
        if let date = needInpatientData.last?.date {
            latestDateOfNeedInpatientData = date
        }
    }
    // 入院治療等を要する者の最終更新日のデータを取得
    func getNeedInpatientNumsLastDay() {
        needInpatientNumsLastDay = needInpatientData[needInpatientData.count - 1].ncures
    }
    // 入院治療等を要する者のデータの最終更新日とその前日との比
    func compareNeedInpatientFromPrevDay() {
        let lastNum = needInpatientData[needInpatientData.count - 1].ncures
        let prevNum = needInpatientData[needInpatientData.count - 2].ncures
        needInpatientNumComparedPrevDay = lastNum - prevNum
        needInpatientRateComparedPrevDay = (Double(lastNum) - Double(prevNum)) / Double(prevNum) * 100
    }
    // 24ヶ月間の入院治療等を要する者のデータを取得
    func getNeedInpatientNumsInMonths() {
        let lastDatesExceptFeb = ["-04-30", "-06-30", "-09-30", "-11-30"]
        var needInpatientNums = [Double]()
        
        for (index, item) in needInpatientData.enumerated() {
            // データの最新の日付と月違いの同じ日にちだったら配列に追加する
            if item.date.hasSuffix(latestDateOfNeedInpatientData.suffix(3)) {
                needInpatientNums.append(Double(item.ncures))
            // データの最新の日にちが31日か30日で、かつループitemの日付が2月28日の場合
            } else if (latestDateOfNeedInpatientData.hasSuffix("-31") || latestDateOfNeedInpatientData.hasSuffix("-30")) && item.date.hasSuffix("-02-28") {
                // 閏年で2月29日のデータが見つかったら2月29日のデータを配列に追加
                if needInpatientData[index + 1].date.hasSuffix("-02-29") {
                    needInpatientNums.append(Double(needInpatientData[index + 1].ncures))
                // 閏年ではなく2月29日のデータが見つからない場合は2月28日のデータを配列に追加
                } else {
                    needInpatientNums.append(Double(item.ncures))
                }
            } else {
                for date in lastDatesExceptFeb {
                    // データの最新の日付が31日で、かつループitemの日付が月末が30日の月の末日の場合は、その末日のデータを配列に追加
                    if latestDateOfNeedInpatientData.hasSuffix("-31") && item.date.hasSuffix(date) {
                        needInpatientNums.append(Double(item.ncures))
                    }
                }
            }
        }
        if needInpatientNums.count >= 24 {
            needInpatientNumsInMonths = Array(needInpatientNums.suffix(24))
        } else {
            needInpatientNumsInMonths = needInpatientNums
        }
    }
    // 12週間の入院治療等を要する者のデータを取得
    func getNeedInpatientNumsInWeeks() {
        var needInpatientNums = [Double]()
        for (index, item) in needInpatientData.reversed().enumerated() {
            if index == 0 || (index + 1) % 7 == 0 {
                needInpatientNums.append(Double(item.ncures))
            }
        }
        if needInpatientNums.count >= 12 {
            needInpatientNumsInWeeks = Array(needInpatientNums.reversed().suffix(12))
        } else {
            needInpatientNumsInWeeks = needInpatientNums.reversed()
        }
    }
    // 7日間の入院治療等を要する者のデータを取得
    func getNeedInpatientNumsInDays() {
        var needInpatientNums = [Double]()
        for item in needInpatientData {
            needInpatientNums.append(Double(item.ncures))
        }
        if needInpatientNums.count >= 7 {
            needInpatientNumsInDays = Array(needInpatientNums.suffix(7))
        } else {
            needInpatientNumsInDays = needInpatientNums
        }
    }
    
    //MARK: - 全国の累積死亡者数
    
    // 累積死亡者数のJSONデータをデコードして取得
    func loadJapanDeathsData() {
        guard let url = URL(string: "https://data.corona.go.jp/converted-json/covid19japan-ndeaths.json") else {
            print("Japan Deaths: Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("Japan Deaths: Status Code: \(statusCode)")
            guard let jsonData = data else { return }
            do {
                let fetchedData = try JSONDecoder().decode([JapanDeathsModel].self, from: jsonData)
                DispatchQueue.main.async {
                    self.deathsData = fetchedData
                }
            } catch {
                fatalError("Japan Deaths: Failed loading \(error)")
            }
        }.resume()
    }
    // 累積死亡者数の最終更新日を取得する
    func getLatestDateOfDeathsData() {
        if let date = self.deathsData.last?.date {
            latestDateOfDeathsData = date
        }
    }
    // 最終更新日の累積死亡者数を取得する
    func getComulDeathsLastDay() {
        if let deaths = deathsData.last?.ndeaths {
            comulDeathsLastDay = deaths
        }
    }
    // 最終更新日の累積死亡者数とその前日比の値を比較する
    func compareComulDeathsFromPrevDay() {
        let lastNum = Double(deathsData[deathsData.count - 1].ndeaths)
        let prevNum = Double(deathsData[deathsData.count - 2].ndeaths)
        comulDeathsRateComparedPrevDay = (lastNum - prevNum) / prevNum * 100
    }
    // 24ヶ月間の累積死亡者数を取得する
    func getComulDeathsInMonths() {
        let lastDatesExceptFeb = ["-04-30", "-06-30", "-09-30", "-11-30"]
        var deathsInMonths = [(String, Double)]()
        
        for (index, item) in deathsData.enumerated() {
            // データの最新の日付と月違いの同じ日にちだったら配列に追加する
            if item.date.hasSuffix(latestDateOfDeathsData.suffix(3)) {
                deathsInMonths.append((item.date, Double(item.ndeaths)))
            // データの最新の日にちが31日か30日で、かつループitemの日付が2月28日の場合
            } else if (latestDateOfDeathsData.hasSuffix("-31") || latestDateOfDeathsData.hasSuffix("-30")) && item.date.hasSuffix("-02-28") {
                // 閏年で2月29日のデータが見つかったら2月29日のデータを配列に追加
                if deathsData[index + 1].date.hasSuffix("-02-29") {
                    deathsInMonths.append((deathsData[index+1].date, Double(deathsData[index+1].ndeaths)))
                // 閏年ではなく2月29日のデータが見つからない場合は2月28日のデータを配列に追加
                } else {
                    deathsInMonths.append((item.date, Double(item.ndeaths)))
                }
            } else {
                for date in lastDatesExceptFeb {
                    // データの最新の日付が31日で、かつループitemの日付が月末が30日の月の末日の場合は、その末日のデータを配列に追加
                    if latestDateOfDeathsData.hasSuffix("-31") && item.date.hasSuffix(date) {
                        deathsInMonths.append((item.date, Double(item.ndeaths)))
                    }
                }
            }
        }
        if deathsInMonths.count >= 24 {
            comulDeathsInMonths = Array(deathsInMonths.suffix(24))
        } else {
            comulDeathsInMonths = deathsInMonths
        }
    }
    // 12週間の累積死亡者数を取得する
    func getComulDeathsInWeeks() {
        var deathsInWeeks = [(String, Double)]()
        for (index, item) in deathsData.reversed().enumerated() {
            if index == 0 || (index + 1) % 7 == 0 {
                deathsInWeeks.append((item.date, Double(item.ndeaths)))
            }
        }
        if deathsInWeeks.count >= 12 {
            comulDeathsInWeeks = Array(deathsInWeeks.reversed().suffix(12))
        } else {
            comulDeathsInWeeks = deathsInWeeks.reversed()
        }
    }
    // 7日間の累積死亡者数を取得する
    func getComulDeathsInDays() {
        var deathsInDays = [(String, Double)]()
        for item in deathsData {
            deathsInDays.append((item.date, Double(item.ndeaths)))
        }
        if deathsInDays.count >= 7 {
            comulDeathsInDays = Array(deathsInDays.suffix(7))
        } else {
            comulDeathsInDays = deathsInDays
        }
    }
    //MARK: - 新規死亡者
    // 全期間の新規死亡者データを取得する
    func getNewDeathsAll() {
        var newlyDeathsAll = [(String, Double)]()
        for (index, item) in deathsData.enumerated() {
            if index + 1 < deathsData.count {
                let nextItem = deathsData[index+1]
                let previousDeaths = item.ndeaths
                let currentDeaths = nextItem.ndeaths
                let diff = Double(currentDeaths - previousDeaths)
                newlyDeathsAll.append((nextItem.date, diff))
            }
        }
        newDeathsAll = newlyDeathsAll
    }
    // 最終更新日の新規死亡者数を取得する
    func getNewDeathsLastDay() {
        if let deaths = newDeathsAll.last?.1 {
            newDeathsLastDay = Int(deaths)
        }
    }
    // 最終更新日の新規死亡者とその前日の新規死亡者との比較
    func compareNewDeathsFromPrevDay() {
        let lastNum = newDeathsAll[newDeathsAll.count - 1].1
        let prevNum = newDeathsAll[newDeathsAll.count - 2].1
        newDeathsComparedPrevDay = Int(lastNum) - Int(prevNum)
        newDeathsRateComparedPrevDay = (lastNum - prevNum) / prevNum * 100
    }
    // 24ヶ月間の新規死亡者数を取得する
    func getNewDeathsInMonths() {
        let lastDatesExceptFeb = ["-04-30", "-06-30", "-09-30", "-11-30"]
        var deathsInMonths = [Double]()
        
        for (index, item) in newDeathsAll.enumerated() {
            // データの最新の日付と月違いの同じ日にちだったら配列に追加する
            if item.0.hasSuffix(latestDateOfDeathsData.suffix(3)) {
                deathsInMonths.append(Double(item.1))
            // データの最新の日にちが31日か30日で、かつループitemの日付が2月28日の場合
            } else if (latestDateOfDeathsData.hasSuffix("-31") || latestDateOfDeathsData.hasSuffix("-30")) && item.0.hasSuffix("-02-28") {
                // 閏年で2月29日のデータが見つかったら2月29日のデータを配列に追加
                if newDeathsAll[index + 1].0.hasSuffix("-02-29") {
                    deathsInMonths.append(Double(newDeathsAll[index+1].1))
                // 閏年ではなく2月29日のデータが見つからない場合は2月28日のデータを配列に追加
                } else {
                    deathsInMonths.append(Double(item.1))
                }
            } else {
                for date in lastDatesExceptFeb {
                    // データの最新の日付が31日で、かつループitemの日付が月末が30日の月の末日の場合は、その末日のデータを配列に追加
                    if latestDateOfDeathsData.hasSuffix("-31") && item.0.hasSuffix(date) {
                        deathsInMonths.append(Double(item.1))
                    }
                }
            }
        }
        if deathsInMonths.count >= 24 {
            newDeathsInMonths = Array(deathsInMonths.suffix(24))
        } else {
            newDeathsInMonths = deathsInMonths
        }
    }
    // 12週間の新規死亡者数を取得する
    func getNewDeathsInWeeks() {
        var deathsInWeeks = [Double]()
        for (index, item) in newDeathsAll.reversed().enumerated() {
            if index == 0 || (index + 1) % 7 == 0 {
                deathsInWeeks.append(Double(item.1))
            }
        }
        if deathsInWeeks.count >= 12 {
            newDeathsInWeeks = Array(deathsInWeeks.reversed().suffix(12))
        } else {
            newDeathsInWeeks = deathsInWeeks.reversed()
        }
    }
    // 7日間の新規死亡者数を取得する
    func getNewDeathsInDays() {
        var deathsInDays = [Double]()
        for item in newDeathsAll {
            deathsInDays.append(Double(item.1))
        }
        if deathsInDays.count >= 7 {
            newDeathsInDays = Array(deathsInDays.suffix(7))
        } else {
            newDeathsInDays = deathsInDays
        }
    }
    
    //MARK: - 都道府県別累積陽性者数
    // 都道府県別累積陽性者数のJSONデータをデコードして取得する
    func loadPrefectureComulativePatients() {
        guard let url = URL(string: "https://data.corona.go.jp/converted-json/covid19japan-all.json") else {
            print("Prefecture Comulative: Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("Prefecture Comulative: Status Code: \(statusCode)")
            guard let jsonData = data else { return }
            do {
                let fetchedData = try JSONDecoder().decode([PrefectureComulativePatientsModel].self, from: jsonData)
                DispatchQueue.main.async {
                    self.prefecturePatientsData = fetchedData[0].area
                }
            } catch {
                fatalError("Prefecture Comulative: Failed loading \(error)")
            }
        }.resume()
    }
    // 最終更新日の都道府県別陽性者数を取得する
    func getPrefectureComulPatientsNum() {
        var prefecturePatients = [(String, Double)]()
        let patients = self.prefecturePatientsData
        for item in patients {
            prefecturePatients.append((item.name_jp, Double(item.npatients)))
        }
        prefecturePatients.sort { (a, b) in
            return a.1 > b.1
        }
        prefectureComulPatientsNum = Array(prefecturePatients.prefix(15))
    }
}
