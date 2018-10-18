//
//  SlideShowViewModelTests.swift
//  FlickrSlideShowTests
//
//  Created by 양원석 on 18/10/2018.
//  Copyright © 2018 red. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import FlickrSlideShow

class SlideShowViewModelTests: XCTestCase {

    var viewModel: SlideShowViewModel!
    
    override func setUp() {
        let mockServer = MockFlickrServer()
        viewModel = SlideShowViewModel(server: mockServer)
    }

    override func tearDown() {
    }
    
    func test_current_image_is_nil_when_not_call_get_api() {
        // ViewModel이 만들어진 직후 currentImage 는 비어있음.
        let current = try! viewModel.currentImage.map({ $0!.url })
            .take(1, scheduler: MainScheduler.instance)
            .toBlocking().first()
        XCTAssertNil(current)
    }

    func test_current_image_is_not_nil_when_after_call_get_api() {
        // 이미지 요청 후, 슬라이드 쇼 시작하면 currentImage에 유효한 이미지 url이 들어와야함.
        viewModel.getMorePhotos()
        viewModel.pauseToggle()

        let current = try! viewModel.currentImage
            .map({ $0!.url })
            .take(1, scheduler: MainScheduler.instance)
            .toBlocking().first()
        
        XCTAssertNotNil(current)
    }
    
    func test_current_image_is_not_equal_to_first_value_when_pop_first_photo() {
        // 이미지 요청 후, 슬라이드 쇼에서 첫사진을 pop 하면 currentImage 에 반영되어야 함.
        viewModel.getMorePhotos()
        viewModel.pauseToggle()
        
        let first = try! viewModel.currentImage
            .map({ $0!.url })
            .take(1, scheduler: MainScheduler.instance)
            .toBlocking().first()
        
        viewModel.popFirstPhoto()
        
        let second = try! viewModel.currentImage
            .map({ $0!.url })
            .take(1, scheduler: MainScheduler.instance)
            .toBlocking().first()
        
        XCTAssertNotNil(first)
        XCTAssertNotNil(second)
        XCTAssertNotEqual(first!, second!)
    }
    
    func test_call_get_api_after_private_photos_count_is_3() {
        // popFirstPhoto 를 계속해서 호출하면 내부적으로 3개이미지가 남았을때 다음 사진들을 가져오는 api를 호출해야 함.
        /*
          Test trick
         현재 갖고 있는 이미지가 몇개인지는 viewModel 내부적으로 알수 있지만,
         외부에서는 알수 없다. 여기서는 MockFlickrServer 가 get API가 호출해야 6번째 뒤에 이미지가 반드시 존재한다는 논리적인 가정으로 테스트를 작성했다.
         */
        viewModel.getMorePhotos()
        viewModel.pauseToggle()
        
        viewModel.popFirstPhoto()
        viewModel.popFirstPhoto()
        viewModel.popFirstPhoto()
        viewModel.popFirstPhoto()
        viewModel.popFirstPhoto()
        viewModel.popFirstPhoto()
        
        let second = try! viewModel.currentImage
            .map({ $0!.url })
            .take(1, scheduler: MainScheduler.instance)
            .toBlocking().first()
        
        XCTAssertNotNil(second)
        XCTAssertEqual("https://farm2.staticflickr.com/1914/31456112188_a912f38b26_m.jpg", second!.absoluteString)
    }
}
