//
//  NewsBookmarksCollectionVC.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/10/22.
//

import UIKit

class NewsBookmarksCollectionVC: NLoadingDataViewConroller {

    enum Section {
        case main
    }

    var bookmarks: [Bookmark] = []
    var collectionView: UICollectionView!
    var collectionDataSource: UICollectionViewDiffableDataSource<Section, Bookmark>!

    weak var swiipeCollectionDelegate: SwipeableCollectionViewCellDelegate?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBookmarks()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        configureCollectionView()
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: ResizebleLayout())
        collectionView.register(NewsBookmarksCell.self, forCellWithReuseIdentifier: NewsBookmarksCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.decelerationRate = .fast
        let backgroundView = NEmptyStateView(frame: .zero)
        collectionView.backgroundView = backgroundView
        view.addSubview(collectionView)
    }
    

    private func getBookmarks() {
        PersistenceManager.retrieveBookmarks { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let bookmarks):
                self.updateUI(with: bookmarks)
            case .failure(let error):
                self.presentsNAlertController(title: "Упс", massage: error.rawValue, buttonTitle: "Ок")
            }
        }
    }

    private func updateUI(with bookmarks: [Bookmark]) {
        if bookmarks.isEmpty {
            self.showEmptyStateView(with: "Упс", in: self.view)
        } else {
            self.bookmarks = bookmarks
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.view.bringSubviewToFront(self.collectionView)
            }
        }
    }
}

extension NewsBookmarksCollectionVC: UICollectionViewDelegate {
// реализовать переход на Safari

}

extension NewsBookmarksCollectionVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarks.count
    }

    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Bookmark>()
        snapshot.appendSections([.main])
        snapshot.appendItems(bookmarks)
        DispatchQueue.main.async {
            self.collectionDataSource.apply(snapshot, animatingDifferences: true)

        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsBookmarksCell.reuseIdentifier, for: indexPath) as? NewsBookmarksCell else {
            return UICollectionViewCell()
        }
        
        let bookmark = bookmarks[indexPath.row]
        cell.swipeableDelegate = self
        cell.set(bookmark: bookmark)

        return cell
    }
}

extension NewsBookmarksCollectionVC: SwipeableCollectionViewCellDelegate {

    func hiddenContainerViewTapped(inCell cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        PersistenceManager.updateWith(bookmark: bookmarks[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.bookmarks.remove(at: indexPath.row)

                return
            }
            self.presentsNAlertController(title: "Не можем удалить закладку", massage: error.rawValue, buttonTitle: "Ок")
        }
        
        collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [indexPath])
        })
    }

    func visibleContainerViewTapped(inCell cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        print("Tapped item at index path: \(indexPath)")
    }
}
