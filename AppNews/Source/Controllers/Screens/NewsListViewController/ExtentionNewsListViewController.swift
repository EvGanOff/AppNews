//
//  ExtentionNewsListViewController.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 6/10/22.
//

import UIKit

extension NewsListViewController: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        // Постраничная загрузка.
        if offsetY > contentHeight - height {
            guard hasMoreArticles, !isPaging else { return }
            page += 1
            isPaging = true
            getArticles(page: page)
        }
    }

    // написать метод выбора ячейки и загрузки в сафари
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let article = articles[indexPath.row]
        let destVC = ArticleInfoVC(article: article)
        let navigationController = UINavigationController(rootViewController: destVC)
        present(navigationController, animated: true)
    }
}

extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListCell.identifier) as? NewsListCell else {
            let cell = NewsListCell(style: .default, reuseIdentifier: NewsListCell.identifier)
            return cell
        }

        let article = articles[indexPath.row]
        cell.setupCell(article: article)
        return cell
    }
}
