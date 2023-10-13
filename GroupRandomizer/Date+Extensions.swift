//
//  Date+Extensions.swift
//  GroupRandomizer
//
//  Created by Stepan Baranov on 11.10.2023.
//

import Foundation

private let dateTimeDefaultFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.YY hh:mm"
    return dateFormatter
}()

extension Date {
    var dateTimeString: String { dateTimeDefaultFormatter.string(from: self) }
}
