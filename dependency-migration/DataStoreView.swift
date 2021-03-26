//
//  DataView.swift
//  dependency-migration
//
//  Created by Lee, Kyle on 3/25/21.
//

import Amplify
import Combine
import SwiftUI

struct DataStoreView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.notes) { note in
                Text(note.title)
                    .onTapGesture {
                        viewModel.selectedNote = note
                    }
            }
            .navigationTitle("Notes DataStore")
            .navigationBarItems(
                trailing: Button(action: viewModel.createNote) { Image(systemName: "plus") }
            )
            .alert(item: $viewModel.selectedNote) { note in
                Alert(title: Text(note.title), message: Text(note.description))
            }
        }
    }
}

extension DataStoreView {
    class ViewModel: ObservableObject {
        @Published var notes: [Note] = []
        @Published var selectedNote: Note?
        
        init() {
            getNotes()
            observeNotes()
        }
        
        var token: AnyCancellable?
        func observeNotes() {
            token = Amplify.DataStore.publisher(for: Note.self)
                .filter { $0.mutationType == "create" }
                .tryMap { try $0.decodeModel(as: Note.self) }
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { print($0) },
                    receiveValue: { [weak self] note in
                        if self?.notes.contains(where: {$0.id == note.id}) == false {
                            self?.notes.insert(note, at: 0)
                        }
                    }
                )
        }
        
        func getNotes() {
            Amplify.DataStore.query(Note.self) { [weak self] result in
                DispatchQueue.main.async {
                    self?.notes = try! result.get()
                }
            }
        }
        
        func createNote() {
            let newNote = Note(title: "DataStore - \(UUID().uuidString)", description: UUID().uuidString)
            Amplify.DataStore.save(newNote) { result in
                print("Saved: \(try! result.get())")
            }
        }
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataStoreView()
    }
}
