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
    
    init(eventName: String? = "", eventDate: Date = Date(), eventResult: String? = "") {
        self.eventName = eventName
        self.eventDate = eventDate
        self.eventResult = eventResult
    }
}
