#language: ru

@Positive
@Discount
@tree
@SpecialOffersMaxInRow


Функционал: create order with special offer type - price type (Type joings MaxInRow, Special Offers MaxInRow)

As a sales manager
I want to check the order of discounts in the general group SpecialOffersMaxInRow, subgroup Maximum (MaxInRow).
So that discounts in the Maximum group are calculated by choosing the highest discount in the line.



Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.

# When Type joins MaxInRow in Maximum, the orders in this group with discounts will work out the discounts that are most beneficial to the client. 
# Checking the most advantageous discounts by lines.


Сценарий: _033501 change in the main group Special offers rule Minimum to Maximum by row
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'      |
		| 'Special Offers' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuChange'
	И я нажимаю на кнопку открытия поля "Special offer type"
	И я нажимаю на кнопку 'Set settings'
	Тогда открылось окно 'Special offer rules'
	И из выпадающего списка "Type joining" я выбираю точное значение 'Maximum by row'
	И я нажимаю на кнопку 'Save settings'
	И я нажимаю на кнопку 'Save and close'
	И Пауза 10
	И я нажимаю на кнопку 'Save and close'
	И Пауза 10
	И    Я закрыл все окна клиентского приложения


Сценарий: _033502 order creation discounted by price Discount Price 1 (price including VAT)
# Discount Price 1 works under the Basic Price Partner term (price includes VAT), Discount Price 2  works in parallel under this Partner term (prices lower than Discount Price 1)
# Maximum group has 2 Discount Price 1 and Discount Price 2 discounts
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
		| 'Description'             |
		| 'Ferron BP' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Legal name"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Company Ferron BP'  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Partner term"
	И в таблице "List" я перехожу к строке:
		| 'Description'                     |
		| 'Basic Partner terms, TRY' |
	И в таблице "List" я выбираю текущую строку
	* Adding items to sales order
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Dress' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
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
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Boots' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Boots (12 pcs)' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
	* Calculate Discount Price 1
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'            |
			| 'Discount Price 1' |
		И в таблице "Offers" я активизирую поле "Is select"
		И в таблице "Offers" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'           | 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs'            | '2 470,00'        |
		| 'Boots' | '8 400,00' | '36/18SD'  | 'Store 01' | '2,000' | '2 400,00'    | 'Boots (12 pcs)' | '14 400,00'       |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'         |
		| 'Ferron BP' | '16 870,00' |



Сценарий: _033503 order creation discounted by price Discount Price 2 (price including VAT)
# Discount Price 2 works under the Basic Price Partner term (price includes VAT), Discount Price 1 works in parallel under this Partner term (prices lower than Discount Price 1)
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount Price 2' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку 'Save'
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'         | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01'      | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01'      | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'         |
		| 'Lomaniti' | '2 495,00' |

	
Сценарий: _033504 check the discount order in group Maximum (manual)
# Discounted Discount Price 2
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
		| 'Description'             |
		| 'Lomaniti' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Partner term"
	И в таблице "List" я перехожу к строке:
		| 'Description'                     |
		| 'Basic Partner terms, TRY' |
	И в таблице "List" я выбираю текущую строку
	* Adding items to sales order
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Dress' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
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
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Boots' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Boots (12 pcs)' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount Price 2' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount Price 1' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'    | 'Item key' | 'Store'         | 'Q'     | 'Offers amount' | 'Unit'           | 'Total amount'    |
		| 'Dress' | '520,00'   | 'XS/Blue'  | 'Store 01'      | '5,000' | '655,00'        | 'pcs'            | '1 945,00'        |
		| 'Boots' | '8 400,00' | '36/18SD'  | 'Store 01'      | '2,000' | '3 600,00'      | 'Boots (12 pcs)' | '13 200,00'       |
	И я перехожу к закладке "Special offers"
	И таблица "SpecialOffers" стала равной:
		| 'Special offer'    | 'Amount'   |
		| 'Discount Price 2' | '655,00'   |
		| 'Discount Price 2' | '3 600,00' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'         |
		| 'Lomaniti' | '15 145,00' |

