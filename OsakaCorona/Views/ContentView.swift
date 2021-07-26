//
//  ContentView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/19.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: LocalPatientsViewModel
    //@State var locationViewModel = LocationViewModel(model: LocationDataSource())
    
    var body: some View {
        ZStack {
            TabView {
                LocalDashboard()
                    .tabItem {
                        Image(systemName: "mappin")
                        Text("\(model.currentLocation)")
                    }
                JapanDashboard()
                    .tabItem {
                        Image("icon_japan")
                        Text("全国")
                    }
                PreferencesView()
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
