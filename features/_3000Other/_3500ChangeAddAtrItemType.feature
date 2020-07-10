#language: ru
@tree
@Positive
Функционал: checking a bunch of additional details in the item type for the item key composition

Как Разработчик
Я хочу создать связку для передачи доп реквизитов из item type в состав item key
Для присвоения их товарам

Контекст:
    Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: _350000 preparation for checking a bunch of additional details in item type and their display in the set for item key / price key
    * Открытие набора доп реквизитов для item key
        И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertySets"
        И в таблице "List" я перехожу к строке:
            | 'Predefined data item name' |
            | 'Catalog_ItemKeys'          |
        И в таблице "List" я выбираю текущую строку
        И я нажимаю на кнопку открытия поля "TR"
        И в поле 'ENG' я ввожу текст 'Item key'
        И я нажимаю на кнопку 'Ok'
        И я нажимаю на кнопку 'Save'
     * Создание item type
        И я открываю навигационную ссылку "e1cib/list/Catalog.ItemTypes"
        И Пауза 2
        И я нажимаю на кнопку с именем 'FormCreate'
        И Пауза 2
        И я нажимаю на кнопку открытия поля "TR"
        И в поле с именем 'Description_en' я ввожу текст 'Socks'
        И в поле с именем 'Description_tr' я ввожу текст 'Socks TR'
        И я нажимаю на кнопку 'Ok'
        И В открытой форме я нажимаю на кнопку "Save"
    * Создание доп реквизитов для Socks
        * Создание доп реквизита Color Socks TR
            И я открываю навигационную ссылку "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
            И я нажимаю на кнопку с именем 'FormCreate'
            И я нажимаю на кнопку открытия поля "TR"
            И в поле 'TR' я ввожу текст 'Color Socks TR'
            И в поле 'ENG' я ввожу текст 'Color Socks'
            И я нажимаю на кнопку 'Ok'
        * Установка обязательного заполнения доп реквизита Color Socks TR
            И я нажимаю на кнопку 'Set "Required" at all sets'
            Тогда открылось окно 'Choice value'
            И из выпадающего списка "InputFld" я выбираю точное значение 'Yes'
            И я нажимаю на кнопку 'OK'
            И я нажимаю на кнопку 'Save and close'
            И Пауза 2
        * Создание доп реквизита Brand Socks TR
            И я открываю навигационную ссылку "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
            И я нажимаю на кнопку с именем 'FormCreate'
            И я нажимаю на кнопку открытия поля "TR"
            И в поле 'TR' я ввожу текст 'Brand Socks TR'
            И в поле 'ENG' я ввожу текст 'Brand Socks'
            И я нажимаю на кнопку 'Ok'
            И я нажимаю на кнопку 'Save and close'
            И я закрыл все окна клиентского приложения
         * Создание доп реквизита Article Socks TR
            И я открываю навигационную ссылку "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
            И я нажимаю на кнопку с именем 'FormCreate'
            И я нажимаю на кнопку открытия поля "TR"
            И в поле 'TR' я ввожу текст 'Article Socks TR'
            И в поле 'ENG' я ввожу текст 'Article Socks'
            И я нажимаю на кнопку 'Ok'
            И я нажимаю на кнопку 'Save and close'
            И я закрыл все окна клиентского приложения
    * Наименование AddAttributeAndProperty sets для Price key
        И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertySets"
        И в таблице "List" я перехожу к строке:
        | 'Predefined data item name' |
        | 'Catalog_PriceKeys'          |
        И в таблице "List" я выбираю текущую строку
        И я нажимаю на кнопку открытия поля "TR"
        И в поле 'ENG' я ввожу текст 'Price Keys'
        И я нажимаю на кнопку 'Ok'
        И я нажимаю на кнопку 'Save'
    И я закрыл все окна клиентского приложения



