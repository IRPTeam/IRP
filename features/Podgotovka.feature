#language: ru
@ExportScenarios
@IgnoreOnCIMainBuild
@tree

Функционал: экспортные сценарии

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: создаю элемент справочника с наименованием Test

	И Пауза 2
	И я нажимаю на кнопку с именем 'FormCreate'
	И Пауза 2
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	# И я перехожу к закладке "< >"
	И в поле с именем 'Description_en' я ввожу текст 'Test ENG'
	И в поле с именем 'Description_tr' я ввожу текст 'Test TR'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку с именем 'FormWrite'
	И Пауза 5



Сценарий: заполняю данные о клиенте в заказе (Ferron BP, склад 01)
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Agreement"
	Тогда открылось окно 'Agreements'
	И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Basic Agreements, TRY' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Legal name"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Company Ferron BP'  |
	И в таблице "List" я выбираю текущую строку




Сценарий: очистка скидок
	И Я удаляю все элементы Справочника "ExternalDataProc"
	И Я удаляю все элементы Справочника "SpecialOfferTypes"
	И Я удаляю все элементы Справочника "SpecialOfferRules"
	И Я удаляю все элементы Справочника "SpecialOffers"

Сценарий: создаю скидку Message Dialog Box 2 (Message 3)
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Special offer type"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "External data proc"
	И в таблице "List" я перехожу к строке:
			| 'Description'                   |
			| 'ExternalSpecialMessage' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'DialogBox2'
	И в поле 'TR' я ввожу текст 'DialogBox2'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку 'Save'
	И я нажимаю на кнопку 'Set settings'
	И из выпадающего списка "Message type" я выбираю точное значение 'DialogBox'
	И в поле 'Message Description_en' я ввожу текст 'Message 3'
	И в поле 'Message Description_tr' я ввожу текст 'Message 3'
	И я нажимаю на кнопку 'Save settings'
	И я нажимаю на кнопку 'Save and close'
	И я жду закрытия окна 'DialogBox2 (Special offer types) *' в течение 20 секунд
	И я нажимаю на кнопку с именем 'FormChoose'
	И в поле 'Priority' я ввожу текст '8'
	И в поле 'Start of' я ввожу текст '01.01.2019  0:00:00'
	И из выпадающего списка "Document type" я выбираю точное значение 'Sales'
	И я изменяю флаг 'Launch'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'DialogBox2'
	И в поле 'TR' я ввожу текст 'DialogBox2'
	И я нажимаю на кнопку 'Ok'
	И в таблице "Rules" я нажимаю на кнопку с именем 'RulesAdd'
	И в таблице "Rules" я нажимаю кнопку выбора у реквизита "Rule"
	И в таблице "List" я перехожу к строке:
			| 'Description'                                |
			| 'Discount on Basic Agreements without Vat' |
	И в таблице "List" я выбираю текущую строку
	И в таблице "Rules" я завершаю редактирование строки
	И я нажимаю на кнопку 'Save and close'
	И Пауза 2
	И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'Discount 2 without Vat' |
	И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'DialogBox2' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
			| 'Priority' | 'Special offer type' |
			| '1'        | 'Sum'                |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: переношу скидку Discount 1 without Vat из группы Sum в группу Maximum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount 1 without Vat' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	И в таблице "List" я разворачиваю строку:
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '1'        | 'Special Offers'     |
	И в таблице "List" я перехожу к строке:
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '3'        | 'Maximum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: меняю ручное проведение скидки по Discount 1 without Vat
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'Discount 1 without Vat' |
	И в таблице "List" я выбираю текущую строку
	И Пауза 2
	И я устанавливаю флаг с именем 'Manually'
	И  флаг "Manually" равен "Yes"
	И я нажимаю на кнопку "Save and close"
	И Я закрываю окно 'Special offers'


Сценарий: меняю ручное проведение скидки Discount 2 without Vat
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'Discount 2 without Vat' |
	И в таблице "List" я выбираю текущую строку
	И Пауза 2
	И я устанавливаю флаг с именем 'Manually'
	И  флаг "Manually" равен "Yes"
	И я нажимаю на кнопку "Save and close"
	И Я закрываю окно 'Special offers'

