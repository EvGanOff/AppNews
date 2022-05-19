//
//  NEmptyStateView.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/10/22.
//

import UIKit

class NEmptyStateView: UIView {

    let messageLabel = NTitleLabel(textAligment: .center, fontSize: 28)
    let logoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }

    private func configure() {
        addSubview(messageLabel)
        addSubview(logoImageView)
        configureMessageLabel()
        configureLogoImageView()
    }

    private func configureMessageLabel() {
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel

        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func configureLogoImageView() {
        logoImageView.image = UIImage(systemName: "bookmark", withConfiguration: UIImage.SymbolConfiguration(hierarchicalColor: .systemGray5))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100),
            logoImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
