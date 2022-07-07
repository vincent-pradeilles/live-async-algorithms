//
//  EventsViewModel.swift
//  AsyncAlgorithms
//
//  Created by Vincent on 03/07/2022.
//

import Foundation
import Combine
import AsyncAlgorithms

@MainActor
class EventsViewModel: ObservableObject {
    static let people = ["Luke", "Leia", "Han"]
    static let states = ["angry 😡", "busy 😬", "sleepy 😪"]

    @Published var text: String = ""

    func startEvents() async {
        let peoplePublisher = Timer.publish(
            every: 1,
            on: .main,
            in: .common
        )
        .autoconnect()
        .map { _ in Self.people.randomElement()! }

        let statePublisher = Timer.publish(
            every: 2,
            on: .main,
            in: .common
        )
        .autoconnect()
        .map { _ in Self.states.randomElement()! }

//        Task {
            for await (person, state) in combineLatest(peoplePublisher.values, statePublisher.values) {
                print("LOOP")
                text = "\(person) is currently \(state)"
            }
//        }
    }
}
