//
//  SlideShowViewModel.swift
//  FlickrSlideShow
//
//  Created by 양원석 on 12/10/2018.
//  Copyright © 2018 red. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

struct SlideShowViewModel {
    private var _photos = BehaviorRelay<[FlickrImageProtocol]>(value: [])
    var photos: Observable<[FlickrImageProtocol]>

    var currentImage: Observable<FlickrImageProtocol?>
    private var interval: BehaviorRelay<TimeInterval> = BehaviorRelay(value: 1)
    private var server: Server

    private var _needFetchData = BehaviorRelay(value: false)
    var needFetchData: Observable<Bool>

    init(server: Server) {
        self.server = server
        photos = _photos.asObservable()
        needFetchData = _needFetchData.asObservable()
            .distinctUntilChanged()

        let intervalObservable = self.interval.asObservable()
            .flatMapLatest({ Observable<Int>.interval($0, scheduler: MainScheduler.instance) })

        currentImage = intervalObservable.withLatestFrom(photos)
            .map({ photos in
                if photos.count > 0 {
                    return photos[0]
                } else {
                    return nil
                }
            })

        _ = photos.asObservable()
            .map({ $0.count == 3 })
            .bind(to: _needFetchData)

    }

    func changeInterval(_ interval: Double) {
        self.interval.accept(interval)
    }

    mutating func getMorePhotos() {
        let getPublicPhotos = PublicPhotosRequest()
        let currentPhotos = _photos.value
        _ = server.request(getPublicPhotos)
            .retry(3)
            .map({ response in
                return currentPhotos + (response?.photos ?? [])
            })
            .bind(to: _photos)
    }

    func popFirstPhoto() {
        var photos = _photos.value
        photos.remove(at: 0)
        _photos.accept(photos)
    }

}
