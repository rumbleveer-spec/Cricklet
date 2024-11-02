//
//  CrickletApp.swift
//  Cricklet
//
//  Created by Himanshu on 02/11/24.
//

import SwiftUI

@main
struct CrickletApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
