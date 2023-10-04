//
//  StudentModel.swift
//  GroupRandomizer
//
//  Created by Stepan Baranov on 29.09.2023.
//

import Foundation

struct Student: Codable {
    var name: String
    var marks: String?
    
    init(name: String, marks: String? = nil) {
        self.name = name
        self.marks = marks
    }
}
