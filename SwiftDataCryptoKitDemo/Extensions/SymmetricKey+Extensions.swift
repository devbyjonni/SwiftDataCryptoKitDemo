//
//  SymmetricKey+Extensions.swift
//  SwiftDataCryptoKitDemo
//
//  Created by Jonni Akesson on 2024-09-09.
//

import Foundation
import CryptoKit

extension SymmetricKey {
    /// Helper method to generate a SymmetricKey from a string
    static func key(_ value: String) -> SymmetricKey {
        let keyData = value.data(using: .utf8)!
        let sha256 = SHA256.hash(data: keyData)
        return .init(data: sha256)
    }
}
