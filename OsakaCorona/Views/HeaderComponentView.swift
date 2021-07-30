//
//  HeaderComponentView.swift
//  OsakaCorona
//
//  Created by masanao on 2021/07/29.
//

import SwiftUI

struct HeaderComponentView: View {
    var lastUpdate: String = "yyyy-mm-dd"
    var title: String = "統計データ"
    var isComulative: Bool = false
    var mainNum: Int = 0
    var additionalNum: Int = 0
    var subAdditionalNum: Double = 0.00
    
    var body: some View {
        VStack(spacing: 3) {
            Text(lastUpdate)
                .font(.caption)
                .fontWeight(.light)
            Text(title)
            Text("\(mainNum)")
                .font(.system(size: 32, weight: .bold, design: .default))
            ZStack {
                Divider()
                Text(isComulative ? "過去7日間" : "前日比")
                    .padding(.horizontal)
                    .font(.caption.weight(.light))
            }
            HStack {
                Text("\(additionalNum)")
                    .font(.title3.weight(.light))
                Text(isComulative ? "\(String(format: "%.0f", subAdditionalNum))/Day" : "\(String(format: "%.2f", subAdditionalNum))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
                if !isComulative {
                    Image(systemName: subAdditionalNum > 0 ? "arrow.turn.right.up" : "arrow.turn.right.down")
                        .font(.title2.bold())
                        .foregroundColor(subAdditionalNum > 0 ? .red : .blue)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundColor(Color(.systemBackground))
                .shadow(radius: 5)
        )
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct HeaderComponentView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderComponentView()
    }
}
