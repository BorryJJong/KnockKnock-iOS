//
//  DispatchTimeInterval.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/30.
//

import Foundation

extension DispatchTimeInterval {
  
    func toDouble() -> Double? {
        var result: Double? = 0

        switch self {
        case .seconds(let value):
            result = Double(value)
        case .milliseconds(let value):
            result = Double(value)*0.001
        case .microseconds(let value):
            result = Double(value)*0.000001
        case .nanoseconds(let value):
            result = Double(value)*0.000000001
        case .never:
            result = nil
        @unknown default:
            break
        }

        return result
    }
}

