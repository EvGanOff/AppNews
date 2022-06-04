//
//  BookmarksCell.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/9/22.
//

import UIKit

class BookmarksCell: UITableViewCell {

    static let reuseID = "BookmarksCell"
    let titleLabel = NTitleLabel(textAligment: .left, fontSize: 18)
    let iconImage = NImageView(frame: .zero)
    var networkDelegate: NetworkManagerProtocol? = NetworkManager()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(bookmark: Article) {
        titleLabel.text = bookmark.title

        Task {
            iconImage.image = try await networkDelegate?.downloadImage(from: bookmark.urlToImage ?? Images.placeholderUrlImage)
        }
    }

    private func configure() {
        addSubview(titleLabel)
        addSubview(iconImage)

        accessoryType = .disclosureIndicator
        let padding: CGFloat = 8

        NSLayoutConstraint.activate([
            iconImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            iconImage.heightAnchor.constraint(equalToConstant: 50),
            iconImage.widthAnchor.constraint(equalToConstant: 50),

            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
