#language: ru
@tree
@Positive


Функционал: проведение документа заявки на возврат поставщику по регистрам складского учета

Как Разработчик
Я хочу создать проводки документа заявка на возврат поставщику
Для того чтобы фиксировать какой товар планируется вернуть

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _022001 создание документа заявки на возврат поставщику (Purchase return order) на ордерный склад на основании поступления + проверка статусов и истории по статусам
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-210'
	И    Я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '2'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentPurchaseReturnOrderGeneratePurchaseReturnOrder'
	И я проверяю заполнение реквизитов
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, USD'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я выбираю склад
		И я нажимаю кнопку выбора у поля "Store"
		Тогда открылось окно 'Stores'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'  |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
	И из выпадающего списка "Status" я выбираю точное значение 'Wait'
	И я перехожу к закладке "Item list"
	И в таблице "ItemList" я активизирую поле "Q"
	И в таблице "ItemList" я выбираю текущую строку
	И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
	И в таблице "ItemList" в поле 'Price' я ввожу текст '40,00'
	И в таблице "ItemList" я завершаю редактирование строки
	И я проверяю добавление склада в табличную часть
		# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-229' с именем 'IRP-229'
		И я перехожу к закладке "Item list"
		И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Item key' | 'Purchase invoice'    | 'Store'    | 'Unit' | 'Q'     |
		| 'Dress' | 'L/Green'  | 'Purchase invoice 2*' | 'Store 02' | 'pcs' | '2,000' |
	И я устанавливаю номер документа 1
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно
	И Я закрываю текущее окно
	И я проверяю отсутствие движений по регистрам
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Order'                    | 'Item key' |
			| '2,000'    | 'Purchase return order 1*' | '1'           | 'Store 02' | 'Purchase return order 1*' | 'L/Green'  |
		И Я закрываю текущее окно
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PurchaseTurnovers'
		Тогда таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'                 | 'Line number' | 'Purchase invoice'    | 'Item key' |
			| '-2,000'   | 'Purchase return order 1*' | '1'           | 'Purchase invoice 2*' | 'L/Green'  |
		И Я закрываю текущее окно
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
		Тогда таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key'  |
			| '2,000'    | 'Purchase return order 1*' | '1'           | 'Store 02' | 'L/Green'   |
		И Я закрываю текущее окно
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
		Тогда таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key'  |
			| '2,000'    | 'Purchase return order 1*'    | '1'           | 'Store 02' | 'L/Green'   |
		И    Я закрыл все окна клиентского приложения
	И я устанавливаю по заявке на возврат статус Approved
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на гиперссылку "Decoration group title collapsed picture"
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю на кнопку 'Post'
	И я проверяю историю по статусам
		И я нажимаю на гиперссылку "History"
		Тогда таблица "List" содержит строки:
			| 'Object'                    | 'Status'   |
			| 'Purchase return order 1*' | 'Wait'     |
			| 'Purchase return order 1*' | 'Approved' |
		И я закрываю текущее окно
		И я нажимаю на кнопку 'Post and close'


Сценарий: _022002 проверка движений документа Purchase return order по регистру OrderBalance (ордерный склад на основании поступления)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-210'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Order'                    | 'Item key' |
		| '2,000'    | 'Purchase return order 1*' | '1'           | 'Store 02' | 'Purchase return order 1*' | 'L/Green'  |

Сценарий: _022003 проверка движений документа Purchase return order по регистру PurchaseTurnovers (ордерный склад на основании поступления)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-210'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PurchaseTurnovers'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Purchase invoice'    | 'Item key' |
		| '-2,000'   | 'Purchase return order 1*' | '1'           | 'Purchase invoice 2*' | 'L/Green'  |

Сценарий: _022004 проверка движений документа Purchase return order по регистру OrderReservation (ордерный склад на основании поступления)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-210'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key'  |
	| '2,000'    | 'Purchase return order 1*' | '1'           | 'Store 02' | 'L/Green'   |

Сценарий: _022005 проверка движений документа Purchase return order по регистру StockReservation (ордерный склад на основании поступления)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-210'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key'  |
	| '2,000'    | 'Purchase return order 1*'    | '1'           | 'Store 02' | 'L/Green'   |


Сценарий: _022006 создание документа заявки на возврат поставщику (Purchase return order) на неордерный склад на основании поступления
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-210'
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentPurchaseReturnOrderGeneratePurchaseReturnOrder'
	И я проверяю заполнение реквизитов
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я заполняю необходимые реквизиты
		И я нажимаю кнопку выбора у поля "Store"
		Тогда открылось окно 'Stores'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
	И из выпадающего списка "Status" я выбираю точное значение 'Approved'
	И я перехожу к закладке "Item list"
	И в таблице "ItemList" я перехожу к строке:
		| 'Item'     | 'Item key'  | 'Unit' |
		| 'Trousers'    | '36/Yellow'   | 'pcs' |
	И в таблице "ItemList" я выбираю текущую строку
	И Пауза 2
	И в таблице "ItemList" в поле 'Q' я ввожу текст '3,000'
	И Пауза 2
	И в таблице "ItemList" я завершаю редактирование строки
	И в таблице "ItemList" я перехожу к строке:
		| 'Item'     | 'Item key'  | 'Unit' |
		| 'Dress'    | 'L/Green'   | 'pcs' |
	И Пауза 2
	И в таблице 'ItemList' я удаляю строку
	И в таблице "ItemList" я перехожу к строке:
		| 'Item'     | 'Item key'  | 'Unit' |
		| 'Dress'    | 'M/White'   | 'pcs' |
	И в таблице 'ItemList' я удаляю строку
	И я устанавливаю номер документа 2
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно

Сценарий: _022007 проверка движений документа Purchase return order по регистру OrderBalance (неордерный склад на основании поступления)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-210'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Order'                    | 'Item key' |
		| '3,000'    | 'Purchase return order 2*' | '1'           | 'Store 01' | 'Purchase return order 2*' | '36/Yellow'  |

Сценарий: _022008 проверка движений документа Purchase return order по регистру PurchaseTurnovers (неордерный склад на основании поступления)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-210'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PurchaseTurnovers'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'                 | 'Line number' | 'Purchase invoice'    | 'Item key' |
	| '-3,000'   | 'Purchase return order 2*' | '1'           | 'Purchase invoice 1*' | '36/Yellow'  |

Сценарий: _022009 проверка движений документа Purchase return order по регистру PurchaseTurnovers (неордерный склад на основании поступления)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-210'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key'  |
	| '3,000'    | 'Purchase return order 2*' | '1'           | 'Store 01' | '36/Yellow'   |

Сценарий: _022010 проверка движений документа Purchase return order по регистру StockReservation (неордерный склад на основании поступления)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-210'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key'  |
	| '3,000'    | 'Purchase return order 2*'    | '1'           | 'Store 01' | '36/Yellow'   |


Сценарий: _022016 проверка наличия итогов в документе Purchase Return Order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
	И я выбираю документ PurchaseReturnOrder
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И в таблице "List" я выбираю текущую строку
	И я проверяю наличие итогов документа
		И     у элемента формы с именем "ItemListTotalTaxAmount" текст редактирования стал равен '12,20'
		И     у элемента формы с именем "ItemListTotalNetAmount" текст редактирования стал равен '67,80'
		И     у элемента формы с именем "ItemListTotalTotalAmount" текст редактирования стал равен '80,00'