Сценарий: _350001 check the connection between adding additional details to item type and displaying them in the set for item key
    * Открытие item type Socks
        И я открываю навигационную ссылку "e1cib/list/Catalog.ItemTypes"
        И в таблице "List" я перехожу к строке:
            | 'Description' |
            | 'Socks TR'    |
        И в таблице "List" я выбираю текущую строку
    * Открытие Additional attribute sets для item key
        И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertySets"
        И в таблице "List" я перехожу к строке:
            | 'Predefined data item name' |
            | 'Catalog_ItemKeys'          |
        И в таблице "List" я выбираю текущую строку
    * Проверка связки
        * Добавление доп реквизитов в item type
            Когда В панели открытых я выбираю 'Item types'
            И в таблице "AvailableAttributes" я нажимаю на кнопку с именем 'AvailableAttributesAdd'
            И в таблице "AvailableAttributes" я нажимаю кнопку выбора у реквизита "Attribute"
            И в таблице "List" я перехожу к строке:
                | 'Description' |
                | 'Brand Socks TR'    |
            И в таблице "List" я выбираю текущую строку
            И в таблице "AvailableAttributes" я устанавливаю флаг 'Required'
            И в таблице "AvailableAttributes" я завершаю редактирование строки
            И в таблице "AvailableAttributes" я нажимаю на кнопку с именем 'AvailableAttributesAdd'
            И в таблице "AvailableAttributes" я нажимаю кнопку выбора у реквизита "Attribute"
            И в таблице "List" я перехожу к строке:
                | 'Description' |
                | 'Color Socks TR'    |
            И в таблице "List" я выбираю текущую строку
            И в таблице "AvailableAttributes" я завершаю редактирование строки
            И я нажимаю на кнопку 'Save'
        * Проверка их добавления в Additional attribute sets по item key
            И В панели открытых я выбираю 'Additional attribute sets'
            И     таблица "AttributesTree" содержит строки:
                | 'Presentation'    |
                | 'Socks TR'        |
                | 'Brand Socks TR'       |
                | 'Color Socks TR'        |
        * Удаление доп реквизита из item type и проверка его удаления из Additional attribute sets по item key
            Когда В панели открытых я выбираю 'Item types'
            И в таблице "AvailableAttributes" я перехожу к строке:
                | 'Attribute' |
                | 'Brand Socks TR'  |
            И в таблице 'AvailableAttributes' я удаляю строку
            И я нажимаю на кнопку 'Save'
            И В панели открытых я выбираю 'Additional attribute sets'
            И     таблица "AttributesTree" не содержит строки:
                | 'Presentation'    |
                |  'Brand Socks TR' |
        * Добавление доп реквизита обратно и проверка связки
            Когда В панели открытых я выбираю 'Item types'
            И в таблице "AvailableAttributes" я нажимаю на кнопку с именем 'AvailableAttributesAdd'
            И в таблице "AvailableAttributes" я нажимаю кнопку выбора у реквизита "Attribute"
            И в таблице "List" я перехожу к строке:
                | 'Description' |
                | 'Brand Socks TR'    |
            И в таблице "List" я выбираю текущую строку
            И я нажимаю на кнопку 'Save'
            И В панели открытых я выбираю 'Additional attribute sets'
            И     таблица "AttributesTree" содержит строки:
                | 'Presentation'    |
                | 'Brand Socks TR'  |
        И я закрыл все окна клиентского приложения
        * Удаление доп реквизита из Additional attribute sets по item key и проверка связки с item type
            * Удаление реквизита из AddAttributeAndPropertySets по item key
                И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertySets"
                И в таблице "List" я перехожу к строке:
                    | 'Predefined data item name' |
                    | 'Catalog_ItemKeys'          |
                И в таблице "List" я выбираю текущую строку
                И в таблице "AttributesTree" я перехожу к строке:
                    | 'Presentation'    |
                    | 'Brand Socks TR'  |
                И я нажимаю на кнопку 'DeleteItemType'
            * Открытие item type и проверка удаления реквизита
                И я открываю навигационную ссылку "e1cib/list/Catalog.ItemTypes"
                И в таблице "List" я перехожу к строке:
                    | 'Description' |
                    | 'Socks TR'    |
                И в таблице "List" я выбираю текущую строку
                И     таблица "AvailableAttributes" не содержит строки:
                    | 'Attribute' |
                    | 'Brand Socks TR'  |
            * Добавление реквизита обратно
                И в таблице "AvailableAttributes" я нажимаю на кнопку с именем 'AvailableAttributesAdd'
                И в таблице "AvailableAttributes" я нажимаю кнопку выбора у реквизита "Attribute"
                И в таблице "List" я перехожу к строке:
                    | 'Description' |
                    | 'Brand Socks TR'    |
                И в таблице "List" я выбираю текущую строку
                И я нажимаю на кнопку 'Save'
        И я закрыл все окна клиентского приложения

