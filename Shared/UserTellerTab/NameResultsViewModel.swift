//
//  NameResultsViewModel.swift
//  ConcurrencyProgram
//
//  Created by Marin Novitchi on 01.05.2022.
//

import Combine
import Foundation


extension NameResultsView {
    @MainActor class ViewModel: ObservableObject {
        
        @Published var operation: Operation
        @Published var origin = NameOrigin(name: "", country: [])
        @Published var gender = NameGender(name: "", gender: "", probability: 0, count: 0)
        
        init(name: String, operation: Operation) {
            print("LOG: NameResultsView init")
            self.name = name
            self.operation = operation
            update(using: operation)
        }

        private let name: String
        private let fetcher = DataFetcher()
        
        private var nameOriginURL: URL {
            URL(string: "https://api.nationalize.io/?name=\(name)")!
        }
        private var nameGenderURL: URL {
            URL(string: "https://api.genderize.io/?name=\(name)")!
        }
        
        private func update(using operation: Operation) {
            switch operation {
            case .classicURLSession:
                updateData()
            case .combineURLSession:
                updateDataWithCombine()
            case .asyncURLSession:
                Task {
                    await updateData()
                }
            case .quickerAsyncURLSession:
                Task {
                    await updateDataQuicker()
                }
            case .asyncBridge:
                Task(priority: .high) {
                    await updateDataOverBridge()
                }
            case .asyncProperty:
                Task {
                    await updateDataViaAsyncProperty()
                }
            }
        }
        
        func updateData() {
            fetcher.fetchData(from: nameOriginURL) { [weak self] (nameOrigin: NameOrigin?) in
                if let nameOrigin = nameOrigin {
                    self?.origin = nameOrigin
                }
            }
            fetcher.fetchData(from: nameGenderURL) { [weak self] (nameGender: NameGender?) in
                if let nameGender = nameGender {
                    self?.gender = nameGender
                }
            }
        }
        
        @Published var requests = Set<AnyCancellable>()
        
        func updateDataWithCombine() {
            let firstFetch: AnyPublisher<NameOrigin, AppErrors> = fetcher.updateData(from: nameOriginURL)
            let secondFetch: AnyPublisher<NameGender, AppErrors> = fetcher.updateData(from: nameGenderURL)
            Publishers.Zip(firstFetch, secondFetch)
                .sink{ completion in
                    switch completion {
                    case .failure(let fetchError):
                        print(fetchError.localizedDescription)
                    default: break
                    }
                } receiveValue: {
                    self.origin = $0.0
                    self.gender = $0.1
                }
                .store(in: &requests)
        }
        
        @available(iOS 15.0, *)
        func updateData() async {
            do {
                origin = try await fetcher.fetchData(from: nameOriginURL)
                gender = try await fetcher.fetchData(from: nameGenderURL)
            } catch (let fetchError) {
                print(fetchError.localizedDescription)
            }
        }
        
        
        @available(iOS 15.0, *)
        func updateDataQuicker() async {
            async let (originData, _) = URLSession.shared.data(from: nameOriginURL)
            async let (genderData, _) = URLSession.shared.data(from: nameGenderURL)
            do {
                let decoder = JSONDecoder()
                origin = try await decoder.decode(NameOrigin.self, from: originData)
                gender = try await decoder.decode(NameGender.self, from: genderData)

            } catch (let fetchError) {
                print(fetchError.localizedDescription)
            }
        }
        
        func updateDataOverBridge() async {
            do {
                origin = try await fetcher.fetchDataOverBridge(from: nameOriginURL)
                gender = try await fetcher.fetchDataOverBridge(from: nameGenderURL)
            } catch (let fetchError) {
                print(fetchError.localizedDescription)
            }
        }
        
        @available(iOS 15.0, *)
        private var nameOriginFetcher: NameOrigin {
            get async throws {
                let (data, _) = try await URLSession.shared.data(from: nameOriginURL)
                return try JSONDecoder().decode(NameOrigin.self, from: data)
            }
            //cannot have a set
        }
        
        @available(iOS 15.0, *)
        func updateDataViaAsyncProperty() async {
            do {
                origin = try await nameOriginFetcher
            } catch (let fetchError) {
                print(fetchError.localizedDescription)
            }
        }
    }
}
