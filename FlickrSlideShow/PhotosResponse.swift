//
//  PhotosResponse.swift
//  FlickrSlideShow
//
//  Created by 양원석 on 15/10/2018.
//  Copyright © 2018 red. All rights reserved.
//

import Foundation
import Gloss

class PhotosResponse: FlickrResponse {

    var photos: [FlickrImageProtocol]

    required init?(json: JSON) {
        guard let photos: [FlickrImage] = "items" <~~ json else {
            return nil
        }
        self.photos = photos
    }

}
