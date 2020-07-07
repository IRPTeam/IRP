#language: ru
@tree
@Positive
Функционал: проведение документа Расходный ордер на товары по регистрам складского учета

As a storekeeper
I want to create a Goods receipt
For shipment of products from store


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.



Сценарий: _028801 creating document Shipment confirmation based on Sales Invoice (with Sales order)
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner'    |
		| '2'      | 'Ferron BP' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	* Checking that information is filled in when creating based on
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Change of document number
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '95'
	* Checking if the product is filled in
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Quantity' | 'Item key' | 'Unit' | 'Shipment basis'   |
		| 'Dress'    | '10,000'   | 'L/Green'  | 'pcs' | 'Sales invoice 2*' |
		| 'Trousers' | '14,000'   | '36/Yellow'| 'pcs' | 'Sales invoice 2*' |
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  | 'Store'    |
		| 'Dress'    |  'L/Green'  | 'Store 02' |
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно
	

Сценарий: _028802 checking Shipment confirmation posting (based on Sales invoice with Sales order) by register GoodsInTransitOutgoing (-)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                  | 'Shipment basis'    | 'Store'    | 'Item key' |
		| '10,000'   | 'Shipment confirmation 95*' | 'Sales invoice 2*' | 'Store 02' | 'L/Green'  |
		| '14,000'   | 'Shipment confirmation 95*' | 'Sales invoice 2*' | 'Store 02' | '36/Yellow'   |

Сценарий: _028803 checking Shipment confirmation posting (based on Sales invoice with Sales order) by register StockBalance (-)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                  | 'Store'    | 'Item key' |
		| '10,000'   | 'Shipment confirmation 95*' | 'Store 02' | 'L/Green'  |
		| '14,000'   | 'Shipment confirmation 95*' | 'Store 02' | '36/Yellow'   |


Сценарий: _028804 creating document Shipment confirmation  based on Sales Invoice (without Sales order)
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner'    |
		| '4'      | 'Kalipso' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	* Checking that information is filled in when creating based on
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Change of document number
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '98'
	* Checking if the product is filled in
		И     таблица "ItemList" содержит строки:
		| '#' | 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Shipment basis'   |
		| '1' | 'Dress' | '20,000'   | 'L/Green'  | 'pcs'  | 'Sales invoice 4*' |
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно

Сценарий: _028805 checking Shipment confirmation posting (based on Sales invoice without Sales order) by register GoodsInTransitOutgoing (-)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                 | 'Shipment basis'   | 'Line number' | 'Store'    | 'Item key' |
		| '20,000'   | 'Shipment confirmation 98*' | 'Sales invoice 4*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _028806 checking Shipment confirmation posting (based on Sales invoice without Sales order) by register StockBalance (-)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key' |
		| '20,000'   | 'Shipment confirmation 98*' | '1'           | 'Store 02' | 'L/Green'  |



Сценарий: _028807 creating document Shipment confirmation based on Purchase return
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
	И     элемент формы с именем "Company" стал равен 'Main Company'
	И     элемент формы с именем "Store" стал равен 'Store 02'
	* Change of document number
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '101'
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Shipment basis'                              |
		| 'Dress' | '2,000'    | 'L/Green'  | 'pcs'  | 'Purchase return 1*' |
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно

Сценарий: _028808 checking Shipment confirmation posting (based on Purchase return) by register StockBalance
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key' |
		| '2,000'    | 'Shipment confirmation 101*' | '1'           | 'Store 02' | 'L/Green'  |



Сценарий: _028809 checking Shipment confirmation posting (based on Purchase return) by register GoodsInTransitOutgoing
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                 | 'Shipment basis'     | 'Line number' | 'Store'    | 'Item key' |
		| '2,000'   | 'Shipment confirmation 101*' | 'Purchase return 1*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _028810 creating document Shipment confirmation  based on Inventory transfer
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Store receiver' | 'Store sender' |
		| '2'      | 'Store 03'       | 'Store 02'     |
	И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
	И Пауза 1
	И     элемент формы с именем "Company" стал равен 'Main Company'
	* Change of document number
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '102'
	И я нажимаю на кнопку 'Post and close'
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Store receiver' | 'Store sender' |
		| '3'      | 'Store 01'       | 'Store 02'     |
	И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
	И Пауза 1
	И     элемент формы с именем "Company" стал равен 'Main Company'
	* Change of document number
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '103'
	И я нажимаю на кнопку 'Post and close'
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Store receiver' | 'Store sender' |
		| '6'      | 'Store 03'       | 'Store 02'     |
	И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
	И Пауза 1
	И     элемент формы с именем "Company" стал равен 'Main Company'
	* Change of document number
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '104'
	И я нажимаю на кнопку 'Post and close'
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Store receiver' | 'Store sender' |
		| '7'      | 'Store 01'       | 'Store 02'     |
	И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
	И Пауза 1
	И     элемент формы с именем "Company" стал равен 'Main Company'
	* Change of document number
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '105'
	И я нажимаю на кнопку 'Post and close'


