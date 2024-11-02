//
//  MatchDetailView.swift
//  Cricklet
//
//  Created by Himanshu on 02/11/24.
//

import SwiftUI

struct MatchDetailView: View {
    let matchData: MatchData?
    
    var body: some View {
        if let matchData = matchData {
            VStack(spacing: 10) {
                // Match Summary Section
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 10) {
                        Text(matchData.scorecard)
                            .font(.headline)
                        Link(destination: URL(string: matchData.detailsUrl) ?? URL(string: "https://espncricinfo.com")!) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                        }
                    }
                    Text(matchData.status)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
                
                // Batting Section
                VStack {
                    BattingHeaderRow()
                    ForEach(matchData.battingPlayers, id: \.name) { player in
                        BattingPlayerRow(player: player)
                    }
                }
                
                // Bowling Section
                VStack {
                    BowlingHeaderRow()
                    ForEach(matchData.bowlingPlayers, id: \.name) { player in
                        BowlingPlayerRow(player: player)
                    }
                }
            }
            .padding()
        } else {
            VStack {
                Text("Please select a match to view details")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity).padding(20)
        }
    }
}

