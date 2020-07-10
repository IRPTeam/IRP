#language: ru
@tree
@Positive


Функционал: test filling-in SO - SI




Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: _29700101 preparation
	* Create customer
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Foxred'
		И я изменяю флаг 'Vendor'
		И я изменяю флаг 'Customer'
		И я нажимаю кнопку выбора у поля "Manager segment"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Region 2'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Partner segments content'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Segment"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Retail'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Company'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Company Foxred'
		И я нажимаю кнопку выбора у поля "Country"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Turkey'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
		И я нажимаю на кнопку 'Save and close'
	* Create SO
		Когда creating a test SO for VerificationPosting
	* Change number SO to 2970
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '2970'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2970'
		И я нажимаю на кнопку 'Post'
		И я закрыл все окна клиентского приложения
		

Сценарий: _29700102 test filling-in SO - SI - SC by quantity
	* Select SO 2970
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Partner' |
			| '2 970'  | 'Foxred'  |
		И в таблице "List" я выбираю текущую строку
	* Create SI based on SO
		И я нажимаю на кнопку 'Sales invoice'
		И таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'      | 'Unit' | 'Store'    | 'Sales order'        |
			| 'Dress' | 'L/Green'  | '20,000' | 'pcs'  | 'Store 02' | 'Sales order 2 970*' |
			| 'Dress' | 'M/White'  | '8,000'  | 'pcs'  | 'Store 02' | 'Sales order 2 970*' |
		* Check the prohibition of holding SI for an amount greater than specified in the order
			* Change in the second row to 12
				И в таблице "ItemList" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
				И в таблице "ItemList" я выбираю текущую строку
				И в таблице "ItemList" в поле 'Q' я ввожу текст '12,000'
				И в таблице "ItemList" я завершаю редактирование строки
			* Checking for a ban
				И я нажимаю на кнопку 'Post'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'OK'
				Затем я жду, что в сообщениях пользователю будет подстрока "Line No. [1] [Dress M/White] Ordered remains: 8 pcs Required: 12 pcs Lacks: 4 pcs" в течение 20 секунд
			* Change in quantity to original value
				И в таблице "ItemList" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
				И в таблице "ItemList" я выбираю текущую строку
				И в таблице "ItemList" в поле 'Q' я ввожу текст '8,000'
				И в таблице "ItemList" я завершаю редактирование строки
		* Check the prohibition of holding SI for an amount greater than specified in the order (копирование строки)	
			* Copy second kine
				И в таблице "ItemList" я перехожу к строке:
				| 'Item'  | 'Item key' | 'Q'     |
				| 'Dress' | 'M/White'  | '8,000' |
				И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuCopy'
			* Checking for a ban
				И я нажимаю на кнопку 'Post'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'OK'
				Затем я жду, что в сообщениях пользователю будет подстрока "Line No. [1,3] [Dress M/White] Ordered remains: 8 pcs Required: 16 pcs Lacks: 8 pcs" в течение 20 секунд
			* Delete added line
				И в таблице "ItemList" я перехожу к строке:
					| 'Item'  | 'Item key' | 'Q'     |
					| 'Dress' | 'M/White'  | '8,000' |
				И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
				И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuDelete'
		* Add an over-order line to the SI and checking post
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post'
			Тогда в окне сообщений пользователю нет сообщений
		* Create SI for closing quantity on order
			* Delete added line
				И в таблице "ItemList" я перехожу к строке:
					| 'Item'     | 'Item key'  |
					| 'Trousers' | '38/Yellow' |
				И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
				И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuDelete'
				И я нажимаю на кнопку 'Post'
			* Change the SO number to 2970
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '2970'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '2970'
				И я нажимаю на кнопку 'Post and close'
			И я закрыл все окна клиентского приложения
	