Сценарий: _350002 checking the connection between the installation according to the additional attribute of the sign of influence on the price and Add atribute and property sets by Price key
          * Открытие Additional attribute sets для price key
            И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertySets"
            И в таблице "List" я перехожу к строке:
            | 'Predefined data item name' |
            | 'Catalog_PriceKeys'          |
            И в таблице "List" я выбираю текущую строку
        * Открытие item type Socks
            И я открываю навигационную ссылку "e1cib/list/Catalog.ItemTypes"
            И в таблице "List" я перехожу к строке:
            | 'Description' |
            | 'Socks TR'    |
            И в таблице "List" я выбираю текущую строку
            И     таблица "AvailableAttributes" содержит строки:
            | 'Attribute'      | 'Affect pricing' |
            | 'Color Socks TR' | 'No'             |
            | 'Brand Socks TR' | 'No'             |
        * Добавление признака того, что Color Socks TR будет влиять на цену
            Когда В панели открытых я выбираю 'Item types'
            И в таблице "AvailableAttributes" я активизирую поле "Attribute"
            И в таблице "AvailableAttributes" я перехожу к строке:
                | 'Attribute'      |
                | 'Color Socks TR' |
            И в таблице "AvailableAttributes" я активизирую поле "Affect pricing"
            И в таблице "AvailableAttributes" я устанавливаю флаг 'Affect pricing'
            И в таблице "AvailableAttributes" я завершаю редактирование строки
            И я нажимаю на кнопку 'Save'
        * Проверка связки с Additional attribute sets по price key
            И В панели открытых я выбираю 'Additional attribute sets'
            И     таблица "AttributesTree" содержит строки:
                | 'Presentation'   |
                | 'Socks TR'       |
                | 'Color Socks TR' |
        * Снятие признака того, что Color Socks TR будет влиять на цену
            Когда В панели открытых я выбираю 'Item types'
            И в таблице "AvailableAttributes" я активизирую поле "Attribute"
            И в таблице "AvailableAttributes" я перехожу к строке:
                | 'Attribute'      |
                | 'Color Socks TR' |
            И в таблице "AvailableAttributes" я активизирую поле "Affect pricing"
            И в таблице "AvailableAttributes" я снимаю флаг 'Affect pricing'
            И в таблице "AvailableAttributes" я завершаю редактирование строки
            И я нажимаю на кнопку 'Save'
        * Проверка связки с Additional attribute sets по price key
            И В панели открытых я выбираю 'Additional attribute sets'
            И     таблица "AttributesTree" не содержит строки:
                | 'Presentation'   |
                | 'Color Socks TR' |
        * Повторная установка галочки влияния на цену
            Когда В панели открытых я выбираю 'Item types'
            И в таблице "AvailableAttributes" я активизирую поле "Attribute"
            И в таблице "AvailableAttributes" я перехожу к строке:
                | 'Attribute'      |
                | 'Color Socks TR' |
            И в таблице "AvailableAttributes" я активизирую поле "Affect pricing"
            И в таблице "AvailableAttributes" я устанавливаю флаг 'Affect pricing'
            И в таблице "AvailableAttributes" я завершаю редактирование строки
            И я нажимаю на кнопку 'Save'
         * Проверка связки с Additional attribute sets по price key
            И В панели открытых я выбираю 'Additional attribute sets'
            И     таблица "AttributesTree" содержит строки:
                | 'Presentation'   |
                | 'Socks TR'       |
                | 'Color Socks TR' |
        И я закрыл все окна клиентского приложения