Сценарий: _033505 checking the application of discounts Discount Price 1 without Vat (price not include VAT) - manual in the group Minimum and Discount Price 2 without Vat
	Когда move the Discount 2 without Vat special offer from Maximum to Minimum
	Когда changing the manual apply of Discount 2 without Vat for test
	Когда transfer the Discount 1 without Vat discount from Maximum to Minimum.
	И Пауза 2
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
			| 'Shirt' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
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
	И я нажимаю на кнопку 'Post'
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount 1 without Vat' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	И таблица "ItemList" содержит строки:
	| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit'|
	| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02' | '10,000' | '593,20'        | 'pcs' |
	| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '12,000' | '813,60'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2


Сценарий: _033506  checking the application of discounts Discount Price 2 without Vat (price not include VAT)- manual in the group Minimum and Discount Price 1 without Vat
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
			| 'Shirt' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
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
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount 2 without Vat' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку 'Save'
	И таблица "ItemList" содержит строки:
	| 'Item'     | 'Price'  | 'Item key'  | 'Store'         | 'Q'      | 'Offers amount' | 'Unit'|
	| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02'      | '10,000' | '896,10'        | 'pcs' |
	| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02'      | '12,000' | '1 187,76'      | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	

	

Сценарий: _033507 check the discount order in group Minimum (auto)
# Discounted Discount Price without Vat 1
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
	И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'Discount 1 without Vat' |
	И в таблице "List" я выбираю текущую строку
	И я снимаю флаг "Manually"
	И Пауза 2
	И  флаг "Manually" равен "No"
	И я нажимаю на кнопку "Save and close"
	И Я закрываю окно 'Special offers'
	Когда changing the auto apply of Discount 1 without Vat
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
			| 'Shirt' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
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
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И Пауза 2
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку 'Save'
	И таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'         | 'Q'      | 'Offers amount' | 'Unit'|
		| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02'      | '10,000' | '593,20'        | 'pcs' |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02'      | '12,000' | '813,60'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	
	

Сценарий: _033508 check the discount order in group Maximum (auto)
# Discounted Discount Price without Vat 2
	Когда move Discount 2 without Vat and Discount 1 without Vat discounts from the group Minimum to the group Maximum 
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
			| 'Shirt' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
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
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку 'Save'
	И таблица "ItemList" содержит строки:
	| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit'|
	| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02' | '10,000' | '896,10'        | 'pcs' |
	| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '12,000' | '1 187,76'      | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	

Сценарий: _033509 check the discount order in group Sum (auto discount by price type + message)
# Discounted Discount Price without Vat 2 + message Special Message DialogBox
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount 1 without Vat' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	И я нажимаю на кнопку 'List'
	И Пауза 2
	И в таблице "List" я перехожу к строке:
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '1'        | 'Sum'                |
	И я нажимаю на кнопку с именем 'FormChoose'
	И в таблице "List" я перехожу к строке:
		| 'Description'                 |
		| 'Special Message DialogBox' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	И Пауза 2
	И я фиксирую текущую форму
	И я нажимаю на кнопку с именем 'FormChoose'
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
			| 'Shirt' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
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
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message 2" в течение 30 секунд
	И я нажимаю на кнопку 'Save'
	И таблица "ItemList" содержит строки:
	| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit'|
	| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02' | '10,000' | '896,10'        | 'pcs' |
	| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '12,000' | '1 187,76'      | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	

Сценарий: _033510 check the discount order in group Sum 2 auto message + price type discount
	# Discounted Discount Price without Vat 2 + Message 2 and Message 3
	Когда create discount Message Dialog Box 2 (Message 3)
	Когда changing the auto apply of Discount 1 without Vat
	Когда move the Discount 1 without Vat discount to the Sum group
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
			| 'Shirt' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
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
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message 2" в течение 30 секунд
	Затем я жду, что в сообщениях пользователю будет подстрока "Message 3" в течение 30 секунд
	И я нажимаю на кнопку 'Save'
	И таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit'|
		| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02' | '10,000' | '896,10'        | 'pcs' |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '12,000' | '1 187,76'      | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	

		

