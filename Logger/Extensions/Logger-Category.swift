//
//  Logger-Category.swift
//  Logger
//
//  Created by Maris Lagzdins on 07/04/2022.
//

import Foundation
import os.log

extension Logger {
    init(category: String = #fileID) {
        // swiftlint:disable:next force_unwrapping
        self.init(subsystem: Bundle.main.bundleIdentifier!, category: "\(category)")
    }

    init<T>(category: T.Type) {
        self.init(category: String(describing: category))
    }
}
