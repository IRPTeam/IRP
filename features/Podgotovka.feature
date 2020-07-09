#language: ru
@ExportScenarios
@IgnoreOnCIMainBuild
@tree

Функционал: export scenarios

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.




Сценарий: filling in customer data in the order (Ferron BP, store 01)
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Partner term"
	Тогда открылось окно 'Partner terms'
	И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Basic Partner terms, TRY' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Legal name"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Company Ferron BP'  |
	И в таблице "List" я выбираю текущую строку




Сценарий: cleaning discounts
	И Я удаляю все элементы Справочника "ExternalDataProc"
	И Я удаляю все элементы Справочника "SpecialOfferTypes"
	И Я удаляю все элементы Справочника "SpecialOfferRules"
	И Я удаляю все элементы Справочника "SpecialOffers"

Сценарий: create discount Message Dialog Box 2 (Message 3)
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Special offer type"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Plugins"
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
			| 'Discount on Basic Partner terms without Vat' |
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

Сценарий: transfer the discount Discount 1 without Vat from Sum to Maximum
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



Сценарий: changing the auto apply of Discount 1 without Vat for test
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

Сценарий: changing the auto apply of Discount 2 without Vat
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




	Сценарий: creating an order for MIO Basic Partner terms, without VAT (High shoes and Boots)
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
			| 'Description'             |
			| 'MIO' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Partner term"
	И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Basic Partner terms, without VAT' |
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


Сценарий: finishing adding a line to the price list
	И в таблице "ItemList" я завершаю редактирование строки
	И в таблице "ItemList" я нажимаю на кнопку 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"


Сценарий: open the form to create a price list
	И я открываю навигационную ссылку 'e1cib/list/Document.PriceList'
	И Пауза 2
	И я нажимаю на кнопку с именем 'FormCreate'
	И Пауза 2

Сценарий: transfer the Discount 1 without Vat discount from Maximum to Minimum.
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





	Сценарий: choose the unit of measurement pcs
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Unit"
		И в таблице "List" я перехожу к строке:
		| Description |
		| pcs         |
		И в таблице "List" я выбираю текущую строку
	

