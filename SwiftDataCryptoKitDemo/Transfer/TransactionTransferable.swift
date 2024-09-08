//
//  TransactionTransferable.swift
//  SwiftDataCryptoKitDemo
//
//  Created by Jonni Akesson on 2024-09-09.
//

import Foundation
import CryptoKit
import SwiftUI

///// A struct representing transferable transaction data, including encryption logic
struct TransactionTransferable: Transferable {
    var transactions: [Transaction]
    var key: String
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .data) {
            let data = try JSONEncoder().encode($0.transactions)
            guard let encryptedData = try AES.GCM.seal(data, using: .key($0.key)).combined else {
                throw EncryptionError.encryptionFailed
            }
            
            return encryptedData
        }
    }
    
    enum EncryptionError: Error {
        case encryptionFailed
    }
}
