#language: ru
@tree
@Positive
Функционал: posting shipment confirmation before Sales invoice

As a sales manager
I want to create Shipment confirmation before Sales invoice
To sell a product when customer first receives items and then the documents arrive at him.


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий



Сценарий: _029001 partner setup Shipment confirmation before Sales invoice
	* Check partner setup Shipment confirmation before Sales invoice
		И я открываю навигационную ссылку "e1cib/list/Catalog.Partners"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Kalipso   |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "ShipmentConfirmationsBeforeSalesInvoice" стал равен 'No'
		И я устанавливаю флаг 'Shipment confirmations before sales invoice'
		И     элемент формы с именем "ShipmentConfirmationsBeforeSalesInvoice" стал равен 'Yes'
		И я нажимаю на кнопку 'Save and close'

Сценарий: _029002 creating document Sales order and Shipment confirmation (partner Kalipso, Store use Shipment confirmation)
	И Я закрыл все окна клиентского приложения
	Когда создаю заказ на Kalipso Basic Partner terms, without VAT, TRY (Dress и Shirt)
	* Change of document number 
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '180'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '180'
		И я нажимаю на кнопку 'Post'
	* Create Shipment confirmation
		И я нажимаю на кнопку 'Shipment confirmation'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И в поле 'Number' я ввожу текст '180'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '180'
	* Checking that the tabular part is filled in
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Store'    | 'Unit' | 'Shipment basis'   |
			| 'Trousers' | '12,000'   | '36/Yellow' | 'Store 02' | 'pcs' | 'Sales order 180*' |
			| 'Shirt'    | '10,000'   | '36/Red'    | 'Store 02' | 'pcs' | 'Sales order 180*' |
	И я нажимаю на кнопку 'Post and close'
	И Я закрыл все окна клиентского приложения

Сценарий: _029003 checking Sales order posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register OrderBalance
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'         | 'Store'    | 'Order'            | 'Item key'  |
		| '12,000'   | 'Sales order 180*' | 'Store 02' | 'Sales order 180*' | '36/Yellow' |
		| '10,000'   | 'Sales order 180*' | 'Store 02' | 'Sales order 180*' | '36/Red'    |
	И Я закрыл все окна клиентского приложения

Сценарий: _029004 checking Sales order posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register StockReservation
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'         | 'Store'    | 'Item key'  |
		| '12,000'   | 'Sales order 180*' | 'Store 02' | '36/Yellow' |
		| '10,000'   | 'Sales order 180*' | 'Store 02' | '36/Red'    |
	И Я закрыл все окна клиентского приложения

Сценарий: _029005 checking Sales order posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register InventoryBalance
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'          | 'Company'      | 'Item key'  |
		| '12,000'   | 'Sales order 180*'  | 'Main Company' | '36/Yellow' |
		| '10,000'   | 'Sales order 180*'  | 'Main Company' | '36/Red'    |
	И Я закрыл все окна клиентского приложения

Сценарий: _029006 checking Sales order posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register GoodsInTransitOutgoing
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'         | 'Shipment basis'   | 'Store'    | 'Item key'  |
		| '12,000'   | 'Sales order 180*' | 'Sales order 180*' | 'Store 02' | '36/Yellow' |
		| '10,000'   | 'Sales order 180*' | 'Sales order 180*' | 'Store 02' | '36/Red'    |
	И Я закрыл все окна клиентского приложения

