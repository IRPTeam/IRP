#language: ru 
@tree
@Positive
Функционал: creating document Sales return

As a procurement manager
I want to create a Sales return document
To track a product that returned from customer

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: _028501 creating document Sales return, store use Goods receipt, without Sales return order
	И Я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner'     |
		| '3'      |  'Kalipso' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentSalesReturnGenerateSalesReturn'
	* Checking the details
		И     элемент формы с именем "Partner" стал равен 'Kalipso'
		И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		И     элемент формы с именем "Agreement" стал равен 'Personal Partner terms, $'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я нажимаю кнопку выбора у поля "Store"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Store 02'  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	И я перехожу к закладке "Item list"
	И в таблице "ItemList" я активизирую поле "Q"
	И в таблице "ItemList" я выбираю текущую строку
	И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
	И в таблице "ItemList" в поле 'Price' я ввожу текст '550,00'
	И в таблице "ItemList" я завершаю редактирование строки
	И я перехожу к закладке "Item list"
	И     таблица "ItemList" содержит строки:
	| 'Item'     | 'Item key'  | 'Store'    |
	| 'Dress'    |  'L/Green'  | 'Store 02' |
	* Filling in the document number 1
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно


Сценарий: _028502 checking that there are no postings of Sales return in register OrderBalance (store use Goods receipt, without Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'        | 'Line number' | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales return 1*' | '1'           | 'Store 02' | 'L/Green'  |


Сценарий: _028503 checking postings of Sales return in register SalesTurnovers (store use Goods receipt, without Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Line number' | 'Sales invoice'    | 'Item key' |
		| '-1,000'   | 'Sales return 1*' | '1'           | 'Sales invoice 3*' | 'L/Green'  |

Сценарий: _028504 checking postings of Sales return in register InventoryBalance (store use Goods receipt, without Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Line number' | 'Company'      | 'Item key' |
		| '1,000'    | 'Sales return 1*' | '1'           | 'Main Company' | 'L/Green'  |

Сценарий: _028505 checking postings of Sales return in register GoodsInTransitIncoming (store use Goods receipt, without Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Receipt basis'   | 'Line number' | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales return 1*' | 'Sales return 1*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _028506 checking that there are no postings of Sales return in register StockBalance (store use Goods receipt, without Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'        | 'Line number' | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales return 1*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _028507 checking that there are no postings of Sales return in register StockReservation (store use Goods receipt, without Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'        | 'Line number' | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales return 1*' | '1'           | 'Store 02' | 'L/Green'  |



Сценарий: _028508 creating document Sales return, store doesn't use Goods receipt, without Sales return order
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner'     |
		| '2'      |  'Ferron BP' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentSalesReturnGenerateSalesReturn'
	* Checking the details
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, without VAT'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	* Select store
		И я нажимаю кнопку выбора у поля "Store"
		Тогда открылось окно 'Stores'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
	И я перехожу к закладке "Item list"
	И в таблице "ItemList" я перехожу к строке:
		| 'Item'     |
		| 'Trousers' |
	И в таблице 'ItemList' я удаляю строку
	И в таблице "ItemList" я активизирую поле "Q"
	И в таблице "ItemList" я выбираю текущую строку
	И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
	И в таблице "ItemList" в поле 'Price' я ввожу текст '466,10'
	И в таблице "ItemList" я завершаю редактирование строки
	* Filling in the document number 2
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно


Сценарий: _028509 checking that there are no postings of Sales return in register OrderBalance (store doesn't use Goods receipt, without Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'        | 'Line number' | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales return 2*' | '1'           | 'Store 01' | 'L/Green'  |

Сценарий: _028510 checking postings of Sales return in register SalesTurnovers (store doesn't use Goods receipt, without Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Line number' | 'Sales invoice'    | 'Item key' |
		| '-1,000'   | 'Sales return 2*' | '1'           | 'Sales invoice 2*' | 'L/Green'  |

Сценарий: _028511 checking postings of Sales return in register InventoryBalance (store doesn't use Goods receipt, without Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Line number' | 'Company'      | 'Item key' |
		| '1,000'    | 'Sales return 2*' | '1'           | 'Main Company' | 'L/Green'  |

Сценарий: _028512 checking that there are no postings of Sales return in register GoodsInTransitIncoming (store doesn't use Goods receipt, without Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'        | 'Receipt basis'   | 'Line number' | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales return 2*' | 'Sales return 2*' | '1'           | 'Store 01' | 'L/Green'  |

Сценарий: _028513 checking postings of Sales return in register StockBalance (store doesn't use Goods receipt, without Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'        | 'Line number' | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales return 2*' | '1'           | 'Store 01' | 'L/Green'  |

Сценарий: _028514 checking postings of Sales return in register StockReservation (store doesn't use Goods receipt, without Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'        | 'Line number' | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales return 2*' | '1'           | 'Store 01' | 'L/Green'  |



Сценарий: _028515 creating document Sales return, store use Goods receipt, based on Sales return order
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentSalesReturnGenerateSalesReturn'
	* Checking the details
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, without VAT'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	И в таблице "ItemList" в поле 'Price' я ввожу текст '466,10'
	* Filling in the document number 3
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '3'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '3'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно

Сценарий: _028516 checking postings of Sales return in register OrderBalance (store use Goods receipt,  based on Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Store'    | 'Order'                 | 'Item key' |
		| '1,000'    | 'Sales return 3*' | 'Store 02' | 'Sales return order 1*' | 'L/Green'  |

Сценарий: _028517 checking that there are no postings of Sales return in register SalesTurnovers (store use Goods receipt, based on Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'        | 'Item key' |
		| '-1,000'   | 'Sales return 3*' | 'L/Green'  |

Сценарий: _028518 checking postings of Sales return in register InventoryBalance (store use Goods receipt,  based on Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Company'      | 'Item key' |
		| '1,000'    | 'Sales return 3*' | 'Main Company' | 'L/Green'  |

Сценарий: _028519 checking postings of Sales return in register GoodsInTransitIncoming (store use Goods receipt,  based on Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Receipt basis'   | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales return 3*' | 'Sales return 3*' | 'Store 02' | 'L/Green'  |

Сценарий: _028520 checking that there are no postings of Sales return in register StockBalance (store use Goods receipt, based on Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales return 3*' | 'Store 02' | 'L/Green'  |

Сценарий: _028521 checking that there are no postings of Sales return in register StockReservation (store use Goods receipt, based on Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales return 3*' | 'Store 02' | 'L/Green'  |


Сценарий: _028522 creating document Sales return, store doesn't use Goods receipt, based on Sales return order
	
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '2'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentSalesReturnGenerateSalesReturn'
	* Checking the details
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 01'
	* Filling in the document number 4
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '4'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '4'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно


Сценарий: _028523 checking postings of Sales return in register OrderBalance (store use Goods receipt,  based on Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key'  |
		| '2,000'    | 'Sales return 4*' | 'Store 01' | 'L/Green'   |
		| '4,000'    | 'Sales return 4*' | 'Store 01' | '36/Yellow' |

Сценарий: _028524 checking that there are no postings of Sales return in register SalesTurnovers (store doesn't use Goods receipt, based on Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'        | 'Sales invoice'    | 'Item key' |
		| '-2,000'   | 'Sales return 4*' | 'Sales invoice 4*' | 'L/Green'  |
		| '-4,000'   | 'Sales return 4*' | 'Sales invoice 4*' | '36/Yellow' |


Сценарий: _028525 checking postings of Sales return in register InventoryBalance (store doesn't use Goods receipt,  based on Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Company'      | 'Item key'  |
		| '2,000'    | 'Sales return 4*' | 'Main Company' | 'L/Green'   |
		| '4,000'    | 'Sales return 4*' | 'Main Company' | '36/Yellow' |


Сценарий: _028526 checking that there are no postings of Sales return in register GoodsInTransitIncoming (store doesn't use Goods receipt, based on Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'        | 'Receipt basis'   | 'Store'    | 'Item key' |
		| '2,000'    | 'Sales return 4*' | 'Sales return 4*' | 'Store 01' | 'L/Green'  |
		| '4,000'    | 'Sales return 4*' | 'Sales return 4*' | 'Store 01' | '36/Yellow'  |


Сценарий: _028527 checking postings of Sales return in register StockBalance (store doesn't use Goods receipt,  based on Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key'  |
	| '2,000'    | 'Sales return 4*' | 'Store 01' | 'L/Green'   |
	| '4,000'    | 'Sales return 4*' | 'Store 01' | '36/Yellow' |

Сценарий: _028528 checking postings of Sales return in register StockReservation (store doesn't use Goods receipt,  based on Sales return order) 
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key'  |
	| '2,000'    | 'Sales return 4*' | 'Store 01' | 'L/Green'   |
	| '4,000'    | 'Sales return 4*' | 'Store 01' | '36/Yellow' |




Сценарий: _028534 checking totals in the document Sales return
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
	И я выбираю документ SalesReturn
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И в таблице "List" я выбираю текущую строку
	* Checking totals in the document Sales return
		И     элемент формы с именем "ItemListTotalNetAmount" стал равен '466,10'
		И     элемент формы с именем "ItemListTotalTaxAmount" стал равен '83,90'
		И     элемент формы с именем "ItemListTotalTotalAmount" стал равен '550,00'
		И     элемент формы с именем "CurrencyTotalAmount" стал равен 'USD'


