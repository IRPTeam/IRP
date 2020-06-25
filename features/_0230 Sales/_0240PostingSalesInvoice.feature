#language: ru
@tree
@Positive
Функционал: creating document Sales invoice

As a sales manager
I want to create a Sales invoice document
To sell a product to a customer


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий



Сценарий: _024001 creating document Sales Invoice based on order - Shipment confirmation doesn't used
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И в таблице "List" я перехожу к первой строке
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем "FormDocumentSalesInvoiceGenerateSalesInvoice"
	* Checking that information is filled in when creating based on
		Тогда элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Agreements, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	* Check adding Store
		И я перехожу к закладке "Item list"
		И     таблица "ItemList" содержит строки:
			| 'Item'     | Price | 'Item key'  | 'Store'    | 'Shipment confirmation' | 'Sales order'    | 'Unit' | 'Q'     | 'Offers amount'  | 'Tax amount' | 'Net amount' | 'Total amount' |
			| 'Dress'    | '*'    | 'L/Green'   | 'Store 01' | ''                      | 'Sales order 1*' | 'pcs' | '5,000' | '*'              | '*'          | '*'          | '*'           |
			| 'Trousers' | '*'    | '36/Yellow' | 'Store 01' | ''                      | 'Sales order 1*' | 'pcs' | '4,000' | '*'              | '*'          | '*'          | '*'           |
	* Checking prices and type of prices
		И     таблица "ItemList" содержит строки:
		| 'Price'  | 'Item'     | 'Item key'  | 'Q'     | 'Price type'        |
		| '550,00' | 'Dress'    | 'L/Green'   | '5,000' | 'Basic Price Types' |
		| '400,00' | 'Trousers' | '36/Yellow' | '4,000' | 'Basic Price Types' |	
	* Change of document number - 1
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно

