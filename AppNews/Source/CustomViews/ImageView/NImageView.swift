//
//  NImageView.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/6/22.
//

import UIKit

class NImageView: UIImageView {
    let placeholderImage = Images.placeholderImage
    let cache = NetworkManager.shared.cache

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Преднастойка картинки
    private func configure() {
        layer.cornerRadius = 5
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        image = placeholderImage
    }

    func downloadImages(fromURL url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] images in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.image = images
            }
        }
    }
}
