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

        cachingImages(photos.map({ $0.url }))
    }

    func cachingImages(_ urls: [URL]) {

        let cache = UIImageView.af_sharedImageDownloader.imageCache
        DispatchQueue.global(qos: .background).async {
            urls.forEach({ url in
                let request = URLRequest(url: url)
                URLSession.shared.dataTask(with: request, completionHandler: { data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        cache?.add(image, for: request, withIdentifier: url.absoluteString)
                    }
                }).resume()
            })
        }
    }

}
