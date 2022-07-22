# AppNews
## Простое приложение для загрузки новостей из интернета с возможностью добавления их в закладки и обновлением списка новостей.
### Стек: UIKit, MVC, TableView, CollectionView, UserDefaults, NSCache, SafariServices.
=======================================================================================

<img src="https://user-images.githubusercontent.com/83611962/173223103-617a1d42-61ab-41ce-9e15-16f5199b4511.png" width="200"> <img src="https://user-images.githubusercontent.com/83611962/173223109-e35ab15f-8818-4d97-92b9-2b770d1fc351.png" width="200"> <img src="https://user-images.githubusercontent.com/83611962/173223110-a75911ee-f41e-467c-a2fc-b6c5414ea844.png" width="200"> 
<img src="https://user-images.githubusercontent.com/83611962/173223113-85b9fd70-c792-4fb7-8d8e-e909bec19f75.png" width="200"> <img src="https://user-images.githubusercontent.com/83611962/173223115-e8dafef6-ec0c-4699-b6fe-a003f742c292.png" width="200"> <img src="https://user-images.githubusercontent.com/83611962/173223117-cf9bb50a-4a2b-4d7b-b2ad-440869a06ce8.png" width="200"> 
<img src="https://user-images.githubusercontent.com/83611962/173223119-bf7b6df7-23f0-42c8-8a18-701fba27cc88.png" width="200"> <img src="https://user-images.githubusercontent.com/83611962/173223120-b645cb64-edc6-4422-a249-b613aca77270.png" width="200"> 

### Подробное описание
1. Проект написан на UIKit;
2. Использована архитектура MVC;
3. Использованы TabBarController, NavigationController;
4. Использованы TableView с кастомными ячейками;
5. Использованы CollectionView c кастомными ячейками и кастомным Layout (за основу реализации была взята [статья-гайд из raywenderlich.com](https://www.raywenderlich.com/7246-expanding-cells-in-ios-collection-views);
6. Реализована постраничная загрузка новостей (1 страница = 20 новостей);
7. Реализован жест pull to refresh (UIRefreshControl);
8. Загрузка из интернета по API (newsapi.org) картинки, тайтла, краткого описания, автора, времени публикации и URL источника новости;
9. Сохранение загруженных из сети картинок в кэш;
10. Возможность просмотра оригинального источника новостей через браузер Safari;
11. Реализован ScrollView для айфонов с маленьким экраном при открытии новости;
12. Реализовано сохранение новостей в закладки с помощью UserDafaults;
13. Реализовано удаление новостей из закладок через свайп;
14. Кастомный AlertViewController с обработками различных ошибок;
15. Приложение проверено на утечки памяти;
16. Добавлена иконка приложения.

### Что еще планируется реализовать/исправить
1. Добавить счетчик просмотров для каждой новости;
2. Внедрить MVP архитектуру;
3. Реализовать DI для каждого модуля и слоев;
4. Реализовать Coordinator;
5. Реализовать категории выбора новостей;
6. Написать Unit/UI-тесты.
