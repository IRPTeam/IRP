#language: ru
@tree
@Positive
Функционал: creating document Sales return order

As a sales manager
I want to create a Sales return order document
To track a product that needs to be returned from customer


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _028001 creating document Sales return order, store use Goods receipt, based on Sales invoice + checking status
	И Я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner'     |
		| '2'      |  'Ferron BP' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentSalesReturnOrderGenerateSalesReturnOrder'
	* Checking the details
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Agreements, without VAT'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	* Select store
		И я нажимаю кнопку выбора у поля "Store"
		Тогда открылось окно 'Stores'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'  |
		И в таблице "List" я выбираю текущую строку
	И из выпадающего списка "Status" я выбираю точное значение 'Wait'
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
	* Filling in the document number 1
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
		И я перехожу к закладке "Item list"
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  | 'Store'    |
		| 'Dress'    |  'L/Green'  | 'Store 02' |
	И я нажимаю на кнопку 'Post and close'
	И Я закрыл все окна клиентского приложения
	* Checking for no postings in the registers
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'              | 'Store'    | 'Order'              | 'Item key' |
			| '1,000'    | 'Sales return order 1*' | 'Store 02' | 'Sales return order 1*' | 'L/Green'  |
		И Я закрываю текущее окно
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
		Тогда таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'              | 'Sales invoice'    | 'Item key' |
			| '-1,000'   | 'Sales return order 1*' | 'Sales invoice 2*' | 'L/Green'  |
		И Я закрыл все окна клиентского приложения
	* And I set Approved status
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на гиперссылку "Decoration group title collapsed picture"
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю на кнопку "Post"
	* Check history by status
		И я нажимаю на гиперссылку "History"
		Тогда таблица "List" содержит строки:
			| 'Object'                 | 'Status'   |
			| 'Sales return order 1*' | 'Wait'     |
			| 'Sales return order 1*' | 'Approved' |
		И я закрываю текущее окно
		И я нажимаю на кнопку 'Post and close'


Сценарий: _028002 checking  Sales  return order postings the OrderBalance register (store use Goods receipt, based on Sales invoice)  (+)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'              | 'Store'    | 'Order'              | 'Item key' |
		| '1,000'    | 'Sales return order 1*' | 'Store 02' | 'Sales return order 1*' | 'L/Green'  |

Сценарий: _028003 checking  Sales  return order postings the SalesTurnovers register (store use Goods receipt, based on Sales invoice)  (-)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'              | 'Sales invoice'    | 'Item key' |
		| '-1,000'   | 'Sales return order 1*' | 'Sales invoice 2*' | 'L/Green'  |


Сценарий: _028004 creating document Sales return order, store doesn't use Goods receipt, based on Sales invoice
	
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner'     |
		| '1'      |  'Ferron BP' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentSalesReturnOrderGenerateSalesReturnOrder'
	* Checking the details
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Agreements, TRY'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я нажимаю кнопку выбора у поля "Store"
	Тогда открылось окно 'Stores'
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Store 01'  |
	И в таблице "List" я выбираю текущую строку
	И из выпадающего списка "Status" я выбираю точное значение 'Approved'
	И я перехожу к закладке "Item list"
	И в таблице "ItemList" я перехожу к строке:
		| 'Item'  | 'Item key' |
		| 'Dress' | 'L/Green'  |
	И в таблице "ItemList" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле "Q"
	И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
	И в таблице "ItemList" в поле 'Price' я ввожу текст '550,00'
	И в таблице "ItemList" я завершаю редактирование строки
	И в таблице "ItemList" я перехожу к строке:
		| Item     | Item key  |
		| Trousers | 36/Yellow |
	И в таблице "ItemList" я выбираю текущую строку
	И в таблице "ItemList" в поле 'Price' я ввожу текст '400,00'
	И в таблице "ItemList" я завершаю редактирование строки
	* Filling in the document number 2
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно


Сценарий: _028005 checking Sales return order postings the OrderBalance register (store doesn't use Goods receipt, based on Sales invoice)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'              | 'Store'    | 'Order'                 | 'Item key'  |
		| '2,000'    | 'Sales return order 2*' | 'Store 01' | 'Sales return order 2*' | 'L/Green'   |
		| '4,000'    | 'Sales return order 2*' | 'Store 01' | 'Sales return order 2*' | '36/Yellow' |

Сценарий: _028006 checking Sales return order postings the SalesTurnovers register (store doesn't use Goods receipt, based on Sales invoice) (-)
	
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'              | 'Sales invoice'    | 'Item key'  |
		| '-2,000'   | 'Sales return order 2*' | 'Sales invoice 1*' | 'L/Green'   |
		| '-4,000'   | 'Sales return order 2*' | 'Sales invoice 1*' | '36/Yellow' |



Сценарий: _028012 checking totals in the document Sales return order
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
	И я выбираю документ SalesReturn
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И в таблице "List" я выбираю текущую строку
	* Checking totals in the document Sales return order
		И     элемент формы с именем "ItemListTotalNetAmount" стал равен '466,10'
		И     элемент формы с именем "ItemListTotalTaxAmount" стал равен '83,90'
		И     элемент формы с именем "ItemListTotalTotalAmount" стал равен '550,00'
		И     элемент формы с именем "CurrencyTotalAmount" стал равен 'TRY'


