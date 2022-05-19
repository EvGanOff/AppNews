//
//  ArticleInfoVC.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/8/22.
//

import UIKit
import SafariServices

class ArticleInfoVC: NLoadingDataViewConroller {

    let scrollView = UIScrollView()
    let contentView = UIView()
    let labelsStackView = UIStackView()

    var imageView = NImageView(frame: .zero)
    let titleLabel = NTitleLabel(textAligment: .left, fontSize: 24)
    let descriptionLabel = NTitleLabel(textAligment: .left, fontSize: 18)
    let authorLabel = NBodyLabel(textAligment: .left)
    let dateLabel = NBodyLabel(textAligment: .left)
    let actionButton = NButton(backgraundColor: .systemPink, title: "Источник")
    var article: Article?
    let networkDelegate: NetworkManagerProtocol? = NetworkManager()

    init(article: Article) {
        super.init(nibName: nil, bundle: nil)
        self.article = article
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureScrollView()
        configureLayout()
        configureUI()
        configureStackView()
    }

    // MARK: - Private methods -
    private func configureViewController() {
        view.backgroundColor = .systemBackground

        let doneButton = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(dismssVC))
        navigationItem.rightBarButtonItem = doneButton
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.leftBarButtonItem = addButton
    }

    @objc private func dismssVC() {
        dismiss(animated: true)
    }

    @objc private func addButtonTapped() {
        showLoadingView()

        networkDelegate?.getArticleInfo { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()

            switch result {
            case .success(let bookmark):
                self.addArticleToBookmarks(bookmark: bookmark)

            case .failure(let error):
                self.presentsNAlertControllerOnMainTread(title: "Что-то пошло не так", massage: error.rawValue, buttonTitle: "Ок")
            }
        }
    }

    private func addArticleToBookmarks(bookmark: [Article]) {
        guard let article = article else { return }

        let bookmark = Article(title: article.title, url: article.url)

        PersistenceManager.updateWith(bookmark: bookmark, actionType: .add) { [weak self] error in
            guard let self = self else { return }

            guard let error = error else {
                self.presentsNAlertControllerOnMainTread(title: "Добавлено", massage: "Вы добавили эту новость в закладки.", buttonTitle: "Ок")
                return
            }
            self.presentsNAlertControllerOnMainTread(title: "Упс!", massage: error.rawValue, buttonTitle: "Ок")
        }
    }

    private func configureUI() {
        guard let article = article else { return }
        networkDelegate?.downloadImage(from: article.urlToImage ?? Images.placeholderUrlImage, completion: { [weak self] images in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.imageView.image = images
            }
        })

        titleLabel.text = article.title
        descriptionLabel.text = article.description ?? Descriptions.articleDescription
        authorLabel.text = article.author ?? Descriptions.articleAuthor
        dateLabel.text = (article.publishedAt?.convertToDisplayFormat() ?? "N/A")
        actionButton.addTarget(self, action: #selector(sourceButtonTapped), for: .touchUpInside)
    }

    @objc private func sourceButtonTapped() {
        guard let article = article else { return }
        guard let url = URL(string: article.url ?? "что то пошло не так") else { return }
        presenSafariVC(from: url)
        actionButton.transformButton()
    }

    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 700)
        ])
    }

    private func configureLabelStackView() {
        labelsStackView.axis = .vertical
        labelsStackView.layer.cornerRadius = 5
        labelsStackView.distribution = .equalCentering
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false

        let views = [titleLabel, descriptionLabel, authorLabel, dateLabel]
        views.forEach { views in
            labelsStackView.addSubview(views)
        }
    }

    private func configureLayout() {
        let views = [imageView, labelsStackView, actionButton]
        views.forEach { views in
            contentView.addSubview(views)
        }

        let padding: CGFloat = 8

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalToConstant: 250),

            labelsStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            labelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            labelsStackView.heightAnchor.constraint(equalToConstant: 320),

            actionButton.topAnchor.constraint(equalTo: labelsStackView.bottomAnchor, constant: 20),
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func configureStackView() {
        configureLabelStackView()

        let padding: CGFloat = 20

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: labelsStackView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: padding),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: padding),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
}
