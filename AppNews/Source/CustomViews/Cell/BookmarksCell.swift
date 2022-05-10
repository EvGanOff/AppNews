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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(bookmark: Article) {
        titleLabel.text = bookmark.title
    }

    private func configure() {
        addSubview(titleLabel)

        accessoryType = .disclosureIndicator
        let padding: CGFloat = 8

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
