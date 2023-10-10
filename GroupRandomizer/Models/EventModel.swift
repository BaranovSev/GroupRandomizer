//
//  EventModel.swift
//  GroupRandomizer
//
//  Created by Stepan Baranov on 10.10.2023.
//

import Foundation

class Event: Codable {
    var eventName: String?
    var eventDate: Date
    var eventResult: String?
    
    init(eventName: String? = "EmptyEventName", eventDate: Date, eventResult: String? = "") {
        self.eventName = eventName
        self.eventDate = Date()
        self.eventResult = eventResult
    }
}
