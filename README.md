# SwiftDataCryptoKitDemo

SwiftDataCryptoKitDemo is an iOS app that demonstrates how to manage, export, and import encrypted transaction data using **SwiftUI**, **SwiftData**, and **CryptoKit**. The app allows users to add transactions, securely export transaction data, and import encrypted transaction data from files.

## Features

- **Add Transactions**: Add a transaction with a name, date, amount, and category (Income/Expense).
- **View Transactions**: Display a list of transactions sorted by the most recent date.
- **Export Transactions**: Export all transactions to a file in encrypted form using AES-GCM encryption.
- **Import Transactions**: Import transactions from an encrypted file and automatically insert them into the app's database.
- **Secure Encryption**: Data is encrypted and decrypted using a user-provided key for enhanced security.

## Technologies Used

- **SwiftUI**: For building the user interface.
- **SwiftData**: To manage transactions in a local database.
- **CryptoKit**: For encrypting and decrypting transaction data using AES-GCM.
- **File Handling**: Exporting and importing files using `fileExporter` and `fileImporter`.

## Project Structure

The project is organized into several files and folders for maintainability and clarity:

### 1. **Views**
   - `HomeView.swift`: The main interface for users, providing functionality to view, add, export, and import transactions.

### 2. **Models**
   - `Transaction.swift`: Contains the `Transaction` class, representing each transaction with a name, date, amount, and category.
   - `TransactionCategory.swift`: Enum to define whether a transaction is an **Income** or an **Expense**.

### 3. **Transfer**
   - `TransactionTransferable.swift`: Handles logic for exporting transaction data in an encrypted form, using `AES-GCM` encryption via CryptoKit.

### 4. **Data Management**
   - `DataManager.swift`: A singleton responsible for managing core data operations, including fetching, importing, and saving transaction data to the database.

### 5. **Utilities**
   - `SymmetricKey+Extensions.swift`: Extension that provides helper functions for generating AES encryption keys from user-provided input, utilizing SHA-256 hashing for key generation.

## How It Works

### Exporting Transactions
Transactions can be securely exported using the `fileExporter`. The transactions are serialized, encrypted using AES-GCM with a key provided by the user, and saved to a file that can be exported.

### Importing Transactions
Users can import transactions from an encrypted file via the `fileImporter`. The app decrypts the file using the same AES-GCM encryption key and inserts the transactions into the app's database.
