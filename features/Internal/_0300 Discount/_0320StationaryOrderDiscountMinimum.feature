#language: ru
@Positive
@Discount
@SpecialOffersMinimum


Функционал: calculation of discounts in a group Minimum (type joings Minimum, Special Offers MaxInRow)

As a sales manager
I want to check the order of discounts in the general group SpecialOffersMaxInRow, subgroup Minimum.
So that discounts in the Minimal group are calculated by choosing the lowest discount in the line.


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.

# Checking the discount calculation in the group Minimum created inside the group Minimum, which is in the group Maximum
# With Type joins Minimum, discounts in this group will work out the discounts that are least beneficial to the client. 
# Checking for overall discounts on orders (not on lines). 
# Discounts that are outside the group are at least checked by lines and applied according to the rule "most advantageous to the client". 


Сценарий: _032001 discount calculation Discount 2 without Vat in the group Sum in Minimum and Discount 1 without Vat in the group Minimum (manual)
	# Discounted Discount 1 without Vat
	Когда move the group Sum in Minimum to Minimum
	Когда move the Discount 1 without Vat discount to the Sum in Minimum group
	Когда move the Discount 1 without Vat discount to Minimum
	И я включаю Kalipso в сегмент Retail
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.PartnerSegments'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Segment"
		
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
		| 'MIO' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Partner term"
	И в таблице "List" я перехожу к строке:
		| 'Description'                     |
		| 'Basic Partner terms, without VAT' |
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
			| '38/Black'  |
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
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount 1 without Vat' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount 2 without Vat' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку 'Save'
	И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'     | 'Offers amount' |
		| 'Shirt'    | '296,61' | '38/Black'  | 'Store 02' | '8,000' | '474,56'        |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '4,000' | '271,20'        |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'        |
		| 'MIO'       | '3 519,99' |
		| 'MIO'       | '3 519,99' |

Сценарий: _032002 discount calculation Discount 2 without Vat in the group Sum in Minimum и Discount 1 without Vat in the group Minimum (auto)
	# Discounted Discount 1 without Vat
	Когда changing the auto apply of Discount 1 without Vat
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
	И я включаю Kalipso в сегмент Retail
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.PartnerSegments'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Segment"
		
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
		| 'MIO' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Partner term"
	И в таблице "List" я перехожу к строке:
		| 'Description'                     |
		| 'Basic Partner terms, without VAT' |
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
			| '38/Black'  |
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
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку 'Save'
	И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'     | 'Offers amount' |
		| 'Shirt'    | '296,61' | '38/Black'  | 'Store 02' | '8,000' | '474,56'        |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '4,000' | '271,20'        |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'        |
		| 'MIO'       | '3 519,99' |
		| 'MIO'       | '3 519,99' |
		| 'MIO'       | '3 519,99' |


Сценарий: _032003 discount calculation Discount 2 without Vat in the main group Special Offers, Discount 1 without Vat in the group Sum in Minimum (auto)
	# Discounted Discount 2 without Vat
	Когда move the Discount 2 without Vat discount to Special Offers
	И я включаю Kalipso в сегмент Retail
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.PartnerSegments'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Segment"
		
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
		| 'MIO' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Partner term"
	И в таблице "List" я перехожу к строке:
		| 'Description'                     |
		| 'Basic Partner terms, without VAT' |
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
			| '38/Black'  |
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
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount 2 without Vat' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку 'Save'
	И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
		| 'Shirt'    | '296,61' | '38/Black'  | 'Store 02' | '8,000' | '716,88'        | 'pcs' |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '4,000' | '395,92'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'        |
		| 'MIO'       | '3 086,88' |
	
	

Сценарий: _032004 discount calculation Discount 1 without Vat in the main group Special Offers, Discount 2 without Vat in the group Sum in Minimum (auto)
	# Discounted Discount 2 without Vat
	Когда move the Discount 1 without Vat discount to the Sum in Minimum group
	Когда move Discount 1 without Vat в Special Offers
	И я включаю Kalipso в сегмент Retail
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.PartnerSegments'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Segment"
		
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
		| 'MIO' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Partner term"
	И в таблице "List" я перехожу к строке:
		| 'Description'                     |
		| 'Basic Partner terms, without VAT' |
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
			| '38/Black'  |
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
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount 2 without Vat' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку 'Save'
	И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'     | 'Offers amount' |
		| 'Shirt'    | '296,61' | '38/Black'  | 'Store 02' | '8,000' | '716,88'        |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '4,000' | '395,92'        |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'        |
		| 'MIO'       | '3 086,88' |
		| 'MIO'       | '3 086,88' |


# Procedure for calculating discounts in the main group Minimum


