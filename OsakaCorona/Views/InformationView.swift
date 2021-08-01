//
//  InformationView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/08/01.
//

import SwiftUI

struct InformationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle.weight(.thin))
                            .foregroundColor(Color(.tertiarySystemBackground))
                            .shadow(radius: 4)
                    })
                    .padding(8)
                }
                Spacer()
            }
            Text("モーダルビューだよ")
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
