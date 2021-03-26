//
//  dependency_migrationApp.swift
//  dependency-migration
//
//  Created by Lee, Kyle on 3/25/21.
//

import Amplify
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
import AWSAPIPlugin
import AWSS3StoragePlugin
import AWSPinpointAnalyticsPlugin
import SwiftUI

@main
struct dependency_migrationApp: App {
    
    init() {
        configureAmplify()
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                AuthView().tabItem { Text("Auth") }
                DataStoreView().tabItem { Text("DataStore") }
                APIView().tabItem { Text("API") }
                StorageView().tabItem { Text("Storage") }
                AnalyticsView().tabItem { Text("Analytics") }
            }
        }
    }
    
    func configureAmplify() {
        let models = AmplifyModels()
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: models))
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: models))
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.add(plugin: AWSPinpointAnalyticsPlugin())
            
            try Amplify.configure()
            
            print("Configured Amplify")
        } catch {
            print("Failed to configure Amplify")
        }
    }
}
