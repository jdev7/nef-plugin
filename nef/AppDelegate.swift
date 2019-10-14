//  Copyright © 2019 The nef Authors.

import SwiftUI
import NefCarbon

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    private let assembler = Assembler()
    private var command: Command?
    @IBOutlet weak var aboutMenuItem: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard let command = command else { applicationDidFinishLaunching(); return }
        
        switch command {
        case .preferences:
            preferencesDidFinishLaunching()
        case .carbon(let code):
            carbonDidFinishLaunching(code: code)
        case .about:
            aboutDidFinishLaunching()
        }
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        let eventManager = NSAppleEventManager.shared()
        eventManager.setEventHandler(self,
                                     andSelector: #selector(handle(event:withReplyEvent:)),
                                     forEventClass: AEEventClass(kInternetEventClass),
                                     andEventID: AEEventID(kAEGetURL))
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    // MARK: Aplication actions
    @IBAction func showAbout(_ sender: Any) {
        aboutDidFinishLaunching()
    }
    
    // MARK: life cycle
    private func applicationDidFinishLaunching() {
        aboutDidFinishLaunching()
    }
    
    private func aboutDidFinishLaunching() {
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 350, height: 350),
                          styleMask: [.titled, .closable],
                          backing: .buffered, defer: false)
        
        window.center()
        window.title = i18n.aboutTitle
        window.setFrameAutosaveName(i18n.aboutTitle)
        window.contentView = NSHostingView(rootView: assembler.resolveAboutView())
        window.makeKeyAndOrderFront(nil)
        
        aboutMenuItem.isHidden = true
    }
    
    private func preferencesDidFinishLaunching() {
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 800, height: 760),
                          styleMask: [.titled, .closable, .miniaturizable],
                          backing: .buffered, defer: false)
        
        window.center()
        window.title = i18n.preferencesTitle
        window.setFrameAutosaveName(i18n.preferencesTitle)
        window.contentView = NSHostingView(rootView: assembler.resolvePreferencesView())
        window.makeKeyAndOrderFront(nil)
    }
    
    private func carbonDidFinishLaunching(code: String) {
        guard !code.isEmpty else { terminate(); return }
        guard let _ = carbonWindow(code: code) else { terminate(); return }
        
        self.window = NSWindow.empty
        self.window.makeKeyAndOrderFront(nil)
    }
    
    // MARK: private methods
    private func carbonWindow(code: String) -> NSWindow? {
        guard let writableFolder = assembler.resolveOpenPanel().writableFolder(create: true) else { return nil }
        
        let filename = "nef \(Date.now.human)"
        let outputPath = writableFolder.appendingPathComponent(filename).path
        
        return assembler.resolveCarbonWindow(code: code, outputPath: outputPath) { status in
            if status {
                let file = URL(fileURLWithPath: "\(outputPath).png")
                self.showFile(file)
            }
            
            self.terminate()
        }
    }

    private func showFile(_ file: URL) {
        NSWorkspace.shared.activateFileViewerSelecting([file])
    }
    
    private func terminate() {
        DispatchQueue.main.async {
            NSApplication.shared.terminate(nil)
        }
    }
    
    // MARK: scheme url types
    @objc private func handle(event: NSAppleEventDescriptor, withReplyEvent: NSAppleEventDescriptor) {
        let keyword = AEKeyword(keyDirectObject)
        let urlDescriptor = event.paramDescriptor(forKeyword: keyword)
        guard let urlString = urlDescriptor?.stringValue,
            let incomingURL = URL(string: urlString),
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems else { return }
        
        let params = queryItems.map { item in (name: item.name, value: item.value ?? "") }
        self.command = params.first(where: self.isOperation).flatMap(self.operation)
    }
    
    private func isOperation(param: (name: String, value: String)) -> Bool {
        return operation(for: param) != nil
    }
    
    private func operation(for param: (name: String, value: String)) -> Command? {
        switch param {
        case ("preferences", _):
            return .preferences
        case let ("carbon", value):
            return .carbon(code: value)
        case ("about", _):
            return .about
        default:
            return nil
        }
    }
    
    // MARK: Constants
    enum Command {
        case about
        case preferences
        case carbon(code: String)
    }
    
    enum i18n {
        static let preferencesTitle = NSLocalizedString("preferences", comment: "")
        static let aboutTitle = NSLocalizedString("about", comment: "")
    }
}
