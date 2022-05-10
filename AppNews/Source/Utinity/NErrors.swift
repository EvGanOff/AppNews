//
//  NErrors.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/6/22.
//

import Foundation

enum NErrors: String, Error {
    case unableToComplete = "Не удается обработать ваш запрос. Пожалуйста, проверьте ваше интернет-соединение."
    case invalidResponce = "Ошибка соединения. Пожалуйста, попробуйте еще раз."
    case invalidData = "Данные, полученные с сервера, недействительны. Пожалуйста, попробуйте еще раз."

    case unableToBookmarks = "Ошибка при добавлении в закладки. Попробуйте еще раз."
    case alreadyInBookmarks = "Вы уже добавили в закладки."
}