Сценарий: _029007 checking the absence posting of Sales order (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register StockBalance
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
		| 'Recorder'         |
		| 'Sales order 180*' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029008 checking the absence posting of Sales order (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register ShipmentOrders
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.ShipmentOrders'
	Тогда таблица "List" не содержит строки:
		| 'Recorder'         |
		| 'Sales order 180*' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029009 checking Shipment confirmation posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register StockBalance
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                   | 'Line number' | 'Store'    | 'Item key'  |
		| '12,000'   | 'Shipment confirmation 180*' | '1'           | 'Store 02' | '36/Yellow' |
		| '10,000'   | 'Shipment confirmation 180*' | '2'           | 'Store 02' | '36/Red'    |
	И Я закрыл все окна клиентского приложения

Сценарий: _029010 checking Shipment confirmation posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register GoodsInTransitOutgoing
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                   | 'Shipment basis'   | 'Line number' | 'Store'    | 'Item key'  |
		| '12,000'   | 'Shipment confirmation 180*' | 'Sales order 180*' | '1'           | 'Store 02' | '36/Yellow' |
		| '10,000'   | 'Shipment confirmation 180*' | 'Sales order 180*' | '2'           | 'Store 02' | '36/Red'    |
	И Я закрыл все окна клиентского приложения

Сценарий: _029011 checking Shipment confirmation posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register ShipmentOrders
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.ShipmentOrders'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                   | 'Order'            | 'Shipment confirmation'      | 'Item key'  |
		| '12,000'   | 'Shipment confirmation 180*' | 'Sales order 180*' | 'Shipment confirmation 180*' | '36/Yellow' |
		| '10,000'   | 'Shipment confirmation 180*' | 'Sales order 180*' | 'Shipment confirmation 180*' | '36/Red'    |
	И Я закрыл все окна клиентского приложения

Сценарий: _029012 creating document Sales order and Shipment confirmation (partner Kalipso, one Store use Shipment confirmation and Second not)
	Когда создаю заказ на Kalipso Basic Partner terms, without VAT, TRY (Dress и Shirt)
	* Change of quantity and store on the second line
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| Item     | Item key  |
			| Trousers | 36/Yellow |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '7,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
	* Change number
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '181'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '181'
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
		И я нажимаю на кнопку 'Post'
	* Create Shipment confirmation
		И я нажимаю на кнопку 'Shipment confirmation'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Quantity' | 'Item key' | 'Store'    | 'Unit' | 'Shipment basis'   |
			| 'Shirt' | '10,000'   | '36/Red'   | 'Store 02' | 'pcs' | 'Sales order 181*' |
		И я нажимаю на кнопку 'Post and close'
	И Я закрыл все окна клиентского приложения
	* Check postings by register OrderBalance
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'         | 'Line number' | 'Store'    | 'Order'            | 'Item key'  |
			| '7,000'    | 'Sales order 181*' | '1'           | 'Store 01' | 'Sales order 181*' | '36/Yellow' |
			| '10,000'   | 'Sales order 181*' | '2'           | 'Store 02' | 'Sales order 181*' | '36/Red'    |
		И Я закрыл все окна клиентского приложения
	* Check postings by register StockReservation
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'         | 'Line number' | 'Store'    | 'Item key'  |
			| '7,000'    | 'Sales order 181*' | '1'           | 'Store 01' | '36/Yellow' |
			|'10,000'    | 'Sales order 181*' | '2'           | 'Store 02' | '36/Red'    |
		И Я закрыл все окна клиентского приложения
	* Check postings by register InventoryBalance
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'         |'Company'      | 'Item key'  |
			| '7,000'    | 'Sales order 181*' |'Main Company' | '36/Yellow' |
		Тогда таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'         |'Company'      | 'Item key'  |
			| '10,000'   | 'Sales order 181*' |'Main Company' | '36/Red'    |
		И Я закрыл все окна клиентского приложения
	* Check postings by register GoodsInTransitOutgoing
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'         | 'Shipment basis'   | 'Line number' | 'Store'    | 'Item key' |
			| '10,000'   | 'Sales order 181*' | 'Sales order 181*' | '1'           | 'Store 02' | '36/Red'   |
		И Я закрыл все окна клиентского приложения
	* Check postings by register StockBalance
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'         | 'Line number' | 'Store'    | 'Item key'  |
			| '7,000'    | 'Sales order 181*' | '1'           | 'Store 01' | '36/Yellow' |
		И Я закрыл все окна клиентского приложения
	* Check postings by register ShipmentOrders
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.ShipmentOrders'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'         | 'Line number' | 'Order'            | 'Shipment confirmation'  | 'Item key'  |
			| '7,000'    | 'Sales order 181*' | '1'           | 'Sales order 181*' | 'Sales order 181*'       | '36/Yellow' |
		И Я закрыл все окна клиентского приложения
	* Check postings by register StockBalance
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'                   | 'Line number' | 'Store'    | 'Item key' |
			| '10,000'   | 'Shipment confirmation 181*' | '1'           | 'Store 02' | '36/Red'   |
		И Я закрыл все окна клиентского приложения
	* Check postings by register GoodsInTransitOutgoing
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'                   | 'Shipment basis'   | 'Line number' | 'Store'    | 'Item key' |
			| '10,000'   | 'Shipment confirmation 181*' | 'Sales order 181*' | '1'           | 'Store 02' | '36/Red'   |
		И Я закрыл все окна клиентского приложения
	* Check postings by register ShipmentOrders
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.ShipmentOrders'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'                   | 'Line number' | 'Order'            | 'Shipment confirmation'      | 'Item key' |
			| '10,000'   | 'Shipment confirmation 181*' | '1'           | 'Sales order 181*' | 'Shipment confirmation 181*' | '36/Red'   |
		И Я закрыл все окна клиентского приложения
	
Сценарий: _029013 creating Sales invoice for several shipments
# one shipment can apply to only one Sales invoice
	И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner'     |
		| '180'    | 'Kalipso' |
	И В таблице  "List" я перехожу на одну строку вниз с выделением
	И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
	И я нажимаю на кнопку с именем 'FormSelectAll'
	И я нажимаю на кнопку 'Ok'
	И     элемент формы с именем "Partner" стал равен 'Kalipso'
	И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
	И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, without VAT'
	И     элемент формы с именем "Company" стал равен 'Main Company'
	И в таблице "ItemList" я перехожу к строке:
    	| 'Item'     | 'Item key'  | 'Store'    | 'Unit' | 'Q'      |
		| 'Trousers' | '36/Yellow' | 'Store 01' | 'pcs'  | '7,000'  |
	И в таблице 'ItemList' я удаляю строку	
	* Checking the filling of the tabular part
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Shipment confirmation'      | 'Sales order'      | 'Unit' | 'Q'      | 'Offers amount' | 'Tax amount' | 'Net amount' | 'Total amount' |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | 'Shipment confirmation 180*' | 'Sales order 180*' | 'pcs' | '12,000' | ''            | '732,20'     | '4 067,76'   | '4 799,96'     |
		| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02' | 'Shipment confirmation 180*' | 'Sales order 180*' | 'pcs' | '10,000' | ''            | '533,90'     | '2 966,10'   | '3 500,00'     |
		| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02' | 'Shipment confirmation 180*' | 'Sales order 180*' | 'pcs' | '10,000' | ''            | '533,90'     | '2 966,10'   | '3 500,00'     |
	* Change number
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '180'
		И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	* Checking postings
		* Checking the absence posting by register Stock Balance
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Sales invoice 180*' |
			И Я закрыл все окна клиентского приложения
		* Checking the absence posting by register Inventory Balance 
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Sales invoice 180*' |
			И Я закрыл все окна клиентского приложения
		* Checking the absence posting by register Stock StockReservation
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Sales invoice 180*' |
			И Я закрыл все окна клиентского приложения
		* Checking the absence posting by register GoodsInTransitOutgoing
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Sales invoice 180*' |
			И Я закрыл все окна клиентского приложения
		* Checking posting by register Order Balance
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
			Тогда таблица "List" содержит строки:
				| 'Quantity' | 'Recorder'           | 'Store'    | 'Order'            | 'Item key'  |
				| '12,000'   | 'Sales invoice 180*' | 'Store 02' | 'Sales order 180*' | '36/Yellow' |
				| '10,000'   | 'Sales invoice 180*' | 'Store 02' | 'Sales order 180*' | '36/Red'    |
				| '10,000'   | 'Sales invoice 180*' | 'Store 02' | 'Sales order 181*' | '36/Red'    |
			И Я закрыл все окна клиентского приложения
		* Checking posting by register OrderReservation
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
			Тогда таблица "List" содержит строки:
				| 'Quantity' | 'Recorder'           | 'Store'    | 'Item key'  |
				| '12,000'   | 'Sales invoice 180*' | 'Store 02' | '36/Yellow' |
				| '20,000'   | 'Sales invoice 180*' | 'Store 02' | '36/Red'    |
			И Я закрыл все окна клиентского приложения
		* Checking posting by register OrderReservation
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
			Тогда таблица "List" содержит строки:
				| 'Quantity' | 'Recorder'           | 'Sales invoice'      | 'Item key'  |
				| '12,000'   | 'Sales invoice 180*' | 'Sales invoice 180*' | '36/Yellow' |
				| '10,000'   | 'Sales invoice 180*' | 'Sales invoice 180*' | '36/Red'    |
				| '10,000'   | 'Sales invoice 180*' | 'Sales invoice 180*' | '36/Red'    |
			И Я закрыл все окна клиентского приложения
		* Checking posting by register ShipmentOrders
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.ShipmentOrders'
			Тогда таблица "List" содержит строки:
				| 'Quantity' | 'Recorder'           | 'Order'            | 'Shipment confirmation'      | 'Item key'  |
				| '12,000'   | 'Sales invoice 180*' | 'Sales order 180*' | 'Shipment confirmation 180*' | '36/Yellow' |
				| '10,000'   | 'Sales invoice 180*' | 'Sales order 180*' | 'Shipment confirmation 180*' | '36/Red'    |
				| '10,000'   | 'Sales invoice 180*' | 'Sales order 181*' | 'Shipment confirmation 181*' | '36/Red'    |
			И Я закрыл все окна клиентского приложения

Сценарий: _029014 availability check for selection shipment confirmation for which sales invoice has already been issued
# should not be displayed
	И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner'     |
		| '180'    | 'Kalipso' |
	И В таблице  "List" я перехожу на одну строку вниз с выделением
	И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
	И я нажимаю на кнопку с именем 'FormSelectAll'
	И я нажимаю на кнопку 'Ok'
	* Filling check
		И     элемент формы с именем "Partner" стал равен 'Kalipso'
		И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, without VAT'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	* Checking the filling of the tabular part
		И я запоминаю количество строк таблицы "ItemList" как "Q"
		И     я вывожу значение переменной "Q"
		Тогда переменная "Q" имеет значение 1
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Shipment confirmation'    | 'Sales order'      | 'Unit' | 'Q'     | 'Offers amount' | 'Tax amount' | 'Net amount' | 'Total amount' |
			| 'Trousers' | '338,98' | '36/Yellow' | 'Store 01' | 'Sales order 181*'         | 'Sales order 181*' | 'pcs' | '7,000' | ''              | '427,11'     | '2 372,86'   | '2 799,97'     |
	* Change number
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '181'
		И я нажимаю на кнопку 'Post and close'
	И Я закрыл все окна клиентского приложения
	* Checking postings
		* Checking the absence posting by register Stock Balance
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Sales invoice 181*' |
			И Я закрыл все окна клиентского приложения
		* Checking the absence posting by register Inventory Balance 
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Sales invoice 181*' |
			И Я закрыл все окна клиентского приложения
		* Checking the absence posting by register Stock StockReservation
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Sales invoice 181*' |
			И Я закрыл все окна клиентского приложения
		* Checking the absence posting by register GoodsInTransitOutgoing
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Sales invoice 181*' |
			И Я закрыл все окна клиентского приложения
		* Checking posting by register Order Balance
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
			Тогда таблица "List" содержит строки:
				| 'Recorder'           |
				| 'Sales invoice 181*' |
			И Я закрыл все окна клиентского приложения
		* Checking posting by register Order reservation
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
			Тогда таблица "List" содержит строки:
				| 'Recorder'           |
				| 'Sales invoice 181*' |
			И Я закрыл все окна клиентского приложения
		* Checking posting by register Sales turnovers
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Sales invoice 181*' |
			И Я закрыл все окна клиентского приложения
		* Checking posting by register ShipmentOrders
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.ShipmentOrders'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Sales invoice 181*' |
			И Я закрыл все окна клиентского приложения