Сценарий: _350003 mark on removal of Item type and non-display in Add atribute and property sets by Price key and by item key
    * Открытие списка выбора item type и пометка на удаление нужного элемента
        И я открываю навигационную ссылку "e1cib/list/Catalog.ItemTypes"
        И в таблице "List" я перехожу к строке:
            | 'Description' |
            | 'Socks TR'    |
        И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuSetDeletionMark'
        Тогда открылось окно '1C:Enterprise'
        И я нажимаю на кнопку 'Yes'
    * Проверка, что помеченный на удаление Item type не отображается в Add atribute and property sets по Price key
        И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertySets"
        И в таблице "List" я перехожу к строке:
            | 'Predefined data item name' |
            | 'Catalog_PriceKeys'          |
        И в таблице "List" я выбираю текущую строку
        И     таблица "AttributesTree" не содержит строки:
            | 'Presentation'   |
            | 'Socks TR'       |
            | 'Color Socks TR' |
        И я закрыл все окна клиентского приложения
     * Проверка, что помеченный на удаление Item type не отображается в Add atribute and property sets по item key
        И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertySets"
        И в таблице "List" я перехожу к строке:
            | 'Predefined data item name' |
            | 'Catalog_ItemKeys'          |
        И в таблице "List" я выбираю текущую строку
        И     таблица "AttributesTree" не содержит строки:
            | 'Presentation'    |
            | 'Socks TR'        |
            | 'Brand Socks TR'       |
            | 'Color Socks TR'        |
        И я закрыл все окна клиентского приложения
    * Снятие пометки на удаление с Item type
        И я открываю навигационную ссылку "e1cib/list/Catalog.ItemTypes"
        И в таблице "List" я перехожу к строке:
            | 'Description' |
            | 'Socks TR'    |
        И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuSetDeletionMark'
        Тогда открылось окно '1C:Enterprise'
        И я нажимаю на кнопку 'Yes'
    * Проверка, что при снятии пометки на удаление Item type отображается в Add atribute and property sets по Price key
        И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertySets"
        И в таблице "List" я перехожу к строке:
            | 'Predefined data item name' |
            | 'Catalog_PriceKeys'          |
        И в таблице "List" я выбираю текущую строку
        И     таблица "AttributesTree" содержит строки:
            | 'Presentation'   |
            | 'Socks TR'       |
            | 'Color Socks TR' |
        И я закрыл все окна клиентского приложения
     * Проверка, что при снятии пометки на удаление Item type отображается в Add atribute and property sets по item key
        И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertySets"
        И в таблице "List" я перехожу к строке:
            | 'Predefined data item name' |
            | 'Catalog_ItemKeys'          |
        И в таблице "List" я выбираю текущую строку
        И     таблица "AttributesTree" содержит строки:
            | 'Presentation'    |
            | 'Socks TR'        |
            | 'Brand Socks TR'       |
            | 'Color Socks TR'        |
        И я закрыл все окна клиентского приложения

Сценарий: _350004 edit Item type and check changes in Add atribute and property sets by item key
     * Открытие Additional attribute sets для item key
        И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertySets"
        И в таблице "List" я перехожу к строке:
            | 'Predefined data item name' |
            | 'Catalog_ItemKeys'          |
        И в таблице "List" я выбираю текущую строку
     * Редактирование item type Socks
        И я открываю навигационную ссылку "e1cib/list/Catalog.ItemTypes"
        И в таблице "List" я перехожу к строке:
            | 'Description' |
            | 'Socks TR'    |
        И в таблице "List" я выбираю текущую строку
        И в поле 'TR' я ввожу текст 'Warm Socks TR'
        И я нажимаю на кнопку 'Save and close'
    * Проверка замены item type в Add atribute and property sets по item key
        И В панели открытых я выбираю 'Additional attribute sets'
        И     таблица "AttributesTree" содержит строки:
            | 'Presentation'    |
            | 'Warm Socks TR'   |
            | 'Brand Socks TR'  |
            | 'Color Socks TR'  |
        И я закрыл все окна клиентского приложения


