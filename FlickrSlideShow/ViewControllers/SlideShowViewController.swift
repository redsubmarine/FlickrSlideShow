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

final class SlideShowViewController: UIViewController {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!

    var viewModel: SlideShowViewModel!
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.getMorePhotos()

        viewModel.currentImage
            .bind(onNext: display)
            .disposed(by: disposeBag)

        viewModel.playButtonTitle
            .bind(onNext: setPlayButtonTitle)
            .disposed(by: disposeBag)

        playButton.rx.tap
            .withLatestFrom(viewModel.pause, resultSelector: { ($0, $1) })
            .map({ $0.1 })
            .do(onNext: viewModel.buttonsHidden)
            .map({ _ in })
            .bind(onNext: viewModel.pauseToggle)
            .disposed(by: disposeBag)

        viewModel.isHiddenButtons
            .bind(onNext: isHiddenAllButtons)
            .disposed(by: disposeBag)

        setupGesture()
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)

        tapGesture.rx.event.asObservable()
            .withLatestFrom(viewModel.isHiddenButtons, resultSelector: { ($0, $1) })
            .filter({ $0.0.state == .recognized })
            .map({ !$0.1 })
            .bind(onNext: viewModel.buttonsHidden)
            .disposed(by: disposeBag)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func isHiddenAllButtons(_ isHidden: Bool) {
        playButton.isHidden = isHidden
        settingButton.isHidden = isHidden
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
