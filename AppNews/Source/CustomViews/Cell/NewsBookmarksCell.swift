//
//  NewsBookmarksCell.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/10/22.
//

import UIKit

class NewsBookmarksCell: SwipeableCollectionViewCell {

    static let reuseIdentifier = "NewsBookmarksCell"

    var backgroundImageView = NImageView(frame: .zero)
    var shadowView = NShadowView(frame: .zero)
    var titleLabel = NTitleLabel(textAligment: .center, fontSize: 18)

    var networkDelegate: NetworkManagerProtocol? = NetworkManager()

    private lazy var deleteImageView: UIImageView = {
        let image = UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemBackground
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    func set(bookmark: Article) {
        titleLabel.text = bookmark.title
        Task {
            backgroundImageView.image = try await networkDelegate?.downloadImage(from: bookmark.urlToImage ?? Images.secondPlaceholderImage)
        }
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let  dragOffset = UIHelper.featuredHeight - UIHelper.standardHeight

        let delta = 1 - (UIHelper.featuredHeight - frame.height) / dragOffset

        let maxAlpha: CGFloat = 0.7
        let minAlpha: CGFloat = 0.1

        let scale = max(delta, 0.5)

        titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        shadowView.alpha = maxAlpha - delta * (maxAlpha - minAlpha)
    }

    func configureContainers() {
        visibleContainerView.backgroundColor = .clear
        visibleContainerView.addSubview(backgroundImageView)

        hiddenContainerView.backgroundColor = UIColor(red: 231.0 / 255.0, green: 76.0 / 255.0, blue: 60.0 / 255.0, alpha: 1)
        hiddenContainerView.layer.borderColor = UIColor.black.cgColor
        hiddenContainerView.layer.borderWidth = 1
        hiddenContainerView.layer.cornerRadius = 10
        hiddenContainerView.addSubview(deleteImageView)
    }

    func configureUIElements() {
        backgroundImageView.pinEdgesToSuperView()
        backgroundImageView.addSubview(shadowView)
        shadowView.pinToEdges(of: backgroundImageView)
        backgroundImageView.addSubview(titleLabel)
        backgroundImageView.layer.cornerRadius = 10
    }

    private func configure() {
        configureContainers()
        configureUIElements()

        let padding: CGFloat = 32

        NSLayoutConstraint.activate([
            deleteImageView.centerXAnchor.constraint(equalTo: hiddenContainerView.centerXAnchor),
            deleteImageView.centerYAnchor.constraint(equalTo: hiddenContainerView.centerYAnchor),
            deleteImageView.leadingAnchor.constraint(equalTo: hiddenContainerView.leadingAnchor, constant: padding),
            deleteImageView.trailingAnchor.constraint(equalTo: hiddenContainerView.trailingAnchor, constant: -padding),

            titleLabel.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -padding)
        ])
    }
}
