//
//  SplashView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/08/02.
//

import SwiftUI

struct SplashView: View {
    @State var isShowing = false
    
    var body: some View {
        ZStack {
            Color(.tertiarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                LinearGradient(gradient: Gradient(colors: [Color(.systemTeal), .blue, .purple, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .mask(
                        VStack(spacing: 8) {
                            Image("corona")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .padding(.bottom, 25)
                            Text("コロナのデータ")
                                .font(.system(size: 32, weight: .medium, design: .rounded))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                            Text("published by Cabinet Secretariat")
                                .font(.system(size: 12, weight: .medium, design: .serif))
                                .foregroundColor(.secondary)
                        }
                    )
            }
            .opacity(isShowing ? 1 : 0)
            .blur(radius: isShowing ? 0.5 : 10)
            .animation(.easeInOut(duration: 0.5))
            .transition(.opacity)
        }
        .onAppear {
            self.isShowing = true
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
            .preferredColorScheme(.dark)
    }
}