//
//  SlideShowViewModel.swift
//  FlickrSlideShow
//
//  Created by 양원석 on 12/10/2018.
//  Copyright © 2018 red. All rights reserved.
//

import UIKit

struct SlideShowViewModel {
    var photos: [UIImage]
    var currentIndex: Int = 0

    init() {
        photos = [
            UIImage(named: "30331203967_7720cb9c89_m")!,
            UIImage(named: "30331205227_c07c0e139a_m")!,
            UIImage(named: "30331205497_c93c763c59_m")!,
            UIImage(named: "30331205857_2df4c2c643_m")!,
            UIImage(named: "30331208127_263fcdae5a_m")!
        ]
    }

    var currentImage: UIImage {
        return photos[currentIndex]
    }

    mutating func next() {
        currentIndex = currentIndex == photos.count - 1 ? 0 : currentIndex + 1
    }
}
