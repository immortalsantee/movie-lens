//
//  AppEnvironment.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/17/26.
//

import Foundation

enum SMAppEnvironment {
    static let isUITest: Bool = ProcessInfo.processInfo.arguments.contains("-UITestMode")
}
