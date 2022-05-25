//
//  Operations.swift
//  ConcurrencyProgram
//
//  Created by Marin Novitchi on 01.05.2022.
//

import Foundation

enum Operation: String, CaseIterable {
    case classicURLSession
    case combineURLSession
    case asyncURLSession
    case quickerAsyncURLSession
    case asyncBridge
    case asyncProperty
}
