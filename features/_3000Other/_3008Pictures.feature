#language: ru
@tree
@Positive
Функционал: внесение настроек для отображения картинок

Как Разработчик
Я хочу создать подсистему картинок
Для присвоения их товарам

Контекст:
    Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

# предварительно необходимо создать папку Picture, в которую нужно положить 3 папки: Preview, Script, Source. У пользователя 1с должен быть к ним доступ


Сценарий: _300101 настройки для отображения картинок
    * Внесение настроек в справочник File storages info
        И я открываю навигационную ссылку 'e1cib/list/Catalog.FileStoragesInfo'
        Тогда я нажимаю на кнопку 'Create'
        И в поле 'Path to catalog at server' я ввожу текст '#workingDir#\DataProcessor\Picture\Preview'
        И в поле 'URL Alias' я ввожу текст 'preview'
        И я нажимаю на кнопку 'Save and close'
        И я открываю навигационную ссылку 'e1cib/list/Catalog.FileStoragesInfo'
        Тогда я нажимаю на кнопку 'Create'
        И в поле 'Path to catalog at server' я ввожу текст '#workingDir#\DataProcessor\Picture\Script'
        И в поле 'URL Alias' я ввожу текст 'js'
        И я нажимаю на кнопку 'Save and close'
        И я открываю навигационную ссылку 'e1cib/list/Catalog.FileStoragesInfo'
        Тогда я нажимаю на кнопку 'Create'
        И в поле 'Path to catalog at server' я ввожу текст '#workingDir#\DataProcessor\Picture\Source'
        И в поле 'URL Alias' я ввожу текст 'pic'
        И я нажимаю на кнопку 'Save and close'
   * Внесение настроек в справочник Integration Settings для PICTURE STORAGE
        И я открываю навигационную ссылку 'e1cib/list/Catalog.IntegrationSettings'
        Тогда я нажимаю на кнопку 'Create'
        И в поле 'Description' я ввожу текст 'PICTURE STORAGE'
        И из выпадающего списка "Integration type" я выбираю точное значение 'Local file storage'
        И в таблице "ConnectionSetting" я нажимаю на кнопку с именем 'ConnectionSettingFillByDefault'
        И в таблице "ConnectionSetting" я перехожу к строке:
            | 'Key'         |
            | 'AddressPath' |
        И в таблице "ConnectionSetting" я активизирую поле "Value"
        И в таблице "ConnectionSetting" я выбираю текущую строку
        И в таблице "ConnectionSetting" в поле 'Value' я ввожу текст '#workingDir#\DataProcessor\Picture\Source'
        И в таблице "ConnectionSetting" я завершаю редактирование строки
        И в таблице "ConnectionSetting" я перехожу к строке:
            | 'Key'       | 'Value' |
            | 'QueryType' | 'POST'  |
        И в таблице "ConnectionSetting" я активизирую поле "Key"
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И я нажимаю на кнопку 'Save and close'
    * Внесение настроек в справочник Integration Settings для PREVIEW STORAGE
        И я открываю навигационную ссылку 'e1cib/list/Catalog.IntegrationSettings'
        Тогда я нажимаю на кнопку 'Create'
        И в поле 'Description' я ввожу текст 'PREWIEV STORAGE'
        И из выпадающего списка "Integration type" я выбираю точное значение 'Local file storage'
        И в таблице "ConnectionSetting" я нажимаю на кнопку с именем 'ConnectionSettingFillByDefault'
        И в таблице "ConnectionSetting" я перехожу к строке:
            | 'Key'         |
            | 'AddressPath' |
        И в таблице "ConnectionSetting" я активизирую поле "Value"
        И в таблице "ConnectionSetting" я выбираю текущую строку
        И в таблице "ConnectionSetting" в поле 'Value' я ввожу текст 'C:\Users\NTrukhacheva\Desktop\Picture\Prewiev'
        И в таблице "ConnectionSetting" я завершаю редактирование строки
        И в таблице "ConnectionSetting" я перехожу к строке:
            | 'Key'       | 'Value' |
            | 'QueryType' | 'POST'  |
        И в таблице "ConnectionSetting" я активизирую поле "Key"
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И в таблице 'ConnectionSetting' я удаляю строку
        И я нажимаю на кнопку 'Save and close'
    * Внесение настроек в справочник File Storage Volumes
        И я открываю навигационную ссылку 'e1cib/list/Catalog.FileStorageVolumes'
        Тогда я нажимаю на кнопку 'Create'
        И в поле 'Description' я ввожу текст 'DEFAULT PICTURE STORAGE'
        И из выпадающего списка "Files type" я выбираю точное значение 'Picture'
        И я нажимаю кнопку выбора у поля "POST Integration settings"
        И в таблице "List" я перехожу к строке:
            | Description     |
            | PICTURE STORAGE |
        И в таблице "List" я выбираю текущую строку
        И я нажимаю кнопку выбора у поля "GET Integration settings"
        И в таблице "List" я перехожу к строке:
            | Description     |
            | PICTURE STORAGE |
        И в таблице "List" я выбираю текущую строку
        И я устанавливаю флаг 'Use preview1'
        И я нажимаю кнопку выбора у поля "Preview1 POST Integration settings"
        И в таблице "List" я перехожу к строке:
            | Description     |
            | PREWIEV STORAGE |
        И в таблице "List" я выбираю текущую строку
        И я нажимаю кнопку выбора у поля "Preview1 GET Integration settings"
        И в таблице "List" я перехожу к строке:
            | Description     |
            | PREWIEV STORAGE |
        И в таблице "List" я выбираю текущую строку
        И в поле 'Preview1 size px' я ввожу текст '200'
        И я нажимаю на кнопку 'Save and close'
    * Заполнение константы по расположению картинок 
        Когда В панели разделов я выбираю 'Settings'
        И В панели функций я выбираю 'Default picture storage volume'
        И я нажимаю кнопку выбора у поля "Default picture storage volume"
        И я нажимаю на кнопку с именем 'FormChoose'
        И я нажимаю на кнопку 'Save and close'
        И Пауза 3


