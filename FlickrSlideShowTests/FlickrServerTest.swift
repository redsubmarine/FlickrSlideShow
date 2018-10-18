//
//  FlickrServerTest.swift
//  FlickrSlideShowTests
//
//  Created by 양원석 on 18/10/2018.
//  Copyright © 2018 red. All rights reserved.
//

import XCTest
import RxBlocking
@testable import FlickrSlideShow

class FlickrServerTest: XCTestCase {

    var server: FlickrServer!
    
    override func setUp() {
        server = MockFlickrServer()
    }

    override func tearDown() {
        
    }
    
    func test_get_data_not_empty() {
        let photos = try! server.getPublicPhotos().toBlocking().first()!
        XCTAssertTrue(photos.count > 0 )
    }

}
