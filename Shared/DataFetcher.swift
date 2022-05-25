//
//  DataFetcher.swift
//  ConcurrencyProgram
//
//  Created by Marin Novitchi on 01.05.2022.
//

import Combine
import Foundation

class DataFetcher {
    
    /// Fetches the data using the classic URLSession.
    /// - Parameters:
    ///   - givenURL: The URL where the data can be fetched.
    ///   - completion: Completion closure to be executed that receives the fetched data.
    func fetchData<T>(from givenURL: URL, completion: @escaping (T?) -> Void) where T: Decodable {
        DispatchQueue.global(qos: .default).async {
            URLSession.shared.dataTask(with: givenURL) { data, response, error in
                if let data = data {
                    if let decodedOrigin = try? JSONDecoder().decode(T.self, from: data) {
                        DispatchQueue.main.async {
                            completion(decodedOrigin)
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }.resume()
        }
    }
    
    /// Fetches the data using the Combine.
    /// - Returns: The newly fetched data.
    func updateData<T>(from givenURL: URL) -> AnyPublisher<T, AppErrors> where T: Decodable {
        URLSession.shared.dataTaskPublisher(for: givenURL)
            .mapError{ _ in AppErrors.networkIssue }
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError{ _ in AppErrors.decodingError }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    @available(iOS 15.0, *)
    /// Fetches the data using the async URLSession.
    /// - Parameter givenURL: The URL where the data can be fetched.
    /// - Returns: The newly fetched data.
    func fetchData<T>(from givenURL: URL) async throws -> T where T: Decodable {

        let (data, _) = try await URLSession.shared.data(from: givenURL)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    /// Bridges the completion closure to async await.
    ///
    ///  Check the documentation for `withCheckedContinuation`, `withUnsafeContinuation`, `withCheckedThrowingContinuation` and `withUnsafeThrowingContinuation`.
    ///
    /// - Parameter givenURL: The URL where the data can be fetched.
    /// - Returns: The newly fetched data.
    func fetchDataOverBridge<T>(from givenURL: URL) async throws -> T where T: Decodable {
        try await withCheckedThrowingContinuation { continuation in
            fetchData(from: givenURL) { (fetchedData: T?) in
                if let fetchedData = fetchedData {
                    continuation.resume(returning: fetchedData)
                } else {
                    continuation.resume(throwing: AppErrors.networkIssue)
                }
            }
        }
    }
    
    /// Fetches the data. Depending on the iOS version it either calls the async fetch method or the bridge over the classic one.
    /// - Parameter givenURL: The URL where the data can be fetched.
    /// - Returns: The newly fetched data.
    func fetch<T>(from givenURL: URL) async throws -> T? where T: Decodable {
        if #available(iOS 15.0, *) {
            return try await fetchData(from: givenURL)
        } else {
            return try await fetchDataOverBridge(from: givenURL)
        }
    }
}