Сценарий: _300102 отображение реквизитов item/item key в форме списка (html поле)
    * Открытие формы настройки доп реквизитов для Item
        И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
        И в таблице "List" я перехожу к строке:
            | 'Description' | 'Predefined data item name' |
            | 'Items'       | 'Catalog_Items'             |
        И в таблице "List" я выбираю текущую строку
    * Настройка отображения реквизитов в html поле
        И в таблице "Attributes" я перехожу к строке:
            | 'Attribute' |
            | 'Brand TR'     |
        И в таблице "Attributes" я устанавливаю флаг с именем 'AttributesShowInHTML'
        И в таблице "Attributes" я завершаю редактирование строки
        И в таблице "Attributes" я перехожу к строке:
            | 'Attribute'              |
            | 'Country of consignment TR' |
        И в таблице "Attributes"я устанавливаю флаг с именем 'AttributesShowInHTML'
        И в таблице "Attributes" я завершаю редактирование строки
        И я нажимаю на кнопку 'Save and close'
    * Открытие формы настройки доп реквизитов для Item key
        И я открываю навигационную ссылку 'e1cib/list/Catalog.ItemTypes'
        И в таблице "List" я перехожу к строке:
            | 'Description'   |
            | 'Сlothes TR'       |
        И в таблице "List" я выбираю текущую строку
    * Настройка отображения реквизитов в html поле
        И в таблице "AvailableAttributes" я перехожу к строке:
            | 'Attribute' |
            | 'Color TR'     |
        И в таблице "AvailableAttributes" я устанавливаю флаг 'Show in HTML'
        И в таблице "AvailableAttributes" я завершаю редактирование строки
        И в таблице "AvailableAttributes" я перехожу к строке:
            | 'Attribute' |
            | 'Size TR'     |
        И в таблице "AvailableAttributes" я устанавливаю флаг 'Show in HTML'
        И в таблице "AvailableAttributes" я завершаю редактирование строки
        И я нажимаю на кнопку 'Save and close'




Сценарий:_300110 добавление картинок к доп реквизитам и доп свойствам
    * Открытие перечня доп реквизитов и доп свойствам
        И я открываю навигационную ссылку 'e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty'
    * Добавление картинки к доп реквизиту/доп свойству
        И в таблице "List" я перехожу к строке:
        | 'Description' |
        | 'Brand TR'     |
        И в таблице "List" я выбираю текущую строку
        И я буду выбирать внешний файл "#workingDir#\features\_3000Other\16466.png"
        И я нажимаю на гиперссылку "Icon"
    * Проверка добавления картинки к доп реквизиту
        Тогда значение поля с именем "Icon" содержит текст 'e1cib/tempstorage/'
        И я нажимаю на кнопку 'Save and close'

