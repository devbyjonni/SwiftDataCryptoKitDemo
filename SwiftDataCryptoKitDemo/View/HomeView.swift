//
//  HomeView.swift
//  SwiftDataCryptoKitDemo
//
//  Created by Jonni Akesson on 2024-09-09.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [.init(\Transaction.transactionDate, order: .reverse)], animation: .snappy)
    private var transactions: [Transaction]
    @State private var showAlertTF = false
    @State private var keyTF = ""
    @State private var exportItem: TransactionTransferable?
    @State private var showFileExporter = false
    @State private var showFileImporter = false
    @State private var importedURL: URL?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(transactions) { transaction in
                    Text(transaction.transactionName)
                }
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem {
                    Button(action: { showAlertTF.toggle() }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                ToolbarItem {
                    Button(action: { showFileImporter.toggle() }) {
                        Image(systemName: "square.and.arrow.down")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        let transaction = Transaction(transactionName: "Dummy Transaction", transactionDate: .now, transactionAmount: 1000.0, transactionCategory: .expense)
                        modelContext.insert(transaction)
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
        }
        .alert("Enter Key", isPresented: $showAlertTF) {
            TextField("Key", text: $keyTF)
                .autocorrectionDisabled()
            
            Button("Cancel", role: .cancel) {
                keyTF = ""
                importedURL = nil
            }
            
            Button(importedURL != nil ? "Import" : "Export") {
                if importedURL != nil {
                    importData()
                } else {
                    exportData()
                }
            }
        }
        .fileExporter(isPresented: $showFileExporter, item: exportItem, contentTypes: [.data], defaultFilename: "Transactions") { result in
            handleFileExport(result: result)
        }
        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.data]) { result in
            handleFileImport(result: result)
        }
    }
    
    // MARK: - Export Data
    private func exportData() {
        Task.detached(priority: .background) {
            do {
                // Fetch transactions from the DataManager
                let allTransactions = try DataManager.shared.fetchTransactions()
                
                // Create TransactionTransferable with the transactions and provided key
                let exportItem = TransactionTransferable(transactions: allTransactions, key: keyTF)
                
                // Update the UI on the main thread after export preparation
                await MainActor.run {
                    self.exportItem = exportItem
                    showFileExporter = true // Show file exporter UI
                    keyTF = "" // Clear the key input field
                }
            } catch {
                print("Export failed: \(error.localizedDescription)")
                await MainActor.run {
                    keyTF = "" // Reset the key input field
                }
            }
        }
    }
    
    // MARK: - Import Data
    private func importData() {
        guard let url = importedURL else { return }
        
        Task.detached(priority: .background) {
            do {
                // Check if the URL allows accessing security-scoped resources (for sandboxed environments)
                guard url.startAccessingSecurityScopedResource() else { return }
                
                // Import transactions using DataManager
                let allTransactions = try DataManager.shared.importTransactions(from: url, withKey: keyTF)
                
                // Insert each transaction into the model context
                for transaction in allTransactions {
                    modelContext.insert(transaction)
                }
                
                // Save the updated context
                try modelContext.save()
                url.stopAccessingSecurityScopedResource() // Stop accessing the resource after import
                
                // Clear the key input field
                await MainActor.run {
                    keyTF = ""
                }
            } catch {
                print("Import failed: \(error.localizedDescription)")
                await MainActor.run {
                    keyTF = "" // Reset the key input field
                }
            }
        }
    }
    
    // MARK: - Handle File Export Result
    private func handleFileExport(result: Result<URL, Error>) {
        switch result {
        case .success(_):
            print("Success")
        case .failure(let error):
            print("Failure: \(error.localizedDescription)")
        }
        exportItem = nil
    }
    
    // MARK: - Handle File Import Result
    private func handleFileImport(result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            importedURL = url
            showAlertTF.toggle()
        case .failure(let error):
            print("Failure: \(error.localizedDescription)")
        }
    }
}
