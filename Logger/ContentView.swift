//
//  ContentView.swift
//  Logger
//
//  Created by Maris Lagzdins on 07/04/2022.
//

// More information about Logger can be found in:
// https://developer.apple.com/documentation/os/logging/generating_log_messages_from_your_code

import SwiftUI
import OSLog
import os.log

struct ContentView: View {
    private static let logger = Logger(category: Self.self)

    var body: some View {
        VStack {
            VStack {
                Text("Type")

                HStack {
                    Button("Debug", action: debug)
                    Button("Trace", action: trace)
                }
                Button("Info", action: info)
                Button("Notice", action: notice)
                Button("Error", action: error)
                HStack {
                    Button("Fault", action: fault)
                    Button("Critical", action: critical)
                }
            }

            Divider()
                .padding()

            VStack {
                Text("Privacy")

                HStack {
                    Button("Private") {
                        Self.logger.notice("Privacy private message \(Date(), privacy: .private)")
                        // Produces output: "Privacy private message <private>"
                    }

                    Button("Private hash") {
                        Self.logger.notice("Privacy private hash message \(Date(), privacy: .private(mask: .hash))")
                        // Produces output: "Privacy private hash message <mask.hash: 'yejBhMgpKcQy57Heqrfx9g=='>"
                    }
                }

                HStack {
                    Button("Sensitive") {
                        Self.logger.notice("Privacy sensitive message \(Date(), privacy: .sensitive)")
                        // Produces output: "Privacy sensitive message <private>"
                    }

                    Button("Sensitive hash") {
                        Self.logger.notice("Privacy sensitive hash message \(Date(), privacy: .sensitive(mask: .hash))")
                        // Produces output: "Privacy sensitive hash message <mask.hash: 'LvH9iKb0KPn4E+9ke77VNA=='>"
                    }
                }

                HStack {
                    Button("Public") {
                        Self.logger.notice("Privacy public message \(Date(), privacy: .public)")
                        // Produces output: "Privacy public message 2022-04-07 08:56:46 +0000"
                    }
                }
            }

            Divider()
                .padding()

            Button("Collect logs") {
                let logs = collectLogs()
                printLogs(logs)
            }
            .buttonStyle(.borderless)

        }
        .buttonStyle(.borderedProminent)
        .frame(width: 300)
    }

    func debug() {
        // Captures verbose information during development that is useful only for debugging your code.
        //
        // Persisted to disk: No
        Self.logger.debug("Produce debug message \(Date())")
        // Self.logger.log(level: .debug, "Produce debug message \(Date())")
    }

    func trace() {
        // The same as the `debug`
        Self.logger.trace("Produce trace message \(Date())")
    }

    func info() {
        // Captures information that is helpful, but not essential, to troubleshoot problems.
        //
        // Persisted to disk: Only when collected with the log tool
        Self.logger.info("Produce info message \(Date())")
        // Self.logger.log(level: .info, "Produce info message \(Date())")
    }

    func notice() {
        // Default log.
        //
        // Captures information that is essential for troubleshooting problems.
        // For example, capture information that might result in a failure.
        //
        // Persisted to disk: Yes, up to a storage limit
        Self.logger.notice("Produce notice message \(Date())")
        // Self.logger.log(level: .default, "Produce notice message \(Date())")
    }

    func error() {
        // Captures errors seen during the execution of your code.
        // If an activity object exists, the system captures information
        // for the related process chain.
        //
        // Persisted to disk: Yes, up to a storage limit
        Self.logger.error("Produce error message \(Date())")
        // Self.logger.log(level: .error, "Produce error message \(Date())")
    }

    func fault() {
        // Captures information about faults and bugs in your code.
        // If an activity object exists, the system captures information
        // for the related process chain.
        //
        // Persisted to disk: Yes, up to a storage limit
        Self.logger.fault("Produce fault message \(Date())")
        // Self.logger.log(level: .fault, "Produce fault message \(Date())")
    }

    func critical() {
        // The same as the `fault`
        Self.logger.critical("Produce critical message \(Date())")
    }



    func collectLogs(since date: Date = .init().addingTimeInterval(-60)) -> [OSLogEntryLog] {
        guard let store = try? OSLogStore(scope: .currentProcessIdentifier) else {
            return []
        }

        let sinceTime = store.position(date: date)

        guard let entries = try? store.getEntries(at: sinceTime) else {
            return []
        }

        return entries
            .compactMap { $0 as? OSLogEntryLog }
            .filter { $0.subsystem == Bundle.main.bundleIdentifier! }
    }

    func printLogs(_ logs: [OSLogEntryLog]) {
        for log in logs {
            print(log.date, log.composedMessage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
