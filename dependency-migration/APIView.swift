//
//  APIView.swift
//  dependency-migration
//
//  Created by Lee, Kyle on 3/25/21.
//

import Amplify
import Combine
import SwiftUI

struct APIView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.notes) { note in
                Text(note.title)
                    .onTapGesture {
                        viewModel.selectedNote = note
                    }
            }
            .navigationTitle("Notes API")
            .navigationBarItems(
                trailing: Button(action: viewModel.createNote) { Image(systemName: "plus") }
            )
            .alert(item: $viewModel.selectedNote) { note in
                Alert(title: Text(note.title), message: Text(note.description))
            }
        }
    }
}

extension APIView {
    class ViewModel: ObservableObject {
        @Published var notes: [Note] = []
        @Published var selectedNote: Note?
        
        init() {
            getNotes()
            observeNotes()
        }
        
        var subscription: GraphQLSubscriptionOperation<Note>?
        var token: AnyCancellable?
        func observeNotes() {
            subscription = Amplify.API.subscribe(request: .subscription(of: Note.self, type: .onCreate))
            token = subscription?.subscriptionDataPublisher
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { print($0) },
                    receiveValue: { [weak self] result in
                        let note = try! result.get()
                        if self?.notes.contains(where: {$0.id == note.id}) == false {
                            self?.notes.insert(note, at: 0)
                        }
                    }
                )
        }
        
        func getNotes() {
            Amplify.API.query(request: .paginatedList(Note.self)) { [weak self] result in
                DispatchQueue.main.async {
                    self?.notes = try! Array(result.get().get())
                }
                
            }
        }
        
        func createNote() {
            let newNote = Note(title: "API - \(UUID().uuidString)", description: UUID().uuidString)
            Amplify.API.mutate(request: .create(newNote)) { result in
                print("Saved:", try! result.get().get())
            }
        }
    }
}

struct APIView_Previews: PreviewProvider {
    static var previews: some View {
        APIView()
    }
}
