#language: ru
@tree
@Positive
Функционал: creating document Goods receipt

As a storekeeper
I want to create a Goods receipt
To take products to the store


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий



Сценарий: _028901 creating document Goods Reciept based on Purchase invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '2'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем "FormDocumentGoodsReceiptGenerateGoodsReceipt"
	* Checking that information is filled in when creating based on
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Change of document number - 106
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '106'
	* Checking the filling in the tabular part of the  items
		И     таблица "ItemList" содержит строки:
		| '#' | 'Item'     | 'Receipt basis'     | 'Item key' | 'Unit' | 'Quantity'       |
		| '1' | 'Dress'    | 'Purchase invoice 2*' | 'L/Green'  | 'pcs' | '500,000' |
		И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Quantity' | 'Item key' | 'Store'    | 'Unit' |
		| 'Dress' | '500,000'  | 'L/Green'  | 'Store 02' | 'pcs' |
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно
	

Сценарий: _028902 checking  Goods Reciept posting by register GoodsInTransitIncoming (-)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'          | 'Receipt basis'         | 'Line number' | 'Store'    | 'Item key'  |
		| '500,000'  | 'Goods receipt 106*'  | 'Purchase invoice 2*'   | '1'           | 'Store 02' | 'L/Green'   |

Сценарий: _028903 checking  Goods Reciept posting by register StockBalance (+)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки: 
		| 'Quantity' | 'Recorder'             | 'Line number'  | 'Store'    | 'Item key' |
		| '500,000'  | 'Goods receipt 106*'   | '1'            | 'Store 02' | 'L/Green'  |

Сценарий: _028904 checking  Goods Reciept posting by register StockReservation (+)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки: 
		| 'Quantity' | 'Recorder'                          | 'Line number' | 'Store'    | 'Item key' |
		| '500,000'  | 'Goods receipt 106*'                 | '1'           | 'Store 02'    | 'L/Green'  |

