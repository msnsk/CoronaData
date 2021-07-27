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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(JapanViewModel())
                .environmentObject(LocalViewModel())
                .environmentObject(OtherViewModel())
        }
    }
}
