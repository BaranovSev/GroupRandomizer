//
//  GroupModel.swift
//  GroupRandomizer
//
//  Created by Stepan Baranov on 04.10.2023.
//

import Foundation

struct Group: Codable {
    var groupName: String
    var groupTask: String?
    var students: [Student]
    var events: [Event]?
    
    init(groupName: String, groupInfo: String? = nil, students: [Student]) {
        self.groupName = groupName
        self.groupTask = groupInfo
        self.students = students
    }
}
