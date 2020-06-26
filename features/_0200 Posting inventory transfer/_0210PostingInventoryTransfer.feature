#language: ru
@tree
@Positive
Функционал: creating document Inventory transfer

As a procurement manager
I want to create a Inventory transfer order
To transfer items from one store to another

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

# 1
Сценарий: _021001 creating document Inventory Transfer - Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	* Opening Inventory transfer order to create Inventory transfer
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Store sender' | 'Store receiver' |
			| '201'      |  'Store 01'     | 'Store 02'       |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormDocumentInventoryTransferGenerateInventoryTransfer"
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
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		* Filling in the document number
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '1'
		И я перехожу к закладке "Items"
		И     таблица "ItemList" содержит строки:
		| 'Inventory transfer order'    | 'Item'  | 'Quantity' | 'Item key'  | 'Unit' |
		| 'Inventory transfer order 201*' | 'Dress' | '50,000'   | 'M/White'  | 'pcs' |
		| 'Inventory transfer order 201*' | 'Dress' | '10,000'   | 'S/Yellow' | 'pcs' |
		И я нажимаю на кнопку 'Post and close'
		И Я закрываю текущее окно

Сценарий: _021002 checking Inventory transfer (based on order) posting by register TransferOrderBalance (-) (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Store sender' | 'Store receiver' | 'Order'                       | 'Item key'  |
		| '10,000'   | 'Inventory transfer 1*'       | 'Store 01'     | 'Store 02'       | 'Inventory transfer order 201*' | 'S/Yellow'  |
		| '50,000'   | 'Inventory transfer 1*'       | 'Store 01'     | 'Store 02'       | 'Inventory transfer order 201*' | 'M/White'   |

Сценарий: _021002 checking Inventory transfer (based on order) posting by register StockReservation (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'               | 'Item key'  |
		| '10,000'    | 'Inventory transfer 1*' | 'S/Yellow'   |
		| '50,000'    | 'Inventory transfer 1*' | 'M/White'   |

Сценарий: _021003 checking Inventory transfer (based on order) posting by register GoodsInTransitOutgoing (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" не содержит строки:
	| 'Recorder'              |
	| 'Inventory transfer 1*' |


Сценарий: _021004 checking Inventory transfer (based on order) posting by register GoodsInTransitIncoming (+)  (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'              | 'Receipt basis'         | 'Store'    | 'Item key' |
	| '10,000'   | 'Inventory transfer 1*' | 'Inventory transfer 1*' | 'Store 02' | 'S/Yellow' |
	| '50,000'   | 'Inventory transfer 1*' | 'Inventory transfer 1*' | 'Store 02' | 'M/White'  |


Сценарий: _021005 checking Inventory transfer (based on order) posting by register StockBalance (-) (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'              | 'Store'    | 'Item key' |
	| '10,000'   | 'Inventory transfer 1*' | 'Store 01' | 'S/Yellow' |
	| '50,000'   | 'Inventory transfer 1*' | 'Store 01' | 'M/White'  |


	# 2
Сценарий: _021006 creating document Inventory Transfer - Store sender use Shipment confirmation, Store receiver use Goods receipt
	* Opening Inventory transfer order to create Inventory transfer
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Store sender'  | 'Store receiver' |
			| '202'      |  'Store 02'     | 'Store 03'       |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormDocumentInventoryTransferGenerateInventoryTransfer"
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
		* Filling in the document number
			И в поле 'Number' я ввожу текст '2'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2'
		И я перехожу к закладке "Items"
		И     таблица "ItemList" содержит строки:
		| '#' | 'Inventory transfer order'    | 'Item'  | 'Quantity' | 'Item key' | 'Unit' |
		| '1' | 'Inventory transfer order 2*' | 'Dress' | '20,000'   | 'L/Green'  | 'pcs' |
		И я нажимаю на кнопку 'Post and close'
		И Я закрываю текущее окно

Сценарий: _021007 checking Inventory transfer (based on order) posting by register TransferOrderBalance (-) (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                       | 'Item key'  |
		| '20,000'   | 'Inventory transfer 2*'       | '1'           | 'Store 02'     | 'Store 03'       | 'Inventory transfer order 2*' | 'L/Green'   |

Сценарий: _021008 checking Inventory transfer (based on order) posting by register StockReservation (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'              | 'Line number' | 'Item key'  |
		| '20,000'    | 'Inventory transfer 2*' | '1'          | 'L/Green'   |


Сценарий: _021009 checking Inventory transfer (based on order) posting by register GoodsInTransitOutgoing (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'              | 'Shipment basis'        | 'Line number' | 'Store'    | 'Item key' |
	| '20,000'   | 'Inventory transfer 2*' | 'Inventory transfer 2*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _021010 checking Inventory transfer (based on order) posting by register GoodsInTransitIncoming (+) (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'              | 'Receipt basis'         | 'Line number' | 'Store'    | 'Item key' |
	| '20,000'   | 'Inventory transfer 2*' | 'Inventory transfer 2*' | '1'           | 'Store 03' | 'L/Green'  |


Сценарий: _021011 checking Inventory transfer (based on order) posting by register StockBalance (-) (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
	| 'Recorder'              |
	| 'Inventory transfer 2*' |


	# 3
Сценарий: _021012 creating document Inventory Transfer - Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt
	* Opening Inventory transfer order to create Inventory transfer
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Store sender'  | 'Store receiver' |
			| '203'      |  'Store 02'     | 'Store 01'       |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormDocumentInventoryTransferGenerateInventoryTransfer"
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
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		* Filling in the document number
			И в поле 'Number' я ввожу текст '3'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '3'
		И я перехожу к закладке "Items"
		И     таблица "ItemList" содержит строки:
		| '#' | 'Inventory transfer order'    | 'Item'  | 'Quantity' | 'Item key' | 'Unit' |
		| '1' | 'Inventory transfer order 203*' | 'Dress' | '17,000'   | 'L/Green'  | 'pcs' |
		И я нажимаю на кнопку 'Post and close'
		И Я закрываю текущее окно
	
Сценарий: _021013 checking Inventory transfer (based on order) posting by register TransferOrderBalance (-) (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                       | 'Item key'  |
		| '17,000'   | 'Inventory transfer 3*'       | '1'           | 'Store 02'     | 'Store 01'       | 'Inventory transfer order 203*' | 'L/Green'   |

Сценарий: _021014 checking Inventory transfer (based on order) posting by register StockReservation (+) (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity'  | 'Recorder'              | 'Line number' | 'Store'    | 'Item key'  |
		| '17,000'    | 'Inventory transfer 3*' | '1'           | 'Store 01' | 'L/Green'   |

Сценарий: _021015 checking Inventory transfer (based on order) posting by register GoodsInTransitOutgoing (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'              | 'Shipment basis'        | 'Line number' | 'Store'    | 'Item key' |
	| '17,000'   | 'Inventory transfer 3*' | 'Inventory transfer 3*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _021016 checking the absence posting of Inventory transfer (based on order) by register GoodsInTransitIncoming (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'              | 'Receipt basis'         | 'Line number' | 'Store'    | 'Item key' |
	| '20,000'   | 'Inventory transfer 2*' | 'Inventory transfer 2*' | '1'           | 'Store 03' | 'L/Green'  |


Сценарий: _021017 checking the absence posting of Inventory transfer (based on order) by register StockBalance (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
	| 'Recorder'              |
	| 'Inventory transfer 3*' |



	# 4
Сценарий: _021018 creating document Inventory Transfer - Store sender doesn't use Shipment confirmation, Store receiver doesn't use Goods receipt
	* Opening Inventory transfer order to create Inventory transfer
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Store sender'  | 'Store receiver' |
			| '204'      |  'Store 01'     | 'Store 04'       |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormDocumentInventoryTransferGenerateInventoryTransfer"
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
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		* Filling in the document number
			И в поле 'Number' я ввожу текст '4'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '4'
		И я перехожу к закладке "Items"
		И     таблица "ItemList" содержит строки:
		| '#' | 'Inventory transfer order'    | 'Item'     | 'Quantity' | 'Item key'  | 'Unit' |
		| '1' | 'Inventory transfer order 204*' | 'Trousers' | '10,000'   | '36/Yellow' | 'pcs' |
		И я нажимаю на кнопку 'Post and close'
		И Я закрываю текущее окно

Сценарий: _021019  checking Inventory transfer (without order) posting by register TransferOrderBalance (-) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)	
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                       | 'Item key'  |
		| '10,000'   | 'Inventory transfer 4*'       | '1'           | 'Store 01'     | 'Store 04'       | 'Inventory transfer order 204*' | '36/Yellow' |

Сценарий: _021020  checking Inventory transfer (without order) posting by register StockReservation (+) Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt

	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity'  | 'Recorder'              | 'Store'    | 'Item key'  |
		| '10,000'    | 'Inventory transfer 4*' | 'Store 04' | '36/Yellow'   |



Сценарий: _021021 checking the absence posting of Inventory transfer (without order) posting by register GoodsInTransitOutgoing (+) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" не содержит строки:
	| 'Recorder'              |
	| 'Inventory transfer 4*' |


Сценарий: _021022 checking the absence posting of Inventory transfer (without order) posting by register GoodsInTransitIncoming (+) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" не содержит строки:
	| 'Recorder'              |
	| 'Inventory transfer 4*' |

Сценарий: _021023 checking Inventory transfer (without order) posting by register StockBalance (+/-) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'              | 'Store'    | 'Item key'  |
	| '10,000'   | 'Inventory transfer 4*' | 'Store 04' | '36/Yellow' |
	| '10,000'   | 'Inventory transfer 4*' | 'Store 01' | '36/Yellow' |




	# 5
Сценарий: _021024 creating document Inventory Transfer - Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt (without Purchase order)
	
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Store sender"
	И в таблице "List" я перехожу к строке:
		| Description |
		| Store 01    |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Store receiver"
	И в таблице "List" я перехожу к строке:
		| Description |
		| Store 02    |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| 'Description'  |
		| 'Main Company' |
	И в таблице "List" я выбираю текущую строку
	* Filling in the document number
			И в поле 'Number' я ввожу текст '5'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '5'
	И я перехожу к закладке "Items"
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Dress'       |
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле "Item key"
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
	И в таблице "List" я перехожу к строке:
		| 'Item key' |
		| 'S/Yellow' |
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле "Unit"
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле "Quantity"
	И в таблице "ItemList" в поле 'Quantity' я ввожу текст '7,000'
	И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'

Сценарий: _021025 checking the absence posting of Inventory transfer (without order) posting by register TransferOrderBalance Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Item key'  |
		| '7,000'   | 'Inventory transfer 5*'       | '1'            | 'Store 01'     | 'Store 02'       | 'S/Yellow'  |

Сценарий: _021026  checking Inventory transfer (without order) posting by register StockReservation (-) Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                                       | 'Line number' | 'Store'    | 'Item key'  |
		| '7,000'    | 'Inventory transfer 5*' | '1'           | 'Store 01' | 'S/Yellow'  |


Сценарий: _021027 checking the absence posting of Inventory transfer (without order) posting by register GoodsInTransitOutgoing Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" не содержит строки:
	| 'Recorder'              |
	| 'Inventory transfer 5*' |


Сценарий: _021028 checking Inventory transfer (without order) posting by register GoodsInTransitIncoming (+) Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'              | 'Receipt basis'         | 'Line number' | 'Store'    | 'Item key' |
	| '7,000'    | 'Inventory transfer 5*' | 'Inventory transfer 5*' | '1'           | 'Store 02' | 'S/Yellow' |

Сценарий: _021029 checking Inventory transfer (without order) posting by register StockBalance (-) Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'              | 'Line number' | 'Store'    | 'Item key' |
	| '7,000'    | 'Inventory transfer 5*' | '1'           | 'Store 01' | 'S/Yellow' |



	# 6
Сценарий: _021030 creating document Inventory Transfer - Store sender use Shipment confirmation, Store receiver use Goods receipt (without Purchase order)
	
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Store sender"
	И в таблице "List" я перехожу к строке:
		| Description |
		| Store 02    |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Store receiver"
	И в таблице "List" я перехожу к строке:
		| Description |
		| Store 03    |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| 'Description'  |
		| 'Main Company' |
	И в таблице "List" я выбираю текущую строку
	* Filling in the document number
			И в поле 'Number' я ввожу текст '6'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '6'
	И я перехожу к закладке "Items"
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Dress'       |
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле "Item key"
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
	И в таблице "List" я перехожу к строке:
		| 'Item key' |
		| 'L/Green' |
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле "Unit"
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле "Quantity"
	И в таблице "ItemList" в поле 'Quantity' я ввожу текст '3,000'
	И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'

Сценарий: _021031 проверка отсутствия движений документа перемещения (InventoryTransfer) по регистру TransferOrderBalanceStore sender use Shipment confirmation, Store receiver use Goods receipt
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Item key'  |
		| '3,000'    | 'Inventory transfer 6*'       | '1'            | 'Store 02'     | 'Store 03'       | 'L/Green'  |

Сценарий: _021032 checking Inventory transfer (without order) posting by register StockReservation (-)Store sender use Shipment confirmation, Store receiver use Goods receipt
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'              | 'Line number' | 'Store'    | 'Item key'  |
		| '3,000'    | 'Inventory transfer 6*' | '1'           | 'Store 02' | 'L/Green'  |


Сценарий: _021033 checking Inventory transfer (without order) posting by register GoodsInTransitOutgoing Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'              | 'Shipment basis'        | 'Line number' | 'Store'    | 'Item key' |
	| '3,000'    | 'Inventory transfer 6*' | 'Inventory transfer 6*' | '1'           | 'Store 02' | 'L/Green'  |


Сценарий: _021034 п checking Inventory transfer (without order) posting by register GoodsInTransitIncoming (+) Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'              | 'Receipt basis'         | 'Line number' | 'Store'    | 'Item key' |
	| '3,000'    | 'Inventory transfer 6*' | 'Inventory transfer 6*' | '1'           | 'Store 03' | 'L/Green'  |

Сценарий: _021035 checking the absence posting of Inventory transfer (without order) posting by register StockBalance (-) Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
	| 'Recorder'              |
	| 'Inventory transfer 6*' |



	# 7

Сценарий: _021036 creating document Inventory Transfer - Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt (without Purchase order)
	
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Store sender"
	И в таблице "List" я перехожу к строке:
		| Description |
		| Store 02    |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Store receiver"
	И в таблице "List" я перехожу к строке:
		| Description |
		| Store 01    |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| 'Description'  |
		| 'Main Company' |
	И в таблице "List" я выбираю текущую строку
	* Filling in the document number
			И в поле 'Number' я ввожу текст '7'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '7'
	И я перехожу к закладке "Items"
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Dress'       |
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле "Item key"
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
	И в таблице "List" я перехожу к строке:
		| 'Item key' |
		| 'L/Green' |
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле "Unit"
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле "Quantity"
	И в таблице "ItemList" в поле 'Quantity' я ввожу текст '4,000'
	И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'

Сценарий: _021037 checking the absence posting of Inventory transfer (without order) posting by register TransferOrderBalance Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Item key'  |
		| '4,000'    | 'Inventory transfer 7*'       | '1'            | 'Store 02'     | 'Store 01'       | 'L/Green'  |

Сценарий: _021038  checking Inventory transfer (without order) posting by register StockReservation Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt

	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'              | 'Store'    | 'Item key'  |
		| '4,000'    | 'Inventory transfer 7*' | 'Store 01' | 'L/Green'   |
		| '4,000'    | 'Inventory transfer 7*' | 'Store 02' | 'L/Green'   |


Сценарий: _021039 п checking Inventory transfer (without order) posting by register GoodsInTransitOutgoing Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'              | 'Shipment basis'        | 'Line number' | 'Store'    | 'Item key' |
	| '4,000'    | 'Inventory transfer 7*' | 'Inventory transfer 7*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _021040 checking the absence posting of Inventory transfer (without order) posting by register GoodsInTransitIncoming (+) Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" не содержит строки:
	| 'Recorder'              |
	| 'Inventory transfer 7*' |


Сценарий: _021041 checking the absence posting of Inventory transfer (without order) posting by register StockBalance (+) Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
	| 'Recorder'              |
	| 'Inventory transfer 7*' |

	# 8

Сценарий: _021042 creating document Inventory Transfer - Store sender doesn't use Shipment confirmation, Store receiver doesn't use Goods receipt (without Purchase order)
	
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Store sender"
	И в таблице "List" я перехожу к строке:
		| Description |
		| Store 01    |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Store receiver"
	И в таблице "List" я перехожу к строке:
		| Description |
		| Store 04    |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| 'Description'  |
		| 'Main Company' |
	И в таблице "List" я выбираю текущую строку
	* Filling in the document number
		И в поле 'Number' я ввожу текст '8'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '8'
	И я перехожу к закладке "Items"
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	И в таблице "List" я перехожу к строке:
		| 'Description'    |
		| 'Trousers'       |
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле "Item key"
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
	И в таблице "List" я перехожу к строке:
		| 'Item key' |
		| '36/Yellow' |
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле "Unit"
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле "Quantity"
	И в таблице "ItemList" в поле 'Quantity' я ввожу текст '4,000'
	И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'

Сценарий: _021043 checking the absence posting of Inventory transfer (without order) posting by register TransferOrderBalance (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Line number'  | 'Store sender' | 'Store receiver' | 'Item key'  |
		| '4,000'    | 'Inventory transfer 8*'       | '1'            | 'Store 01'     | 'Store 04'       | '36/Yellow'  |

Сценарий: _021044  checking Inventory transfer (without order) posting by register StockReservation (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)

	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'              | 'Store'    | 'Item key'  |
		| '4,000'    | 'Inventory transfer 8*' | 'Store 04' | '36/Yellow'   |
		| '4,000'    | 'Inventory transfer 8*' | 'Store 01' | '36/Yellow'   |

Сценарий: _021045 checking the absence posting of Inventory transfer (without order) posting by register GoodsInTransitOutgoing (+) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" не содержит строки:
	| 'Recorder'              |
	| 'Inventory transfer 8*' |

Сценарий: _021046 checking the absence posting of Inventory transfer (without order) posting by register GoodsInTransitIncoming (+) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" не содержит строки:
	| 'Recorder'              |
	| 'Inventory transfer 8*' |

Сценарий: _021047 п checking Inventory transfer (without order) posting by register StockBalance (+/-) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'              | 'Store'    | 'Item key'  |
	| '4,000'    | 'Inventory transfer 8*' | 'Store 04' | '36/Yellow' |
	| '4,000'    | 'Inventory transfer 8*' | 'Store 01' | '36/Yellow' |


