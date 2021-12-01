//
//  AgeGateVC.swift
//  MedMen
//
//  Created by Jan Zimandl on 22.11.2021.
//

import UIKit

class AgeGateVC: UIViewController {

    @IBOutlet private weak var logoImageV: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var overAgeButton: UIButton!
    @IBOutlet private weak var underAgeButton: UIButton!
    @IBOutlet private weak var footerLabel: InteractiveLinkLabel!

    var viewModel: AgeGateMV!

    static func instantiateFromStoryboard(viewModel: AgeGateMV) -> AgeGateVC {
        // swiftlint:disable:next force_unwrapping
        let vc = R.storyboard.ageGate.instantiateInitialViewController()!
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupUI() {
        underAgeButton.layer.borderColor = UIColor.white.cgColor
        underAgeButton.layer.borderWidth = 1

        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle

        overAgeButton.setTitle(viewModel.overAgeTitle, for: .normal)
        overAgeButton.isHidden = viewModel.overAgeTitle == nil
        underAgeButton.setTitle(viewModel.underAgeTitle, for: .normal)
        underAgeButton.isHidden = viewModel.underAgeTitle == nil

        footerLabel.attributedText = viewModel.footerNote
        footerLabel.isHidden = viewModel.footerNote == nil
    }

    @IBAction private func overAgeTapped(_ sender: AnyObject) {
        viewModel.overAgeAction?()
        self.dismiss(animated: true)
    }

    @IBAction private func underAgeTapped(_ sender: AnyObject) {
        viewModel.underAgeAction?()
        self.dismiss(animated: true)
    }

}
