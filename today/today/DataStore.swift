//
//  DataStore.swift
//  day
//
//  Created by Tony Dinh on 2016-11-04.
//  Copyright © 2016 Tony Dinh. All rights reserved.
//

import Foundation

class DataStore {
    let storage: UserDefaults

    init() {
        storage = UserDefaults.standard
    }

    func set(value: Any?, key: String) {
        storage.set(value, forKey: key)
    }

    func get(key: String) -> Any? {
        return storage.value(forKey: key)
    }

    func synchronize() {
        storage.synchronize()
    }
}
