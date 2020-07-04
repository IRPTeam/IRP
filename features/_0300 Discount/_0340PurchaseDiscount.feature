#language: ru

@Positive
@Discount
@tree

Функционал: Checking discounts in purchase documents Purchase order/Purchase invoice

As a developer
I want to add discount functionality to the purchase documents.
So you can display the amount of the vendor's discount

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий
# discount for document

Сценарий: check the Document discount in Purchase order
	* Activating discount Document discount
		И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
		И я нажимаю на кнопку 'List'
		И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'Document discount' |
		И в таблице "List" я выбираю текущую строку
		И я устанавливаю флаг 'Launch'
		И я нажимаю на кнопку 'Save and close'
	* Create Purchase order
		И я открываю форму для создания Purchase Order
			И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in the necessary details
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		* Filling in vendor's info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor Ferron, TRY |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 01'  |
			И в таблице "List" я выбираю текущую строку
		* Filling in items table
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'M/White'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			Тогда открылось окно 'Item keys'
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'L/Green'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я перехожу к строке:
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '1' | 'Dress' | 'M/White' | 'pcs' |
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '100'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я перехожу к строке:
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '2' | 'Dress' | 'L/Green'  | 'pcs' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '200'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я перехожу к строке:
				| '#' | 'Item'     | 'Item key' | 'Unit' |
				| '3' | 'Trousers' | '36/Yellow'   | 'pcs' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '300'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '250'
			И в таблице "ItemList" я завершаю редактирование строки
	* Calculate Document discount for Purchase order
		И я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я выбираю текущую строку
		И в поле 'Percent' я ввожу текст '10,00'
		И я нажимаю на кнопку 'Ok'
		И в таблице "Offers" я нажимаю на кнопку 'OK'
	* Check the discount calculation
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Q'       | 'Offers amount' | 'Unit' | 'Total amount' | 'Store'    |
		| 'Dress'    | '200,00' | 'M/White'   | '100,000' | '2 000,00'      | 'pcs'  | '18 000,00'    | 'Store 01' |
		| 'Dress'    | '210,00' | 'L/Green'   | '200,000' | '4 200,00'      | 'pcs'  | '37 800,00'    | 'Store 01' |
		| 'Trousers' | '250,00' | '36/Yellow' | '300,000' | '7 500,00'      | 'pcs'  | '67 500,00'    | 'Store 01' |
	* Check the transfer of the discount value from Purchase order to Purchase invoice when creating based on
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Purchase invoice'
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Q'       | 'Offers amount' | 'Unit' | 'Total amount' | 'Store'    |
		| 'Dress'    | '200,00' | 'M/White'   | '100,000' | '2 000,00'      | 'pcs'  | '18 000,00'    | 'Store 01' |
		| 'Dress'    | '210,00' | 'L/Green'   | '200,000' | '4 200,00'      | 'pcs'  | '37 800,00'    | 'Store 01' |
		| 'Trousers' | '250,00' | '36/Yellow' | '300,000' | '7 500,00'      | 'pcs'  | '67 500,00'    | 'Store 01' |
		И Я закрыл все окна клиентского приложения

Сценарий: check the Document discount in Purchase invoice
	* Activating discount Document discount
		И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
		И я нажимаю на кнопку 'List'
		И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'Document discount' |
		И в таблице "List" я выбираю текущую строку
		И я устанавливаю флаг 'Launch'
		И я нажимаю на кнопку 'Save and close'
	* Create Purchase invoice
		* Open form for creating Purchase invoice
			И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in vendor's info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor Ferron, TRY |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 01'  |
			И в таблице "List" я выбираю текущую строку
		* Filling in items table
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'M/White'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			Тогда открылось окно 'Item keys'
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'L/Green'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я перехожу к строке:
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '1' | 'Dress' | 'M/White' | 'pcs' |
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '100'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я перехожу к строке:
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '2' | 'Dress' | 'L/Green'  | 'pcs' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '200'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я перехожу к строке:
				| '#' | 'Item'     | 'Item key' | 'Unit' |
				| '3' | 'Trousers' | '36/Yellow'   | 'pcs' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '300'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '250'
			И в таблице "ItemList" я завершаю редактирование строки
	* Calculate Document discount for Purchase invoice
		И я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я выбираю текущую строку
		И в поле 'Percent' я ввожу текст '10,00'
		И я нажимаю на кнопку 'Ok'
		И в таблице "Offers" я нажимаю на кнопку 'OK'
	* Check the discount calculation
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Q'       | 'Offers amount' | 'Unit' | 'Total amount' | 'Store'    |
		| 'Dress'    | '200,00' | 'M/White'   | '100,000' | '2 000,00'      | 'pcs'  | '18 000,00'    | 'Store 01' |
		| 'Dress'    | '210,00' | 'L/Green'   | '200,000' | '4 200,00'      | 'pcs'  | '37 800,00'    | 'Store 01' |
		| 'Trousers' | '250,00' | '36/Yellow' | '300,000' | '7 500,00'      | 'pcs'  | '67 500,00'    | 'Store 01' |
		И Я закрыл все окна клиентского приложения

Сценарий: check that discounts with the Sales document type are not displayed in the purchase documents
	* Open Purchase Invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Checking the discount tree
		И я нажимаю на кнопку '% Offers'
		Тогда таблица "Offers" стала равной:
		| 'Presentation'      | 'Is select' | '%' | '∑' |
		| 'Document discount' | ' '         | ''  | ''  |
		И Я закрыл все окна клиентского приложения
	* Open Purchase Order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Checking the discount tree
		И я нажимаю на кнопку '% Offers'
		Тогда таблица "Offers" стала равной:
		| 'Presentation'      | 'Is select' | '%' | '∑' |
		| 'Document discount' | ' '         | ''  | ''  |
		И Я закрыл все окна клиентского приложения


Сценарий: check that discounts with the Purchase document type are not displayed in the sales documents
	* Change the type of Document discount from Purchases and sales to Purchases
		И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
		И я нажимаю на кнопку 'List'
		И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'Document discount' |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Document type" я выбираю точное значение 'Purchases'
		И я нажимаю на кнопку 'Save and close'
	* Check that the Document discount is not displayed in the Sales order document
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку '% Offers'
		Тогда таблица "Offers" не содержит строки:
		| 'Presentation'      | 'Is select' | '%' | '∑' |
		| 'Document discount' | ' '         | ''  | ''  |
		И Я закрыл все окна клиентского приложения
	* Checking that the Document discount is not displayed in the Sales invoice document
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку '% Offers'
		Тогда таблица "Offers" не содержит строки:
		| 'Presentation'      | 'Is select' | '%' | '∑' |
		| 'Document discount' | ' '         | ''  | ''  |
		И Я закрыл все окна клиентского приложения
	* Then I return the Document discount type back
		И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
		И я нажимаю на кнопку 'List'
		И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'Document discount' |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Document type" я выбираю точное значение 'Purchases and sales'
		И я нажимаю на кнопку 'Save and close'



