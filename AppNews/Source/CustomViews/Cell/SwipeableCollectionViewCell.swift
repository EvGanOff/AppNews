//
//  SwipeableCollectionViewCell.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/12/22.
//

import Foundation

import UIKit

protocol SwipeableCollectionViewCellDelegate: AnyObject {
    func visibleContainerViewTapped(inCell cell: UICollectionViewCell)
    func hiddenContainerViewTapped(inCell cell: UICollectionViewCell)
}

class SwipeableCollectionViewCell: UICollectionViewCell {

    // MARK: Properties

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private let conteinerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear

        return view
    }()

    // первый контейнер
    let visibleContainerView = UIView()
    // второй контейнер
    let hiddenContainerView = UIView()

    var swipeableDelegate: SwipeableCollectionViewCellDelegate?

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupGestureRecognizer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(visibleContainerView)
        stackView.addArrangedSubview(hiddenContainerView)

        addSubview(conteinerView)
        conteinerView.addSubview(scrollView)

        NSLayoutConstraint.activate([
            conteinerView.topAnchor.constraint(equalTo: topAnchor, constant: 90),
            conteinerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            conteinerView.heightAnchor.constraint(equalTo: heightAnchor),
            conteinerView.widthAnchor.constraint(equalTo: widthAnchor)
        ])

        scrollView.pinToEdges(of: conteinerView)
        scrollView.backgroundColor = .clear
        scrollView.addSubview(stackView)
        stackView.pinEdgesToSuperView()

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 2)
        ])

    }

    // настройка свайпа
    private func setupGestureRecognizer() {
        let hiddenContainerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hiddenContainerViewTapped))
        hiddenContainerView.addGestureRecognizer(hiddenContainerTapGestureRecognizer)

        let visibleContainerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(visibleContainerViewTapped))
        visibleContainerView.addGestureRecognizer(visibleContainerTapGestureRecognizer)

    }

    @objc private func visibleContainerViewTapped() {
        swipeableDelegate?.visibleContainerViewTapped(inCell: self)
    }

    @objc private func hiddenContainerViewTapped() {
        swipeableDelegate?.hiddenContainerViewTapped(inCell: self)

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x = scrollView.frame.width
        }
    }
}
