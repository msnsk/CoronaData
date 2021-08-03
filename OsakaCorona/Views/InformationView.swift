//
//  InformationView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/08/01.
//

import SwiftUI

struct InformationView: View {
    @Environment(\.presentationMode) var presentationMode
    //現在のバージョンを取得
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("基本情報")) {
                    //Version
                    HStack {
                        Text("バージョン: ")
                        Text(self.appVersion!)
                    }
                    
                    //Developer
                    Text("開発元: Masanao Sako")
                    
                    //Website
                    //HStack(alignment: .top) {
                        //Text("Web: ")
                        //Link("ピーナッツコード", destination: URL(string: "https://www.peanuts-code.com")!)
                    //}
                }
                
                Section(header: Text("統計データについて")) {
                    //Sound Creator
                    Text("このAppで表示される統計データは全て、内閣官房新型コロナウイルス感染症対策推進室が運営する下記ウェブサイトで取得可能なオープンデータです。")
                        .padding(.vertical)
                    
                    //Website
                    HStack {
                        Text("Web: ")
                        Link("新型コロナウイルス感染症対策", destination: URL(string: "https://corona.go.jp/dashboard/")!)
                            .font(.system(size: 18))
                    }
                }
                HStack {
                    Spacer()
                    Text("閉じる")
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                    Spacer()
                }
            }
            .font(.title3.weight(.light))
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
