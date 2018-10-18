//
//  Server.swift
//  FlickrSlideShow
//
//  Created by 양원석 on 15/10/2018.
//  Copyright © 2018 red. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import Gloss

class Server: FlickrServer {
    let session = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
    private let httpDispatchQueue = DispatchQueue(label: "flickr_http_queue")

    func getPublicPhotos() -> Observable<[FlickrImageProtocol]> {
        let getPublicPhotos = PublicPhotosRequest()
        return request(getPublicPhotos)
            .retry(3)
            .map({ $0?.photos ?? [] })
    }

    private func request<T: FlickrRequest>(_ request: T) -> Observable<T.ResponseType?> {
        guard let url = URL(string: request.url) else {
            fatalError()
        }
        return Observable.create({ observer in
            self.session.request(url,
                            method: request.method,
                            parameters: request.params(),
                            encoding: JSONEncoding.default,
                            headers: nil)
                .responseJSON(queue: self.httpDispatchQueue) { response in
                    switch response.result {
                    case .success(let json):
                        if let json = json as? JSON {
                            let result = T.ResponseType(json: json)
                            request.response.accept(result)
                            if let result = result {
                                request.process(result: result)
                                observer.on(.next(result))
                            }
                        }
                    case .failure(let error):
                        observer.on(.error(error))
                    }
            }
            return Disposables.create()
        }).observeOn(MainScheduler.instance)
    }

}

protocol FlickrRequest {
    associatedtype ResponseType: FlickrResponse
    var method: HTTPMethod { get set  }
    var url: String { get }

    var response: BehaviorRelay<ResponseType?> { get }

    func params() -> JSON?
    func process(result: ResponseType)
}

protocol FlickrResponse: JSONDecodable {
}

protocol FlickrServer {
    func getPublicPhotos() -> Observable<[FlickrImageProtocol]>
}

protocol FlickrImageProtocol {
    var url: URL { get }
}
