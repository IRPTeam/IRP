#language: ru
@tree
@Positive
Функционал: создание группы видов номенклатуры



Контекст:
    Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _351501 создание группы видов номенклатуры
    * Open catalog вида номенклатуры
        И я открываю навигационную ссылку 'e1cib/list/Catalog.ItemTypes'
    * Создание группы видов номенклатуры
        И я нажимаю на кнопку с именем 'FormCreateFolder'
        И я нажимаю на кнопку открытия поля "TR"
        И в поле 'ENG' я ввожу текст 'Accessories'
         И в поле 'TR' я ввожу текст 'Accessories TR'
        И я нажимаю на кнопку 'Ok'
        И я нажимаю на кнопку 'Save and close'
    * Create item type в группе Accessories
        И я нажимаю на кнопку с именем 'FormCreate'
        И я нажимаю на кнопку открытия поля "TR"
        И в поле с именем 'Description_en' я ввожу текст 'Earrings'
        И в поле с именем 'Description_tr' я ввожу текст 'Earrings TR'
        И я нажимаю на кнопку 'Ok'
        И из выпадающего списка "Parent" я выбираю по строке 'Accessories'
        И В открытой форме я нажимаю на кнопку "Save and close"
    * create вида номенклатуры Earrings
        И в таблице "List" я перехожу к строке:
            | 'Description' |
            | 'Accessories TR'            |
        И в таблице  "List" я перехожу на один уровень вниз
        Тогда таблица "List" стала равной:
            | 'Description'    |
            | 'Accessories TR' |
            | 'Earrings TR'    |
        И я закрыл все окна клиентского приложения
    * Проверка отображения группы видов номенклатуры в AddAttributeAndPropertySets по item key
        И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertySets"
        И в таблице "List" я перехожу к строке:
        | 'Predefined data item name' |
        | 'Catalog_ItemKeys'          |
        И в таблице "List" я выбираю текущую строку
        И     таблица "AttributesTree" содержит строки:
            | 'Presentation'      |
            | 'Accessories TR'    |
            | 'Earrings TR'       |
        И я закрыл все окна клиентского приложения






