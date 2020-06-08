//
//  Country.swift
//  App
//
//  Created by Andreas Lüdemann on 07/06/2020.
//

import Foundation
import Vapor
import FluentSQLite

struct Country {
    var id: Int?
    var name: String
    
    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

extension Country: SQLiteModel { }
extension Country: Migration { }
extension Country: Parameter { }
