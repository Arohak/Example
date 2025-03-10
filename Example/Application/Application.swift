//
//  ExampleApp.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import SwiftUI
import SwiftData

@main
struct Application: App {
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [Story.self, Post.self, Item.self], inMemory: false) { result in
            switch result {
            case .success:
                print("Successfully created model container")
            case .failure(let error):
                print("Failed to create model container: \(error)")
                handleDatabaseError()
            }
        }
    }
    
    private func handleDatabaseError() {
        // Try to recover by deleting the database file
        do {
            let fileManager = FileManager.default
            let appSupportURL = try fileManager.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            
            let storeURL = appSupportURL.appendingPathComponent("default.store")
            if fileManager.fileExists(atPath: storeURL.path) {
                try fileManager.removeItem(at: storeURL)
                print("Deleted corrupted database file")
            }
            
            // Also try to delete the -shm and -wal files
            let shmURL = appSupportURL.appendingPathComponent("default.store-shm")
            if fileManager.fileExists(atPath: shmURL.path) {
                try fileManager.removeItem(at: shmURL)
            }
            
            let walURL = appSupportURL.appendingPathComponent("default.store-wal")
            if fileManager.fileExists(atPath: walURL.path) {
                try fileManager.removeItem(at: walURL)
            }
        } catch {
            print("Failed to delete database file: \(error)")
        }
    }
}
