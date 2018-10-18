//
//  MockFlickrServer.swift
//  FlickrSlideShowTests
//
//  Created by 양원석 on 18/10/2018.
//  Copyright © 2018 red. All rights reserved.
//

import Foundation
import RxSwift
import Gloss

@testable import FlickrSlideShow

class MockFlickrServer: FlickrServer {
    
    static var index = 0
    
    // 호출할때마다, 새로운 이미지를 리턴하는 flickr API 흉내.
    func getPublicPhotos() -> Observable<[FlickrImageProtocol]> {
        let index = MockFlickrServer.index
        defer {
            MockFlickrServer.index = (index + 1) % 3
        }
        return .just(MockFlickrServer.DataJSON[index].compactMap(FlickrImage.init))
    }
    
    static let DataJSON: [[JSON]] =
        [[
            ["media": ["m": "https://farm2.staticflickr.com/1945/30390495177_d4b60b95df_m.jpg"]],
            ["media": ["m": "https://farm2.staticflickr.com/1961/31456110398_8006ab7321_m.jpg"]],
            ["media": ["m": "https://farm2.staticflickr.com/1947/31456110968_febc2ca3c2_m.jpg"]],
            ["media": ["m": "https://farm2.staticflickr.com/1904/31456111538_7532d33a52_m.jpg"]],
            ["media": ["m": "https://farm2.staticflickr.com/1955/31456112008_4d390147e6_m.jpg"]],
            ["media": ["m": "https://farm2.staticflickr.com/1978/31456112028_8c089b3a9f_m.jpg"]]
            ],
         [
            ["media": ["m": "https://farm2.staticflickr.com/1914/31456112188_a912f38b26_m.jpg"]],
            ["media": ["m": "https://farm2.staticflickr.com/1943/43514761060_f0ca345770_m.jpg"]],
            ["media": ["m": "https://farm2.staticflickr.com/1967/43514761340_e96e6cd52e_m.jpg"]],
            ["media": ["m": "https://farm2.staticflickr.com/1962/44417434135_2a04cfbe21_m.jpg"]],
            ["media": ["m": "https://farm2.staticflickr.com/1973/44417434295_38834fa21b_m.jpg"]]
            ],
         [
            ["media": ["m": "https://farm2.staticflickr.com/1913/44607185514_7c09578c9c_m.jpg"]],
            ["media": ["m": "https://farm2.staticflickr.com/1921/44607185934_2c389d536e_m.jpg"]],
            ["media": ["m": "https://farm2.staticflickr.com/1916/45280729002_02a978d5a1_m.jpg"]],
            ["media": ["m": "https://farm2.staticflickr.com/1933/45280730502_31c6c40af0_m.jpg"]],
            ["media": ["m": "https://farm2.staticflickr.com/1965/45280730962_d9f82e0be7_m.jpg"]]
            ]]


}

