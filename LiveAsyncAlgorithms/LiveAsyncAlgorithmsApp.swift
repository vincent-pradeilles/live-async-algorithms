//
//  AsyncAlgorithmsApp.swift
//  AsyncAlgorithms
//
//  Created by Vincent on 03/07/2022.
//

import SwiftUI

@main
struct AsyncAlgorithmsApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    MoviesView()
                }
                .tabItem {
                    Label("Movies", systemImage: "film")
                }

                EventsView()
                .tabItem {
                    Label("Events", systemImage: "clock.arrow.2.circlepath")
                }
                LoginView()
                .tabItem {
                    Label("Login", systemImage: "person.fill")
                }
            }
        }
    }
}
