//
//  BattingPlayerRow.swift
//  Cricklet
//
//  Created by Himanshu on 02/11/24.
//

import SwiftUI

struct BattingPlayerRow: View {
    let player: BattingPlayer
    
    var body: some View {
        HStack {
            Text(player.name).frame(width: 120, alignment: .leading)
            Text("\(player.runs)").frame(width: 40)
            Text(player.ballsFaced).frame(width: 40)
            Text(player.fours).frame(width: 40)
            Text(player.sixes).frame(width: 40)
            Text(player.strikeRate).frame(width: 60)
        }
        .padding(.vertical, 4)
    }
}

