#language: ru
@tree
@Positive


Функционал: creating document Purchase return order

As a procurement manager
I want to create a Purchase return order document
To track a product that needs to be returned to the vendor

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: _022001 creating document Purchase return order, store use Shipment confirmation based on Purchase invoice + checking status
	И    Я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '2'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentPurchaseReturnOrderGeneratePurchaseReturnOrder'
	И я проверяю заполнение реквизитов
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, USD'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	* Select store
		И я нажимаю кнопку выбора у поля "Store"
		Тогда открылось окно 'Stores'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'  |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
	И из выпадающего списка "Status" я выбираю точное значение 'Wait'
	И я перехожу к закладке "Item list"
	И в таблице "ItemList" я активизирую поле "Q"
	И в таблице "ItemList" я выбираю текущую строку
	И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
	И в таблице "ItemList" в поле 'Price' я ввожу текст '40,00'
	И в таблице "ItemList" я завершаю редактирование строки
	* Checking the addition of the store to the tabular partner
		И я перехожу к закладке "Item list"
		И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Item key' | 'Purchase invoice'    | 'Store'    | 'Unit' | 'Q'     |
		| 'Dress' | 'L/Green'  | 'Purchase invoice 2*' | 'Store 02' | 'pcs' | '2,000' |
	* Filling in the document number 1
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно
	И Я закрываю текущее окно
	* Checking for no postings in the registers
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Order'                    | 'Item key' |
			| '2,000'    | 'Purchase return order 1*' | '1'           | 'Store 02' | 'Purchase return order 1*' | 'L/Green'  |
		И Я закрываю текущее окно
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PurchaseTurnovers'
		Тогда таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'                 | 'Line number' | 'Purchase invoice'    | 'Item key' |
			| '-2,000'   | 'Purchase return order 1*' | '1'           | 'Purchase invoice 2*' | 'L/Green'  |
		И Я закрываю текущее окно
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
		Тогда таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key'  |
			| '2,000'    | 'Purchase return order 1*' | '1'           | 'Store 02' | 'L/Green'   |
		И Я закрываю текущее окно
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
		Тогда таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key'  |
			| '2,000'    | 'Purchase return order 1*'    | '1'           | 'Store 02' | 'L/Green'   |
		И    Я закрыл все окна клиентского приложения
	* And I set Approved status
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на гиперссылку "Decoration group title collapsed picture"
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю на кнопку 'Post'
	* Check history by status
		И я нажимаю на гиперссылку "History"
		Тогда таблица "List" содержит строки:
			| 'Object'                    | 'Status'   |
			| 'Purchase return order 1*' | 'Wait'     |
			| 'Purchase return order 1*' | 'Approved' |
		И я закрываю текущее окно
		И я нажимаю на кнопку 'Post and close'


Сценарий: _022002 checking postings of the document Purchase return order in the OrderBalance register (store doesn't use Shipment confirmation) 
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Order'                    | 'Item key' |
		| '2,000'    | 'Purchase return order 1*' | '1'           | 'Store 02' | 'Purchase return order 1*' | 'L/Green'  |

Сценарий: _022003 checking postings of the document Purchase return order in the OrderBalance register PurchaseTurnovers (store use Shipment confirmation)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PurchaseTurnovers'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Purchase invoice'    | 'Item key' |
		| '-2,000'   | 'Purchase return order 1*' | '1'           | 'Purchase invoice 2*' | 'L/Green'  |

Сценарий: _022004 checking postings of the document Purchase return order in the OrderReservation register (store use Shipment confirmation)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key'  |
	| '2,000'    | 'Purchase return order 1*' | '1'           | 'Store 02' | 'L/Green'   |

Сценарий: _022005 checking postings of the document Purchase return order in the StockReservation register (store use Shipment confirmation)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key'  |
	| '2,000'    | 'Purchase return order 1*'    | '1'           | 'Store 02' | 'L/Green'   |


Сценарий: _022006 creating document Purchase return order, store doesn't use Shipment confirmation, based on Purchase invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentPurchaseReturnOrderGeneratePurchaseReturnOrder'
	* Check filling details
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	* Filling in the main details of the document
		И я нажимаю кнопку выбора у поля "Store"
		Тогда открылось окно 'Stores'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
	И из выпадающего списка "Status" я выбираю точное значение 'Approved'
	И я перехожу к закладке "Item list"
	И в таблице "ItemList" я перехожу к строке:
		| 'Item'     | 'Item key'  | 'Unit' |
		| 'Trousers'    | '36/Yellow'   | 'pcs' |
	И в таблице "ItemList" я выбираю текущую строку
	И Пауза 2
	И в таблице "ItemList" в поле 'Q' я ввожу текст '3,000'
	И Пауза 2
	И в таблице "ItemList" я завершаю редактирование строки
	И в таблице "ItemList" я перехожу к строке:
		| 'Item'     | 'Item key'  | 'Unit' |
		| 'Dress'    | 'L/Green'   | 'pcs' |
	И Пауза 2
	И в таблице 'ItemList' я удаляю строку
	И в таблице "ItemList" я перехожу к строке:
		| 'Item'     | 'Item key'  | 'Unit' |
		| 'Dress'    | 'M/White'   | 'pcs' |
	И в таблице 'ItemList' я удаляю строку
	* Filling in the document number 2
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно

Сценарий: _022007 checking postings of the document Purchase return order in the OrderBalance (store doesn't use Shipment confirmation)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Order'                    | 'Item key' |
		| '3,000'    | 'Purchase return order 2*' | '1'           | 'Store 01' | 'Purchase return order 2*' | '36/Yellow'  |

Сценарий: _022008 checking postings of the document Purchase return order in the PurchaseTurnovers (store doesn't use Shipment confirmation)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PurchaseTurnovers'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'                 | 'Line number' | 'Purchase invoice'    | 'Item key' |
	| '-3,000'   | 'Purchase return order 2*' | '1'           | 'Purchase invoice 1*' | '36/Yellow'  |

Сценарий: _022009 checking postings of the document Purchase return order in the PurchaseTurnovers (store doesn't use Shipment confirmation)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key'  |
	| '3,000'    | 'Purchase return order 2*' | '1'           | 'Store 01' | '36/Yellow'   |

Сценарий: _022010 checking postings of the document Purchase return order in the StockReservation (store doesn't use Shipment confirmation)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key'  |
	| '3,000'    | 'Purchase return order 2*'    | '1'           | 'Store 01' | '36/Yellow'   |


Сценарий: _022016 checking totals in the document Purchase return order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
	И я выбираю документ PurchaseReturnOrder
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И в таблице "List" я выбираю текущую строку
	* Checking totals in the document Purchase return order
		И     у элемента формы с именем "ItemListTotalTaxAmount" текст редактирования стал равен '12,20'
		И     у элемента формы с именем "ItemListTotalNetAmount" текст редактирования стал равен '67,80'
		И     у элемента формы с именем "ItemListTotalTotalAmount" текст редактирования стал равен '80,00'



