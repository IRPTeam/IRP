#language: ru 
@tree
@Positive
Функционал: проведение документа возврат от покупателя по регистрам складского учета

Как Разработчик
Я хочу создать проводки документа возврат клиента
Для того чтобы фиксировать какой товар планируется вернуть

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _028501 создание документа возврат от клиента (Sales return) на ордерный склад без заявки на возврат
	И Я закрыл все окна клиентского приложения
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-220' с именем 'IRP-220'
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-235' с именем 'IRP-235'
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner'     |
		| '3'      |  'Kalipso' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentSalesReturnGenerateSalesReturn'
	И я проверяю заполнение реквизитов
		И     элемент формы с именем "Partner" стал равен 'Kalipso'
		И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		И     элемент формы с именем "Agreement" стал равен 'Personal Agreements, $'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я нажимаю кнопку выбора у поля "Store"
	Тогда открылось окно 'Stores'
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
	И я проверяю добавление склада в табличную часть
		# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-235' с именем 'IRP-235'
		И я перехожу к закладке "Item list"
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  | 'Store'    |
		| 'Dress'    |  'L/Green'  | 'Store 02' |
	И я устанавливаю номер документа 1
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно


Сценарий: _028502 проверка отсутствия движений документа возврат от клиента (Sales return) на ордерный склад без заявки на возврат по регистру OrderBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'        | 'Line number' | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales return 1*' | '1'           | 'Store 02' | 'L/Green'  |


Сценарий: _028503 проверка  движений документа возврат от клиента (Sales return) на ордерный склад без заявки на возврат по регистру SalesTurnovers
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Line number' | 'Sales invoice'    | 'Item key' |
		| '-1,000'   | 'Sales return 1*' | '1'           | 'Sales invoice 3*' | 'L/Green'  |

Сценарий: _028504 проверка  движений документа возврат от клиента (Sales return) на ордерный склад без заявки на возврат по регистру InventoryBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Line number' | 'Company'      | 'Item key' |
		| '1,000'    | 'Sales return 1*' | '1'           | 'Main Company' | 'L/Green'  |

Сценарий: _028505 проверка  движений документа возврат от клиента (Sales return) на ордерный склад без заявки на возврат по регистру GoodsInTransitIncoming
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Receipt basis'   | 'Line number' | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales return 1*' | 'Sales return 1*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _028506 проверка отсутствия движений документа возврат от клиента (Sales return) на ордерный склад без заявки на возврат по регистру StockBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'        | 'Line number' | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales return 1*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _028507 проверка отсутствия движений документа возврат от клиента (Sales return) на ордерный склад без заявки на возврат по регистру StockReservation
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'        | 'Line number' | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales return 1*' | '1'           | 'Store 02' | 'L/Green'  |



Сценарий: _028508 создание документа возврат от клиента (Sales return) на неордерный склад без заявки на возврат
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner'     |
		| '2'      |  'Ferron BP' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentSalesReturnGenerateSalesReturn'
	И я проверяю заполнение реквизитов
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Agreements, without VAT'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я выбираю склад
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
	И я устанавливаю номер документа 2
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно


Сценарий: _028509 проверка отсутствия движений документа возврат от клиента (Sales return) на неордерный склад без заявки на возврат по регистру OrderBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'        | 'Line number' | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales return 2*' | '1'           | 'Store 01' | 'L/Green'  |

Сценарий: _028510 проверка движений документа возврат от клиента (Sales return) на неордерный склад без заявки на возврат по регистру SalesTurnovers
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Line number' | 'Sales invoice'    | 'Item key' |
		| '-1,000'   | 'Sales return 2*' | '1'           | 'Sales invoice 2*' | 'L/Green'  |

Сценарий: _028511 проверка движений документа возврат от клиента (Sales return) на неордерный склад без заявки на возврат по регистру InventoryBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Line number' | 'Company'      | 'Item key' |
		| '1,000'    | 'Sales return 2*' | '1'           | 'Main Company' | 'L/Green'  |

Сценарий: _028512 проверка отсутствия движений документа возврат от клиента (Sales return) на неордерный склад без заявки на возврат по регистру GoodsInTransitIncoming
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'        | 'Receipt basis'   | 'Line number' | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales return 2*' | 'Sales return 2*' | '1'           | 'Store 01' | 'L/Green'  |

Сценарий: _028513 проверка движений документа возврат от клиента (Sales return) на неордерный склад без заявки на возврат по регистру StockBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'        | 'Line number' | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales return 2*' | '1'           | 'Store 01' | 'L/Green'  |

Сценарий: _028514 проверка движений документа возврат от клиента (Sales return) на неордерный склад без заявки на возврат по регистру StockReservation
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'        | 'Line number' | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales return 2*' | '1'           | 'Store 01' | 'L/Green'  |



Сценарий: _028515 создание документа возврат от клиента (Sales return) на ордерный склад на основании заявки на возврат
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentSalesReturnGenerateSalesReturn'
	И я проверяю заполнение реквизитов
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Agreements, without VAT'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	И в таблице "ItemList" в поле 'Price' я ввожу текст '466,10'
	И я устанавливаю номер документа 3
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '3'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '3'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно

