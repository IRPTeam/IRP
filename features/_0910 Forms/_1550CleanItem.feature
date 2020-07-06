#language: ru
@tree
@Positive

Функционал: check that the item is not cleared when saving the document

As a QA
I want to check that Item (without item key) is not cleared when saving a document


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий




Сценарий: saving information about an Item without a completed item key in a document Sales order
	* Opening a document form Sales order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add Item item key
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Dress'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
	* Check saving Item
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я запоминаю значение поля с именем "Number" как "DocumentNumber"
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '$DocumentNumber$'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
	* Check the Saved Item register cleaning
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedLabel"
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'         |
			| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post and close'
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.SavedItems'
		И таблица "List" не содержит строки:
			| 'Object ref'    | 'Item'  |
			| 'Sales order*'  | 'Dress' |
		И я закрыл все окна клиентского приложения

Сценарий: saving information about an Item without a completed item key in a document Sales invoice
	* Opening a document form Sales invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add Item item key
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Dress'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
	* Check saving Item
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я запоминаю значение поля с именем "Number" как "DocumentNumber"
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '$DocumentNumber$'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
	* Check the Saved Item register cleaning
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedLabel"
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'         |
			| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post and close'
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.SavedItems'
		И таблица "List" не содержит строки:
			| 'Object ref'      | 'Item'  |
			| 'Sales invoice*'  | 'Dress' |
		И я закрыл все окна клиентского приложения

Сценарий: saving information about an Item without a completed item key in a document SalesReturn
	* Opening a document form SalesReturn
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add Item item key
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Dress'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
	* Check saving Item
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
		И я перехожу к закладке "Other"
		И я запоминаю значение поля с именем "Number" как "DocumentNumber"
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '$DocumentNumber$'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
	* Check the Saved Item register cleaning
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedLabel"
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'         |
			| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post and close'
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.SavedItems'
		И таблица "List" не содержит строки:
			| 'Object ref'     | 'Item'  |
			| 'Sales return*'  | 'Dress' |
		И я закрыл все окна клиентского приложения

Сценарий: saving information about an Item without a completed item key in a document SalesReturnOrder
	* Opening a document form SalesReturnOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add Item item key
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Dress'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
	* Check saving Item
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
		И я перехожу к закладке "Other"
		И я запоминаю значение поля с именем "Number" как "DocumentNumber"
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '$DocumentNumber$'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
	* Check the Saved Item register cleaning
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedLabel"
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'         |
			| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post and close'
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.SavedItems'
		И таблица "List" не содержит строки:
			| 'Object ref'           | 'Item'  |
			| 'Sales return order*'  | 'Dress' |
		И я закрыл все окна клиентского приложения
	
Сценарий: saving information about an Item without a completed item key in a document PurchaseOrder
	* Opening a document form PurchaseOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add Item item key
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Dress'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
	* Check saving Item
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я запоминаю значение поля с именем "Number" как "DocumentNumber"
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '$DocumentNumber$'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
	* Check the Saved Item register cleaning
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedLabel"
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
		И в таблице "ItemList" я активизирую поле "Price"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
		И я нажимаю на кнопку 'Post and close'
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.SavedItems'
		И таблица "List" не содержит строки:
			| 'Object ref'       | 'Item'  |
			| 'Purchase order*'  | 'Dress' |
		И я закрыл все окна клиентского приложения

Сценарий: saving information about an Item without a completed item key in a document PurchaseInvoice
	* Opening a document form PurchaseInvoice
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add Item item key
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Dress'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
	* Check saving Item
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
		И я перехожу к закладке "Other"
		И я запоминаю значение поля с именем "Number" как "DocumentNumber"
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '$DocumentNumber$'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
	* Check the Saved Item register cleaning
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedLabel"
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
		И в таблице "ItemList" я активизирую поле "Price"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
		И я нажимаю на кнопку 'Post and close'
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.SavedItems'
		И таблица "List" не содержит строки:
			| 'Object ref'         | 'Item'  |
			| 'Purchase invoice*'  | 'Dress' |
		И я закрыл все окна клиентского приложения

Сценарий: saving information about an Item without a completed item key in a document PurchaseReturn
	* Opening a document form PurchaseReturn
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add Item item key
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Dress'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
	* Check saving Item
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
		И я перехожу к закладке "Other"
		И я запоминаю значение поля с именем "Number" как "DocumentNumber"
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '$DocumentNumber$'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
	* Check the Saved Item register cleaning
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedLabel"
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
		И в таблице "ItemList" я активизирую поле "Price"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
		И я нажимаю на кнопку 'Post and close'
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.SavedItems'
		И таблица "List" не содержит строки:
			| 'Object ref'        | 'Item'  |
			| 'Purchase return*'  | 'Dress' |
		И я закрыл все окна клиентского приложения

Сценарий: saving information about an Item without a completed item key in a document PurchaseReturnOrder
	* Opening a document form PurchaseReturnOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add Item item key
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Dress'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
	* Check saving Item
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
		И я перехожу к закладке "Other"
		И я запоминаю значение поля с именем "Number" как "DocumentNumber"
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '$DocumentNumber$'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
	* Check the Saved Item register cleaning
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedLabel"
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
		И в таблице "ItemList" я активизирую поле "Price"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
		И я нажимаю на кнопку 'Post and close'
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.SavedItems'
		И таблица "List" не содержит строки:
			| 'Object ref'              | 'Item'  |
			| 'Purchase return order*'  | 'Dress' |
		И я закрыл все окна клиентского приложения



