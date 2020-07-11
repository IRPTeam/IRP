#language: ru
@tree
@Positive


Функционал: register changes when documents are changed 

As a Developer
I want to develop a system to check if the postings need to be changed when documents are changed.
In order not to double entries in the registers

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.



Сценарий: _019901 Checking changes in postings on a Purchase Order document when quantity changes
	Когда creating a Purchase Order document
	Когда change purchase order number to 103
	* Checking registry entries (Order Balance)
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'            | 'Store'    | 'Order'             | 'Item key'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'S/Yellow'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'XS/Blue'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'M/White'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'XL/Green'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/Yellow' |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/Yellow' |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/Red'    |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/Black'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/18SD'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '37/18SD'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/18SD'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '39/18SD'   |
		И Я закрыл все окна клиентского приложения
	* Changing the quantity by Item Dress 'S/Yellow' by 250 pcs
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И Пауза 2
		И в таблице "List" я перехожу к строке:
			| 'Number'    |
			| '103' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Q'        | 'Unit' |
			| 'Dress' | 'S/Yellow' | '200,000'  | 'pcs' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '250,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
	* Checking registry entries (Order Balance)
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key'  |
			| '250,000'  | 'Purchase order 103*' | '1'           | 'Store 03' | 'Purchase order 103*' | 'S/Yellow'  |
		Тогда таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key'  |
			| '200,000'  | 'Purchase order 103*' | '1'           | 'Store 03' | 'Purchase order 103*' | 'S/Yellow'  |
	
Сценарий: _019902 delete line in Purchase order and chek postings changes
	* Delete last line in the order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И Пауза 2
		И в таблице "List" я перехожу к строке:
			| 'Number'    |
			| '103' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я перехожу к последней строке
		И в таблице "ItemList" я удаляю текущую строку
		И я нажимаю на кнопку 'Post and close'
	* Checking registry entries (Order Balance)
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'            | 'Store'    | 'Order'             | 'Item key'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '39/18SD'   |
	
Сценарий: _019903 add line in Purchase order and chek postings changes
	* Add line in the order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number'    |
			| '103' |
		И Пауза 2
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '39/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Boots' | '39/18SD'  | 'pcs' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '100,000'
		И в таблице "ItemList" в поле 'Price' я ввожу текст '195,00'
		И в таблице "ItemList" в поле 'Store' я ввожу текст 'Store 03'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'High shoes'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '39/19SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'       | 'Item key' | 'Unit' |
			| 'High shoes' | '39/19SD'  | 'pcs' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '50,000'
		И в таблице "ItemList" в поле 'Price' я ввожу текст '190,00'
		И в таблице "ItemList" в поле 'Store' я ввожу текст 'Store 03'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
	* Checking registry entries (Order Balance)
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key'  |
			| '100,000'  | 'Purchase order 103*' | '12'          | 'Store 03' | 'Purchase order 103*' | '39/18SD'   |
			| '50,000'   | 'Purchase order 103*' | '13'          | 'Store 03' | 'Purchase order 103*' | '39/19SD'   |
	
Сценарий: _019904 add package in Purchase order and chek postings (conversion to storage unit)
	* Add package in the order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number'    |
			| '103' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я перехожу к последней строке
		И в таблице "ItemList" я удаляю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'High shoes'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '39/19SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
		И в таблице "List" я перехожу к строке:
			| 'Description'               |
			| 'High shoes box (8 pcs)' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Store' я ввожу текст 'Store 03'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'       | 'Item key' | 'Unit' |
			| 'High shoes' | '39/19SD'  | 'High shoes box (8 pcs)' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
		И в таблице "ItemList" в поле 'Price' я ввожу текст '190,00'
		И в таблице "ItemList" в поле 'Store' я ввожу текст 'Store 03'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
	* Checking registry entries (Order Balance)
	# Packages are converted into pcs.
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key'  |
			| '80,000'   | 'Purchase order 103*' | '13'          | 'Store 03' | 'Purchase order 103*' | '39/19SD'   |
	
Сценарий: _019905 mark for deletion document Purchase Order and check cancellation of postings
	* Mark for deletion document Purchase Order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
		| 'Number'    |
		| '103' |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuSetDeletionMark'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
	* Checking registry entries (Order Balance)
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'            | 'Store'    | 'Order'             | 'Item key'  |
			| '250,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'S/Yellow'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'XS/Blue'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'M/White'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'XL/Green'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/Yellow' |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/Yellow' |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/Red'    |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/Black'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/18SD'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '37/18SD'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/18SD'   |
			| '100,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '39/18SD'   |
			| '80,000'   | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '39/19SD'   |
 
Сценарий: _019906 post a document previously marked for deletion and check of postings
	* Post a document previously marked for deletion
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
		| 'Number'    |
		| '103' |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuSetDeletionMark'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
	* Checking registry entries (Order Balance)
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'            | 'Store'    | 'Order'             | 'Item key'  |
			| '250,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'S/Yellow'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'XS/Blue'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'M/White'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'XL/Green'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/Yellow' |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/Yellow' |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/Red'    |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/Black'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/18SD'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '37/18SD'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/18SD'   |
			| '100,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '39/18SD'   |
			| '80,000'   | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '39/19SD'   |
		И Я закрываю текущее окно


Сценарий: _019907 clear posting document Purchase Order and check cancellation of postings
	* Clear posting document Purchase Order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
		| 'Number'    |
		| '103' |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И Я закрываю текущее окно
	* Checking registry entries (Order Balance)
		И Пауза 5
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		И таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'          |
			| '250,000'  | 'Purchase order 103*' |
			| '200,000'  | 'Purchase order 103*' |
		И Я закрываю текущее окно
	* Post a document with previously cleared postings
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
		| 'Number'    |
		| '103' |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И Я закрываю текущее окно
	* Checking registry entries (Order Balance)
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'            | 'Store'    | 'Order'             | 'Item key'  |
			| '250,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'S/Yellow'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'XS/Blue'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'M/White'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'XL/Green'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/Yellow' |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/Yellow' |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/Red'    |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/Black'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/18SD'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '37/18SD'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/18SD'   |
			| '100,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '39/18SD'   |
			| '80,000'   | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '39/19SD'   |
		И Я закрываю текущее окно
	
Сценарий: _019908 create Purchase invoice and Goods receipt based on a Purchase order with that contains packages
	# Packages are converted into pcs.
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	И в таблице "List" я перехожу к строке:
		| 'Number'    |
		| '103' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
	И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
	И я нажимаю кнопку выбора у поля "Company"
	И я нажимаю на кнопку с именем 'FormChoose'
	И я нажимаю кнопку выбора у поля "Store"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Store 03'  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку "Post"
	И я провожу приходный ордер
		И я нажимаю на кнопку с именем "FormDocumentGoodsReceiptGenerateGoodsReceipt"
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 03'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post and close'
	И я закрываю текущее окно