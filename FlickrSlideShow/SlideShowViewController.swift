//
//  SlideShowViewController.swift
//  FlickrSlideShow
//
//  Created by 양원석 on 12/10/2018.
//  Copyright © 2018 red. All rights reserved.
//

import UIKit

class SlideShowViewController: UIViewController {

    @IBOutlet weak var photoView: UIImageView!

    var viewModel: SlideShowViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        photoView.image = viewModel.currentImage
    }

    @IBAction func nextTapped(_ sender: Any) {

        let currentImage = viewModel.currentImage
        viewModel.next()
        let nextImage = viewModel.currentImage

        let dissolve = CABasicAnimation(keyPath: "contents")
        dissolve.duration = 1.0
        dissolve.fromValue = currentImage.cgImage
        dissolve.toValue = nextImage.cgImage

        photoView.layer.add(dissolve, forKey: "animateDissolve")
        photoView.image = nextImage
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
