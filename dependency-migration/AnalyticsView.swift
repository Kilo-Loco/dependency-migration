//
//  AnalyticsView.swift
//  dependency-migration
//
//  Created by Lee, Kyle on 3/25/21.
//
import Amplify
import SwiftUI

struct AnalyticsView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            TextField("Event name", text: $viewModel.title)
            Slider(value: $viewModel.rating, in: 1 ... 10, step: 1)
            Button("Log Event", action: viewModel.logEvent)
        }
    }
}

extension AnalyticsView {
    class ViewModel: ObservableObject {
        @Published var title = ""
        @Published var rating = 1.0
        
        func logEvent() {
            let properties: AnalyticsProperties = ["title": title, "rating": rating]
            let event = BasicAnalyticsEvent(name: "sexy event", properties: properties)
            Amplify.Analytics.record(event: event)
            title.removeAll()
            rating = 1
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
