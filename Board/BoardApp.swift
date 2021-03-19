//
//  BoardApp.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/16/21.
//

import SwiftUI
import AlamofireNetworkActivityIndicator

@main
struct BoardApp: App {
    init() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(HomeViewModel(scheduler: DispatchQueue.main))
        }
    }
}
