//
//  SettingViewController.swift
//  FlickrSlideShow
//
//  Created by 양원석 on 12/10/2018.
//  Copyright © 2018 red. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingViewController: UITableViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!

    var disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        timeSlider.isContinuous = false

        timeSlider.rx.controlEvent(.valueChanged)
            .bind(onNext: reloadTimeLabel)
            .disposed(by: disposeBag)
    }

    func reloadTimeLabel() {
        let time = Int(timeSlider.value)

        timeLabel.text = "\(time) sec"
    }

    @IBAction func doneTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
}
