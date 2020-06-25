#language: ru
@tree
@Positive


Функционал: creating document Purchase return

As a procurement manager
I want to create a Purchase return document
To track a product that returned to the vendor

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _022301 creating document Purchase return, store use Shipment confirmation, based on Purchase return order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentPurchaseReturnGeneratePurchaseReturn'
	* Check filling details
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, USD'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	* Select store
		И я нажимаю кнопку выбора у поля "Store"
		Тогда открылось окно 'Stores'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'  |
		И в таблице "List" я выбираю текущую строку
	* Checking the addition of the store to the tabular part
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

Сценарий: _022302 checking postings of the document Purchase return order in the OrderBalance (store use Shipment confirmation, based on Purchase return order) - minus
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Order'                    | 'Item key' |
		| '2,000'    | 'Purchase return 1*' | '1'           | 'Store 02' | 'Purchase return order 1*' | 'L/Green'  |

Сценарий: _022303 checking postings of the document Purchase return order in the InventoryBalance (store use Shipment confirmation, based on Purchase return order - minus
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'           | 'Line number' | 'Company'      | 'Item key' |
	| '2,000'    | 'Purchase return 1*' | '1'           | 'Main Company' | 'L/Green'  |

Сценарий: _022304 checking postings of the document Purchase return order in the GoodsInTransitOutgoing (store use Shipment confirmation, based on Purchase return order) - plus
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'           | 'Shipment basis'     | 'Line number' | 'Store'    | 'Item key' |
	| '2,000'    | 'Purchase return 1*' | 'Purchase return 1*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _022305 checking postings of the document Purchase return order in the OrderReservation (store use Shipment confirmation, based on Purchase return order) - plus
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
	| '2,000'    | 'Purchase return 1*' | '1'           | 'Store 02' | 'L/Green'  |

	
Сценарий: _022306 checking that there are no postings of Purchase return in register PurchaseTurnovers (store use Shipment confirmation, based on Purchase return order)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PurchaseTurnovers'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'           |
		| '-2,000'   | 'Purchase return 1*' |
	

Сценарий: _022307 checking that there are no postings of Purchase return in register StockBalance (store use Shipment confirmation, based on Purchase return order)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
		| '2,000'    | 'Purchase return 1*' | '1'           | 'Store 02' | 'L/Green'  |


Сценарий: _022308 checking that there are no postings of Purchase return in register StockReservation (store use Shipment confirmation, based on Purchase return order)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'              | 'Line number' | 'Store'    | 'Item key'  |
	| '2,000'    | 'Purchase return 1*'    | '1'           | 'Store 02' | 'L/Green'   |


Сценарий: _022309 creating document Purchase retur, store use Shipment confirmation, based on Purchase return order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '2'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentPurchaseReturnGeneratePurchaseReturn'
	И я проверяю заполнения реквизитов
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	* Select store
		И я нажимаю кнопку выбора у поля "Store"
		Тогда открылось окно 'Stores'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
	Временно цены
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
		И в таблице "ItemList" я завершаю редактирование строки
	* Filling in the document number 2
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно

Сценарий: _022310 checking postings of the document Purchase return order in the OrderBalance (store use Shipment confirmation, based on Purchase return order) - minus
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Order'                    | 'Item key' |
		| '3,000'    | 'Purchase return 2*' | '1'           | 'Store 01' | 'Purchase return order 2*' | '36/Yellow'  |

Сценарий: _022311 checking postings of the document Purchase return order in the InventoryBalance (store use Shipment confirmation, based on Purchase return order) - minus
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'           | 'Line number' | 'Company'      | 'Item key' |
	| '3,000'    | 'Purchase return 2*' | '1'           | 'Main Company' | '36/Yellow'  |

Сценарий: _022312 checking postings of the document Purchase return order in the InventoryBalance (store use Shipment confirmation, based on Purchase return order) - minus
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
		| '3,000'    | 'Purchase return 2*' | '1'           | 'Store 01' | '36/Yellow'  |

Сценарий: _022313 checking postings of the document Purchase return order in the OrderReservation (store use Shipment confirmation, based on Purchase return order) - minus
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
		| '3,000'    | 'Purchase return 2*' | '1'           | 'Store 01' | '36/Yellow'  |

Сценарий: _022314 creating document Purchase return, store use Shipment confirmation, without Purchase return order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '2'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentPurchaseReturnGeneratePurchaseReturn'
	* Check filling details
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, USD'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я нажимаю кнопку выбора у поля "Store"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Store 02'  |
	И в таблице "List" я выбираю текущую строку
	И я проверяю, что в возврат подтягивается количество из поступления за minusом предыдущих возвратов
		И таблица "ItemList" содержит строки:
			| 'Purchase return order' | 'Item'  | 'Item key' | 'Purchase invoice'    | 'Unit' | 'Q'       |
			| ''                      | 'Dress' | 'L/Green'  | 'Purchase invoice 2*' | 'pcs' | '498,000' |
	И в таблице "ItemList" я активизирую поле "Q"
	И в таблице "ItemList" я выбираю текущую строку
	И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
	И в таблице "ItemList" я завершаю редактирование строки
	* Filling in the document number 3
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '3'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '3'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно

Сценарий: _022315 checking that there are no postings of Purchase return document by OrderBalance (store use Shipment confirmation, without Purchase return order) - minus
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
		| '10,000'    | 'Purchase return 3*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _022316 проверка движений Purchase return по регистру PurchaseTurnovers (store use Shipment confirmation, without Purchase return order) - minus
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PurchaseTurnovers'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           |
		| '-10,000'   | 'Purchase return 3*' |

Сценарий: _022317 checking postings of the document Purchase return order in the InventoryBalance (store use Shipment confirmation, without Purchase return order) - minus
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'           | 'Line number' | 'Company'      | 'Item key' |
	| '10,000'    | 'Purchase return 3*' | '1'           | 'Main Company' | 'L/Green'  |

Сценарий: _022318 checking postings of the document Purchase return order in the GoodsInTransitOutgoing (store use Shipment confirmation, without Purchase return order) - plus
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'           | 'Shipment basis'     | 'Line number' | 'Store'    | 'Item key' |
	| '10,000'    | 'Purchase return 3*' | 'Purchase return 3*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _022319 checking that there are no postings of Purchase return in register StockBalance (store use Shipment confirmation, without Purchase return order)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
		| '10,000'    | 'Purchase return 3*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _022320 checking purchase return postings by register StockReservation (store use Shipment confirmation, without Purchase return order)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'              | 'Line number' | 'Store'    | 'Item key'  |
		| '10,000'    | 'Purchase return 3*'    | '1'           | 'Store 02' | 'L/Green'   |

Сценарий: _022321 checking purchase return postings by register Purchase return по регистру OrderReservation (store use Shipment confirmation, without Purchase return order)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'            | 'Line number' | 'Store'    | 'Item key' |
		| '10,000'    | 'Purchase return 3*' | '1'           | 'Store 02' | 'L/Green'  |


Сценарий: _022322 creating document Purchase return, store doesn't use Shipment confirmation, without Purchase return order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentPurchaseReturnGeneratePurchaseReturn'
	* Check filling details
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я нажимаю кнопку выбора у поля "Store"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Store 01'  |
	И в таблице "List" я выбираю текущую строку
	И Пауза 2
	И в таблице "ItemList" я перехожу к строке:
		| 'Item'     | 'Item key' |
		| 'Trousers' | '36/Yellow'|
	И в таблице "ItemList" я активизирую поле "Q"
	И в таблице "ItemList" я выбираю текущую строку
	И Пауза 2
	И в таблице "ItemList" в поле 'Q' я ввожу текст '12,000'
	И в таблице "ItemList" я завершаю редактирование строки
	И в таблице "ItemList" я перехожу к строке:
		| 'Item'  | 'Item key' | 'Unit' |
		| 'Dress' | 'L/Green'  | 'pcs'  |
	И в таблице 'ItemList' я удаляю строку
	И в таблице "ItemList" я перехожу к строке:
		| 'Item'  |
		| 'Dress' |
	И в таблице 'ItemList' я удаляю строку
	* Filling in the document number 4
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '4'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '4'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно

Сценарий: _022323 checking postings of the document Purchase return order in the PurchaseTurnovers (store doesn't use Shipment confirmation, without Purchase return order) - minus
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PurchaseTurnovers'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           |
		| '-12,000'   | 'Purchase return 4*' |

Сценарий: _022324 checking postings of the document Purchase return order in the InventoryBalance (store doesn't use Shipment confirmation, without Purchase return order) - minus
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'           | 'Line number' | 'Company'      | 'Item key' |
	| '12,000'    | 'Purchase return 4*' | '1'           | 'Main Company' | '36/Yellow'  | 

Сценарий: _022325 checking that there are no postings of Purchase return document by GoodsInTransitOutgoing (store doesn't use Shipment confirmation, without Purchase return order)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'           | 'Shipment basis'     | 'Line number' | 'Item key' |
	| '12,000'    | 'Purchase return 4*' | 'Purchase return 4*' | '1'           | '36/Yellow'  |

Сценарий: _022326 checking postings of the document Purchase return order in the StockBalance (store doesn't use Shipment confirmation, without Purchase return order) - minus
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
		| '12,000'   | 'Purchase return 4*' | '1'           | 'Store 01' | '36/Yellow'  |

Сценарий: _022327 checking postings of the document Purchase return order in the StockReservation (store doesn't use Shipment confirmation, without Purchase return order) - minus
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
		| '12,000'   | 'Purchase return 4*' | '1'           | 'Store 01' | '36/Yellow'  |

Сценарий: _022328 checking that there are no postings of Purchase return in register StockReservation (store doesn't use Shipment confirmation, without Purchase return order)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'              | 'Line number' | 'Store'    | 'Item key'  |
		| '12,000'    | 'Purchase return 4*'    | '1'           | 'Store 01' | '36/Yellow'   |

Сценарий: _022329 checking that there are no postings of Purchase return document by OrderReservation (store doesn't use Shipment confirmation, without Purchase return order)
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'            | 'Line number' | 'Store'    | 'Item key' |
		| '12,000'    | 'Purchase return 3*' | '1'           | 'Store 01' | '36/Yellow'  |


Сценарий: _022335 checking totals in the document Purchase return
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
	И я выбираю документ PurchaseReturn
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И в таблице "List" я выбираю текущую строку
	* Checking totals in the document Purchase return
		И     у элемента формы с именем "ItemListTotalTaxAmount" текст редактирования стал равен '12,20'
		И     у элемента формы с именем "ItemListTotalNetAmount" текст редактирования стал равен '67,80'
		И     у элемента формы с именем "ItemListTotalTotalAmount" текст редактирования стал равен '80,00'





