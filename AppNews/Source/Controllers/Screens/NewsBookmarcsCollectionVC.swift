//
//  NewsBookmarcsCollectionVC.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/10/22.
//

import UIKit

class NewsBookmarcsCollectionVC: NLoadingDataViewConroller {

    enum Section {
        case main
    }

    var bookmarks: [Article] = []
    var collectionView: UICollectionView!
    var collectionDataSource: UICollectionViewDiffableDataSource<Section, Article>!

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
        configereCollectionView()

//        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) [0]
//        print(documentDirectory)
    }

    private func configereCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: ResizebleLayout())
        collectionView.register(NewsBookmarksCell.self, forCellWithReuseIdentifier: NewsBookmarksCell.reuseIdentifier)
        //collectionView.delegate = self
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
                self.presentsNAlertControllerOnMainTread(title: "Упс", massage: error.rawValue, buttonTitle: "Ок")
            }
        }
    }

    private func updateUI(with bookmarks: [Article]) {
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

extension NewsBookmarcsCollectionVC: UICollectionViewDelegate {


}

extension NewsBookmarcsCollectionVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarks.count
    }

    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Article>()
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
        cell.delegate = self
        cell.set(bookmark: bookmark)

        return cell
    }
}

extension NewsBookmarcsCollectionVC: SwipeableCollectionViewCellDelegate {

    func hiddenContainerViewTapped(inCell cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        PersistenceManager.updateWith(bookmark: bookmarks[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.bookmarks.remove(at: indexPath.row)

                return
            }
            self.presentsNAlertControllerOnMainTread(title: "Не можем удалить закладку", massage: error.rawValue, buttonTitle: "Ок")
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