Сценарий: _350005 check the selection conditions when adding additional details on item
    * Открытие Additional attribute sets для item
        И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertySets"
        И в таблице "List" я перехожу к строке:
            | 'Predefined data item name' |
            | 'Catalog_Items'          |
        И в таблице "List" я выбираю текущую строку
    * Добавление доп реквизита только для item type Warm Socks TR
        И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
        И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
        И в таблице "List" я перехожу к строке:
            | 'Description'      |
            | 'Article Socks TR' |
        И в таблице "List" я выбираю текущую строку
        И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "UI group"
        И в таблице "List" я перехожу к строке:
            | 'Description'               |
            | 'Accounting information TR' |
        И в таблице "List" я выбираю текущую строку
        И в таблице "Attributes" я завершаю редактирование строки
        И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesSetCondition'
        Тогда открылось окно '1C:Enterprise'
        И я нажимаю на кнопку 'Yes'
        И в таблице "SettingsFilter" я нажимаю на кнопку с именем 'SettingsFilterAddFilterItem'
        И в таблице "SettingsFilter" из выпадающего списка "Field" я выбираю точное значение 'Item type'
        И я перехожу к следующему реквизиту
        И в таблице "SettingsFilter" я нажимаю кнопку выбора у реквизита "Comparison type"
        И в таблице "SettingsFilter" я активизирую поле "Value"
        И в таблице "SettingsFilter" я нажимаю кнопку выбора у реквизита "Value"
        И в таблице "List" я перехожу к строке:
            | 'Description'   |
            | 'Warm Socks TR' |
        И в таблице "List" я выбираю текущую строку
        И в таблице "SettingsFilter" я завершаю редактирование строки
        И я нажимаю на кнопку 'Ok'
        И я нажимаю на кнопку 'Save and close'
        И Пауза 5
    * Проверка прорисовки доп реквизитов для товара с видом номенклатуры Warm Socks TR
        * Создание Item с видом номенклатуры Warm Socks TR
            И я открываю навигационную ссылку "e1cib/list/Catalog.Items"
            И я нажимаю на кнопку с именем 'FormCreate'
            И в поле 'TR' я ввожу текст 'Socks'
            И я нажимаю кнопку выбора у поля "Item type"
            И в таблице "List" я перехожу к строке:
                | 'Description'   |
                | 'Warm Socks TR' |
            И в таблице "List" я выбираю текущую строку
            И я нажимаю кнопку выбора у поля "Unit"
            И в таблице "List" я перехожу к строке:
                | 'Description' |
                | 'adet'        |
            И в таблице "List" я выбираю текущую строку
            И я нажимаю на кнопку 'Save and close'
            И Пауза 2
        * Проверка отображения реквизита Article Socks TR
            И в таблице "List" я перехожу к строке:
                | 'Description' |
                | 'Socks'       |
            И в таблице "List" я выбираю текущую строку
            И поле "Article Socks TR" существует
            И Я закрываю текущее окно
            И в таблице "List" я перехожу к строке:
                | 'Description' |
                | 'Dress TR'       |
            И в таблице "List" я выбираю текущую строку
            И поле "Article Socks TR" не существует
            И я закрыл все окна клиентского приложения


Сценарий: _350006 check error when doubling additional details on item
    * Открытие Additional attribute sets для Items
        И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertySets"
        И в таблице "List" я перехожу к строке:
            | 'Predefined data item name' |
            | 'Catalog_Items'          |
        И в таблице "List" я выбираю текущую строку
    * Проверка в наличии доп реквизитов
        И     таблица "Attributes"содержит строки:
        | 'Attribute'                 |
        | 'Producer TR'               |
        | 'Article TR'                |
        | 'Brand TR'                  |
        | 'Country of consignment TR' |
        | 'Article Socks TR'          |
    * Добавление доп реквизита Brand TR
        И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
        И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
        И в таблице "List" я перехожу к строке:
            | 'Description'      |
            | 'Brand TR' |
        И в таблице "List" я выбираю текущую строку
    * Проверка сообщения об ошибке сохранения
        И я нажимаю на кнопку 'Save'
        Тогда я жду, что в сообщениях пользователю будет подстрока "Duplicated attribute: Brand TR" в течение 10 секунд
    И я закрыл все окна клиентского приложения

Сценарий: _350007 check error when duplicating an additional attribute of an item key
    * Открытие Item type для Socks
        И я открываю навигационную ссылку "e1cib/list/Catalog.ItemTypes"
        И в таблице "List" я перехожу к строке:
            | 'Description'   |
            | 'Warm Socks TR' |
        И в таблице "List" я выбираю текущую строку
    * Проверка в наличии доп реквизитов
        И     таблица "AvailableAttributes" содержит строки:
            | 'Attribute'      |
            | 'Color Socks TR' |
            | 'Brand Socks TR' |
    * Добавление доп реквизита Brand Socks TR
        И в таблице "AvailableAttributes" я нажимаю на кнопку с именем 'AvailableAttributesAdd'
        И в таблице "AvailableAttributes" я нажимаю кнопку выбора у реквизита "Attribute"
        И в таблице "List" я перехожу к строке:
            | 'Description'    |
            | 'Brand Socks TR' |
        И в таблице "List" я выбираю текущую строку
        И в таблице "AvailableAttributes" я завершаю редактирование строки
    * Проверка сообщения об ошибке сохранения
        И я нажимаю на кнопку 'Save'
        Тогда я жду, что в сообщениях пользователю будет подстрока "Duplicated attribute: Brand Socks TR" в течение 10 секунд
    И я закрыл все окна клиентского приложения