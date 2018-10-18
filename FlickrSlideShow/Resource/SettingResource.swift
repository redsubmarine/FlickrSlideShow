//
//  SettingResource.swift
//  FlickrSlideShow
//
//  Created by 양원석 on 18/10/2018.
//  Copyright © 2018 red. All rights reserved.
//

import Foundation

extension R.Setting {
    enum String: CustomStringConvertible {
        case durationTime
        case second(sec: Int)
        var description: Swift.String {
            switch self {
            case .durationTime:
                return "DurationTime".localized
            case let .second(sec):
                return Swift.String(format: NSLocalizedString("%d second", comment: "\(sec) second"), sec)
            }
        }
    }
}
