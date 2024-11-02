//
//  AppDelegate.swift
//  Cricklet
//
//  Created by Himanshu on 02/11/24.
//

import Foundation
import Combine
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var instance: AppDelegate!
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = CrickletAppMenu()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.instance = self
        statusBarItem.button?.title = "Select Match"
        statusBarItem.menu = menu.createMenu()
    }
}
