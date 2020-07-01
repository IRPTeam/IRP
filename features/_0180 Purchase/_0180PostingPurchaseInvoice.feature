#language: ru
@tree
@Positive


Функционал: creating document Purchase invoice

As a procurement manager
I want to create a Purchase invoice document
To track a product that has been received from a vendor

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _018001 creating document Purchase Invoice based on order - Goods receipt is not used
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '2'      |
	И в таблице "List" я выбираю текущую строку
	* Check filling of elements upon entry based on
		И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
		Тогда элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "Store" стал равен 'Store 01'
	* Filling in the main details of the document
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я выбираю текущую строку
	* Check filling items table
		И я перехожу к закладке "Item list"
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Purchase order'    | 'Item key' | 'Unit'| 'Q'       |
		| 'Dress'    | 'Purchase order 2*' | 'M/White'  | 'pcs' | '100,000' |
		| 'Dress'    | 'Purchase order 2*' | 'L/Green'  | 'pcs' | '200,000' |
		| 'Trousers' | 'Purchase order 2*' | '36/Yellow'| 'pcs' | '300,000' |
	* Check filling prices
		И     таблица "ItemList" содержит строки:
		| 'Price'  | 'Item'     | 'Item key'  | 'Q'       | 'Price type'                         | 'Store'    |
		| '200,00' | 'Dress'    | 'M/White'   | '100,000' | 'en descriptions is empty'           | 'Store 01' |
		| '210,00' | 'Dress'    | 'L/Green'   | '200,000' | 'en descriptions is empty'           | 'Store 01' |
		| '250,00' | 'Trousers' | '36/Yellow' | '300,000' | 'en descriptions is empty'           | 'Store 01' |
	* Filling in the document number 1
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	* Checking addition of the store in tabular part
		И я перехожу к закладке "Item list"
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  | 'Store'    | 'Unit' | 'Q'       |
		| 'Dress'    | 'M/White'   | 'Store 01' | 'pcs' | '100,000' |
	И я нажимаю на кнопку 'Post and close'
	

Сценарий: _018002 Checking Purchase Invoice postings by register Order Balance (minus) - Goods receipt is not used
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'            |  'Store'    | 'Order'             | 'Item key' |
		| '100,000'  | 'Purchase invoice 1*' |  'Store 01' | 'Purchase order 2*' | 'M/White'  |
		| '200,000'  | 'Purchase invoice 1*' |  'Store 01' | 'Purchase order 2*' | 'L/Green'  |
		| '300,000'  | 'Purchase invoice 1*' |  'Store 01' | 'Purchase order 2*' | '36/Yellow'|


Сценарий: _018003 Checking Purchase Invoice postings by register Stock Balance (plus) - Goods receipt is not used
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'            | 'Store'     | 'Item key' |
		| '100,000'  | 'Purchase invoice 1*' | 'Store 01'  | 'M/White'  |
		| '200,000'  | 'Purchase invoice 1*' |  'Store 01' | 'L/Green'  |
		| '300,000'  | 'Purchase invoice 1*' |  'Store 01' | '36/Yellow'|

Сценарий: _018004 Checking Purchase Invoice postings by register Stock Reservation (plus) - Goods receipt is not used
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'             | 'Store'    | 'Item key'  |
		| '100,000'  | 'Purchase invoice 1*'  |  'Store 01' | 'M/White'  |
		| '200,000'  | 'Purchase invoice 1*'  |  'Store 01' | 'L/Green'  |
		| '300,000'  | 'Purchase invoice 1*'  |  'Store 01' | '36/Yellow'|

Сценарий: _018005 Checking Purchase Invoice postings by register Inventory Balance - Goods receipt is not used
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'             |  'Company'     | 'Item key' |
		| '100,000'  | 'Purchase invoice 1*'  | 'Main Company' | 'M/White'  |
		| '200,000'  | 'Purchase invoice 1*'  | 'Main Company' | 'L/Green'  |
		| '300,000'  | 'Purchase invoice 1*'  | 'Main Company' | '36/Yellow'|

Сценарий: _018006 creating document Purchase Invoice based on order - Goods receipt is used
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '3'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
	* Check filling of elements upon entry based on
		Тогда элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, USD'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Filling in the main details of the document
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я выбираю текущую строку
	* Check filling items table
		И я перехожу к закладке "Item list"
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Purchase order'    | 'Item key' | 'Unit' | 'Q'       |
		| 'Dress'    | 'Purchase order 3*' | 'L/Green'  | 'pcs' | '500,000' |
	* Filling prices
		И     таблица "ItemList" содержит строки:
		| 'Price' | 'Item'  | 'Item key' | 'Q'       | 'Price type'               | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' |
		| '40,00' | 'Dress' | 'L/Green'  | '500,000' | 'en descriptions is empty' | 'pcs'  | '3 050,85'   | '16 949,15'  | '20 000,00'    |
	* Filling in the document number 2
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	И я нажимаю на кнопку 'Post and close'
	

