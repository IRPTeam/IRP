#language: ru
@tree
@Positive
Функционал: password check



Контекст:
    Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: _351001 check user password setting from enterprise mode
    * Select пользователя
        И я открываю навигационную ссылку 'e1cib/list/Catalog.Users'
        И в таблице "List" я перехожу к строке:
            | 'Description'                 |
            | 'Arina Brown (Financier 3)TR' |
        И в таблице "List" я выбираю текущую строку
        * Изменение кода локализации
            И в поле 'Interface localization code' я ввожу текст 'en'
            И я нажимаю на кнопку 'Save'
    * Установка пароля
        И я нажимаю на кнопку 'Set password'
        И в поле 'Password' я ввожу текст 'F12345'
        * Проверка вывода сообщения если подтверждение пароля не совпадает
            И в поле 'Confirm password' я ввожу текст 'F12346'
            И я нажимаю на кнопку 'Ok'
            Затем я жду, что в сообщениях пользователю будет подстрока "Password and password confirmation do not match" в течении 30 секунд
        * Правильный ввод пароля
            И в поле 'Confirm password' я ввожу текст ''
            И в поле 'Confirm password' я ввожу текст 'F12345'
            И я нажимаю на кнопку 'Ok'
            И я нажимаю на кнопку 'Save and close'
            И Пауза 10
    * Проверка установленного пароля
        И я подключаю TestClient "Тест" логин "ABrown" пароль "F12345"
        И Пауза 3
        Когда В панели разделов я выбираю 'Sales - A/R'
        И я закрываю сеанс TESTCLIENT
        Затем Я подключаю уже запущенный клиент тестирования "Этот клиент"

Сценарий: _351002 check user password generation from enterprise mode
   * Select пользователя
        И я открываю навигационную ссылку 'e1cib/list/Catalog.Users'
        И в таблице "List" я перехожу к строке:
            | 'Description'                 |
            | 'Arina Brown (Financier 3)TR' |
        И в таблице "List" я выбираю текущую строку
    * Установка пароля
        И я нажимаю на кнопку 'Set password'
        И я нажимаю на кнопку 'Generate'
        И я запоминаю значение поля с именем "GeneratedValue" как "password"
        И я нажимаю на кнопку 'Ok'
        И я нажимаю на кнопку 'Save and close'
        И Пауза 10
    * Проверка установленного пароля
        И я подключаю TestClient "Тест" логин "ABrown" пароль "$password$"
        И Пауза 3
        Когда В панели разделов я выбираю 'Sales - A/R'
        И я закрываю сеанс TESTCLIENT
        Затем Я подключаю уже запущенный клиент тестирования "Этот клиент"