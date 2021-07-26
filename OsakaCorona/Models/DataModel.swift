//
//  DataModel.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/19.
//

import Foundation

// https://opendata.corona.go.jp/api/Covid19JapanAll のオープンデータ
// 累積感染者数データ。クエリにより地域、日付の指定ができる
struct LocalPatientsDataModel: Decodable {
    var errorInfo: ErrorInfo
    var itemList: [ItemData]
}
struct ErrorInfo: Decodable {
    var errorFlag: String
    var errorCode: String?
    var errorMessage: String?
}
struct ItemData: Decodable, Hashable {
    var date: String
    var name_jp: String
    var npatients: String
}

// https://data.corona.go.jp/converted-json/covid19japan-npatients.json のJSONデータ
// 全国の累積陽性者数と新規陽性者数
struct JapanPatientsDataModel: Decodable {
    var date: String
    var npatients: Int
    var adpatients: Int
}

// https://data.corona.go.jp/converted-json/covid19japan-ncures.json のJSONデータ
// 全国の入院治療等を要する者
struct JapanPatientsNeedInpatientModel: Decodable {
    var date: String
    var ncures: Int
}

// https://data.corona.go.jp/converted-json/covid19japan-ndeaths.json のJSONデータ
// 全国の累積死亡者数
struct JapanDeathsModel: Decodable {
    var date: String
    var ndeaths: Int
}

// https://data.corona.go.jp/converted-json/covid19japan-all.json のJSONデータ
// 都道府県別累積陽性者
struct PrefectureComulativePatientsModel: Decodable {
    var srcurl_pdf: String
    var srcurl_web: String
    var description: String
    var npatients: Int
    var nexits: Int
    var ndeaths: Int
    var ncurrentpatients: Int
    var srcurl_pdf_archived: String
    var lastUpdate: String
    var area: [Area]
}
struct Area: Decodable {
    var name_jp: String
    var name: String
    var ncurrentpatients: Int
    var nexits: Int
    var ndeaths: Int
    var npatients: Int
}

// https://opendata.corona.go.jp/api/Covid19JapanNdeaths?dataName=%E5%A4%A7%E9%98%AA%E5%BA%9C のJSONデータ
// 地域、日付が指定できる累積感染者数のオープンデータ
struct localDeathsDataModel: Decodable {
    var errorInfo: ErrorInfo
    var itemList: [DeathItemData]
}
struct DeathItemData: Decodable {
    var date: String
    var ndeaths: String
}