Сценарий: saving information about an Item without a completed item key in a document Bundling
	* Opening a document form Bundling
		И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add Item item key
		И я заполняю основные реквизиты документа
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
					| 'Description'  |
					| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Item bundle"
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Bound Dress+Shirt' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Unit"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 01'  |
			И в таблице "List" я выбираю текущую строку
			И в поле с именем 'Quantity' я ввожу текст '1,000'
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Dress'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
	* Check saving Item
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
		И я перехожу к закладке "Other"
		И я запоминаю значение поля с именем "Number" как "DocumentNumber"
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '$DocumentNumber$'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
	* Check the Saved Item register cleaning
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.SavedItems'
		И таблица "List" не содержит строки:
			| 'Object ref'   | 'Item'  |
			| 'Bundling*'    | 'Dress' |
		И я закрыл все окна клиентского приложения

Сценарий: saving information about an Item without a completed item key in a document Unbundling
	* Opening a document form Unbundling
		И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add Item item key
		И я заполняю основные реквизиты документа
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
					| 'Description'  |
					| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Item bundle"
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Bound Dress+Shirt' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Unit"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 01'  |
			И в таблице "List" я выбираю текущую строку
			И в поле с именем 'Quantity' я ввожу текст '1,000'
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Dress'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
	* Check saving Item
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
		И я перехожу к закладке "Other"
		И я запоминаю значение поля с именем "Number" как "DocumentNumber"
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '$DocumentNumber$'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
	* Check the Saved Item register cleaning
		И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedLabel"
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Bound Dress+Shirt' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item key bundle"
		И в таблице "List" я перехожу к строке:
			| 'Item key'                      |
			| 'Bound Dress+Shirt/Dress+Shirt' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Unit"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.SavedItems'
		И таблица "List" не содержит строки:
			| 'Object ref'     | 'Item'  |
			| 'Unbundling*'    | 'Dress' |
		И я закрыл все окна клиентского приложения


Сценарий: saving information about an Item without a completed item key in a document GoodsReceipt
	* Opening a document form GoodsReceipt
		И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add Item item key
		И я заполняю основные реквизиты документа
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
					| 'Description'  |
					| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'  |
			И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Dress'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
	* Check saving Item
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
		И я перехожу к закладке "Other"
		И я запоминаю значение поля с именем "Number" как "DocumentNumber"
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '$DocumentNumber$'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
	* Check the Saved Item register cleaning
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.SavedItems'
		И таблица "List" не содержит строки:
			| 'Object ref'     | 'Item'  |
			| 'GoodsReceipt*'  | 'Dress' |
		И я закрыл все окна клиентского приложения

Сценарий: saving information about an Item without a completed item key in a document ShipmentConfirmation
	* Opening a document form ShipmentConfirmation
		И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add Item item key
		И я заполняю основные реквизиты документа
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
					| 'Description'  |
					| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'  |
			И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Dress'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
	* Check saving Item
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
		И я перехожу к закладке "Other"
		И я запоминаю значение поля с именем "Number" как "DocumentNumber"
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '$DocumentNumber$'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
	* Check the Saved Item register cleaning
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.SavedItems'
		И таблица "List" не содержит строки:
			| 'Object ref'             | 'Item'  |
			| 'ShipmentConfirmation*'  | 'Dress' |
		И я закрыл все окна клиентского приложения

Сценарий: saving information about an Item without a completed item key in a document InternalSupplyRequest
	* Opening a document form InternalSupplyRequest
		И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add Item item key
		И я заполняю основные реквизиты документа
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
					| 'Description'  |
					| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 01'  |
			И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Dress'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
	* Check saving Item
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
		И я перехожу к закладке "Other"
		И я запоминаю значение поля с именем "Number" как "DocumentNumber"
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '$DocumentNumber$'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
	* Check the Saved Item register cleaning
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.SavedItems'
		И таблица "List" не содержит строки:
			| 'Object ref'              | 'Item'  |
			| 'InternalSupplyRequest*'  | 'Dress' |
		И я закрыл все окна клиентского приложения

Сценарий: saving information about an Item without a completed item key in a document InventoryTransfer
	* Opening a document form InventoryTransfer
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add Item item key
		И я заполняю основные реквизиты документа
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
					| 'Description'  |
					| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store sender"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 01'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store receiver"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'  |
			И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Dress'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
	* Check saving Item
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
		И я перехожу к закладке "Other"
		И я запоминаю значение поля с именем "Number" как "DocumentNumber"
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '$DocumentNumber$'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
	* Check the Saved Item register cleaning
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.SavedItems'
		И таблица "List" не содержит строки:
			| 'Object ref'          | 'Item'  |
			| 'InventoryTransfer*'  | 'Dress' |
		И я закрыл все окна клиентского приложения


Сценарий: saving information about an Item without a completed item key in a document InventoryTransferOrder
	* Opening a document form InventoryTransferOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add Item item key
		И я заполняю основные реквизиты документа
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
					| 'Description'  |
					| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store sender"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 01'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store receiver"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'  |
			И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Dress'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
	* Check saving Item
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
		И я перехожу к закладке "Other"
		И я запоминаю значение поля с именем "Number" как "DocumentNumber"
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '$DocumentNumber$'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'  |
			| 'Dress' |
	* Check the Saved Item register cleaning
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.SavedItems'
		И таблица "List" не содержит строки:
			| 'Object ref'               | 'Item'  |
			| 'InventoryTransferOrder*'  | 'Dress' |
		И я закрыл все окна клиентского приложения