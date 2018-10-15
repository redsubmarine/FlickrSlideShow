//
//  SlideShowViewController.swift
//  FlickrSlideShow
//
//  Created by 양원석 on 12/10/2018.
//  Copyright © 2018 red. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import AlamofireImage

class SlideShowViewController: UIViewController {

    @IBOutlet weak var photoView: UIImageView!

    var viewModel: SlideShowViewModel!
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.currentImage
            .bind(onNext: display)
            .disposed(by: disposeBag)

        viewModel.needFetchData
            .filter({ $0 == true })
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.getMorePhotos()
            })
            .disposed(by: disposeBag)

        viewModel.getMorePhotos()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    func display(next image: FlickrImageProtocol?) {
        guard let url = image?.url else {
            return
        }
        let tempImageView = UIImageView()
        tempImageView.af_setImage(withURL: url)

        let dissolve = CABasicAnimation(keyPath: "contents")
        dissolve.duration = 0.65
        dissolve.fromValue = photoView.image
        dissolve.toValue = tempImageView.image

        self.photoView.layer.add(dissolve, forKey: "animateDissolve")
        self.photoView.image = tempImageView.image

        viewModel.popFirstPhoto()
    }
}
