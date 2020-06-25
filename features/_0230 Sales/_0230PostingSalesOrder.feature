#language: ru
@tree
@Positive
Функционал: creating document Sales order

As a sales manager
I want to create a Sales order document
To track the items ordered by the customer

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _023001 creating document Sales order - Shipment confirmation is not used
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда заполняю данные о клиенте в заказе (Ferron BP, склад 01)
	* Filling in items table
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'L/Green'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		Когда выбираю в заказе item Trousers
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '4,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
	* Checking store filling in the tabular section
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    |
		| 'Dress'    | '550,00' | 'L/Green'   | 'Store 01' |
	* Checking default sales order status
		И я перехожу к закладке "Other"
		И     элемент формы с именем "Status" стал равен 'Approved'
	* Filling Delivery date
		И в поле с именем 'DeliveryDate' я ввожу текущую дату
	И я нажимаю на кнопку 'Post and close'

Сценарий: _023002 checking Sales Order posting by register OrderBalance (+)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'       | 'Store'    | 'Order'          | 'Item key' |
	| '5,000'    | 'Sales order 1*' | 'Store 01' | 'Sales order 1*' | 'L/Green'  |
	| '4,000'    | 'Sales order 1*' | 'Store 01' | 'Sales order 1*' | '36/Yellow'   |

Сценарий: _023003 checking Sales Order posting by register StockReservation (-)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'       | 'Store'    | 'Item key' |
	| '5,000'    | 'Sales order 1*' | 'Store 01' | 'L/Green'  |
	| '4,000'    | 'Sales order 1*' | 'Store 01' | '36/Yellow'   |

Сценарий: _023004 checking Sales Order posting by register OrderReservation (+)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'       | 'Store'    | 'Item key' |
	| '5,000'    | 'Sales order 1*' | 'Store 01' | 'L/Green'  |
	| '4,000'    | 'Sales order 1*' | 'Store 01' | '36/Yellow'   |

Сценарий: _023005 создание документа заказа клиента с ордерного склада
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in customer information
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Ferron BP'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Basic Agreements, without VAT' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Company Ferron BP'  |
		И в таблице "List" я выбираю текущую строку
	Когда добавляю товар в заказ клиента (Dress и Trousers)
	И я перерасчитываю скидки
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
	И я проверяю статус заказа клиента установленный по умолчанию
		И я перехожу к закладке "Other"
		И     элемент формы с именем "Status" стал равен 'Approved'
	И я нажимаю на кнопку 'Post and close'

Сценарий: _023006 checking Sales Order posting by register OrderBalance (+)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Order'          | 'Item key' |
	| '10,000'    | 'Sales order 2*' | 'Store 02' | 'Sales order 2*' | 'L/Green'  |
	| '14,000'    | 'Sales order 2*' | 'Store 02' | 'Sales order 2*' | '36/Yellow'   |

Сценарий: _023007 checking Sales Order posting by register StockReservation (-)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key' |
	| '10,000'    | 'Sales order 2*' | 'Store 02' | 'L/Green'  |
	| '14,000'    | 'Sales order 2*' | 'Store 02' | '36/Yellow'   |

Сценарий: _023008 checking Sales Order posting by register OrderReservation (+)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key' |
	| '10,000'    | 'Sales order 2*' | 'Store 02' | 'L/Green'  |
	| '14,000'    | 'Sales order 2*' | 'Store 02' | '36/Yellow'   |


Сценарий: _023014 checking postings by status and status history of a Sales Order document
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner'   |
		| '1'      | 'Ferron BP' |
	И в таблице "List" я выбираю текущую строку
	* Change status to Wait (doesn't post)
		И я нажимаю на гиперссылку "Decoration group title collapsed picture"
		И из выпадающего списка "Status" я выбираю точное значение 'Wait'
	И я нажимаю на кнопку 'Post and close'
	* Checking the absence of postings Sales Order
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" не содержит строки:
			| 'Recorder'       | 'Order'          |
			| 'Sales order 1*' |'Sales order 1*'  |
			| 'Sales order 1*' |'Sales order 1*' |
		И я закрываю текущее окно
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
		Тогда таблица "List" не содержит строки:
			| 'Recorder'       |
			| 'Sales order 1*' |
			| 'Sales order 1*' |
		И я закрываю текущее окно
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
		Тогда таблица "List" не содержит строки:
			| 'Recorder'       |
			| 'Sales order 1*' |
			| 'Sales order 1*' |
		И Я закрываю текущее окно
	* Opening a previously created order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Partner'   |
			| '1'      | 'Ferron BP' |
		И в таблице "List" я выбираю текущую строку
	* Change sales order status to Approved
		И я нажимаю на гиперссылку "Decoration group title collapsed picture"
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю на кнопку 'Post'
	* Check history by status
		И я нажимаю на гиперссылку "History"
		Тогда таблица "List" содержит строки:
			| 'Object'         | 'Status'   |
			| 'Sales order 1*' | 'Wait'     |
			| 'Sales order 1*' | 'Approved' |
		И я закрываю текущее окно
		И я нажимаю на кнопку 'Post and close'
	* Checking document postings
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
			| 'Recorder'       | 'Order'          |
			| 'Sales order 1*' |'Sales order 1*'  |
			| 'Sales order 1*' |'Sales order 1*' |
		И я закрываю текущее окно
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
		Тогда таблица "List" содержит строки:
			| 'Recorder'       |
			| 'Sales order 1*' |
			| 'Sales order 1*' |
		И я закрываю текущее окно
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
		Тогда таблица "List" содержит строки:
			| 'Recorder'       |
			| 'Sales order 1*' |
			| 'Sales order 1*' |
		И Я закрываю текущее окно




