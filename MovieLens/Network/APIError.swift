//
//  APIError.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/13/26.
//

import Foundation

/// Errors based on https://developer.themoviedb.org/docs/errors
enum APIError: Error {
    case invalidURL
    case authentication
    case permissionDenied
    case notFound
    case validationFailed
    case rateLimited
    case serverError
    case serviceUnavailable
    case decodingError
    case unknown
    
    static func from(statusCode: Int) -> APIError {
        switch statusCode {
        case 400:
            return .validationFailed
        case 401:
            return .authentication
        case 403:
            return .permissionDenied
        case 404:
            return .notFound
        case 405:
            return .validationFailed
        case 406:
            return .validationFailed
        case 422:
            return .validationFailed
        case 429:
            return .rateLimited

        case 500, 501, 502:
            return .serverError
        case 503, 504:
            return .serviceUnavailable

        default:
            return .unknown
        }
    }

    func message() -> String {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."

        case .authentication:
            return "Authentication failed. Please check your API key or login status."

        case .permissionDenied:
            return "You do not have permission to perform this action."

        case .notFound:
            return "The requested resource could not be found."

        case .validationFailed:
            return "Some request parameters were invalid. Please try again."

        case .rateLimited:
            return "You have made too many requests. Please try again later."

        case .serverError:
            return "Something went wrong on the server. Please try again."

        case .serviceUnavailable:
            return "The service is temporarily unavailable. Please try again later."

        case .decodingError:
            return "We couldn’t process the server response. Please try again."

        case .unknown:
            return "An unexpected error occurred. Please try again."
        }
    }
}
