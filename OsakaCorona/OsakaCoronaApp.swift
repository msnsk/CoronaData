//
//  OsakaCoronaApp.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/19.
//

import SwiftUI
import CoreLocation

@main
struct OsakaCoronaApp: App {
    @State var isActive = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isActive {
                    ContentView()
                        .environmentObject(JapanViewModel())
                        .environmentObject(LocalViewModel())
                        .environmentObject(AreaViewModel())
                } else {
                    SplashView()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
