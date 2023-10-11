//
//  Storage.swift
//  GroupRandomizer
//
//  Created by Stepan Baranov on 29.09.2023.
//

import Foundation

final class Storage {
    static let shared = Storage()
    private let userDefaults = UserDefaults.standard
    
    // only one group in project
    private enum Keys: String {
        case allGroups
    }
    private var allGroups: [Group]? {
        get {
            guard let data = userDefaults.data(forKey: Keys.allGroups.rawValue),
                  let record = try? JSONDecoder().decode([Group]?.self, from: data) else {
//                let data = try? JSONEncoder().encode(allGroupsOne)
//                userDefaults.set(data, forKey: Keys.allGroups.rawValue)
                return nil
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                return
            }
            
            userDefaults.set(data, forKey: Keys.allGroups.rawValue)
        }
    }
    
//    private let allGroupsOne: [Group] = [
//        Group(
//            groupName: "Group #1",
//            students:[
//            Student(name: "Dariel"),
//            Student(name: "Alex"),
//            Student(name: "Bardot"),
//            Student(name: "Caulin")
//            ]),
//        Group(
//            groupName: "Group #2",
//            students:[
//            Student(name: "Denis"),
//            Student(name: "Anatolii"),
//            Student(name: "Fedor"),
//            Student(name: "German")
//            ])
//    ]
    
    func getAllGroups() -> [Group] {
        return allGroups ?? []
    }
    
    func saveData(_ data: [Group]?) {
        self.allGroups = data
    }
}

    