Сценарий: _29700103 test filling-in SO - SI - SC by quantity (second part)
	* Checking the SO unpost when SI is created
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner' |
		| '2 970'  | 'Foxred'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Clear posting'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		Затем я жду, что в сообщениях пользователю будет подстрока "Line No. [1] [Dress M/White] Invoiced remains: 8 pcs Required: 0 pcs Lacks: 8 pcs" в течение 20 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Line No. [2] [Dress L/Green] Invoiced remains: 20 pcs Required: 0 pcs Lacks: 20 pcs" в течение 20 секунд
	* Checking for changes in the quantity in SO when SI is created (SI is more than in SO)
		* Change the number in the second line to 19
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Dress' | 'L/Green'  | '20,000' |
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '19,000'
		* Checking for a ban
			И я нажимаю на кнопку 'Post'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'OK'
			Затем я жду, что в сообщениях пользователю будет подстрока "Line No. [2] [Dress L/Green] Invoiced remains: 20 pcs Required: 19 pcs Lacks: 1 pcs" в течение 20 секунд
	* Checking for changes in the quantity in SO when SI is created (SI is less than in SO)
		* Change the number in the second line to 21
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Dress' | 'L/Green'  | '19,000' |
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '21,000'
			И я нажимаю на кнопку 'Post'
	* Check post SO with deleted a string when SI is created (SI has this string)
		* Remove the second line
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Dress' | 'L/Green'  | '21,000' |
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuDelete'
		* Checking for a ban 
			И я нажимаю на кнопку 'Post'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'OK'
			Затем я жду, что в сообщениях пользователю будет подстрока "Line No. [] [Dress L/Green] Invoiced remains: 20 pcs Required: 0 pcs Lacks: 20 pcs" в течение 20 секунд
	* Check the addition in SO of a string that has been deleted and that is in the Sales invoice carried out 
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '20,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post'
		Тогда в окне сообщений пользователю нет сообщений
	* Create one more SI
		* Add line in SO
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post'
			Тогда в окне сообщений пользователю нет сообщений
		* Create SI on the added line
			И я нажимаю на кнопку 'Sales invoice'
			# temporarily
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Dress' | 'L/Green'  | '20,000' |
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuDelete'
			# temporarily
			И таблица "ItemList" содержит строки:
			| 'Item'     | 'Item key'   |
			| 'Trousers' | '38/Yellow'  |
			И я нажимаю на кнопку 'Post'
			Тогда в окне сообщений пользователю нет сообщений
	* Checking for a ban SI if you add a line to it (by copying) from an order for which SI has already been created (order by line is specified)
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю на кнопку 'Copy'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| '#' | 'Item'     | 'Item key'  |
			| '2' | 'Trousers' | '38/Yellow' |
		И в таблице "ItemList" я активизирую поле "Item"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '20,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		Затем я жду, что в сообщениях пользователю будет подстрока "Line No. [2] [Dress L/Green] Ordered remains: 0 pcs Required: 20 pcs Lacks: 20 pcs" в течение 20 секунд
	* Checking post SI if a line is not added to it by order
		И в таблице "ItemList" я перехожу к строке:
		| '#' | 'Item'  | 'Item key' |
		| '2' | 'Dress' | 'L/Green'  |
		И в таблице "ItemList" я нажимаю на кнопку 'Delete'
		И в таблице "ItemList" я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post'
		Тогда в окне сообщений пользователю нет сообщений
		И Я закрыл все окна клиентского приложения
	* Create Shipment confirmation by more than the quantity specified on the invoice
		* Select created SI (2970)
			И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
			И в таблице "List" я перехожу к строке:
			| 'Number' | 'Partner' |
			| '2 970'  | 'Foxred'  |
		* Create SC
			И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
			И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Store'    | 'Shipment basis'       |
			| 'Dress' | '8,000'    | 'M/White'  | 'pcs'  | 'Store 02' | 'Sales invoice 2 970*' |
			| 'Dress' | '20,000'   | 'L/Green'  | 'pcs'  | 'Store 02' | 'Sales invoice 2 970*' |
		* Change of document number
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2 970'
			И я нажимаю на кнопку 'Post'
		* Change the quantity by more than SI
			И я перехожу к закладке "Items"
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '22,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'OK'
			Дано В последнем сообщении  TestClient есть строка по шаблону "* [Dress L/Green] Invoiced remains: 20 pcs Required: 22 pcs Lacks: 2 pcs"
		* Change the quantity by less than specified in SI and post
			И я перехожу к закладке "Items"
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '19,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post'
			Тогда в окне сообщений пользователю нет сообщений
		* Add line which isn't in SI and try to post
			И я нажимаю на кнопку 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key'  |
				| 'Boots' | 'Boots/S-8' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post'
			Тогда в окне сообщений пользователю нет сообщений
		* Copy the string that is in the order and try to post
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Dress' | 'L/Green'  |
			И я нажимаю на кнопку с именем "ItemListContextMenuCopy"
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'OK'
			Дано В последнем сообщении TestClient есть строка по шаблону "* [Dress L/Green] Invoiced remains: 20 pcs Required: 38 pcs Lacks: 18 pcs"
		* Clearing the basis document from the copied line and try to post
			И в таблице "ItemList" я перехожу к последней строке
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" я нажимаю кнопку очистить у поля "Shipment basis"
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post'
			Тогда в окне сообщений пользователю нет сообщений
		* Deleting a string that has SI and try to post
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuDelete'
			И я нажимаю на кнопку 'Post'
			Тогда в окне сообщений пользователю нет сообщений
		* Create one more SC for the rest of SI
			И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
			И в таблице "List" я перехожу к строке:
				| 'Number' | 'Partner' |
				| '2 970'  | 'Foxred'  |
			И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Store'    | 'Shipment basis'       |
				| 'Dress' | '8,000'    | 'M/White'  | 'pcs'  | 'Store 02' | 'Sales invoice 2 970*' |
				| 'Dress' | '1,000'    | 'L/Green'  | 'pcs'  | 'Store 02' | 'Sales invoice 2 970*' |
			И я нажимаю на кнопку 'Post'
			Тогда в окне сообщений пользователю нет сообщений
		* Change by more than the SI balance (already created by SC) and try to post
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '9,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'OK'
			Дано В последнем сообщении TestClient есть строка по шаблону "* [Dress M/White] Invoiced remains: 8 pcs Required: 9 pcs Lacks: 1 pcs"
		* Change by less than the SI balance (already created by SC) and try to post
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'  | 'Item key' | 'Quantity' |
				| 'Dress' | 'M/White'  | '9,000'    |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '7,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post'
			Тогда в окне сообщений пользователю нет сообщений
			И я закрыл все окна клиентского приложения
		* Checking that the SI cannot be unpost when SC is created
			И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
			И в таблице "List" я перехожу к строке:
				| 'Number' | 'Partner' |
				| '2 970'  | 'Foxred'  |
			И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'OK'
			# Затем я жду, что в сообщениях пользователю будет подстрока "Line No. [1] [Dress M/White] Shipped remains: 1 pcs Required: 8 pcs Lacks: 7 pcs" в течение 20 секунд
			Дано В последнем сообщении  TestClient есть строка по шаблону "* [Dress L/Green] Shipped remains: 20 pcs Required: 0 pcs Lacks: 20 pcs"
			И я закрыл все окна клиентского приложения




