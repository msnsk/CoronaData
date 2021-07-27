//
//  ContentView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/19.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: LocalViewModel
    //@State var locationViewModel = LocationViewModel(model: LocationDataSource())
    
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
                AreaPickerView()
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("設定")
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
