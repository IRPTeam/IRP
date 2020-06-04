#language: ru
@tree
@Positive
Функционал: проведение документа заявки на возврат от покупателя по регистрам складского учета

Как Разработчик
Я хочу создать проводки документа заявка на возврат клиента
Для того чтобы фиксировать какой товар планируется вернуть

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _028001 создание документа заявки на возврат от клиента (Sales return order) на ордерный склад на основании Sales invoice + проверка движений по статусам и истории статусов
	И Я закрыл все окна клиентского приложения
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-205' с именем 'IRP-205'
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner'     |
		| '2'      |  'Ferron BP' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentSalesReturnOrderGenerateSalesReturnOrder'
	И я проверяю заполнение реквизитов
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Agreements, without VAT'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я выбираю склад для возврата
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
	И я устанавливаю номер документа 1
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	И я проверяю добавление склада в табличную часть
		# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-234' с именем 'IRP-234'
		И я перехожу к закладке "Item list"
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  | 'Store'    |
		| 'Dress'    |  'L/Green'  | 'Store 02' |
	И я нажимаю на кнопку 'Post and close'
	И Я закрыл все окна клиентского приложения
	И я проверяю отсутствие движений по регистрам
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
	И я меняю статус заказа на Approved
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на гиперссылку "Decoration group title collapsed picture"
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю на кнопку "Post"
	И я проверяю историю по статусам
		И я нажимаю на гиперссылку "History"
		Тогда таблица "List" содержит строки:
			| 'Object'                 | 'Status'   |
			| 'Sales return order 1*' | 'Wait'     |
			| 'Sales return order 1*' | 'Approved' |
		И я закрываю текущее окно
		И я нажимаю на кнопку 'Post and close'


Сценарий: _028002 проверка движений документа Sales return order по регистру OrderBalance (ордерный склад на основании реализации) - плюс
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-218' с именем 'IRP-218'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'              | 'Store'    | 'Order'              | 'Item key' |
		| '1,000'    | 'Sales return order 1*' | 'Store 02' | 'Sales return order 1*' | 'L/Green'  |

Сценарий: _028003 проверка движений документа Sales return order по регистру SalesTurnovers (ордерный склад на основании реализации) - минус
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-218' с именем 'IRP-218'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'              | 'Sales invoice'    | 'Item key' |
		| '-1,000'   | 'Sales return order 1*' | 'Sales invoice 2*' | 'L/Green'  |


Сценарий: _028004 создание документа заявки на возврат от клиента (Sales return order) на неордерный склад на основании реализации
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-218' с именем 'IRP-218'
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner'     |
		| '1'      |  'Ferron BP' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentSalesReturnOrderGenerateSalesReturnOrder'
	И я проверяю заполнение реквизитов
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
	И я устанавливаю номер документа 2
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно


Сценарий: _028005 проверка движений документа Sales return order по регистру OrderBalance (неордерный склад на основании реализации)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-218' с именем 'IRP-218'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'              | 'Store'    | 'Order'                 | 'Item key'  |
		| '2,000'    | 'Sales return order 2*' | 'Store 01' | 'Sales return order 2*' | 'L/Green'   |
		| '4,000'    | 'Sales return order 2*' | 'Store 01' | 'Sales return order 2*' | '36/Yellow' |

Сценарий: _028006 проверка движений документа Sales return order по регистру SalesTurnovers (неордерный склад на основании реализации) - минус
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-218' с именем 'IRP-218'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'              | 'Sales invoice'    | 'Item key'  |
		| '-2,000'   | 'Sales return order 2*' | 'Sales invoice 1*' | 'L/Green'   |
		| '-4,000'   | 'Sales return order 2*' | 'Sales invoice 1*' | '36/Yellow' |



Сценарий: _028012 проверка наличия итогов в документе Sales return order
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
	И я выбираю документ SalesReturn
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И в таблице "List" я выбираю текущую строку
	И я проверяю наличие итогов документа
		И     элемент формы с именем "ItemListTotalNetAmount" стал равен '466,10'
		И     элемент формы с именем "ItemListTotalTaxAmount" стал равен '83,90'
		И     элемент формы с именем "ItemListTotalTotalAmount" стал равен '550,00'
		И     элемент формы с именем "CurrencyTotalAmount" стал равен 'TRY'


