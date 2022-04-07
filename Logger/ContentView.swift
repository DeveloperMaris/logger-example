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
                    Button {
                        // Captures verbose information during development that is useful only for debugging your code.
                        //
                        // Persisted to disk: No
                        Self.logger.debug("Produce debug message \(Date(), align: .right(columns: 15))")
                        // Self.logger.log(level: .debug, "Produce debug message \(Date())")
                    } label: {
                        Text("Debug")
                            .frame(maxWidth: .infinity)
                    }

                    Button {
                        // The same as the `debug`
                        Self.logger.trace("Produce trace message \(Date())")
                    } label: {
                        Text("Trace")
                            .frame(maxWidth: .infinity)
                    }
                }

                Divider()

                Button {
                    // Captures information that is helpful, but not essential, to troubleshoot problems.
                    //
                    // Persisted to disk: Only when collected with the log tool
                    Self.logger.info("Produce info message \(Date())")
                    // Self.logger.log(level: .info, "Produce info message \(Date())")
                } label: {
                    Text("Info")
                        .frame(maxWidth: .infinity)
                }

                Divider()

                Button {
                    // Default log.
                    //
                    // Captures information that is essential for troubleshooting problems.
                    // For example, capture information that might result in a failure.
                    //
                    // Persisted to disk: Yes, up to a storage limit
                    Self.logger.notice("Produce notice message \(Date())")
                    // Self.logger.log(level: .default, "Produce notice message \(Date())")
                } label: {
                    Text("Notice")
                        .frame(maxWidth: .infinity)
                }

                Divider()

                Button {
                    // Captures errors seen during the execution of your code.
                    // If an activity object exists, the system captures information
                    // for the related process chain.
                    //
                    // Persisted to disk: Yes, up to a storage limit
                    Self.logger.error("Produce error message \(Date())")
                    // Self.logger.log(level: .error, "Produce error message \(Date())")
                } label: {
                    Text("Error")
                        .frame(maxWidth: .infinity)
                }

                Divider()

                HStack {
                    Button {
                        // Captures information about faults and bugs in your code.
                        // If an activity object exists, the system captures information
                        // for the related process chain.
                        //
                        // Persisted to disk: Yes, up to a storage limit
                        Self.logger.fault("Produce fault message \(Date())")
                        // Self.logger.log(level: .fault, "Produce fault message \(Date())")
                    } label: {
                        Text("Fault")
                            .frame(maxWidth: .infinity)
                    }

                    Button {
                        // The same as the `fault`
                        Self.logger.critical("Produce critical message \(Date())")
                    } label: {
                        Text("Critical")
                            .frame(maxWidth: .infinity)
                    }
                }
            }

            Divider()

            VStack {
                Text("Privacy")
                HStack {
                    Button {
                        Self.logger.notice("Privacy private message \(Date(), privacy: .private)")
                        // Produces output: "Privacy private message <private>"
                    } label: {
                        Text("Private")
                            .frame(maxWidth: .infinity)
                    }

                    Button {
                        Self.logger.notice("Privacy private hash message \(Date(), privacy: .private(mask: .hash))")
                        // Produces output: "Privacy private hash message <mask.hash: 'yejBhMgpKcQy57Heqrfx9g=='>"
                    } label: {
                        Text("Private hash")
                            .frame(maxWidth: .infinity)
                    }
                }

                HStack {
                    Button {
                        Self.logger.notice("Privacy public message \(Date(), privacy: .public)")
                        // Produces output: "Privacy public message 2022-04-07 08:56:46 +0000"
                    } label: {
                        Text("Public")
                            .frame(maxWidth: .infinity)
                    }

                    Button {
                        Self.logger.notice("Privacy sensitive message \(Date(), privacy: .sensitive)")
                        // Produces output: "Privacy sensitive message <private>"
                    } label: {
                        Text("Sensitive")
                            .frame(maxWidth: .infinity)
                    }
                }

                HStack {
                    Button {
                        Self.logger.notice("Privacy sensitive hash message \(Date(), privacy: .sensitive(mask: .hash))")
                        // Produces output: "Privacy sensitive hash message <mask.hash: 'LvH9iKb0KPn4E+9ke77VNA=='>"
                    } label: {
                        Text("Sensitive hash")
                            .frame(maxWidth: .infinity)
                    }
                }
            }

            Divider()

            Button {
                let logs = collectLogs()
                printLogs(logs)
            } label: {
                Text("Collect logs")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderless)

        }
        .buttonStyle(.borderedProminent)
        .frame(width: 200)
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
