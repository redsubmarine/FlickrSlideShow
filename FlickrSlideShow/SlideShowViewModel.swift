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
    private var _interval: BehaviorRelay<TimeInterval>
    private var _pause = BehaviorRelay(value: true)
    var pause: Observable<Bool>
    private var server: Server

    private var _needFetchData = BehaviorRelay(value: false)
    var needFetchData: Observable<Bool>

    init(server: Server) {
        self.server = server
        photos = _photos.asObservable()
        needFetchData = _needFetchData.asObservable()
            .distinctUntilChanged()
        pause = _pause.asObservable().distinctUntilChanged()
        let interval = BehaviorRelay<Double>(value: 1)
        _interval = interval

        let intervalObservable = pause
            .flatMapLatest({ pause -> Observable<Int> in
                if pause {
                    return Observable.empty()
                } else {
                    return interval.asObservable()
                        .flatMapLatest({ Observable<Int>.interval($0, scheduler: MainScheduler.instance) })
                }
            })

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
        self._interval.accept(interval)
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

    func pauseToggle() {
        _pause.accept(!_pause.value)
        print(" _pause.value: \(_pause.value)")
    }

    func popFirstPhoto() {
        var photos = _photos.value
        photos.remove(at: 0)
        _photos.accept(photos)
    }

}