Сценарий: _024002 checking Sales invoice posting (based on order, store doesn't use Shipment confirmation) by register OrderBalance (-)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'            | 'Store'    | 'Order'              | 'Item key' |
	| '5,000'    | 'Sales invoice 1*'    | 'Store 01' | 'Sales order 1*'     | 'L/Green'  |
	| '4,000'    | 'Sales invoice 1*'    | 'Store 01' | 'Sales order 1*'     | '36/Yellow'   |

Сценарий: _024003 checking Sales invoice posting (based on order, store doesn't use Shipment confirmation) by register OrderReservation (-)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'         | 'Store'    | 'Item key' |
		| '5,000'    | 'Sales invoice 1*' | 'Store 01' | 'L/Green'   |
		| '4,000'    | 'Sales invoice 1*' | 'Store 01' | '36/Yellow' |


Сценарий: _024004 checking Sales invoice posting (based on order, store doesn't use Shipment confirmation) by register InventoryBalance (-)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'            | 'Company'      | 'Item key' |
		| '5,000'    | 'Sales invoice 1*'    | 'Main Company' | 'L/Green'  |
		| '4,000'    | 'Sales invoice 1*'    | 'Main Company' | '36/Yellow'   |

Сценарий: _024005 checking Sales invoice posting (based on order, store doesn't use Shipment confirmation) by register StockBalance (-)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Store'    | 'Item key' |
		| '5,000'    | 'Sales invoice 1*'   | 'Store 01' | 'L/Green'  |
		| '4,000'    | 'Sales invoice 1*'   | 'Store 01' | '36/Yellow'   |


Сценарий: _024006 checking the absence posting of Sales invoice (based on order, store doesn't use Shipment confirmation) by register StockReservation
# All lines in the sales invoice by order
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'               | 'Store'    | 'Item key' |
		| '5,000'    | 'Sales invoice 1*'       | 'Store 01' | 'L/Green'  |
		| '4,000'    | 'Sales invoice 1*'       | 'Store 01' | '36/Yellow'   |

Сценарий: _024007 checking Sales invoice posting (based on order, store doesn't use Shipment confirmation) by register SalesTurnovers
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List"содержит строки:
		| 'Quantity' | 'Recorder'         | 'Sales invoice'    | 'Item key'  |
		| '5,000'    | 'Sales invoice 1*' | 'Sales invoice 1*' | 'L/Green'   |
		| '4,000'    | 'Sales invoice 1*' | 'Sales invoice 1*' | '36/Yellow' |

Сценарий: _024008 creating document Sales Invoice based on order - Shipment confirmation used
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner'   |
		| '2'      | 'Ferron BP' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем "FormDocumentSalesInvoiceGenerateSalesInvoice"
	* Checking the details
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Agreements, without VAT'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Check filling prices and type of prices
		И     таблица "ItemList" содержит строки:
		| 'Price'  | 'Item'     | 'Item key'  | 'Price type'              | 'Q'      |
		| '466,10' | 'Dress'    | 'L/Green'   | 'Basic Price without VAT' | '10,000' |
		| '338,98' | 'Trousers' | '36/Yellow' | 'Basic Price without VAT' | '14,000' |
	* Change of document number - 2
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно

Сценарий: _024009  checking Sales invoice posting (based on order, store use Shipment confirmation) by register SalesTurnovers
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'         | 'Sales invoice'    | 'Item key'  |
		| '10,000'   | 'Sales invoice 2*' | 'Sales invoice 2*' | 'L/Green'   |
		| '14,000'   | 'Sales invoice 2*' | 'Sales invoice 2*' | '36/Yellow' |

Сценарий: _024010  checking Sales invoice posting (based on order, store use Shipment confirmation) by register OrderBalance (-)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'             | 'Store'    | 'Order'              | 'Item key' |
	| '10,000'    | 'Sales invoice 2*'    | 'Store 02' | 'Sales order 2*'     | 'L/Green'  |
	| '14,000'    | 'Sales invoice 2*'    | 'Store 02' | 'Sales order 2*'     | '36/Yellow'   |

Сценарий: _024011  checking Sales invoice posting (based on order, store use Shipment confirmation) by register InventoryBalance (-)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'            | 'Company'      | 'Item key' |
		| '10,000'    | 'Sales invoice 2*'   | 'Main Company' | 'L/Green'  |
		| '14,000'    | 'Sales invoice 2*'   | 'Main Company' | '36/Yellow'   |

Сценарий: _024012  checking Sales invoice posting (based on order, store use Shipment confirmation) by register GoodsInTransitOutgoing
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'         | 'Shipment basis'   | 'Store'    | 'Item key' |
		| '10,000'   | 'Sales invoice 2*' | 'Sales invoice 2*' | 'Store 02' | 'L/Green'  |
		| '14,000'   | 'Sales invoice 2*' | 'Sales invoice 2*' | 'Store 02' | '36/Yellow'   |

Сценарий: _024013 checking the absence posting of Sales invoice (based on order, store  use Shipment confirmation) by register StockBalance
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'            | 'Store'    | 'Item key' |
		| '10,000'    | 'Sales invoice 2*'   | 'Store 02' | 'L/Green'  |
		| '14,000'    | 'Sales invoice 2*'   | 'Store 02' | '36/Yellow'   |

Сценарий: _024014 checking Sales invoice posting (based on order, store use Shipment confirmation) by register OrderReservation (-)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'         | 'Store'    | 'Item key'  |
		| '10,000'   | 'Sales invoice 2*' | 'Store 02' | 'L/Green'   |
		| '14,000'   | 'Sales invoice 2*' | 'Store 02' | '36/Yellow' |


Сценарий: _024015 checking the absence posting of Sales invoice (based on order, store  use Shipment confirmation) by register StockReservation
# All lines in the sales invoice by order
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'              | 'Store'    | 'Item key' |
		| '5,000'    | 'Sales invoice 2*'      | 'Store 02' | 'L/Green'  |
		| '4,000'    | 'Sales invoice 2*'      | 'Store 02' | '36/Yellow'   |


Сценарий: _024016 creating document Sales Invoice order - Shipment confirmation doesn't used
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in customer information
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я выбираю текущую строку
	* Select store 
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я выбираю текущую строку
	* Change of document number - 3
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '3'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '3'
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
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post'
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
	И я нажимаю на кнопку 'Post and close'

Сценарий: _024017 checking Sales invoice posting (without order, store doesn't use Shipment confirmation) by register StockReservation
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'              | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales invoice 3*'      | 'Store 01' | 'L/Green'  |

Сценарий: _024018 checking the absence posting of Sales invoice (without order, store  doesn't use Shipment confirmation) by register OrderBalance
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'             | 'Store'    | 'Order'              | 'Item key' |
	| '1,000'    | 'Sales invoice 3 *'    | 'Store 01' | ''     | 'L/Green'  |

Сценарий: _024019 checking the absence posting of Sales invoice (without order, store  doesn't use Shipment confirmation) by register OrderReservation
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'             | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales invoice 3 *'    | 'Store 01' |  'L/Green'  |

Сценарий: _024020 checking Sales invoice posting (without order, store doesn't use Shipment confirmation) by register InventoryBalance
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'            | 'Company'      | 'Item key' |
		| '1,000'    | 'Sales invoice 3*'    | 'Main Company' | 'L/Green'  |

Сценарий: _024021 checking Sales invoice posting (without order, store doesn't use Shipment confirmation) by register StockBalance
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales invoice 3*'   | 'Store 01' | 'L/Green'  |

Сценарий: _024022 checking the absence posting of Sales invoice (without order, store  doesn't use Shipment confirmation) by register GoodsInTransitOutgoing
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'         | 'Shipment basis'   | 'Store'    | 'Item key' |
		| '1,000'   | 'Sales invoice 3*'  | 'Sales invoice 3*' | 'Store 01' | 'L/Green'  |

Сценарий: _024023 checking Sales invoice posting (without order, store doesn't use Shipment confirmation) by register SalesTurnovers
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List"содержит строки:
		| 'Quantity' | 'Recorder'         | 'Sales invoice'    | 'Item key' |
		| '1,000'    | 'Sales invoice 3*' | 'Sales invoice 3*' | 'L/Green'  |

Сценарий: _024024 checking the absence posting of Sales invoice (without order, store  doesn't use Shipment confirmation) by register OrderReservation (-)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key'  |
		| '1,000'   | 'Sales invoice 3*' | 'Store 01' | 'L/Green'   |



Сценарий: _024025 creating document Sales Invoice order - Shipment confirmation used
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in customer information
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я выбираю текущую строку
	* Change of document number - 4
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '4'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '4'
	* Change store to Store 02
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02  |
		И в таблице "List" я выбираю текущую строку
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
		И в таблице "ItemList" в поле 'Q' я ввожу текст '20,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post'
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
	И я нажимаю на кнопку 'Post and close'

Сценарий: _024026 checking Sales invoice posting (without order, store use Shipment confirmation) by register StockReservation
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'               | 'Store'     | 'Item key' |
		| '20,000'    | 'Sales invoice 4*'      | 'Store 02' | 'L/Green'  |

Сценарий: _024027 checking the absence posting of Sales invoice (without order, store  use Shipment confirmation) by register OrderBalance
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'             | 'Store'    | 'Order'              | 'Item key' |
	| '20,000'    | 'Sales invoice 4 *'   | 'Store 02' | ''                  | 'L/Green'  |

Сценарий: _024028 checking the absence posting of Sales invoice (without order, store  use Shipment confirmation) by register OrderReservation
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'             | 'Store'    | 'Item key' |
	| '20,000'    | 'Sales invoice 4 *'   | 'Store 02' | 'L/Green'  |

Сценарий: _024029 checking Sales invoice posting (without order, store use Shipment confirmation) by register InventoryBalance
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Company'      | 'Item key' |
		| '20,000'    | 'Sales invoice 4*'  | 'Main Company' | 'L/Green'  |

Сценарий: _024030 checking Sales invoice posting (without order, store use Shipment confirmation) by register GoodsInTransitOutgoing
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'          | 'Shipment basis'   | 'Store'    | 'Item key' |
		| '20,000'   | 'Sales invoice 4*'  | 'Sales invoice 4*' | 'Store 02' | 'L/Green'  |

Сценарий: _024031 checking the absence posting of Sales invoice (without order, store  use Shipment confirmation) by register StockBalance
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'             | 'Store'    | 'Item key' |
		| '20,000'    | 'Sales invoice 4*'    | 'Store 02' | 'L/Green'  |

Сценарий: _024032 checking Sales invoice posting (without order, store use Shipment confirmation) by register SalesTurnovers
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List"содержит строки:
		| 'Quantity' | 'Recorder'         | 'Sales invoice'    | 'Item key' |
		| '20,000'   | 'Sales invoice 4*' | 'Sales invoice 4*' | 'L/Green'  |

Сценарий: _024033 checking the absence posting of Sales invoice (without order, store  use Shipment confirmation) by register OrderReservation (-)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'         | 'Store'    | 'Item key'  |
		| '20,000'   | 'Sales invoice 4*' | 'Store 02' | 'L/Green'   |

Сценарий: _024034 Sales invoice creation on set, store use Goods receipt
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in customer information
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Personal Agreements, $' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Company Kalipso'  |
		И в таблице "List" я выбираю текущую строку
	* Select store 
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'  |
		И в таблице "List" я выбираю текущую строку
	* Filling in items table
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key'  |
			| 'Boots' | 'Boots/S-8' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key'  |
			| 'Dress' | 'Dress/A-8' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Change of document number - 5
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '5'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '5'
	И я перехожу к закладке "Item list"
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 2
	И таблица 'List' содержит строки
			| 'Partner'       | 'Σ'        |
			| 'Kalipso'       | '8 000,00' |
	И Я закрыл все окна клиентского приложения
	*  Checking postings by register
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'         | 'Store'    | 'Item key'  |
			| '1,000'    | 'Sales invoice 5*' | 'Store 02' | 'Dress/A-8' |
			| '1,000'    | 'Sales invoice 5*' | 'Store 02' | 'Boots/S-8' |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'            | 'Company'      | 'Item key'  |
			| '1,000'   | 'Sales invoice 5*'    | 'Main Company' | 'Dress/A-8' |
			| '1,000'   | 'Sales invoice 5*'    | 'Main Company' | 'Boots/S-8' |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
		Тогда таблица "List"содержит строки:
			| 'Quantity' | 'Recorder'         | 'Sales invoice'    | 'Item key'  |
			| '1,000'    | 'Sales invoice 5*' | 'Sales invoice 5*' | 'Dress/A-8' |
			| '1,000'    | 'Sales invoice 5*' | 'Sales invoice 5*' | 'Boots/S-8' |
		И Я закрыл все окна клиентского приложения

Сценарий: _024035 checking the form of selection of items (sales invoice)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-379' с именем 'IRP-379'
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the main details of the document
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Basic Agreements, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Company Ferron BP'  |
		И в таблице "List" я выбираю текущую строку
	* Select Store
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
	Когда проверяю форму подбора товара с информацией по ценам в Sales invoice
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
	И я нажимаю на кнопку 'Post and close'
	* Save check
		Тогда таблица "List" содержит строки:
			| 'Partner'     |'Σ'          |
			| 'Ferron BP'   | '2 050,00'  |
	И я закрыл все окна клиентского приложения



Сценарий: _024042 checking totals in the document Sales invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	* Select Purchase Sales invoice
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И в таблице "List" я выбираю текущую строку
	* Checking totals
		И     элемент формы с именем "ItemListTotalOffersAmount" стал равен '0,00'
		И     элемент формы с именем "ItemListTotalNetAmount" стал равен '3 686,44'
		И     элемент формы с именем "ItemListTotalTaxAmount" стал равен '663,56'
		И     элемент формы с именем "ItemListTotalTotalAmount" стал равен '4 350,00'
		И     элемент формы с именем "CurrencyTotalAmount" стал равен 'TRY'











	
















	