Сценарий: _018007 Checking Purchase Invoice postings by register Order Balance (minus) - Goods receipt is used
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'            | 'Line number' | 'Store'    | 'Order'             | 'Item key' |
		| '500,000'  | 'Purchase invoice 2*' | '1'           | 'Store 02' | 'Purchase order 3*' | 'L/Green'  |


Сценарий: _018008 Checking Purchase Invoice postings by register Inventory Balance (plus) - Goods receipt is used
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'             | 'Line number' | 'Company'      | 'Item key' |
		| '500,000'  | 'Purchase invoice 2*'  | '1'           | 'Main Company' | 'L/Green'  |

Сценарий: _018009 Checking Purchase Invoice postings by register GoodsInTransitIncoming (plus) - Goods receipt is used
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'             | 'Receipt basis'        | 'Line number' | 'Store'    | 'Item key' |
		| '500,000'  | 'Purchase invoice 2*'  | 'Purchase invoice 2*'  | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _018010 checking that there are no postings of Purchase Invoice document by register StockBalance if used Goods receipt 
# if Goods receipt is used, there will be no posting
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки: 
		| 'Quantity' | 'Recorder'             | 'Line number' | 'Store'    | 'Item key' |
		| '500,000'  | 'Purchase invoice 2*'  | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _018011 checking that there are no postings of Purchase Invoice document by register StockReservation if used Goods receipt 
# if Goods receipt is used, there will be no posting
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'             | 'Line number' | 'Store'    | 'Item key' |
		| '500,000'  | 'Purchase invoice 2*'  | '1'           | 'Store 01' | 'L/Green'  |

Сценарий: _018012 Purchase invoice creation on set, store does not use Goods receipt
	* Creating Purchase Invoice without Purchase order	
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the main details of the document
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
	* Filling in the document number
		И в поле 'Number' я ввожу текст '5'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '5'
	* Filling in vendor information
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
			| Vendor Ferron, EUR |
		И в таблице "List" я выбираю текущую строку
	* Filling in store
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
	* Filling in items table
		И я перехожу к закладке "Item list"
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'Dress/A-8'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
		И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Boots       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key  |
			| Boots | Boots/S-8 |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '20,000'
		И в таблице "ItemList" в поле 'Price' я ввожу текст '250,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
	* Checking postings by register
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
		Тогда таблица "List" содержит строки: 
			| 'Quantity' | 'Recorder'                   | 'Store'    | 'Item key' |
			| '10,000'   | 'Purchase invoice 5*'        | 'Store 01' | 'Dress/A-8'|
			| '20,000'   | 'Purchase invoice 5*'        | 'Store 01' | 'Boots/S-8'|
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'                   | 'Store'    | 'Item key' |
			| '10,000'   | 'Purchase invoice 5*'        | 'Store 01' | 'Dress/A-8'|
			| '20,000'   | 'Purchase invoice 5*'        | 'Store 01' | 'Boots/S-8'|
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'                   | 'Item key' |
			| '10,000'   | 'Purchase invoice 5*'        | 'Dress/A-8'|
			| '20,000'   | 'Purchase invoice 5*'        | 'Boots/S-8'|


Сценарий: _018018 checking totals in the document Purchase invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	* Select Purchase Invoice
		И в таблице "List" я перехожу к строке:
		| Number |
		| 2      |
		И в таблице "List" я выбираю текущую строку
	* Checking totals
		И     элемент формы с именем "ItemListTotalNetAmount" стал равен '16 949,15'
		И     элемент формы с именем "ItemListTotalTaxAmount" стал равен '3 050,85'
		И     элемент формы с именем "ItemListTotalTotalAmount" стал равен '20 000,00'


Сценарий: _018020 checking the form Pick up items in the document Purchase invoice
	И    Я закрыл все окна клиентского приложения
	* Opening a form for creating Purchase invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the main details of the document
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
	* Filling in vendor information
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
		Тогда открылось окно 'Stores'
		И в таблице "List" я выбираю текущую строку
	Когда проверяю форму подбора товара с информацией по ценам в Purchase invoice
	И Я закрыл все окна клиентского приложения

