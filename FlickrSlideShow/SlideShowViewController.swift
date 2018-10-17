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
    @IBOutlet weak var playButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.getMorePhotos()

        viewModel.currentImage
            .bind(onNext: display)
            .disposed(by: disposeBag)

        viewModel.needFetchData
            .filter({ $0 == true })
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.getMorePhotos()
            })
            .disposed(by: disposeBag)

        viewModel.pause
            .map({ $0 ? "Play" : "Stop" })
            .bind(onNext: setPlayButtonTitle)
            .disposed(by: disposeBag)

        playButton.rx.tap
            .bind(onNext: viewModel.pauseToggle)
            .disposed(by: disposeBag)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func setPlayButtonTitle(_ title: String) {
        playButton.setTitle(title, for: .normal)
    }

    private func display(next image: FlickrImageProtocol?) {
        guard let url = image?.url else {
            return
        }

        let cache = UIImageView.af_sharedImageDownloader.imageCache
        let request = URLRequest(url: url)

        let image = cache?.image(for: request, withIdentifier: url.absoluteString)

        let dissolve = CABasicAnimation(keyPath: "contents")
        dissolve.duration = 0.65
        dissolve.fromValue = photoView.image
        dissolve.toValue = image

        self.photoView.layer.add(dissolve, forKey: "animateDissolve")
        self.photoView.image = image

        viewModel.popFirstPhoto()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SettingViewController.segueIdentifier,
            let navigationController = segue.destination as? UINavigationController,
            let settingViewController = navigationController.topViewController as? SettingViewController {
            settingViewController.viewModel = viewModel
        }
    }
}
