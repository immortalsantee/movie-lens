//
//  Endpoint.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/13/26.
//
import Foundation

enum Endpoint {
    static let baseURL = "https://api.themoviedb.org/3"
    static let apiKey = "97673522c2b07a9703babc9450547931"
    
    case searchMovies(query: String, page: Int)
    case movieDetails(id: Int)
    case genres

    var urlString: String {
        switch self {
        case .searchMovies(let query, let page):
            let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "\(Endpoint.baseURL)/search/movie?api_key=\(Endpoint.apiKey)&query=\(encoded)&page=\(page)"

        case .movieDetails(let id):
            return "\(Endpoint.baseURL)/movie/\(id)?api_key=\(Endpoint.apiKey)"
            
        case .genres:
                return "https://api.themoviedb.org/3/genre/movie/list?language=en&api_key=\(Endpoint.apiKey)"
        }
    }
}
