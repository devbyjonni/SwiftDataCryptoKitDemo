//
//  DataManager.swift
//  SwiftDataCryptoKitDemo
//
//  Created by Jonni Akesson on 2024-09-09.
//

import Foundation
import SwiftData
import CryptoKit

class DataManager {
    
    static let shared = DataManager() // Singleton instance
    
    private init() {} // Private initializer to prevent instantiation
    
    // Fetch all transactions from the database, sorted by date (most recent first)
    func fetchTransactions() throws -> [Transaction] {
        let container = try ModelContainer(for: Transaction.self) // Create model container for Transaction
        let context = ModelContext(container) // Create context to interact with model container
        let descriptor = FetchDescriptor(sortBy: [
            .init(\Transaction.transactionDate, order: .reverse) // Sort by transactionDate in descending order
        ])
        return try context.fetch(descriptor) // Fetch the transactions using the descriptor
    }
    
    // Import transactions from an encrypted file
    func importTransactions(from url: URL, withKey key: String) throws -> [Transaction] {
        let encryptedData = try Data(contentsOf: url) // Load encrypted data from file
        let decryptedData = try AES.GCM.open(.init(combined: encryptedData), using: .key(key)) // Decrypt the data using the provided key
        return try JSONDecoder().decode([Transaction].self, from: decryptedData) // Decode the decrypted data into Transaction array
    }
}

