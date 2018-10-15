//
//  PublicPhotosRequest.swift
//  FlickrSlideShow
//
//  Created by 양원석 on 15/10/2018.
//  Copyright © 2018 red. All rights reserved.
//

import RxCocoa
import Alamofire
import Gloss

class PublicPhotosRequest: FlickrRequest {
    typealias ResponseType = PhotosResponse

    var method: HTTPMethod = .get

    var url: String = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"

    let response: BehaviorRelay<PhotosResponse?> = BehaviorRelay(value: nil)

    func params() -> JSON? {
        return nil
    }

    func process(result: PhotosResponse) {
        print("urls \(result.photos.map({ $0.url }))")
        self.response.accept(result)
    }
}
