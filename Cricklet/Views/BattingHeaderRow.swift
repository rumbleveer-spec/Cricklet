//
//  BattingHeaderRow.swift
//  Cricklet
//
//  Created by Himanshu on 02/11/24.
//

import SwiftUI

struct BattingHeaderRow: View {
    var body: some View {
        HStack {
            Text("Batsman").frame(width: 120, alignment: .leading)
            Text("R").frame(width: 40)
            Text("B").frame(width: 40)
            Text("4s").frame(width: 40)
            Text("6s").frame(width: 40)
            Text("SR").frame(width: 60)
        }
        .fontWeight(.bold)
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(Color.gray.opacity(0.2).cornerRadius(8))
    }
}
