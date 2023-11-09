//
//  AppConfig.swift
//  cricArena
//
//  Created by bjit on 14/2/23.
//

import Foundation
final class apiConfig {
    private init() {}
    private static let apiBaseURL = "https://cricket.sportmonks.com/api/v2.0"
    //private static let apiKey = "zmvH4XzP39oQWQGWKTpiT6ZScMFyctTSUqArJMgEXat6PYARp2RRbZVFqZNf"
    private static let apiKey = "Tx3VQVqDOUeIE0xHqI0D9u6OHApOI4QEKyzq6MnLLOBUE0nyf2Q9sx9itBdy"
    static var getUpcomingMatchUrl: URL? {
        guard let apiURL = URL(string: apiBaseURL) else {
            return nil
        }
        var components = URLComponents(url: apiURL, resolvingAgainstBaseURL: false)
        components?.path += "/fixtures"
        components?.queryItems = [
            URLQueryItem(name: "include", value: "runs,localteam,visitorteam"),
            URLQueryItem(name: "filter[status]", value: "NS"),
            URLQueryItem(name: "fields[teams]", value: "code,image_path"),
            URLQueryItem(name: "sort", value: "starting_at"),
            URLQueryItem(name: "fields[fixtures]", value: "id,type,note,starting_at,round"),
            URLQueryItem(name: "api_token", value: apiKey),
            
        ]
        guard let url = components?.url else { return nil }
        return url
    }
    
    static var getRecentMatchUrl: URL? {
        guard let apiURL = URL(string: apiBaseURL) else {
            return nil
        }
        var components = URLComponents(url: apiURL, resolvingAgainstBaseURL: false)
        components?.path += "/fixtures"
        components?.queryItems = [
            URLQueryItem(name: "include", value: "runs,localteam,visitorteam"),
            URLQueryItem(name: "filter[status]", value: "Finished"),
            URLQueryItem(name: "fields[teams]", value: "code,image_path"),
            URLQueryItem(name: "fields[fixtures]", value: "id,type,note,starting_at,round"),
            URLQueryItem(name: "sort", value: "-starting_at"),
            URLQueryItem(name: "api_token", value: apiKey),
            
        ]
        guard let url = components?.url else { return nil }
        return url
    }
    
    static func getMatchDetailsUrl(matchId: Int) -> URL? {
        var getMatchDetailsUrl: URL? {
            guard let apiURL = URL(string: apiBaseURL) else {
                return nil
            }
            var components = URLComponents(url: apiURL, resolvingAgainstBaseURL: false)
            components?.path += "/fixtures"
            components?.path += "/\(matchId)"
            components?.queryItems = [
                URLQueryItem(name: "include", value: "runs,localteam,visitorteam,league,stage,venue,batting.batsman,bowling.bowler,tosswon,winnerteam,manofmatch,tosswon,localteam.results,visitorteam.results,batting.result,lineup"),
                URLQueryItem(name: "api_token", value: apiKey),
            ]
            guard let url = components?.url else { return nil }
            return url
        }
        return getMatchDetailsUrl
    }
    
    static var getAllPlayerDetailsUrl: URL? {
        guard let apiURL = URL(string: apiBaseURL) else {
            return nil
        }
        var components = URLComponents(url: apiURL, resolvingAgainstBaseURL: false)
        components?.path += "/players"
        components?.queryItems = [
            URLQueryItem(name: "api_token", value: apiKey),
        ]
        guard let url = components?.url else { return nil }
        return url
    }
    
    static var getRankingsUrl: URL? {
        guard let apiURL = URL(string: apiBaseURL) else {
            return nil
        }
        var components = URLComponents(url: apiURL, resolvingAgainstBaseURL: false)
        components?.path += "/team-rankings"
        components?.queryItems = [
            URLQueryItem(name: "api_token", value: apiKey),
        ]
        guard let url = components?.url else { return nil }
        return url
    }
    
    static func getFixtures(leagueId: Int)-> URL? {
        var getMatchwithLeagueIdUrl: URL? {
            guard let apiURL = URL(string: apiBaseURL) else {
                return nil
            }
            var components = URLComponents(url: apiURL, resolvingAgainstBaseURL: false)
            components?.path += "/fixtures"
            components?.queryItems = [
                URLQueryItem(name: "include", value: "runs,localteam,visitorteam"),
                URLQueryItem(name: "fields[teams]", value: "code,image_path"),
                URLQueryItem(name: "fields[fixtures]", value: "id,type,note,starting_at,round"),
                URLQueryItem(name: "sort", value: "starting_at"),
                URLQueryItem(name: "filter[league_id]", value: String(leagueId)),
                URLQueryItem(name: "api_token", value: apiKey),
                
            ]
            guard let url = components?.url else { return nil }
            return url
        }
        return getMatchwithLeagueIdUrl
    }
    
    static func getPlayerDetails(playerID: Int)-> URL? {
        var getPlayerWithIdUrl: URL? {
            guard let apiURL = URL(string: apiBaseURL) else {
                return nil
            }
            var components = URLComponents(url: apiURL, resolvingAgainstBaseURL: false)
            components?.path += "/players/\(playerID)"
            components?.queryItems = [
                URLQueryItem(name: "include", value: "career"),
                URLQueryItem(name: "api_token", value: apiKey),
            ]
            guard let url = components?.url else { return nil }
            return url
        }
        return getPlayerWithIdUrl
    }
}


