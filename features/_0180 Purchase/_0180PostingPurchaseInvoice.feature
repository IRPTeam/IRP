#language: ru
@tree
@Positive


Функционал: проведение документа Поступление  по регистрам складского учета

Как Разработчик
Я хочу создать проводки документа поступления товара
Для того чтобы фиксировать какой товар получен

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _018001 создание документа поступления (Purchase Invoice) на основании заказа - неордерная схема
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-183' с именем 'IRP-183'
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '2'      |
	И в таблице "List" я выбираю текущую строку
	И я проверяю заполнение элементов при вводе на основании
		И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
		Тогда элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "Store" стал равен 'Store 01'
	И я заполняю необходимые реквизиты
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я выбираю текущую строку
	И я проверяю заполнение товарной части
		И я перехожу к закладке "Item list"
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Purchase order'    | 'Item key' | 'Unit'| 'Q'       |
		| 'Dress'    | 'Purchase order 2*' | 'M/White'  | 'pcs' | '100,000' |
		| 'Dress'    | 'Purchase order 2*' | 'L/Green'  | 'pcs' | '200,000' |
		| 'Trousers' | 'Purchase order 2*' | '36/Yellow'| 'pcs' | '300,000' |
	* Проверка заполнения цен
		И     таблица "ItemList" содержит строки:
		| 'Price'  | 'Item'     | 'Item key'  | 'Q'       | 'Price type'                         | 'Store'    |
		| '200,00' | 'Dress'    | 'M/White'   | '100,000' | 'en descriptions is empty'           | 'Store 01' |
		| '210,00' | 'Dress'    | 'L/Green'   | '200,000' | 'en descriptions is empty'           | 'Store 01' |
		| '250,00' | 'Trousers' | '36/Yellow' | '300,000' | 'en descriptions is empty'           | 'Store 01' |
	И я устанавливаю номер документа 1
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	И я проверяю добавление склада в табличную часть
		# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-227' с именем 'IRP-227'
		И я перехожу к закладке "Item list"
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  | 'Store'    | 'Unit' | 'Q'       |
		| 'Dress'    | 'M/White'   | 'Store 01' | 'pcs' | '100,000' |
	И я нажимаю на кнопку 'Post and close'
	

Сценарий: _018002 проверка проводок по документу Purchase Invoice по регистру Order Balance (минус) - неордерная схема
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-184' с именем 'IRP-184'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'            |  'Store'    | 'Order'             | 'Item key' |
		| '100,000'  | 'Purchase invoice 1*' |  'Store 01' | 'Purchase order 2*' | 'M/White'  |
		| '200,000'  | 'Purchase invoice 1*' |  'Store 01' | 'Purchase order 2*' | 'L/Green'  |
		| '300,000'  | 'Purchase invoice 1*' |  'Store 01' | 'Purchase order 2*' | '36/Yellow'|


Сценарий: _018003 проверка проводок по документу Purchase Invoice по регистру Stock Balance (плюс) - неордерная схема
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-184' с именем 'IRP-184'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'            | 'Store'     | 'Item key' |
		| '100,000'  | 'Purchase invoice 1*' | 'Store 01'  | 'M/White'  |
		| '200,000'  | 'Purchase invoice 1*' |  'Store 01' | 'L/Green'  |
		| '300,000'  | 'Purchase invoice 1*' |  'Store 01' | '36/Yellow'|

Сценарий: _018004 проверка проводок по документу Purchase Invoice по регистру Stock Reservation (плюс) - неордерная схема
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-184' с именем 'IRP-184'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'             | 'Store'    | 'Item key'  |
		| '100,000'  | 'Purchase invoice 1*'  |  'Store 01' | 'M/White'  |
		| '200,000'  | 'Purchase invoice 1*'  |  'Store 01' | 'L/Green'  |
		| '300,000'  | 'Purchase invoice 1*'  |  'Store 01' | '36/Yellow'|

Сценарий: _018005 проверка проводок по документу Purchase Invoice по регистру Inventory Balance - неордерная схема
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-184' с именем 'IRP-184'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'             |  'Company'     | 'Item key' |
		| '100,000'  | 'Purchase invoice 1*'  | 'Main Company' | 'M/White'  |
		| '200,000'  | 'Purchase invoice 1*'  | 'Main Company' | 'L/Green'  |
		| '300,000'  | 'Purchase invoice 1*'  | 'Main Company' | '36/Yellow'|