Сценарий: меняю auto проведение скидки по Discount 1 without Vat
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'Discount 1 without Vat' |
	И в таблице "List" я выбираю текущую строку
	И я снимаю флаг "Manually"
	И Пауза 2
	И  флаг "Manually" равен "No"
	И я нажимаю на кнопку "Save and close"
	И Я закрываю окно 'Special offers'

Сценарий: меняю auto проведение скидки Discount 2 without Vat
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'Discount 2 without Vat' |
	И в таблице "List" я выбираю текущую строку
	И я снимаю флаг "Manually"
	И Пауза 2
	И  флаг "Manually" равен "No"
	И я нажимаю на кнопку "Save and close"
	И Я закрываю окно 'Special offers'


Сценарий: создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
			| 'Description'             |
			| 'Lomaniti' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Agreement"
	И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Basic Agreements, TRY' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Legal name"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Company Lomaniti'  |
	И в таблице "List" я выбираю текущую строку
	* Adding items to sales order
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		Тогда открылось окно 'Items'
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Dress' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XS/Blue'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		Тогда открылось окно 'Items'
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Boots' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post'


	Сценарий: создаю заказ на MIO Basic Agreements, without VAT (High shoes и Boots)
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
			| 'Description'             |
			| 'MIO' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Agreement"
	И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Basic Agreements, without VAT' |
	И в таблице "List" я выбираю текущую строку
	* Adding items to sales order
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		Тогда открылось окно 'Items'
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'High shoes' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '39/19SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '8,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		Тогда открылось окно 'Items'
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Boots' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '39/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '4,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post'

	Сценарий: создаю заказ на MIO Basic Agreements, without VAT (Trousers и Shirt)
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
			| 'Description'             |
			| 'MIO' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Agreement"
	И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Basic Agreements, without VAT' |
	И в таблице "List" я выбираю текущую строку
	* Adding items to sales order
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		Тогда открылось окно 'Items'
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Shirt' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '38/Black'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '8,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Trousers' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36/Yellow'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '4,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post'

Сценарий: создаю заказ на Kalipso Basic Agreements, without VAT, TRY (Dress и Shirt)
	И я включаю Kalipso в сегмент Retail
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.PartnerSegments'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Segment"
		Тогда открылось окно 'Partner segments'
		И в таблице "List" я перехожу к строке:
			| Description |
			| Retail      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Kalipso     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		Если появилось окно с заголовком "1C:Enterprise" Тогда
		И Я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
		| 'Description'             |
		| 'Kalipso' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Agreement"
	И в таблице "List" я перехожу к строке:
		| 'Description'                     |
		| 'Basic Agreements, without VAT' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Legal name"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Company Kalipso'  |
	И в таблице "List" я выбираю текущую строку
	* Adding items to sales order
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		Тогда открылось окно 'Items'
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Shirt' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36/Red'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		Тогда открылось окно 'Items'
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Trousers' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36/Yellow'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '12,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки


Сценарий: завершаю добавление строки в прайс лист
	И в таблице "ItemList" я завершаю редактирование строки
	И в таблице "ItemList" я нажимаю на кнопку 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"

Сценарий: изменяю номер прайс-листа
	И в поле 'Number' я ввожу текст '0'
	Тогда открылось окно '1C:Enterprise'
	И я нажимаю на кнопку 'Yes'
	Тогда открылось окно 'Price list (create) *'

Сценарий: открываю форму создания прайс листа
	И я открываю навигационную ссылку 'e1cib/list/Document.PriceList'
	И Пауза 2
	И я нажимаю на кнопку с именем 'FormCreate'
	И Пауза 2

Сценарий: переношу скидку Discount 1 without Vat из группы Maximum в группу Minimum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку "List"
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount 1 without Vat' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuLevelDown'
	И Пауза 2
	И в таблице  "List" я перехожу на один уровень вниз
	И Пауза 1
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '2'        | 'Minimum'            |
	И я нажимаю на кнопку с именем 'FormChoose'



	Сценарий: временная заглушка по реализации
		Затем Если появилось окно диалога я нажимаю на кнопку "OK"
	
	

	Сценарий: выбираю единицу измерения pcs
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Unit"
		И в таблице "List" я перехожу к строке:
		| Description |
		| pcs         |
		И в таблице "List" я выбираю текущую строку
	
	Сценарий: выбираю в заказе item Dress
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
	
	Сценарий: выбираю в заказе item Trousers
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Trousers       |
		И в таблице "List" я выбираю текущую строку


