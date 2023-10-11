//
//  GroupModel.swift
//  GroupRandomizer
//
//  Created by Stepan Baranov on 04.10.2023.
//

import Foundation

class Group: Codable {
    var groupName: String
    var groupTask: String?
    var students: [Student]
    var events: [Event]
    
    init(groupName: String, groupInfo: String? = nil, students: [Student], events: [Event] = []) {
        self.groupName = groupName
        self.groupTask = groupInfo
        self.students = students
        self.events = events
    }
    
    func addEvent(_ event: Event) {
        events.append(event)
    }
}
