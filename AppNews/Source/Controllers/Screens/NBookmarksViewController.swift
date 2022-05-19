//
//  NBookmarksViewController.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/6/22.
//

import UIKit

class NBookmarksViewController: NLoadingDataViewConroller {

    // MARK: - Properties -

    let tableView = UITableView()
    var bookmarks: [Article] = []

    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBookmarks()
    }

    // MARK: - Private methods -

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Закладки"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureTableView() {
        view.addSubview(tableView)

        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BookmarksCell.self, forCellReuseIdentifier: BookmarksCell.reuseID)
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
            self.showEmptyStateView(with: "", in: self.view)
        } else {
            self.bookmarks = bookmarks
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
}

// MARK: - UITableViewDataSource -

extension NBookmarksViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookmarksCell.reuseID) as? BookmarksCell else {
            let cell = BookmarksCell(style: .default, reuseIdentifier: BookmarksCell.reuseID)
            return cell
        }
        let bookmark = bookmarks[indexPath.row]
        cell.setupCell(bookmark: bookmark)
        return cell
    }
}

// MARK: - UITableViewDelegate -

extension NBookmarksViewController: UITableViewDelegate {

    // При нажатии на ячейку отображается SafariViewController.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = bookmarks[indexPath.row]
        guard let url = URL(string: article.url ?? "Что то пошло не так") else { return }
        presenSafariVC(from: url)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        PersistenceManager.updateWith(bookmark: bookmarks[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.bookmarks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                return
            }
            self.presentsNAlertControllerOnMainTread(title: "Не можем удалить закладку", massage: error.rawValue, buttonTitle: "Ок")
        }

        if bookmarks.isEmpty {
            showEmptyStateView(with: "", in: self.view)
        }
    }
}
