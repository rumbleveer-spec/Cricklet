//
//  BowlingPlayer.swift
//  Cricklet
//
//  Created by Himanshu on 02/11/24.
//

struct BowlingPlayer: Codable {
    let economyRate: String
    let maidens: String
    let name: String
    let overs: String
    let runs: String
    let wickets: String
    
    enum CodingKeys: String, CodingKey {
        case economyRate = "economy_rate"
        case maidens
        case name
        case overs
        case runs
        case wickets
    }
}
