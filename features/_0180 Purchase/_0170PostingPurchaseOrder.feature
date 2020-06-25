#language: ru
@tree
@Positive


Функционал: creating document Purchase order

As a procurement manager
I want to create a Purchase order document
For tracking an item that has been ordered from a vendor

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _017001 creating document Purchase order - Goods receipt is not used
	* Opening a form to create Purchase Order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Status filling
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
	* Filling in vendor information
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
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
	* Filling in the document number №2
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	* Filling in items table
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		Тогда открылось окно 'Items'
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'L/Green'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		Тогда открылось окно 'Items'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| '#' | 'Item'  | 'Item key' | 'Unit' |
			| '1' | 'Dress' | 'M/White' | 'pcs' |
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '100'
		И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| '#' | 'Item'  | 'Item key' | 'Unit' |
			| '2' | 'Dress' | 'L/Green'  | 'pcs' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '200'
		И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| '#' | 'Item'     | 'Item key' | 'Unit' |
			| '3' | 'Trousers' | '36/Yellow'   | 'pcs' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '300'
		И в таблице "ItemList" в поле 'Price' я ввожу текст '250'
		И в таблице "ItemList" я завершаю редактирование строки
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Q' | 'Item key'  | 'Store' | 'Unit' |
			| 'Dress'    | '100,000'  | 'M/White'   | 'Store 01'      | 'pcs' |
	* Post document
		И я нажимаю на кнопку 'Post and close'

Сценарий: _017002 checking Purchase Order N2 posting by register Order Balance (+) - Goods receipt is not used
	* Opening register Order Balance
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	* Checking the register form
		Если в таблице "List" есть колонки Тогда
			| 'Period' |
			| 'Quantity' |
			| 'Recorder' |
			| 'Line number' |
			| 'Store' |
			| 'Order' |
			| 'Item key' |
	* Checking Purchase Order N2 posting by register Order Balance
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key' |
			| '100,000'  | 'Purchase order 2*' | '1'           | 'Store 01' | 'Purchase order 2*' | 'M/White' |
			| '200,000'  | 'Purchase order 2*' | '2'           | 'Store 01' | 'Purchase order 2*' | 'L/Green'  |
			| '300,000'  | 'Purchase order 2*' | '3'           | 'Store 01' | 'Purchase order 2*' | '36/Yellow'   |

Сценарий: _017003 creating document Purchase order - Goods receipt is used
	* Opening a form to create Purchase Order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
	* Filling in vendor information
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
			| Vendor Ferron, USD |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'  |
		И в таблице "List" я выбираю текущую строку
	* Filling in the document number №3
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '3'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '3'
	* Filling in items table
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		Тогда открылось окно 'Items'
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'L/Green'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| '#' | 'Item'  | 'Item key' | 'Unit' |
			| '1' | 'Dress' | 'L/Green'  | 'pcs' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '500,000'
		И в таблице "ItemList" в поле 'Price' я ввожу текст '40,00'
		И в таблице "ItemList" я завершаю редактирование строки
	* Post document
		И я нажимаю на кнопку 'Post and close'

Сценарий: _017004 checking Purchase Order N3 posting by register Order Balance (+) - Goods receipt is not used
	* Opening of register Order Balance
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	* Checking Purchase Order N3 posting by register Order Balance
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key' |
			| '500,000'  | 'Purchase order 3*' | '1'           | 'Store 02' | 'Purchase order 3*' | 'L/Green'  |

Сценарий: _017005 checking postings by status and status history of a Purchase Order document
	И    Я закрыл все окна клиентского приложения
	* Opening a form to create Purchase Order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
		И в таблице "List" я выбираю текущую строку
	* Filling in vendor information
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
	* Checking the default status "Wait"
		И элемент формы с именем "Status" стал равен "Wait"
	* Filling in the document number №101
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '101'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '101'
	* Filling in items table
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'L/Green'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| '#' | 'Item'  | 'Item key' | 'Unit' |
			| '1' | 'Dress' | 'M/White' | 'pcs' |
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '20,000'
		И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| '#' | 'Item'  | 'Item key' | 'Unit' |
			| '2' | 'Dress' | 'L/Green'  | 'pcs' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '20,000'
		И в таблице "ItemList" в поле 'Price' я ввожу текст '210,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| '#' | 'Item'     | 'Item key' | 'Unit' |
			| '3' | 'Trousers' | '36/Yellow'   | 'pcs' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '30,000'
		И в таблице "ItemList" в поле 'Price' я ввожу текст '210,00'
		И в таблице "ItemList" я завершаю редактирование строки
	* Post document
		И я нажимаю на кнопку 'Post and close'
		И я закрываю текущее окно
	* Checking the absence of postings Purchase Order N101 by register Order Balance
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" не содержит строки:
			| 'Recorder'          | 'Store'    | 'Order'             |
			| 'Purchase order 101*' | 'Store 01' | 'Purchase order 101*' |
		И    Я закрыл все окна клиентского приложения
	* Setting the status by Purchase Order №101 'Approved'
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '101'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю на кнопку 'Post'
		И я нажимаю на гиперссылку с именем "DecorationStatusHistory"
		Тогда таблица "List" содержит строки:
			| Object             | Status   |
			| Purchase order 101* | Wait     |
			| Purchase order 101* | Approved |
		И я закрываю текущее окно
		И я нажимаю на кнопку 'Post and close'
		И я закрываю текущее окно
	* Checking document postings after the status is set to Approved
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
			| 'Recorder'          | 'Store'    | 'Order'             |
			| 'Purchase order 101*' | 'Store 01' | 'Purchase order 101*' |
		И я закрываю текущее окно
	* Checking for cancelled postings when the Approved status is changed to Wait
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '101'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на гиперссылку "Decoration group title collapsed picture"
		И из выпадающего списка "Status" я выбираю точное значение 'Wait'
		И я нажимаю на кнопку 'Post'
		И я нажимаю на гиперссылку с именем "DecorationStatusHistory"
		Тогда таблица "List" содержит строки:
			| 'Object'             | 'Status'   |
			| 'Purchase order 101*' | 'Wait'     |
			| 'Purchase order 101*' | 'Approved' |
			| 'Purchase order 101*' | 'Wait'     |
		И я закрываю текущее окно
		И я нажимаю на кнопку 'Post and close'
		И я закрываю текущее окно
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" не содержит строки:
			| 'Recorder'          | 'Store'    | 'Order'             |
			| 'Purchase order 101*' | 'Store 01' | 'Purchase order 101*' |
		И я закрываю текущее окно



Сценарий: _017011 checking totals in the document Purchase Order
	* Opening a list of documents Purchase Order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	* Selecting PurchaseOrder
		И в таблице "List" я перехожу к строке:
		| Number |
		| 2      |
		И в таблице "List" я выбираю текущую строку
	* Checking totals in the document
		И     у элемента формы с именем "ItemListTotalOffersAmount" текст редактирования стал равен '0,00'
		И     элемент формы с именем "ItemListTotalNetAmount" стал равен '116 101,69'
		И     элемент формы с именем "ItemListTotalTaxAmount" стал равен '20 898,31'
		И     у элемента формы с именем "ItemListTotalTotalAmount" текст редактирования стал равен '137 000,00'

	


Сценарий: _017003 checking the form Pick up items in the document Purchase order
	* Opening a form to create Purchase Order
		И    Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in vendor information
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
	* Checking the form Pick up items
		Когда проверяю форму подбора товара с информацией по ценам в Purchase order
		И Я закрыл все окна клиентского приложения
	








