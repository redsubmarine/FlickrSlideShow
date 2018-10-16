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

protocol CanChangeInterval {
    func changeInterval(_ interval: Double)
    var interval: Observable<TimeInterval> { get }
}

class SettingViewController: UITableViewController {

    static let segueIdentifier = "fromSlideToSettings"

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!

    var viewModel: CanChangeInterval!

    var disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        timeSlider.rx.value.asObservable().skip(1)
            .map({ Double($0 )})
            .bind(onNext: viewModel.changeInterval)
            .disposed(by: disposeBag)

        viewModel.interval
            .map({ Float($0) })
            .bind(to: timeSlider.rx.value)
            .disposed(by: disposeBag)

        viewModel.interval
            .map({ "\(Int($0)) 초" })
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
    }

    deinit {
        print(" setting deinited")
    }

    @IBAction func doneTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
}