Сценарий: _300111 проверка очистки добавленной картинки к доп реквизитам и доп свойствам
    * Открытие перечня доп реквизитов и доп свойствам
        И я открываю навигационную ссылку 'e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty'
    * Добавление картинки к доп реквизиту/доп свойству
        И в таблице "List" я перехожу к строке:
        | 'Description' |
        | 'Brand TR'     |
        И в таблице "List" я выбираю текущую строку
        И я нажимаю на гиперссылку "Icon"
        Тогда открылось окно '1C:Enterprise'
        И я нажимаю на кнопку 'Clear'
    * Проверка удаления картинки 
        Тогда значение поля с именем "Icon" не содержит текст 'e1cib/tempstorage/'
        И я нажимаю на кнопку 'Save and close'
    * Добавление обратно картинки к доп реквизиту/доп свойству
        И в таблице "List" я перехожу к строке:
        | 'Description' |
        | 'Brand TR'     |
        И в таблице "List" я выбираю текущую строку
        И я буду выбирать внешний файл "#workingDir#\features\_3000Other\16466.png"
        И я нажимаю на гиперссылку "Icon"
    * Проверка добавления картинки к доп реквизиту
        Тогда значение поля с именем "Icon" содержит текст 'e1cib/tempstorage/'
        И я нажимаю на кнопку 'Save and close'




# Сценарий: _300102 настройка интеграции с гугл диском
#     И я открываю навигационную ссылку 'e1cib/list/Catalog.IntegrationSettings'
#     И я нажимаю на кнопку с именем 'FormCreate'
#     И в поле 'Description' я ввожу текст 'Google drive'
#     И из выпадающего списка "Integration type" я выбираю точное значение 'Google drive'
#     И в таблице "ConnectionSetting" я активизирую поле "Key"
#     И в таблице 'ConnectionSetting' я удаляю строку
#     И в таблице 'ConnectionSetting' я удаляю строку
#     И в таблице 'ConnectionSetting' я удаляю строку
#     И в таблице 'ConnectionSetting' я удаляю строку
#     И в таблице 'ConnectionSetting' я удаляю строку
#     И в таблице 'ConnectionSetting' я удаляю строку
#     И в таблице 'ConnectionSetting' я удаляю строку
#     И в таблице 'ConnectionSetting' я удаляю строку
#     И в таблице 'ConnectionSetting' я удаляю строку
#     И в таблице 'ConnectionSetting' я удаляю строку
#     И в таблице 'ConnectionSetting' я удаляю строку
#     И в таблице "ConnectionSetting" я нажимаю на кнопку 'Login'
#     Затем клик на картинку "accaunt"
#     Затем клик на картинку "allow"
#     Когда В панели открытых я выбираю 'Integration settings'
#     И в таблице "ConnectionSetting" я нажимаю на кнопку 'Test'
#     Затем я жду, что в сообщениях пользователю будет подстрока "Done" в течение 30 секунд
#     И я закрыл все окна клиентского приложения

Сценарий: _300103 добавление картинок по товару
    * Open list form товаров и выбор нужного элемента
        И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
        И в таблице "List" я перехожу к строке:
            | 'Description'  |
            | 'Trousers TR'     |
        И в таблице "List" я выбираю текущую строку
    * Добавление картинки
        И я буду выбирать внешний файл "#workingDir#\features\_3000Other\16466.png"
        И Пауза 3
        Затем клик на картинку "plus"
    * Проверка добавления картинки 
        И В текущем окне я нажимаю кнопку командного интерфейса 'Attached files'
        Тогда таблица "List" содержит строки:
            | 'Owner'       | 'File'      |
            | 'Trousers TR'    | '16466.png' |
    * Добавление ещё одной картинки
        И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
        И я буду выбирать внешний файл "#workingDir#\features\_3000Other\dressblue.jpg"
        Дано курсор к картинке "plus3"
        Затем клик на картинку "plus3"
        Дано я нажимаю ENTER
     * Проверка добавления картинки 
        И В текущем окне я нажимаю кнопку командного интерфейса 'Attached files'
        И я нажимаю на кнопку 'Refresh'
        Тогда таблица "List" содержит строки:
            | 'Owner'          | 'File'          |
            | 'Trousers TR'    | '16466.png'     |
            | 'Trousers TR'    | 'dressblue.jpg' |
        И я закрыл все окна клиентского приложения



Сценарий: _300105 открытие элементов справочника Files
    * Open catalog Files
        И я открываю навигационную ссылку 'e1cib/list/Catalog.Files'
    * Открытие элемента справочника Files
        И в таблице "List" я перехожу к строке:
            | 'Extension' | 'File name' |
            | 'PNG'       | '16466.png' |
        И в таблице "List" я выбираю текущую строку
        Тогда не появилось окно предупреждения системы


# надо будет дописать после исправления багов
Сценарий: _300106 удаление неиспользуемых элементов справочника Files
    * Open catalog Files
        И я открываю навигационную ссылку 'e1cib/list/Catalog.Files'
    * Вызов команды удаления неиспользуемых элементов
        И я нажимаю на кнопку 'Delete unused files'
    * Поиск неиспользуемых файлов
        И в таблице "Files" я нажимаю на кнопку 'Find unused files'
        И Пауза 3
    * Выбор всех неспользуемых файлов
        И в таблице "Files" я нажимаю на кнопку 'Check all'
    * Удаление неиспользуемых файлов
        И в таблице "Files" я нажимаю на кнопку 'Delete unused files'
    И я закрыл все окна клиентского приложения



