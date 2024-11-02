//
//  BattingPlayer.swift
//  Cricklet
//
//  Created by Himanshu on 02/11/24.
//

struct BattingPlayer: Codable {
    let ballsFaced: String
    let fours: String
    let isOnStrike: Bool
    let name: String
    let runs: String
    let sixes: String
    let strikeRate: String
    
    enum CodingKeys: String, CodingKey {
        case ballsFaced = "balls_faced"
        case fours
        case isOnStrike = "is_on_strike"
        case name
        case runs
        case sixes
        case strikeRate = "strike_rate"
    }
}
