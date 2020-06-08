//
//  Infection.swift
//  App
//
//  Created by Andreas Lüdemann on 07/06/2020.
//

import Foundation
import Vapor
import FluentSQLite

struct Infection: SQLiteModel {
    var id: Int?
    var count: Int
    var countryCode: Int
}

/// Allows `Country` to be used as a dynamic migration.
extension Infection: Migration { }

/// Allows `Country` to be encoded to and decoded from HTTP messages.
extension Infection: Content { }

/// Allows `Country` to be used as a dynamic parameter in route definitions.
extension Infection: Parameter { }
