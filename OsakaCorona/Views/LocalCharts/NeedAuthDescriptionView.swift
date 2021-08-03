//
//  NeedAuthDescriptionView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/08/02.
//

import SwiftUI

struct NeedAuthDescriptionView: View {
    var body: some View {
        Color(.systemBackground)
            .edgesIgnoringSafeArea(.all)
        VStack(spacing: 25) {
            Text("位置情報サービスが無効です。")
                .font(.title2.weight(.bold))
                .foregroundColor(Color(.systemGray))
            Text("このタブに現在の位置情報を含むエリアのデータを表示するには以下の手順で設定を変更します。")
                .foregroundColor(.secondary)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("1. ")
                    Text("「設定」App ＞「プライバシー」＞「位置情報サービス」を開く。")
                }
                HStack(alignment: .top) {
                    Text("2. ")
                    Text("「CoronaData」（このAppの名前）を選択する。")
                }
                HStack(alignment: .top) {
                    Text("3. ")
                    Text("「このAppの使用中のみ許可」を選択する。")
                }
            }
            .foregroundColor(.secondary)
            
            Button(action: {
                // open the app permission in Settings app
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                //UIApplication.shared.open(URL(string: "prefs:root=Privacy&path=LOCATION")!, options: [:], completionHandler: nil)
            }, label: {
                HStack(spacing: 0) {
                    Image(systemName: "gearshape")
                    Text("設定を開く")
                }
            })
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(50)
            .shadow(color: .primary, radius: 10)
        }
        .padding(.horizontal, 30)
    }
}

struct NeedAuthDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        NeedAuthDescriptionView()
    }
}
