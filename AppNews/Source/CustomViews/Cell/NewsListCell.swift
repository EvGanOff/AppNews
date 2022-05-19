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

    let networkDelegat: NetworkManagerProtocol? = NetworkManager()

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
        //newsImageView.downloadImages(fromURL: article.urlToImage ?? Images.placeholderUrlImage)
        newsTitleLabel.text = article.title
        networkDelegat?.downloadImage(from: article.urlToImage ?? Images.placeholderUrlImage, completion: {[weak self] images in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.newsImageView.image = images
            }
        })
    }

    private func configure() {
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            newsImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Matrics.padding),
            newsImageView.heightAnchor.constraint(equalToConstant: Matrics.heightAnchor),
            newsImageView.widthAnchor.constraint(equalToConstant: Matrics.newsImageViewWidthAnchor),

            newsTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            newsTitleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: Matrics.padding),
            newsTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Matrics.padding),
            newsTitleLabel.heightAnchor.constraint(equalToConstant: Matrics.heightAnchor)
        ])
    }

    private struct Matrics {
        static let padding: CGFloat = 12
        static let heightAnchor: CGFloat = 100
        static let newsImageViewWidthAnchor: CGFloat = 170
    }
}
