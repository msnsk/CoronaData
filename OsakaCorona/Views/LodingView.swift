//
//  LodingView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            VStack {
                Text("Now Loading...")
                Text("Please Wait For A While.")
            }
            Color(.systemBackground)
                .opacity(0.1)
        }
    }
}

struct LodingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
