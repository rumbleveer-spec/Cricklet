//
//  BowlingPlayerRow.swift
//  Cricklet
//
//  Created by Himanshu on 02/11/24.
//

import SwiftUI

struct BowlingPlayerRow: View {
    let player: BowlingPlayer
    
    var body: some View {
        HStack {
            Text(player.name).frame(width: 120, alignment: .leading)
            Text(player.overs).frame(width: 40)
            Text(player.runs).frame(width: 40)
            Text(player.wickets).frame(width: 40)
            Text(player.maidens).frame(width: 40)
            Text(player.economyRate).frame(width: 60)
        }
        .padding(.vertical, 4)
    }
}

