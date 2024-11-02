//
//  BowlingHeaderRow.swift
//  Cricklet
//
//  Created by Himanshu on 02/11/24.
//

import SwiftUI

struct BowlingHeaderRow: View {
    var body: some View {
        HStack {
            Text("Bowler").frame(width: 120, alignment: .leading)
            Text("O").frame(width: 40)
            Text("R").frame(width: 40)
            Text("W").frame(width: 40)
            Text("M").frame(width: 40)
            Text("ER").frame(width: 60)
        }
        .fontWeight(.bold)
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(Color.gray.opacity(0.2).cornerRadius(8))
    }
}
