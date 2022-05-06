//
//  NAlertViewController.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/6/22.
//

import UIKit

class NAlertViewController: UIViewController {
    let containerView = NAlertConteinerView()
    let titleLabel = NTitleLabel(textAligment: .center, fontSize: 26)
    let massageLabel = NBodyLabel(textAligment: .center)
    let actionButton = NButton(backgraundColor: .systemPink, title: "OK")



    var alertTitle: String?
    var massege: String?
    var buttonTitle: String?

    init(title: String, massage: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.massege = massage
        self.buttonTitle = buttonTitle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        setupHierarchy()
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureMassageLabel()

    }

    private func setupHierarchy() {
        let views = [containerView, titleLabel, massageLabel, actionButton]
        views.forEach { views in
            view.addSubview(views)
        }
    }

    func configureContainerView() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: Metrics.containerViewWidthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: Metrics.containerViewHeightAnchor)
        ])
    }

    func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Error"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Metrics.titleLabelPadding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metrics.titleLabelPadding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Metrics.titleLabelPadding),
            titleLabel.heightAnchor.constraint(equalToConstant: Metrics.titleLabelHeightAnchor)
        ])
    }

    func configureActionButton() {
        containerView.addSubview(actionButton)
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor , constant: -Metrics.actionButtonPadding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metrics.actionButtonPadding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Metrics.actionButtonPadding),
            actionButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

    func configureMassageLabel() {
        containerView.addSubview(massageLabel)
        massageLabel.text = massege ?? "Eror"
        massageLabel.numberOfLines = 4
        massageLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            massageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            massageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metrics.massageLabelPadding),
            massageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Metrics.massageLabelPadding),
            massageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }


    @objc func dismissVC() {
        dismiss(animated: true)
    }

    private struct Metrics {
        static let containerViewWidthAnchor: CGFloat = 300
        static let containerViewHeightAnchor: CGFloat = 220
        static let titleLabelPadding: CGFloat = 20
        static let actionButtonPadding: CGFloat = 20
        static let massageLabelPadding: CGFloat = 20
        static let titleLabelHeightAnchor: CGFloat = 30
    }
}