Сценарий: _300107 добавление картинок по item key
    * Open list form товаров и выбор нужного элемента
        И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
        И в таблице "List" я перехожу к строке:
            | 'Description'  |
            | 'Trousers TR'     |
        И в таблице "List" я выбираю текущую строку
        И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
        И в таблице "List" я перехожу к строке:
            | 'Item key'     |
            | '38/Yellow TR' |
        И в таблице "List" я выбираю текущую строку
    * Добавление картинки
        И я буду выбирать внешний файл "#workingDir#\features\_3000Other\16466.png"
        И Пауза 3
        Затем клик на картинку "plus"
    * Проверка добавления картинки
        И В текущем окне я нажимаю кнопку командного интерфейса 'Attached files'
        Тогда таблица "List" содержит строки:
            | 'Owner'        | 'File'      |
            | '38/Yellow TR' | '16466.png' |
    * Добавление ещё одной картинки
        И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
        И я буду выбирать внешний файл "#workingDir#\features\_3000Other\pinkdress.jpg"
        Дано курсор к картинке "plus3"
        Затем клик на картинку "plus3"
        Дано я нажимаю ENTER
    * Проверка добавления картинки 
        И В текущем окне я нажимаю кнопку командного интерфейса 'Attached files'
        И я нажимаю на кнопку 'Refresh'
        Тогда таблица "List" содержит строки:
            | 'Owner'           | 'File'          |
            | '38/Yellow TR'    | '16466.png'     |
            | '38/Yellow TR'    | 'pinkdress.jpg' |
        И я закрыл все окна клиентского приложения


Сценарий: _300108 открытие галереи картинок из Item и item key
    * Проверка открытия галереи из Item
        * Open list form товаров и выбор нужного элемента
            И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
            И в таблице "List" я перехожу к строке:
                | 'Description'  |
                | 'Shirt TR'     |
            И в таблице "List" я выбираю текущую строку
        * Открытие окна галереи
            Дано курсор к картинке "gallery"
            Затем клик на картинку "gallery"
        * Проверка наличия в галереи картинки
            И я жду открытия окна "" в течение 20 секунд
            Дано курсор к картинке "verificationpicture"
        * Проверка выбора картинки при клике
            Затем клик на картинку "selectverificationpic"
            Дано курсор к картинке "addselectedpicture"
        # * Проверка добавления картинки из галереи
        #     Затем клик на картинку "addselectedpicture"
        И я закрыл все окна клиентского приложения
    * Проверка открытия галереи из Item key
        * Open list form товаров и выбор нужного элемента
            И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
            И в таблице "List" я перехожу к строке:
                | 'Description'  |
                | 'Shirt TR'     |
            И в таблице "List" я выбираю текущую строку
            И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
            И в таблице "List" я перехожу к строке:
                | 'Item key'     |
                | '36/Red TR' |
            И в таблице "List" я выбираю текущую строку
        * Открытие окна галереи
            Дано курсор к картинке "gallery"
            Затем клик на картинку "gallery"
        * Проверка наличия в галереи картинки
            И я жду открытия окна "" в течение 20 секунд
            Дано курсор к картинке "verificationpicture"
        * Проверка выбора картинки при клике
            Затем клик на картинку "selectverificationpic"
            Дано курсор к картинке "addselectedpicture"
        # * Проверка добавления картинки из галереи
        #     Затем клик на картинку "addselectedpicture"
    И я закрыл все окна клиентского приложения

Сценарий: _300109 проверка удаления картинок из Item и item key
    * Open list form товаров и выбор нужного элемента
        И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
        И в таблице "List" я перехожу к строке:
            | 'Description'  |
            | 'Trousers TR'     |
        И в таблице "List" я выбираю текущую строку
    * Удаление картинки из Item
        Дано курсор к картинке "deletepic"
        Затем клик на картинку "deletepic"
        Тогда не появилось окно предупреждения системы
    И я закрыл все окна клиентского приложения
    * Open list form товаров и выбор нужного элемента
        И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
        И в таблице "List" я перехожу к строке:
            | 'Description'     |
            | 'Trousers TR'     |
        И в таблице "List" я выбираю текущую строку
        И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
        И в таблице "List" я перехожу к строке:
            | 'Item key'     |
            | '38/Yellow TR' |
        И в таблице "List" я выбираю текущую строку
    * Удаление картинки из Item key
        Дано курсор к картинке "deletepic"
        Затем клик на картинку "deletepic"
        Тогда не появилось окно предупреждения системы
     И я закрыл все окна клиентского приложения