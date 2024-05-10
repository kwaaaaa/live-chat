# language: ru
@all
@javascript
Функционал: Отправка сообщений между пользователями
  Предыстория:
    Дано "Пользователь 1" входит в приложение в одном окне браузера
    Дано "Пользователь 2" входит в приложение в одном окне браузера
    Дано "Пользователь 3" входит в приложение в одном окне браузера
  Сценарий: Отправка сообщений
    Если  Пользователь 1 пишет Пользователю 2 «Сообщение 1»
    И В группу «все пользователи» «Сообщение 2»
    То Пользователь 2 получает оба сообщени
    И Пользователь 3 получает Сообщение 2