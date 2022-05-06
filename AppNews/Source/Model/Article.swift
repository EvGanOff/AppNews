//
//  Article.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/6/22.
//

import Foundation

struct Article: Codable, Hashable {
    var author: String?
    var title: String
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}
