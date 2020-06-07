//
//  Country.swift
//  App
//
//  Created by Andreas Lüdemann on 07/06/2020.
//

import Foundation
import Vapor
import FluentSQLite

struct Country: SQLiteModel {
    var id: Int?
    var name: String
}

/// Allows `Country` to be used as a dynamic migration.
extension Country: Migration { }

/// Allows `Country` to be encoded to and decoded from HTTP messages.
extension Country: Content { }

/// Allows `Country` to be used as a dynamic parameter in route definitions.
extension Country: Parameter { }