Сценарий: _028516 проверка движений документа возврат от клиента (Sales return) на ордерный склад по заявке на возврат по регистру OrderBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Store'    | 'Order'                 | 'Item key' |
		| '1,000'    | 'Sales return 3*' | 'Store 02' | 'Sales return order 1*' | 'L/Green'  |

Сценарий: _028517 проверка отсутствия документа возврат от клиента (Sales return) на ордерный склад по заявке на возврат по регистру SalesTurnovers
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'        | 'Item key' |
		| '-1,000'   | 'Sales return 3*' | 'L/Green'  |

Сценарий: _028518 проверка движений документа возврат от клиента (Sales return) на ордерный склад по заявке на возврат по регистру InventoryBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Company'      | 'Item key' |
		| '1,000'    | 'Sales return 3*' | 'Main Company' | 'L/Green'  |

Сценарий: _028519 проверка движений документа возврат от клиента (Sales return) на ордерный склад по заявке на возврат по регистру GoodsInTransitIncoming
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Receipt basis'   | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales return 3*' | 'Sales return 3*' | 'Store 02' | 'L/Green'  |

Сценарий: _028520 проверка отсутствия движений документа возврат от клиента (Sales return) на ордерный склад по заявке на возврат по регистру StockBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales return 3*' | 'Store 02' | 'L/Green'  |

Сценарий: _028521 проверка отсутствия движений документа возврат от клиента (Sales return) на ордерный склад по заявке на возврат по регистру StockReservation
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales return 3*' | 'Store 02' | 'L/Green'  |


Сценарий: _028522 создание документа возврат от клиента (Sales return) на неордерный склад на основании заявки на возврат
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '2'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentSalesReturnGenerateSalesReturn'
	И я проверяю заполнение реквизитов
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Agreements, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 01'
	И я указываю цены
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '550,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| Item     | Item key  |
			| Trousers | 36/Yellow |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '400,00'
		И в таблице "ItemList" я завершаю редактирование строки
	И я устанавливаю номер документа 4
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '4'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '4'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно


Сценарий: _028523 проверка движений документа возврат от клиента (Sales return) на ордерный склад по заявке на возврат по регистру OrderBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key'  |
		| '2,000'    | 'Sales return 4*' | 'Store 01' | 'L/Green'   |
		| '4,000'    | 'Sales return 4*' | 'Store 01' | '36/Yellow' |

Сценарий: _028524 проверка отсутствия движений документа возврат от клиента (Sales return) на неордерный склад по заявке на возврат по регистру SalesTurnovers
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'        | 'Sales invoice'    | 'Item key' |
		| '-2,000'   | 'Sales return 4*' | 'Sales invoice 4*' | 'L/Green'  |
		| '-4,000'   | 'Sales return 4*' | 'Sales invoice 4*' | '36/Yellow' |


Сценарий: _028525 проверка движений документа возврат от клиента (Sales return) на неордерный склад по заявке на возврат по регистру InventoryBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'        | 'Company'      | 'Item key'  |
		| '2,000'    | 'Sales return 4*' | 'Main Company' | 'L/Green'   |
		| '4,000'    | 'Sales return 4*' | 'Main Company' | '36/Yellow' |


Сценарий: _028526 проверка отсутствия движений документа возврат от клиента (Sales return) на неордерный склад по заявке на возврат по регистру GoodsInTransitIncoming
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'        | 'Receipt basis'   | 'Store'    | 'Item key' |
		| '2,000'    | 'Sales return 4*' | 'Sales return 4*' | 'Store 01' | 'L/Green'  |
		| '4,000'    | 'Sales return 4*' | 'Sales return 4*' | 'Store 01' | '36/Yellow'  |


Сценарий: _028527 проверка движений документа возврат от клиента (Sales return) на неордерный склад по заявке на возврат по регистру StockBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key'  |
	| '2,000'    | 'Sales return 4*' | 'Store 01' | 'L/Green'   |
	| '4,000'    | 'Sales return 4*' | 'Store 01' | '36/Yellow' |

Сценарий: _028528 проверка движений документа возврат от клиента (Sales return) на неордерный склад по заявке на возврат по регистру StockReservation
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-221' с именем 'IRP-221'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key'  |
	| '2,000'    | 'Sales return 4*' | 'Store 01' | 'L/Green'   |
	| '4,000'    | 'Sales return 4*' | 'Store 01' | '36/Yellow' |




Сценарий: _028534 проверка наличия итогов документа Sales return
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
	И я выбираю документ SalesReturn
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И в таблице "List" я выбираю текущую строку
	И я проверяю наличие итогов документа
		И     элемент формы с именем "ItemListTotalNetAmount" стал равен '466,10'
		И     элемент формы с именем "ItemListTotalTaxAmount" стал равен '83,90'
		И     элемент формы с именем "ItemListTotalTotalAmount" стал равен '550,00'
		И     элемент формы с именем "CurrencyTotalAmount" стал равен 'USD'


