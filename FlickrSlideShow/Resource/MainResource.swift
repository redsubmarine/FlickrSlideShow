//
//  MainResource.swift
//  FlickrSlideShow
//
//  Created by 양원석 on 18/10/2018.
//  Copyright © 2018 red. All rights reserved.
//

import Foundation

extension R.Main {
    enum String: CustomStringConvertible {
        case play
        case stop
        var description: Swift.String {
            switch self {
            case .play:
                return "Play".localized
            case .stop:
                return "Stop".localized
            }
        }
    }
}
