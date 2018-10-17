//
//  Persist.swift
//  FlickrSlideShow
//
//  Created by 양원석 on 17/10/2018.
//  Copyright © 2018 red. All rights reserved.
//

import Foundation

class Persist {
    enum Key: String {
        case slideTime
    }

    static let shared = Persist()

    private init() { }

    func set(value: Any?, for key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }

    func value(for key: Key) -> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }

}
