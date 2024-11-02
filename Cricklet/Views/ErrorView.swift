//
//  ErrorView.swift
//  Cricklet
//
//  Created by Himanshu on 02/11/24.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 32))
                .foregroundColor(.orange)
            
            Text(message)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Button("Retry") {
                // TODO: Add retry action
                NotificationCenter.default.post(name: .retryFetch, object: nil)
            }
            .buttonStyle(.borderless)
        }
        .frame(width: 300, height: 150)
        .padding()
    }
}

// Add notification name extension
extension Notification.Name {
    static let retryFetch = Notification.Name("retryFetch")
}

#Preview {
    ErrorView(message: "Unable to fetch matches.\nPlease check your internet connection.")
}
