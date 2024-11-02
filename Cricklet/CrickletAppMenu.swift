//
//  CrickletAppMenu.swift
//  Cricklet
//
//  Created by Himanshu on 02/11/24.
//

import Foundation
import SwiftUI
import Combine

struct Match: Codable, Identifiable {
    let match_id: String
    let title: String
    let link: String
    
    var id: String { match_id }
}

class CrickletAppMenu: NSObject {
    let menu = NSMenu()
    var menuUpdateSubscription: AnyCancellable?
    var matches: [Match] = []
    private let apiURL = "https://cric-back.fly.dev/summary"
    private var isLoading = false
    private var pollingTimer: Timer?
    private let pollingInterval: TimeInterval = 30
    private var currentMatchId: String?
    private var currentMatchData: MatchData?
    private var matchDetailsPollingTimer: Timer?
    private let matchDetailsPollingInterval: TimeInterval = 30
    private var matchDetailHostingController: NSHostingController<MatchDetailView>?
    var statusItem: NSStatusItem?
    
    override init() {
        super.init()
        startPolling()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRetry),
            name: .retryFetch,
            object: nil
        )
    }
    
    deinit {
        stopPolling()
        stopMatchDetailsPolling()
    }
    
    func createMenu() -> NSMenu {
        if let appDelegate = AppDelegate.instance {
            self.statusItem = appDelegate.statusBarItem
        }

        let contentView = currentMatchData != nil
            ? MatchDetailView(matchData: currentMatchData!)
            : MatchDetailView(matchData: nil)
        let topView = NSHostingController(rootView: contentView)
        matchDetailHostingController = topView
        topView.view.frame.size = topView.view.fittingSize
        
        let customMenuItem = NSMenuItem()
        customMenuItem.view = topView.view
        menu.addItem(customMenuItem)
        menu.addItem(NSMenuItem.separator())

        return menu
    }
    
    private func fetchLiveMatches() {
        guard !isLoading, let url = URL(string: apiURL) else { return }
        
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            defer { self?.isLoading = false }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching matches: \(error)")
                    self?.showError("Unable to fetch matches.\nPlease check your internet connection")
                    return
                }
                
                guard let data = data else {
                    self?.showError("No data received from server")
                    return
                }
                
                do {
                    let matches = try JSONDecoder().decode([Match].self, from: data)
                    self?.matches = matches
                    self?.clearMatchMenuItems()
                    matches.forEach { match in
                        self?.addDynamicMenuItem(match: match)
                    }
                    self?.addSeparatorAndQuitMenuItem()
                    
                    // If no matches found, update UI accordingly
                    if matches.isEmpty {
                        self?.showError("No live matches available")
                    }
                } catch {
                    print("Error decoding matches: \(error)")
                    self?.showError("Unable to process match data")
                }
            }
        }.resume()
    }
    
    private func clearMatchMenuItems() {
        let itemsToKeep = 2  // Keep only the custom view and its separator
        while menu.items.count > itemsToKeep {
            menu.removeItem(at: itemsToKeep)
        }
    }

    private func addSeparatorAndQuitMenuItem() {
        menu.addItem(NSMenuItem.separator())
        let quit = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "")
        quit.target = self
        menu.addItem(quit)
    }
    
    func addDynamicMenuItem(match: Match) {
        let truncatedTitle = match.title.count > 55
            ? match.title.prefix(52) + "..."
            : match.title
        
        let newMenuItem = NSMenuItem(title: String(truncatedTitle), action: nil, keyEquivalent: "")
        newMenuItem.target = self
        newMenuItem.representedObject = match.match_id
        
        // Create a submenu with truncated title
        let submenu = NSMenu(title: "Options for \(truncatedTitle)")
        
        // Add match-specific options
        let viewDetails = NSMenuItem(title: "Pin match", action: #selector(pinMatch), keyEquivalent: "")
        viewDetails.target = self
        submenu.addItem(viewDetails)
        
        let shareMatch = NSMenuItem(title: "Open", action: #selector(openInBrowser), keyEquivalent: "")
        shareMatch.representedObject = match.link
        shareMatch.target = self
        submenu.addItem(shareMatch)
        
        newMenuItem.submenu = submenu
        menu.addItem(newMenuItem)
    }
    
    @objc func pinMatch(sender: NSMenuItem) {
        if let parentItem = sender.parent,
           let matchId = parentItem.representedObject as? String {
            currentMatchId = matchId
            fetchMatchDetails(matchId: matchId)
        }
    }
    
    @objc func openInBrowser(sender: NSMenuItem) {
        if let matchLink = sender.representedObject as? String {
            guard let url = URL(string: matchLink) else { return }
            NSWorkspace.shared.open(url)
        }
    }
    
    @objc func openLink(sender: NSMenuItem) {
        let link = sender.representedObject as! String
        guard let url = URL(string: link) else {
            return
        }
        NSWorkspace.shared.open(url)
    }
    
    @objc func quit(sender: NSMenuItem) {
        stopPolling()
        NSApp.terminate(self)
    }
    
    private func startPolling() {
        // Initial fetch
        fetchLiveMatches()
        
        // Setup timer for subsequent fetches
        pollingTimer = Timer(timeInterval: pollingInterval, repeats: true) { [weak self] _ in
            self?.fetchLiveMatches()
        }
        // Add timer to RunLoop with common modes to work even when menu is open
        RunLoop.main.add(pollingTimer!, forMode: .common)
    }
    
    private func stopPolling() {
        pollingTimer?.invalidate()
        pollingTimer = nil
    }
    
    private func fetchMatchDetails(matchId: String) {
        let matchURL = "https://cric-back.fly.dev/match/\(matchId)"
        guard let url = URL(string: matchURL) else { return }
        
        // Start polling when fetching match details
        startMatchDetailsPolling(matchId: matchId)
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching match details: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let matchData = try JSONDecoder().decode(MatchData.self, from: data)
                DispatchQueue.main.async {
                    self?.currentMatchData = matchData
                    self?.changeTitleUtil(title: matchData.scorecard)
                    if let hostingController = self?.matchDetailHostingController {
                        hostingController.rootView = MatchDetailView(matchData: matchData)
                        // Update the view frame to match the new fitting size
                        hostingController.view.frame.size = hostingController.view.fittingSize
                    }
                }
            } catch {
                print("Error decoding match details: \(error)")
            }
        }.resume()
    }
    
    private func startMatchDetailsPolling(matchId: String) {
        // Stop existing polling if any
        stopMatchDetailsPolling()
        
        // Setup timer for polling match details
        matchDetailsPollingTimer = Timer(timeInterval: matchDetailsPollingInterval, repeats: true) { [weak self] _ in
            self?.fetchMatchDetails(matchId: matchId)
        }
        // Add timer to RunLoop with common modes
        RunLoop.main.add(matchDetailsPollingTimer!, forMode: .common)
    }
    
    private func stopMatchDetailsPolling() {
        print("Stop match Details Polling")
        matchDetailsPollingTimer?.invalidate()
        matchDetailsPollingTimer = nil
    }

    private func changeTitleUtil(title: String) {
        if let button = self.statusItem?.button {
            button.title = title
            // Optional: Add print statement to debug
            print("Title changed to: \(title)")
        } else {
            print("Failed to change title: statusItem or button is nil")
        }
    }

    @objc private func handleRetry() {
        fetchLiveMatches()
        
        // Reset the top view with empty match data
        let contentView = MatchDetailView(matchData: nil)
        let topView = NSHostingController(rootView: contentView)
        matchDetailHostingController = topView
        topView.view.frame.size = topView.view.fittingSize
        menu.items[0].view = topView.view
    }

    private func showError(_ message: String) {
        let errorView = ErrorView(message: message)
        let errorViewController = NSHostingController(rootView: errorView)
        errorViewController.view.frame.size = errorViewController.view.fittingSize
        menu.items[0].view = errorViewController.view
    }
}
