//
//  PersistenceManager.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/7/22.
//

import Foundation

// написать менеджер сохранения и удаления новостей в закладки

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    static let userDefaults = UserDefaults.standard

    enum Keys {
        static let bookmarks = "bookmarks"
    }

    static func updateWith(bookmark: Article, actionType: PersistenceActionType, completed: @escaping (NErrors?) -> Void) {
        retrieveBookmarks { result in

            switch result {
            case .success(let bookmarks):
                var retrievedBookmarks = bookmarks

                switch actionType {
                case .add:
                    guard !retrievedBookmarks.contains(bookmark) else {
                        completed(.alreadyInBookmarks)
                        return
                    }
                    
                    retrievedBookmarks.append(bookmark)
                case .remove:
                    retrievedBookmarks.removeAll { $0.title == bookmark.title }
                }

                completed(save(bookmarks: retrievedBookmarks))
            case .failure(let error):
                completed(error)
            }
        }
    }

    static func retrieveBookmarks(completed: @escaping (Result<[Article], NErrors>) -> Void) {
        guard let bookmarksData = userDefaults.object(forKey: Keys.bookmarks) as? Data else {
            completed(.success([]))
            return
        }

        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode([Article].self, from: bookmarksData)
            completed(.success(user))
        } catch {
            completed(.failure(.unableToBookmarks))
        }
    }

    static func save(bookmarks: [Article]) -> NErrors? {
        do {
            let encoder = JSONEncoder()
            let encodedBookmarks = try encoder.encode(bookmarks)
            userDefaults.set(encodedBookmarks, forKey: Keys.bookmarks)
            return nil
        } catch {
            return .unableToBookmarks
        }
    }
}