Сценарий: _032005 change Special offers main group Maximum by row to Minimum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'      |
		| 'Special Offers' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuChange'
	И я нажимаю на кнопку открытия поля "Special offer type"
	И я нажимаю на кнопку 'Set settings'
	Тогда открылось окно 'Special offer rules'
	И из выпадающего списка "Type joining" я выбираю точное значение 'Minimum'
	И я нажимаю на кнопку 'Save settings'
	И я нажимаю на кнопку 'Save and close'
	И Пауза 10
	И я нажимаю на кнопку 'Save and close'
	И Пауза 10
	И    Я закрыл все окна клиентского приложения

Сценарий: _032006 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification (auto)
	И  Я закрыл все окна клиентского приложения
	Когда  move the Discount Price 1 to Maximum
	Когда transfer the Discount Price 2 discount to the Minimum group
	Когда change the priority Discount Price 1 from 1 to 3
	Когда change the priority special offer Discount Price 2 from 4 to 2
	Когда change the auto setting of the special offer Discount Price 1
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
	

Сценарий: _032007 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда change the priority Discount Price 1 to 1 
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|


Сценарий: _032008 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда change the priority Discount Price 1 from 1 to 3
	Когда change the manual setting of the Discount Price 1 discount.
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 1' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|



Сценарий: _032009 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (Discount Price 2 manual, Discount Price 1 - auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
		Когда change the priority Discount Price 1 to 1
		Когда change the Discount Price 2 manual
		Когда change the auto setting of the special offer Discount Price 1
		Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                  |
			| 'Discount Price 2' |
		И в таблице "Offers" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
		Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
			| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
			| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
		И я нажимаю на кнопку "Post and close"
		И Пауза 2
		И таблица 'List' содержит строки
			| 'Partner'   | 'Σ'     |
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032010 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (auto назначение 2-х скидок), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
		Когда  move the Discount Price 1 to Minimum
		Когда  move the Discount Price 2 special offer to Maximum
		Когда change the auto setting of the Discount Price 2
		Когда change the auto setting of the special offer Discount Price 1
		Когда change the priority Discount Price 1 from 1 to 3
		Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И я нажимаю на кнопку 'OK'
		Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
			| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
			| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
		И я нажимаю на кнопку "Post and close"
		И Пауза 2
		И таблица 'List' содержит строки
			| 'Partner'   | 'Σ'     |
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|


Сценарий: _032011 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
		Когда change the priority Discount Price 1 to 1
		Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И я нажимаю на кнопку 'OK'
		Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
			| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
			| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
		И я нажимаю на кнопку "Post and close"
		И Пауза 2
		И таблица 'List' содержит строки
			| 'Partner'   | 'Σ'     |
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|


Сценарий: _032012 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда change the manual setting of the Discount Price 1 discount.
	Когда change the priority Discount Price 1 from 1 to 3
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 1' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|


Сценарий: _032013 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (Discount Price 2 manual, Discount Price 1 - auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда change the priority Discount Price 1 to 1
	Когда change the auto setting of the special offer Discount Price 1
	Когда change the Discount Price 2 manual
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 2' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|


Сценарий: _032014 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (manual), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда change the priority Discount Price 1 from 1 to 3
	Когда change the manual setting of the Discount Price 1 discount.
	Когда change the Discount Price 2 manual
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 2' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount Price 1' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032015 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (manual), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда change the priority Discount Price 1 to 1
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 2' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount Price 1' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032016 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда  move the Discount Price 1 to Maximum
	Когда change the auto setting of the special offer Discount Price 1
	Когда change the priority Discount Price 1 from 1 to 3
	Когда move the Discount Price 2 special offer to Sum
	Когда change the auto setting of the Discount Price 2
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И Пауза 2
	И я нажимаю на кнопку "Post and close"
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032017 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда change the priority Discount Price 1 to 1
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032018 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда change the manual setting of the Discount Price 1 discount.
	Когда change the priority Discount Price 1 from 1 to 3
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 1' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|


Сценарий: _032019 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (manual), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда change the Discount Price 2 manual
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 2' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount Price 1' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032020 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда  move the Discount Price 1 to Minimum
	Когда change the auto setting of the special offer Discount Price 1
	Когда change the auto setting of the Discount Price 2
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|


Сценарий: _032021 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда change the priority Discount Price 1 to 1
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032022 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда change the priority Discount Price 1 from 1 to 3
	Когда change the manual setting of the Discount Price 1 discount.
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 1' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032023 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (Discount Price 2 manual, Discount Price 1 - auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда change the Discount Price 2 manual
	Когда change the auto setting of the special offer Discount Price 1
	Когда change the priority Discount Price 1 to 1
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 2' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032024 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (manual), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда change the manual setting of the Discount Price 1 discount.
	Когда change the priority Discount Price 1 from 1 to 3
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 2' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount Price 1' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032025 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (manual), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда change the priority Discount Price 1 to 1
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 2' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount Price 1' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|










