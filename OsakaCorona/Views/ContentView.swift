//
//  ContentView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/19.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: LocalViewModel
    @State var isShowingInfo: Bool = false
    
    var body: some View {
        ZStack {
            TabView {
                JapanDashboard()
                    .tabItem {
                        Image(systemName: "square.grid.3x3.fill")
                        Text("Japan")
                    }
                LocalDashboard()
                    .tabItem {
                        Image(systemName: "square.fill")
                        Text("Your Area")
                    }
                OtherDashboard()
                    .tabItem {
                        Image(systemName: "square.grid.3x3.topleft.fill")
                        Text("Selected Area")
                    }
            }
            // インフォメーションボタン
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isShowingInfo.toggle()
                    }, label: {
                        Image(systemName: "info.circle.fill")
                            .font(.title3.weight(.thin))
                            .foregroundColor(Color(.tertiarySystemBackground))
                            .shadow(radius: 4)
                    })
                    .padding(8)
                    .sheet(isPresented: $isShowingInfo, onDismiss: {print("画面を閉じた")}) {
                        InformationView()
                    }
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
