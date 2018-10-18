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

struct SlideShowViewModel: CanChangeInterval {
    private var _photos = BehaviorRelay<[FlickrImageProtocol]>(value: [])
    var photos: Observable<[FlickrImageProtocol]>

    var currentImage: Observable<FlickrImageProtocol?>
    private var _interval: BehaviorRelay<TimeInterval>
    var interval: Observable<TimeInterval>
    var intervalText: Observable<String>
    private var _pause = BehaviorRelay(value: true)
    var pause: Observable<Bool>
    var playButtonTitle: Observable<String>
    private var server: Server

    private var _needFetchData = BehaviorRelay(value: false)
    var needFetchData: Observable<Bool>

    private var _isHiddenButtons = BehaviorRelay(value: false)
    var isHiddenButtons: Observable<Bool>

    init(server: Server) {
        self.server = server
        photos = _photos.asObservable()
        needFetchData = _needFetchData.asObservable()
            .distinctUntilChanged()
        pause = _pause.asObservable().distinctUntilChanged()

        playButtonTitle = pause
            .map({ $0 ? R.Main.String.play : R.Main.String.stop })
            .map({ $0.description })

        let interval = BehaviorRelay<Double>(value: (Persist.shared.value(for: .slideTime) as? Double) ?? 3)
        _interval = interval
        self.interval = interval.asObservable().distinctUntilChanged()
            .do(onNext: {
                Persist.shared.set(value: $0, for: .slideTime)
            })
        self.intervalText = interval.map({ Int($0) })
            .map({ R.Setting.String.second(sec: $0).description })

        let intervalObservable = pause
            .flatMapLatest({ pause -> Observable<Int> in
                if pause {
                    return Observable.empty()
                } else {
                    return interval.asObservable()
                        .flatMapLatest({ Observable<Int>.interval($0, scheduler: MainScheduler.instance) })
                        .startWith(0)
                }
            })

        isHiddenButtons = _isHiddenButtons.asObservable()

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
    }

    func buttonsHidden(_ hidden: Bool) {
        _isHiddenButtons.accept(hidden)
    }

    func popFirstPhoto() {
        var photos = _photos.value
        let url = photos.remove(at: 0).url
        let request = URLRequest(url: url)

        if UIImageView.af_sharedImageDownloader.imageCache?.removeImage(for: request, withIdentifier: nil) == true {
            print(" remove cache \(url)")
        }

        _photos.accept(photos)
    }

}