Сценарий: _018006 создание документа поступления (Purchase Invoice) на основании заказа - ордерная схема
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-183' с именем 'IRP-183'
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '3'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
	И я проверяю заполнение элементов при вводе на основании
		Тогда элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, USD'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	И я заполняю необходимые реквизиты
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я выбираю текущую строку
	И я проверяю заполнение товарной части
		И я перехожу к закладке "Item list"
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Purchase order'    | 'Item key' | 'Unit' | 'Q'       |
		| 'Dress'    | 'Purchase order 3*' | 'L/Green'  | 'pcs' | '500,000' |
	И я указываю цены
		И     таблица "ItemList" содержит строки:
		| 'Price' | 'Item'  | 'Item key' | 'Q'       | 'Price type'               | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' |
		| '40,00' | 'Dress' | 'L/Green'  | '500,000' | 'en descriptions is empty' | 'pcs'  | '3 050,85'   | '16 949,15'  | '20 000,00'    |
	И я устанавливаю номер документа 2
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	И я нажимаю на кнопку 'Post and close'
	

Сценарий: _018007 проверка проводок по документу Purchase Invoice по регистру Order Balance (минус) - ордерная схема
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-184' с именем 'IRP-184'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'            | 'Line number' | 'Store'    | 'Order'             | 'Item key' |
		| '500,000'  | 'Purchase invoice 2*' | '1'           | 'Store 02' | 'Purchase order 3*' | 'L/Green'  |


Сценарий: _018008 проверка проводок по документу Purchase Invoice по регистру Inventory Balance (плюс) - ордерная схема
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-184' с именем 'IRP-184'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'             | 'Line number' | 'Company'      | 'Item key' |
		| '500,000'  | 'Purchase invoice 2*'  | '1'           | 'Main Company' | 'L/Green'  |

Сценарий: _018009 проверка проводок по документу Purchase Invoice по регистру GoodsInTransitIncoming (плюс) - ордерная схема
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-184' с именем 'IRP-184'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'             | 'Receipt basis'        | 'Line number' | 'Store'    | 'Item key' |
		| '500,000'  | 'Purchase invoice 2*'  | 'Purchase invoice 2*'  | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _018010 проверка отсутствия проводок по документу Purchase Invoice при ордерной схеме по регистру StockBalance
# при ордерной схеме движения не делает
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-184' с именем 'IRP-184'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки: 
		| 'Quantity' | 'Recorder'             | 'Line number' | 'Store'    | 'Item key' |
		| '500,000'  | 'Purchase invoice 2*'  | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _018011 проверка отсутствия проводок по документу Purchase Invoice при ордерной схеме по регистру StockReservation
# при ордерной схеме движения не делает
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-184' с именем 'IRP-184'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'             | 'Line number' | 'Store'    | 'Item key' |
		| '500,000'  | 'Purchase invoice 2*'  | '1'           | 'Store 01' | 'L/Green'  |

Сценарий: _018012 проверка поступления и учета по регистрам сета/размерной сетки (неделимой упаковки) неордерный склад
	И я создаю документ Purchase Invoice без заказа	
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	И я заполняю необходимые реквизиты
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
	И я меняю номер документа
		И в поле 'Number' я ввожу текст '5'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '5'
	И я заполняю информацию о поставщике
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
	И я заполняю склад
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
	И я заполняю товарную часть
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
	И я проверяю движение по регистрам
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


Сценарий: _018018 проверка наличия итогов в документе Purchase Invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	И я выбираю документ PurchaseInvoice
		И в таблице "List" я перехожу к строке:
		| Number |
		| 2      |
		И в таблице "List" я выбираю текущую строку
	И я проверяю наличие итогов документа
		И     элемент формы с именем "ItemListTotalNetAmount" стал равен '16 949,15'
		И     элемент формы с именем "ItemListTotalTaxAmount" стал равен '3 050,85'
		И     элемент формы с именем "ItemListTotalTotalAmount" стал равен '20 000,00'


Сценарий: _018020 проверка формы подбора товара в документе Purchase invoice
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-381' с именем 'IRP-381'
# необходимо дописать на проверку цен поставщика. Должны подтягиваться из соглашения
	И    Я закрыл все окна клиентского приложения
	И я открываю форму для создания Purchase invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	И я заполняю необходимые реквизиты
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
	И я заполняю информацию о поставщике
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

