//
//  StorageView.swift
//  dependency-migration
//
//  Created by Lee, Kyle on 3/25/21.
//

import Amplify
import SwiftUI

struct StorageView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.status)
            
            viewModel.imageData.flatMap { Image(uiImage: UIImage(data: $0)!).resizable() }
            
            Button("Upload", action: viewModel.uploadImage)
            Button("Download", action: viewModel.getImage)
            Button("Delete", action: viewModel.deleteImage)
        }
    }
}

extension StorageView {
    class ViewModel: ObservableObject {
        @Published var status = ""
        @Published var imageData: Data?
        
        let key = "amplify-logo.jpg"
        
        var imageUrl: URL {
            Bundle.main.url(forResource: "aws-amplify-logo-large", withExtension: "png")!
        }
        
        func getImage() {
            Amplify.Storage.downloadData(key: key) { [weak self] result in
                DispatchQueue.main.async {
                    let data = try? result.get()
                    self?.status = data == nil ? "Couldnt download" : "Downloaded \(self?.key ?? "")"
                    data.flatMap { self?.imageData = $0 }
                }
            }
        }
        
        func uploadImage() {
            Amplify.Storage.uploadFile(key: key, local: imageUrl) { [weak self] result in
                DispatchQueue.main.async {
                    self?.status = "Uploaded \(try! result.get())"
                }
            }
        }
        
        func deleteImage() {
            Amplify.Storage.remove(key: key) { [weak self] result in
                DispatchQueue.main.async {
                    self?.status = "Deleted \((try? result.get()) ?? "nothing")"
                    self?.imageData = nil
                }
            }
        }
    }
}

struct StorageView_Previews: PreviewProvider {
    static var previews: some View {
        StorageView()
    }
}
