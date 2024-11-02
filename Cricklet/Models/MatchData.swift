//
//  MatchData.swift
//  Cricklet
//
//  Created by Himanshu on 02/11/24.
//

struct MatchData: Codable {
    let battingPlayers: [BattingPlayer]
    let bowlingPlayers: [BowlingPlayer]
    let status: String
    let detailsUrl: String
    let scorecard: String
    
    enum CodingKeys: String, CodingKey {
        case battingPlayers = "batting_players"
        case bowlingPlayers = "bowling_players"
        case status
        case detailsUrl = "details_url"
        case scorecard
    }
}
