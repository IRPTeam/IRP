#language: ru
@tree
@Positive


Функционал: проведение документа возврата поставщику по регистрам складского учета

Как Разработчик
Я хочу создать проводки документа возврат поставщику
Для того чтобы фиксировать какой товар возвращается

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _022301 создание документа возврат поставщику (Purchase return) на ордерный склад на основании заявки на возврат
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-204' с именем 'IRP-204'
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentPurchaseReturnGeneratePurchaseReturn'
	И я проверяю заполнение реквизитов
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, USD'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я выбираю склад
		И я нажимаю кнопку выбора у поля "Store"
		Тогда открылось окно 'Stores'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'  |
		И в таблице "List" я выбираю текущую строку
	И я проверяю добавление склада в табличную часть
		# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-230' с именем 'IRP-230'
		И я перехожу к закладке "Item list"
		И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Item key' | 'Purchase invoice'    | 'Store'    | 'Unit' | 'Q'     |
		| 'Dress' | 'L/Green'  | 'Purchase invoice 2*' | 'Store 02' | 'pcs' | '2,000' |
	Временно цены
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '40,00'
		И в таблице "ItemList" я завершаю редактирование строки
	И я устанавливаю номер документа 1
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	И я нажимаю на кнопку 'Post and close'

Сценарий: _022302 проверка движений документа Purchase return по регистру OrderBalance (ордерный склад на основании заявки на возврат) - минус
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Order'                    | 'Item key' |
		| '2,000'    | 'Purchase return 1*' | '1'           | 'Store 02' | 'Purchase return order 1*' | 'L/Green'  |