Сценарий: _29700104 test filling-in SO - SI - SC in different units
	* Create SO
		Когда creating a test SO for VerificationPosting by package
	* Change the document number to 2971
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '2971'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2971'
		И я нажимаю на кнопку 'Post'
		И я закрыл все окна клиентского приложения
	* Create SI
		* Select SO 2970
			И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
			И в таблице "List" я перехожу к строке:
				| 'Number' | 'Partner' |
				| '2 971'  | 'Foxred'  |
			И в таблице "List" я выбираю текущую строку
		* Create SI based on SO
			И я нажимаю на кнопку 'Sales invoice'
			И таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key'  | 'Q'      | 'Unit'           |
			| 'Dress' | 'M/White'   | '15,000' | 'pcs'            |
			| 'Boots' | 'Boots/S-8' | '50,000' | 'pcs'            |
			| 'Boots' | 'Boots/S-8' | '2,000'  | 'Boots (12 pcs)' |
			И я нажимаю на кнопку 'Post'
	* Change in SI quantity between packages and pieces and check for post
		И в таблице "ItemList" я перехожу к строке:
		| 'Item'  | 'Item key'  | 'Q'      | 'Unit' |
		| 'Boots' | 'Boots/S-8' | '50,000' | 'pcs'  |
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '38,000'
		И в таблице "ItemList" я перехожу к строке:
		| 'Item'  | 'Item key'  | 'Q'     | 'Unit'           |
		| 'Boots' | 'Boots/S-8' | '2,000' | 'Boots (12 pcs)' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '3,000'
		И я нажимаю на кнопку 'Post'
		Тогда в окне сообщений пользователю нет сообщений
	* Change in SI quantity by shoes upside down in pieces and try to post
		И в таблице "ItemList" я перехожу к строке:
		| 'Item'  | 'Item key'  | 'Q'      | 'Unit' |
		| 'Boots' | 'Boots/S-8' | '38,000' | 'pcs'  |
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '51,000'
		И я нажимаю на кнопку 'Post'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		Затем я жду, что в сообщениях пользователю будет подстрока "Line No. [2,3] [Boots Boots/S-8] Ordered remains: 74 pcs Required: 87 pcs Lacks: 13 pcs" в течение 20 секунд
	* Change the SI quantity of shoes to a lesser side in packages and try to post
		И в таблице "ItemList" я перехожу к строке:
		| 'Item'  | 'Item key'  | 'Q'      |
		| 'Boots' | 'Boots/S-8' | '3,000' |
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И я нажимаю на кнопку 'Post'
		Тогда в окне сообщений пользователю нет сообщений
	* Change in SI quantity by shoes upside down in packs and try to post
		И в таблице "ItemList" я перехожу к строке:
		| 'Item'  | 'Item key'  | 'Q'      |
		| 'Boots' | 'Boots/S-8' | '1,000' |
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '4,000'
		И в таблице "ItemList" я перехожу к строке:
		| 'Item'  | 'Item key'  | 'Q'      |
		| 'Boots' | 'Boots/S-8' | '51,000' |
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '46,000'
		И я нажимаю на кнопку 'Post'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		Затем я жду, что в сообщениях пользователю будет подстрока "Line No. [2,3] [Boots Boots/S-8] Ordered remains: 74 pcs Required: 94 pcs Lacks: 20 pcs" в течение 20 секунд
	* Change in SI shoe quantity by which in SO
		И в таблице "ItemList" я перехожу к строке:
		| 'Item'  | 'Item key'  | 'Q'      |
		| 'Boots' | 'Boots/S-8' | '4,000' |
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я перехожу к строке:
		| 'Item'  | 'Item key'  | 'Q'      |
		| 'Boots' | 'Boots/S-8' | '46,000' |
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '50,000'
		И я нажимаю на кнопку 'Post'
		Тогда в окне сообщений пользователю нет сообщений
	* Creating SC for the quantity that in SI and checking post
		И я нажимаю на кнопку 'Shipment confirmation'
		И я нажимаю на кнопку 'Post'
		Тогда в окне сообщений пользователю нет сообщений
	* Change the quantity within SI and check post
		И в таблице "ItemList" я перехожу к строке:
		| 'Item'  | 'Item key'  | 'Quantity' |
		| 'Boots' | 'Boots/S-8' | '24,000'   |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '22,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key'  | 'Quantity' | 'Unit' |
			| 'Boots' | 'Boots/S-8' | '50,000'   | 'pcs'  |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '52,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post'
		Тогда в окне сообщений пользователю нет сообщений
	* Specification of packages and post
		И в таблице "ItemList" я перехожу к строке:
		| 'Item'  | 'Item key'  | 'Quantity' |
		| 'Boots' | 'Boots/S-8' | '22,000'   |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я активизирую поле "Unit"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Boots (12 pcs)' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key'  | 'Quantity' | 'Unit' |
			| 'Boots' | 'Boots/S-8' | '52,000'   | 'pcs'  |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '50,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post'
		Тогда в окне сообщений пользователю нет сообщений
	* Specify more packages than in SI and check post
		И в таблице "ItemList" я перехожу к строке:
		| 'Item'  | 'Item key'  | 'Quantity' |
		| 'Boots' | 'Boots/S-8' | '2,000'   |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '3,000'
		И я нажимаю на кнопку 'Post'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		Дано В последнем сообщении  TestClient есть строка по шаблону "*[Boots Boots/S-8] Invoiced remains: 74 pcs Required: 86 pcs Lacks: 12 pcs"
		И я закрыл все окна клиентского приложения








		






		


	









			















