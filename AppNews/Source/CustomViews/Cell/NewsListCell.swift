//
//  NewsListCell.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/6/22.
//

import UIKit

class NewsListCell: UITableViewCell {
    static let identifier = "NewsListCell"

    let newsImageView = NImageView(frame: .zero)
    let newsTitleLabel = NTitleLabel(textAligment: .left, fontSize: 16)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHierarchy() {
        addSubview(newsImageView)
        addSubview(newsTitleLabel)
    }

    func setupCell(article: Article) {
        newsImageView.downloadImages(fromURL: article.urlToImage ?? Images.placeholderUrlImage)
        newsTitleLabel.text = article.title
    }

    private func configure() {
        accessoryType = .disclosureIndicator
        let padding: CGFloat = 12
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            newsImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            newsImageView.heightAnchor.constraint(equalToConstant: 100),
            newsImageView.widthAnchor.constraint(equalToConstant: 140),

            newsTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            newsTitleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 24),
            newsTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            newsTitleLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
