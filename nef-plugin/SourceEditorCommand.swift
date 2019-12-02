//  Copyright © 2019 The nef Authors.

import Foundation
import XcodeKit
import AppKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
        guard let command = SourceEditorExtension.Command(rawValue: invocation.commandIdentifier) else {
            completionHandler(EditorError.invalidCommand); return
        }
        guard let textRange = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(EditorError.unknown); return
        }
        
        let lines = invocation.buffer.lines.map { "\($0)" }
        process(command: command, textRange: textRange, lines: lines, completion: completionHandler)
    }
    
    private func process(command: SourceEditorExtension.Command, textRange: XCSourceTextRange, lines: [String], completion: @escaping (Error?) -> Void) {
        switch command {
        case .preferences:
            preferences(completion: completion)
        case .exportSnippet:
            carbon(textRange: textRange, lines: lines, completion: completion)
        }
    }

    // MARK: commands
    private func preferences(completion: @escaping (Error?) -> Void) {
        let preferencesItem = URLQueryItem(name: "preferences", value: nil)
        let url = nefAppURL(from: preferencesItem)
        
        try! NSWorkspace.shared.open(url, options: .newInstance, configuration: [:])
        terminate(deadline: .now(), completion)
    }
    
    private func carbon(textRange: XCSourceTextRange, lines: [String], completion: @escaping (Error?) -> Void) {
        guard Reachability.isConnected else { completion(EditorError.internetConnection); return }
        guard let selection = userSelection(textRange: textRange, lines: lines) else { completion(EditorError.selection); return }
        
        let code = removeLeadingMargin(selection)
        let codeItem = URLQueryItem(name: "carbon", value: code)
        let url = nefAppURL(from: codeItem)
        
        try! NSWorkspace.shared.open(url, options: .newInstance, configuration: [:])
        terminate(deadline: .now() + .seconds(5), completion)
    }
    
    private func nefAppURL(from item: URLQueryItem) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = "xcode"
        urlComponents.queryItems = [item]
        return urlComponents.url!
    }
    
    private func terminate(deadline: DispatchTime, _ completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: deadline) { completion(nil) }
    }
    
    // MARK: private methods
    private func userSelection(textRange: XCSourceTextRange, lines: [String]) -> String? {
        let hasSelection = (textRange.start.column != textRange.end.column) ||
            (textRange.start.column == 0 && textRange.end.column == 0 && textRange.start.line != textRange.end.line)
        guard lines.count > 0, hasSelection else { return nil }
        
        let start = textRange.start.line
        let end = min(textRange.end.line + 1, lines.count)
        let selection = lines[start..<end].joined().trimmingCharacters(in: .newlines)
        
        return selection
    }
    
    private func removeLeadingMargin(_ code: String) -> String {
        let lines = code.components(separatedBy: "\n")
        guard let firstLine = lines.first,
              let leading = firstLine.map({ $0 }).enumerated().first(where: { $0.element != " " })?.offset else { return code }
        
        return lines.map { $0.dropFirst(leading) }.joined(separator: "\n")
    }
    
    // MARK: - Constants
    enum Constants {
        static let scheme = "nef-plugin"
    }
    
    enum EditorError {
        static let unknown = NSError(domain: "nef editor", code: 1, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Undefined error", comment: "")])
        static let invalidCommand = NSError(domain: "nef editor", code: 2, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("This command has not being implemented", comment: "")])
        static let selection = NSError(domain: "nef editor", code: 3, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("You must make a code selection first", comment: "")])
        static let internetConnection = NSError(domain: "nef editor", code: 4, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("You can not create a code snippet without an internet connection", comment: "")])
    }
}