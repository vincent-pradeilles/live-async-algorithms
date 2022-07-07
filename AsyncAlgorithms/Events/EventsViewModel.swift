//
//  EventsViewModel.swift
//  AsyncAlgorithms
//
//  Created by Vincent on 03/07/2022.
//

import Foundation
import Combine

class EventsViewModel: ObservableObject {
    static let people = ["Luke", "Leia", "Han"]
    static let states = ["angry 😡", "busy 😬", "sleepy 😪"]

    @Published var text = ""

    private var cancellables = Set<AnyCancellable>()

    func startEvents() {
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

        Publishers.CombineLatest(peoplePublisher, statePublisher)
            .sink(receiveValue: { [weak self] (person, state) in
                self?.text = "\(person) is currently \(state)"

            })
            .store(in: &cancellables)
    }
}