Сценарий: _022303 проверка движений документа Purchase return по регистру InventoryBalance (ордерный склад на основании заявки на возврат - минус
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'           | 'Line number' | 'Company'      | 'Item key' |
	| '2,000'    | 'Purchase return 1*' | '1'           | 'Main Company' | 'L/Green'  |

Сценарий: _022304 проверка движений документа Purchase return по регистру GoodsInTransitOutgoing (ордерный склад на основании заявки на возврат) - плюс
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'           | 'Shipment basis'     | 'Line number' | 'Store'    | 'Item key' |
	| '2,000'    | 'Purchase return 1*' | 'Purchase return 1*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _022305 проверка движений документа Purchase return по регистру OrderReservation (ордерный склад на основании заявки на возврат) - плюс
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
	| '2,000'    | 'Purchase return 1*' | '1'           | 'Store 02' | 'L/Green'  |

	
Сценарий: _022306 проверка отсутствия движений Purchase return по регистру PurchaseTurnovers (ордерный склад на основании заявки на возврат)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PurchaseTurnovers'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'           |
		| '-2,000'   | 'Purchase return 1*' |
	

Сценарий: _022307 проверка отсутствия движений Purchase return по регистру StockBalance (ордерный склад на основании заявки на возврат)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
		| '2,000'    | 'Purchase return 1*' | '1'           | 'Store 02' | 'L/Green'  |


Сценарий: _022308 проверка отсутствия движений Purchase return по регистру StockReservation (ордерный склад на основании заявки на возврат)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'              | 'Line number' | 'Store'    | 'Item key'  |
	| '2,000'    | 'Purchase return 1*'    | '1'           | 'Store 02' | 'L/Green'   |


Сценарий: _022309 создание документа возврат поставщику (Purchase return) на неордерный склад на основании заявки на возврат
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-204' с именем 'IRP-204'
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
	И я выбираю склад
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
	И я устанавливаю номер документа 2
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно

Сценарий: _022310 проверка движений документа Purchase return по регистру OrderBalance (неордерный склад на основании заявки на возврат) - минус
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Order'                    | 'Item key' |
		| '3,000'    | 'Purchase return 2*' | '1'           | 'Store 01' | 'Purchase return order 2*' | '36/Yellow'  |

Сценарий: _022311 проверка движений документа Purchase return по регистру InventoryBalance (неордерный склад на основании заявки на возврат) - минус
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'           | 'Line number' | 'Company'      | 'Item key' |
	| '3,000'    | 'Purchase return 2*' | '1'           | 'Main Company' | '36/Yellow'  |

Сценарий: _022312 проверка движений документа Purchase return по регистру InventoryBalance (неордерный склад на основании заявки на возврат) - минус
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
		| '3,000'    | 'Purchase return 2*' | '1'           | 'Store 01' | '36/Yellow'  |

Сценарий: _022313 проверка движений документа Purchase return по регистру OrderReservation (неордерный склад на основании заявки на возврат) - минус
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
		| '3,000'    | 'Purchase return 2*' | '1'           | 'Store 01' | '36/Yellow'  |

Сценарий: _022314 создание возврата поставщику без заявки на возврат (ордерный склад)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '2'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentPurchaseReturnGeneratePurchaseReturn'
	И я проверяю заполнение реквизитов
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, USD'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я нажимаю кнопку выбора у поля "Store"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Store 02'  |
	И в таблице "List" я выбираю текущую строку
	И я проверяю, что в возврат подтягивается количество из поступления за минусом предыдущих возвратов
		И таблица "ItemList" содержит строки:
			| 'Purchase return order' | 'Item'  | 'Item key' | 'Purchase invoice'    | 'Unit' | 'Q'       |
			| ''                      | 'Dress' | 'L/Green'  | 'Purchase invoice 2*' | 'pcs' | '498,000' |
	И в таблице "ItemList" я активизирую поле "Q"
	И в таблице "ItemList" я выбираю текущую строку
	И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
	И в таблице "ItemList" я завершаю редактирование строки
	И я устанавливаю номер документа 3
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '3'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '3'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно

Сценарий: _022315 проверка отсутствия движений документа Purchase return по регистру OrderBalance (ордерный склад без заявки на возврат) - минус
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-223' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
		| '10,000'    | 'Purchase return 3*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _022316 проверка движений Purchase return по регистру PurchaseTurnovers (ордерный склад без заявки на возврат) - минус
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-223' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PurchaseTurnovers'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           |
		| '-10,000'   | 'Purchase return 3*' |

Сценарий: _022317 проверка движений документа Purchase return по регистру InventoryBalance (ордерный склад без заявки на возврат) - минус
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-223' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'           | 'Line number' | 'Company'      | 'Item key' |
	| '10,000'    | 'Purchase return 3*' | '1'           | 'Main Company' | 'L/Green'  |

Сценарий: _022318 проверка движений документа Purchase return по регистру GoodsInTransitOutgoing (ордерный склад без заявки на возврат) - плюс
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-223' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'           | 'Shipment basis'     | 'Line number' | 'Store'    | 'Item key' |
	| '10,000'    | 'Purchase return 3*' | 'Purchase return 3*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _022319 проверка отсутствия движений Purchase return по регистру StockBalance (ордерный склад без заявки на возврат)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-223' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
		| '10,000'    | 'Purchase return 3*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _022320 проверка движений Purchase return по регистру StockReservation (ордерный склад без заявки на возврат)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-223' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'              | 'Line number' | 'Store'    | 'Item key'  |
		| '10,000'    | 'Purchase return 3*'    | '1'           | 'Store 02' | 'L/Green'   |

Сценарий: _022321 проверка отсутствия движений документа Purchase return по регистру OrderReservation (ордерный склад без заявки на возврат)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-223' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'            | 'Line number' | 'Store'    | 'Item key' |
		| '10,000'    | 'Purchase return 3*' | '1'           | 'Store 02' | 'L/Green'  |


Сценарий: _022322 создание возврата поставщику без заявки на возврат (неордерный склад)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-204' с именем 'IRP-204'
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentPurchaseReturnGeneratePurchaseReturn'
	И я проверяю заполнение реквизитов
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
	И я устанавливаю номер документа 4
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '4'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '4'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно

Сценарий: _022323 проверка движений Purchase return по регистру PurchaseTurnovers (неордерный склад без заявки на возврат) - минус
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-223' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PurchaseTurnovers'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           |
		| '-12,000'   | 'Purchase return 4*' |

Сценарий: _022324 проверка движений документа Purchase return по регистру InventoryBalance (неордерный склад без заявки на возврат) - минус
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-223' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'           | 'Line number' | 'Company'      | 'Item key' |
	| '12,000'    | 'Purchase return 4*' | '1'           | 'Main Company' | '36/Yellow'  | 

Сценарий: _022325 проверка отсутствия движений документа Purchase return по регистру GoodsInTransitOutgoing (неордерный склад без заявки на возврат)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-223' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'           | 'Shipment basis'     | 'Line number' | 'Item key' |
	| '12,000'    | 'Purchase return 4*' | 'Purchase return 4*' | '1'           | '36/Yellow'  |

Сценарий: _022326 проверка движений документа Purchase return по регистру StockBalance (неордерный склад без заявки на возврат) - минус
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-223' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
		| '12,000'   | 'Purchase return 4*' | '1'           | 'Store 01' | '36/Yellow'  |

Сценарий: _022327 проверка движений Purchase return по регистру StockReservation (неордерный склад без заявки на возврат) - минус
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-223' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
		| '12,000'   | 'Purchase return 4*' | '1'           | 'Store 01' | '36/Yellow'  |

Сценарий: _022328 проверка отсутствия движений Purchase return по регистру StockReservation (неордерный склад без заявки на возврат)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-223' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'              | 'Line number' | 'Store'    | 'Item key'  |
		| '12,000'    | 'Purchase return 4*'    | '1'           | 'Store 01' | '36/Yellow'   |

Сценарий: _022329 проверка отсутствия движений документа Purchase return по регистру OrderReservation (неордерный склад без заявки на возврат)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-223' с именем 'IRP-223'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'            | 'Line number' | 'Store'    | 'Item key' |
		| '12,000'    | 'Purchase return 3*' | '1'           | 'Store 01' | '36/Yellow'  |


Сценарий: _022335 проверка наличия итогов в документе Purchase Return
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
	И я выбираю документ PurchaseReturn
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И в таблице "List" я выбираю текущую строку
	И я проверяю наличие итогов документа
		И     у элемента формы с именем "ItemListTotalTaxAmount" текст редактирования стал равен '12,20'
		И     у элемента формы с именем "ItemListTotalNetAmount" текст редактирования стал равен '67,80'
		И     у элемента формы с именем "ItemListTotalTotalAmount" текст редактирования стал равен '80,00'





