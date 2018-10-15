//
//  FlickrImage.swift
//  FlickrSlideShow
//
//  Created by 양원석 on 15/10/2018.
//  Copyright © 2018 red. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import Gloss

struct FlickrImage: JSONDecodable, FlickrImageProtocol {
    var url: URL

    init?(json: JSON) {
        guard let url: URL = "media.m" <~~ json else {
            print(" no media.m \(json)")
            return nil
        }
        self.url = url
        DispatchQueue.main.async {
            let imageView = UIImageView()
            imageView.af_setImage(withURL: url)
        }
    }
}
