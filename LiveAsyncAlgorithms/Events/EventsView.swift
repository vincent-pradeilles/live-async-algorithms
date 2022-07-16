//
//  EventsView.swift
//  AsyncAlgorithms
//
//  Created by Vincent on 03/07/2022.
//

import SwiftUI

struct EventsView: View {

    @StateObject var viewModel = EventsViewModel()

    var body: some View {
        Text(viewModel.text)
            .task {
                await viewModel.listenToEvents()
            }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
