#language: ru
@tree
@Positive
Функционал: creating document Inventory transfer order

As a procurement manager
I want to create a Inventory transfer order
To coordinate the transfer of items from one store to another

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.

# 1
Сценарий: _020001 creating document Inventory Transfer Order - Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	* Opening a form to create Inventory transfer order
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in Store sender and Store receiver
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
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Filling in the document number
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '201'
	* Filling in items table
		И я перехожу к закладке "Item list"
		И я нажимаю на кнопку с именем 'Add'
		Когда выбираю в заказе item Dress
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| 'M/White' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
		И я нажимаю на кнопку с именем 'FormChoose'
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '50,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'Add'
		Когда выбираю в заказе item Dress
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| 'S/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Unit"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
		И я нажимаю на кнопку с именем 'FormChoose'
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '10,000'
		И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'

Сценарий: _020002 checking Inventory transfer order posting by register TransferOrderBalance (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
checking Purchase Order N2 posting by register Order Balance (plus) - Goods receipt is not used
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                      |'Store sender' | 'Store receiver' | 'Order'                       | 'Item key' |
		| '10,000'   | 'Inventory transfer order 201*' |'Store 01'     | 'Store 02'       | 'Inventory transfer order 201*' | 'S/Yellow' |
		| '50,000'   | 'Inventory transfer order 201*' |'Store 01'     | 'Store 02'       | 'Inventory transfer order 201*' | 'M/White'  |

Сценарий: _020003 checking Inventory transfer order posting by register StockReservation (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'                      |'Store'    | 'Item key' |
	| '10,000'   | 'Inventory transfer order 201*' |'Store 01' | 'S/Yellow' |
	| '50,000'   | 'Inventory transfer order 201*' |'Store 01' | 'M/White'  |




# 2
Сценарий: _020004 creating document Inventory Transfer Order- Store sender use Shipment confirmation, Store receiver use Goods receipt
	* Opening a form to create Inventory transfer order
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in Store sender and Store receiver
		И я нажимаю кнопку выбора у поля "Store sender"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store receiver"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 03'  |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Filling in the document number
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '202'
	* Filling in items table
		И я перехожу к закладке "Item list"
		И я нажимаю на кнопку с именем 'Add'
		Когда выбираю в заказе item Dress
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| 'L/Green' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Unit"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
		И я нажимаю на кнопку с именем 'FormChoose'
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '20,000'
		И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'

Сценарий: _020005 checking Inventory transfer order posting by register TransferOrderBalance (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                       | 'Item key' |
		| '20,000'   | 'Inventory transfer order 202*' | '1'           | 'Store 02'     | 'Store 03'       | 'Inventory transfer order 202*' | 'L/Green'  |

Сценарий: _020006 checking Inventory transfer order posting by register StockReservation (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key' |
	| '20,000'   | 'Inventory transfer order 202*' | '1'           | 'Store 02' | 'L/Green'  |

# 3
Сценарий: _020007 creating document Inventory Transfer Order- Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt 
	* Opening a form to create Inventory transfer order
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in Store sender and Store receiver
		И я нажимаю кнопку выбора у поля "Store sender"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store receiver"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Filling in the document number
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '203'
	* Filling in items table
		И я перехожу к закладке "Item list"
		И я нажимаю на кнопку с именем 'Add'
		Когда выбираю в заказе item Dress
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| 'L/Green' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Unit"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
		И я нажимаю на кнопку с именем 'FormChoose'
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '17,000'
		И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'


Сценарий: _020008 checking Inventory transfer order posting by register TransferOrderBalance (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                       | 'Item key' |
		| '17,000'   | 'Inventory transfer order 203*' | '1'           | 'Store 02'     | 'Store 01'       | 'Inventory transfer order 203*' | 'L/Green'  |

Сценарий: _020009 checking Inventory transfer order posting by register StockReservation (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key' |
		| '17,000'   | 'Inventory transfer order 203*' | '1'           | 'Store 02' | 'L/Green'  |




# 4
Сценарий: _020010 creating document Inventory Transfer Order- Store sender doesn't use Shipment confirmation, Store receiver doesn't use Goods receipt 
	* Opening a form to create Inventory transfer order
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in Store sender and Store receiver
		И я нажимаю кнопку выбора у поля "Store sender"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store receiver"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 04'  |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Filling in the document number
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '204'
	* Filling in items table
		И я перехожу к закладке "Item list"
		И я нажимаю на кнопку с именем 'Add'
		Когда выбираю в заказе item Trousers
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| '36/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Unit"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
		И я нажимаю на кнопку с именем 'FormChoose'
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '10,000'
		И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'

Сценарий: _020011 checking Inventory transfer order posting by register TransferOrderBalance (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                       | 'Item key'  |
		| '10,000'   | 'Inventory transfer order 204*' | '1'           | 'Store 01'     | 'Store 04'       | 'Inventory transfer order 204*' | '36/Yellow' |


Сценарий: _020012 checking Inventory transfer order posting by register StockReservation (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key'  |
	| '10,000'   | 'Inventory transfer order 204*' | '1'           | 'Store 01' | '36/Yellow' |


Сценарий: _020013 checking movements by status and status history of an Inventory Transfer Order
	И Я закрыл все окна клиентского приложения
	* Create Inventory Transfer Order
		* Opening a form to create Inventory transfer order
			И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in Store sender and Store receiver
			И я нажимаю кнопку выбора у поля "Store sender"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store receiver"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 03'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
		* Checking the default status "Wait"
			И элемент формы с именем "Status" стал равен "Wait"
		* Filling in the document number 101
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '205'
		* Filling in items table
			И я перехожу к закладке "Item list"
			И я нажимаю на кнопку с именем 'Add'
			Когда выбираю в заказе item Dress
			И я перехожу к следующему реквизиту
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key'  |
				| 'L/Green' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Unit"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
			И я нажимаю на кнопку с именем 'FormChoose'
			И я перехожу к следующему реквизиту
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '20,000'
			И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И Я закрываю текущее окно
		* Check that there is no movement in Wait status
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'                    |
				| 'Inventory transfer order 205*' |
			И Я закрываю текущее окно
		* Checking Approve status - makes postings
			И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
			И в таблице "List" я перехожу к строке:
				| 'Number'   | 'Store sender' | 'Store receiver' |
				| '205'      |  'Store 02'     | 'Store 03'       |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
			И я нажимаю на кнопку 'Post and close'
			И Я закрыл все окна клиентского приложения
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
			Тогда таблица "List" содержит строки:
				| 'Recorder'                    |
				| 'Inventory transfer order 205*' |
			И Я закрываю текущее окно
		* Checking Send status - makes postings
			И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
			И в таблице "List" я перехожу к строке:
				| 'Number' | 'Store sender' | 'Store receiver' |
				| '205'      |  'Store 02'     | 'Store 03'       |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
			И из выпадающего списка "Status" я выбираю точное значение 'Send'
			И я нажимаю на кнопку 'Post and close'
			И Я закрываю текущее окно
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
			Тогда таблица "List" содержит строки:
				| 'Recorder'                    |
				| 'Inventory transfer order 205*' |
			И    Я закрыл все окна клиентского приложения
		* Checking Receive status - makes postings
			И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
			И в таблице "List" я перехожу к строке:
				| 'Number' | 'Store sender' | 'Store receiver' |
				| '205'      |  'Store 02'     | 'Store 03'       |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
			И из выпадающего списка "Status" я выбираю точное значение 'Receive'
			И я нажимаю на кнопку 'Post'
			И я нажимаю на гиперссылку "History"
			Тогда таблица "List" содержит строки:
				| 'Object'                         | 'Status'   |
				| 'Inventory transfer order 205*' | 'Approved' |
				| 'Inventory transfer order 205*' | 'Send'     |
				| 'Inventory transfer order 205*' | 'Receive'  |
			И я закрываю текущее окно
			И я нажимаю на кнопку 'Post and close'
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
			Тогда таблица "List" содержит строки:
			| 'Recorder'                    |
			| 'Inventory transfer order 205*' |
			И Я закрываю текущее окно



	
