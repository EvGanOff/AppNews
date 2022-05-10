//
//  NTabBarController.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/6/22.
//

import UIKit

class NTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemPink
        viewControllers = [createNewsListNC(), createBookmarcsNC()]
    }

    func createNewsListNC() -> UINavigationController {
        let newsListNavigationController = NewsListViewContriller()
        newsListNavigationController.title = "Новости"
        newsListNavigationController.tabBarItem = UITabBarItem(title: "Новости", image: UIImage(systemName: "magazine"), tag: 0)

        return UINavigationController(rootViewController: newsListNavigationController)
    }

    func createBookmarcsNC() -> UINavigationController {
        let bookmarksNavigationController = NBookmarksViewController()
        bookmarksNavigationController.title = "Закладки"
        bookmarksNavigationController.tabBarItem = UITabBarItem(title: "Закладки", image: UIImage(systemName: "bookmark"), tag: 1)

        return UINavigationController(rootViewController: bookmarksNavigationController)
    }
    
}