Сценарий: _033511 check the discount order in group Sum 2 auto message
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
	Когда changing the manual apply of Discount 2 without Vat for test
	Когда creating an order for MIO Basic Partner terms, without VAT (High shoes and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message 2" в течение 30 секунд
	Затем я жду, что в сообщениях пользователю будет подстрока "Message 3" в течение 30 секунд
	И я нажимаю на кнопку 'Save'
	И таблица "ItemList" содержит строки:
		| 'Item'       | 'Price'  | 'Item key' | 'Store'    | 'Offers amount' | 'Q'     | 'Unit' |
		| 'High shoes' | '462,96' | '39/19SD'  | 'Store 02' | ''              | '8,000' | 'pcs'  |
		| 'Boots'      | '601,85' | '39/18SD'  | 'Store 02' | ''              | '4,000' | 'pcs'  |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2


	

Сценарий: _033512 check the discount order in group Minimum (manual)
    # Discounted Discount Price without Vat 1
	Когда transfer Discount 2 without Vat and Discount 1 without Vat discounts from Maximum to Minimum
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
			| 'Shirt' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
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
	И таблица "ItemList" содержит строки:
	| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount' |
	| 'Shirt'    | '296,61' | '38/Black'  | 'Store 02' | '8,000' | '474,56'        | 'pcs' | '2 240,02'     |
	| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '4,000' | '271,20'        | 'pcs' | '1 279,97'     |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'MIO'         | '3 519,99' |



Сценарий: _033513 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	# also checking for an unlisted discount of Discount 2 without Vat
	Когда  move the Discount Price 1 to Maximum
	Когда transfer the Discount Price 2 discount to the Minimum group
	Когда change the priority Discount Price 1 from 1 to 3
	Когда change the priority special offer Discount Price 2 from 4 to 2
	Когда change the auto setting of the special offer Discount Price 1
	Когда change the auto setting of the Discount Price 2
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount 2 without Vat' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
	| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
	| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
	| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |


Сценарий: _033514 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	Когда change the priority Discount Price 1 to 1 
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
	| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
	| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
	| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Сценарий: _033515 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	Когда change the priority Discount Price 1 from 1 to 3
	Когда change the manual setting of the Discount Price 1 discount.
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 1' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
	| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
	| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
	| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033516 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (Discount Price 2 manual, Discount Price 1 - auto), priority Discount Price 1 lower than Discount Price 2
# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
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
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033517 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (2 auto discount), priority Discount Price 1 higher than Discount Price 2
# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	Когда  move the Discount Price 1 to Minimum
	Когда  move the Discount Price 2 special offer to Maximum
	Когда change the auto setting of the Discount Price 2
	Когда change the auto setting of the special offer Discount Price 1
	Когда change the priority Discount Price 1 from 1 to 3
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Сценарий: _033518 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (auto), priority Discount Price 1 lower than Discount Price 2
# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	Когда change the priority Discount Price 1 to 1
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' | 'Total amount' |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs'  | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs'  | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |



Сценарий: _033519 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	Когда change the manual setting of the Discount Price 1 discount.
	Когда change the auto setting of the Discount Price 2 
	Когда change the priority Discount Price 1 from 1 to 3
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 1' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Сценарий: _033520 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (Discount Price 2 manual, Discount Price 1 - auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
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
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Сценарий: _033521 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (manual), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	Когда change the priority Discount Price 1 from 1 to 3
	Когда change the manual setting of the Discount Price 1 discount.
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
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount' |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033522 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (manual), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
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
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' | 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs'  | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs'  | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033523 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	Когда  move the Discount Price 1 to Maximum
	Когда change the auto setting of the special offer Discount Price 1
	Когда change the priority Discount Price 1 from 1 to 3
	Когда move the Discount Price 2 special offer to Sum
	Когда change the auto setting of the Discount Price 2
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Сценарий: _033524 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	Когда change the priority Discount Price 1 to 1
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' | 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs'  | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs'  | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033525 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	Когда change the manual setting of the Discount Price 1 discount.
	Когда change the priority Discount Price 1 from 1 to 3
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 1' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' | 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs'  | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs'  | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Сценарий: _033526 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (manual), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
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
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Сценарий: _033527 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	Когда  move the Discount Price 1 to Minimum
	Когда change the auto setting of the special offer Discount Price 1
	Когда change the auto setting of the Discount Price 2
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033528 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	Когда change the priority Discount Price 1 to 1
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033529 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	Когда change the priority Discount Price 1 from 1 to 3
	Когда change the manual setting of the Discount Price 1 discount.
	Когда creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 1' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033530 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (Discount Price 2 manual, Discount Price 1 - auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
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
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount' |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033531 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (manual), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
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
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount' |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033532 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (manual), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
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
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |