//
//  SimpleLogger.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

final class LoggerImpl: Logger {

    private let isLoggingEnabled: Bool

    init(isLoggingEnabled: Bool) {
        self.isLoggingEnabled = isLoggingEnabled
    }

    func log(message: String) {
        guard isLoggingEnabled else { return }

        print("\n******************\n\(message)\n******************\n")
    }

    func log(error: Error) {
        guard isLoggingEnabled else { return }

        print("\nError happened during the app execution:")
        print(error)
    }
}
