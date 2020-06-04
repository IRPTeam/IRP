#language: ru
@tree
@Positive
Функционал: проведение документа sales invoice по регистрам складского учета

Как Разработчик
Я хочу создать проводки документа реализации клиента
Для того чтобы фиксировать какой товар будет отгружен клиенту

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


# Документ проводится по регистрам:
# OrderBalance - (расход) только строки т.ч ItemList с заполненным реквизитом Order.
# OrderReservation - (расход) только строки т.ч ItemList с заполненным реквизитом Order.
# InventoryBalance - (расход) по всем строкам т.ч ItemList
# Если у склада в документе "UseShipmentConfirmation" то движения по регистрам:
# GoodsInTransitOutgoing + (приход) по всем строкам т.ч ItemList
# Если у склада НЕ используется "UseShipmentConfirmation" то движения по регистрам:
# StockBalance - (расход) по всем строкам т.ч ItemList
# StockReservation - (расход) только по тем строкам т.ч ItemList в которых не заполнен SalesOrder


Сценарий: _024001 создание документа sales invoice с неордерного склада на основании заказа клиента
# Из заказа не переносится денежная часть (цена, сумма, НДС и т.д.). Цена, сумма, НДС проставляется после выбора партнера и соглашения
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-190' с именем 'IRP-190'
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И в таблице "List" я перехожу к первой строке
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем "FormDocumentSalesInvoiceGenerateSalesInvoice"
	И я проверяю заполнение информации при создании на основании
		Тогда элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Agreements, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я проверяю добавление склада в табличную часть
		# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-232' с именем 'IRP-232'
		И я перехожу к закладке "Item list"
		И     таблица "ItemList" содержит строки:
			| 'Item'     | Price | 'Item key'  | 'Store'    | 'Shipment confirmation' | 'Sales order'    | 'Unit' | 'Q'     | 'Offers amount'  | 'Tax amount' | 'Net amount' | 'Total amount' |
			| 'Dress'    | '*'    | 'L/Green'   | 'Store 01' | ''                      | 'Sales order 1*' | 'pcs' | '5,000' | '*'              | '*'          | '*'          | '*'           |
			| 'Trousers' | '*'    | '36/Yellow' | 'Store 01' | ''                      | 'Sales order 1*' | 'pcs' | '4,000' | '*'              | '*'          | '*'          | '*'           |
	* Проверка заполнения цен и вида цен
		И     таблица "ItemList" содержит строки:
		| 'Price'  | 'Item'     | 'Item key'  | 'Q'     | 'Price type'        |
		| '550,00' | 'Dress'    | 'L/Green'   | '5,000' | 'Basic Price Types' |
		| '400,00' | 'Trousers' | '36/Yellow' | '4,000' | 'Basic Price Types' |	
	И я перерасчитываю скидки
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
	И я меняю номер sales invoice на 1
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно

Сценарий: _024002 проверка движений документа sales invoice с неордерного склада на основании заказа клиента по регистру OrderBalance (минус)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'            | 'Store'    | 'Order'              | 'Item key' |
	| '5,000'    | 'Sales invoice 1*'    | 'Store 01' | 'Sales order 1*'     | 'L/Green'  |
	| '4,000'    | 'Sales invoice 1*'    | 'Store 01' | 'Sales order 1*'     | '36/Yellow'   |

Сценарий: _024003 проверка движений документа sales invoice с неордерного склада на основании заказа клиента по регистру OrderReservation (минус)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-189' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'         | 'Store'    | 'Item key' |
		| '5,000'    | 'Sales invoice 1*' | 'Store 01' | 'L/Green'   |
		| '4,000'    | 'Sales invoice 1*' | 'Store 01' | '36/Yellow' |


Сценарий: _024004 проверка движений документа sales invoice с неордерного склада на основании заказа клиента по регистру InventoryBalance (минус)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'            | 'Company'      | 'Item key' |
		| '5,000'    | 'Sales invoice 1*'    | 'Main Company' | 'L/Green'  |
		| '4,000'    | 'Sales invoice 1*'    | 'Main Company' | '36/Yellow'   |

 Сценарий: _024005 проверка движений документа sales invoice с неордерного склада на основании заказа клиента по регистру StockBalance (минус)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Store'    | 'Item key' |
		| '5,000'    | 'Sales invoice 1*'   | 'Store 01' | 'L/Green'  |
		| '4,000'    | 'Sales invoice 1*'   | 'Store 01' | '36/Yellow'   |


Сценарий: _024006 проверка отсутствия движений документа sales invoice с неордерного склада на основании заказа клиента по регистру StockReservation
#  Все строки в реализации сделаны по заказу
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'               | 'Store'    | 'Item key' |
		| '5,000'    | 'Sales invoice 1*'       | 'Store 01' | 'L/Green'  |
		| '4,000'    | 'Sales invoice 1*'       | 'Store 01' | '36/Yellow'   |

Сценарий: _024007 проверка  движений документа sales invoice с неордерного склада на основании заказа клиента по регистру SalesTurnovers
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List"содержит строки:
		| 'Quantity' | 'Recorder'         | 'Sales invoice'    | 'Item key'  |
		| '5,000'    | 'Sales invoice 1*' | 'Sales invoice 1*' | 'L/Green'   |
		| '4,000'    | 'Sales invoice 1*' | 'Sales invoice 1*' | '36/Yellow' |

Сценарий: _024008 создание документа sales invoice с ордерного склада на основании заказа клиента
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-190'
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner'   |
		| '2'      | 'Ferron BP' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем "FormDocumentSalesInvoiceGenerateSalesInvoice"
	И я проверяю заполнение реквизитов
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Agreements, without VAT'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Проверка заполнения цен и вида цен
		И     таблица "ItemList" содержит строки:
		| 'Price'  | 'Item'     | 'Item key'  | 'Price type'              | 'Q'      |
		| '466,10' | 'Dress'    | 'L/Green'   | 'Basic Price without VAT' | '10,000' |
		| '338,98' | 'Trousers' | '36/Yellow' | 'Basic Price without VAT' | '14,000' |
	И я перерасчитываю скидки
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
	И я меняю номер sales invoice на 2
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно

Сценарий: _024009 проверка движений документа sales invoice с ордерного склада на основании заказа клиента по регистру SalesTurnovers
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'         | 'Sales invoice'    | 'Item key'  |
		| '10,000'   | 'Sales invoice 2*' | 'Sales invoice 2*' | 'L/Green'   |
		| '14,000'   | 'Sales invoice 2*' | 'Sales invoice 2*' | '36/Yellow' |

Сценарий: _024010 проверка движений документа sales invoice с ордерного склада на основании заказа клиента по регистру OrderBalance (минус)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'             | 'Store'    | 'Order'              | 'Item key' |
	| '10,000'    | 'Sales invoice 2*'    | 'Store 02' | 'Sales order 2*'     | 'L/Green'  |
	| '14,000'    | 'Sales invoice 2*'    | 'Store 02' | 'Sales order 2*'     | '36/Yellow'   |

Сценарий: _024011 проверка движений документа sales invoice с ордерного склада на основании заказа клиента по регистру InventoryBalance (минус)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'            | 'Company'      | 'Item key' |
		| '10,000'    | 'Sales invoice 2*'   | 'Main Company' | 'L/Green'  |
		| '14,000'    | 'Sales invoice 2*'   | 'Main Company' | '36/Yellow'   |

Сценарий: _024012 проверка движений документа sales invoice с ордерного склада на основании заказа клиента по регистру GoodsInTransitOutgoing
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'         | 'Shipment basis'   | 'Store'    | 'Item key' |
		| '10,000'   | 'Sales invoice 2*' | 'Sales invoice 2*' | 'Store 02' | 'L/Green'  |
		| '14,000'   | 'Sales invoice 2*' | 'Sales invoice 2*' | 'Store 02' | '36/Yellow'   |

Сценарий: _024013 проверка отсутствия движений документа sales invoice с ордерного склада на основании заказа клиента по регистру StockBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'            | 'Store'    | 'Item key' |
		| '10,000'    | 'Sales invoice 2*'   | 'Store 02' | 'L/Green'  |
		| '14,000'    | 'Sales invoice 2*'   | 'Store 02' | '36/Yellow'   |

Сценарий: _024014 проверка движений документа sales invoice с ордерного склада на основании заказа клиента по регистру OrderReservation (минус)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-189' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'         | 'Store'    | 'Item key'  |
		| '10,000'   | 'Sales invoice 2*' | 'Store 02' | 'L/Green'   |
		| '14,000'   | 'Sales invoice 2*' | 'Store 02' | '36/Yellow' |


Сценарий: _024015 проверка отсутствия движений документа sales invoice с ордерного склада на основании заказа клиента по регистру StockReservation
# Все строки в реализации сделаны по заказу
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'              | 'Store'    | 'Item key' |
		| '5,000'    | 'Sales invoice 2*'      | 'Store 02' | 'L/Green'  |
		| '4,000'    | 'Sales invoice 2*'      | 'Store 02' | '36/Yellow'   |


Сценарий: _024016 создание документа sales invoice без заказа с неордерного склада
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я заполняю данные о клиенте
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я выбираю текущую строку
	И я выбираю склад 
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я выбираю текущую строку
	И я меняю номер sales invoice на 3
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '3'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '3'
	И я добавляю в реализацию товар
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

Сценарий: _024017 проверка движений документа sales invoice с неордерного склада без заказа клиента по регистру StockReservation
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'              | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales invoice 3*'      | 'Store 01' | 'L/Green'  |

Сценарий: _024018 проверка отсутствия движений документа sales invoice с неордерного склада без заказа клиента по регистру OrderBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'             | 'Store'    | 'Order'              | 'Item key' |
	| '1,000'    | 'Sales invoice 3 *'    | 'Store 01' | ''     | 'L/Green'  |

Сценарий: _024019 проверка отсутствия движений документа sales invoice с неордерного склада без заказа клиента по регистру OrderReservation
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'             | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales invoice 3 *'    | 'Store 01' |  'L/Green'  |

Сценарий: _024020 проверка движений документа sales invoice с неордерного склада без заказа клиента по регистру InventoryBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'            | 'Company'      | 'Item key' |
		| '1,000'    | 'Sales invoice 3*'    | 'Main Company' | 'L/Green'  |

Сценарий: _024021 проверка движений документа sales invoice с неордерного склада без заказа клиента по регистру StockBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales invoice 3*'   | 'Store 01' | 'L/Green'  |

Сценарий: _024022 проверка отсутствия движений документа sales invoice с неордерного склада без заказа клиента по регистру GoodsInTransitOutgoing
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'         | 'Shipment basis'   | 'Store'    | 'Item key' |
		| '1,000'   | 'Sales invoice 3*'  | 'Sales invoice 3*' | 'Store 01' | 'L/Green'  |

Сценарий: _024023 проверка  движений документа sales invoice с неордерного склада без заказа клиента по регистру SalesTurnovers
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List"содержит строки:
		| 'Quantity' | 'Recorder'         | 'Sales invoice'    | 'Item key' |
		| '1,000'    | 'Sales invoice 3*' | 'Sales invoice 3*' | 'L/Green'  |

Сценарий: _024024 проверка отсутствия движений документа sales invoice с неордерного склада без заказа клиента по регистру OrderReservation (минус)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-189' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key'  |
		| '1,000'   | 'Sales invoice 3*' | 'Store 01' | 'L/Green'   |



Сценарий: _024025 создание документа sales invoice без заказа с ордерного склада
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я заполняю данные о клиенте
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
	И я меняю номер sales invoice на 4
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '4'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '4'
	И я меняю склад на Store 02
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02  |
		И в таблице "List" я выбираю текущую строку
	И я добавляю в реализацию товар
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

Сценарий: _024026 проверка движений документа sales invoice с ордерного склада без заказа клиента по регистру StockReservation
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'               | 'Store'     | 'Item key' |
		| '20,000'    | 'Sales invoice 4*'      | 'Store 02' | 'L/Green'  |

Сценарий: _024027 проверка отсутствия движений документа sales invoice с ордерного склада без заказа клиента по регистру OrderBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'             | 'Store'    | 'Order'              | 'Item key' |
	| '20,000'    | 'Sales invoice 4 *'   | 'Store 02' | ''                  | 'L/Green'  |

Сценарий: _024028 проверка отсутствия движений документа sales invoice с ордерного склада без заказа клиента по регистру OrderReservation
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'             | 'Store'    | 'Item key' |
	| '20,000'    | 'Sales invoice 4 *'   | 'Store 02' | 'L/Green'  |

Сценарий: _024029 проверка движений документа sales invoice с ордерного склада без заказа клиента по регистру InventoryBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Company'      | 'Item key' |
		| '20,000'    | 'Sales invoice 4*'  | 'Main Company' | 'L/Green'  |

Сценарий: _024030 проверка движений документа sales invoice с ордерного склада без заказа клиента по регистру GoodsInTransitOutgoing
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'          | 'Shipment basis'   | 'Store'    | 'Item key' |
		| '20,000'   | 'Sales invoice 4*'  | 'Sales invoice 4*' | 'Store 02' | 'L/Green'  |

Сценарий: _024031 проверка отсутствия движений документа sales invoice с ордерного склада без заказа клиента по регистру StockBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'             | 'Store'    | 'Item key' |
		| '20,000'    | 'Sales invoice 4*'    | 'Store 02' | 'L/Green'  |

Сценарий: _024032 проверка  движений документа sales invoice с ордерного склада без заказа клиента по регистру SalesTurnovers
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-191' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.SalesTurnovers'
	Тогда таблица "List"содержит строки:
		| 'Quantity' | 'Recorder'         | 'Sales invoice'    | 'Item key' |
		| '20,000'   | 'Sales invoice 4*' | 'Sales invoice 4*' | 'L/Green'  |

Сценарий: _024033 проверка отсутствия движений документа sales invoice с ордерного склада без заказа клиента по регистру OrderReservation (минус)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-189' с именем 'IRP-191'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'         | 'Store'    | 'Item key'  |
		| '20,000'   | 'Sales invoice 4*' | 'Store 02' | 'L/Green'   |

Сценарий: _024034 проверка проведение реализации с ордерного склада по сету
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я заполняю данные о клиенте
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
	И я выбираю склад 
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'  |
		И в таблице "List" я выбираю текущую строку
	И я добавляю в реализацию товар
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
	И я меняю номер sales invoice на 5
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
	И я проверяю движения по регистрам
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

Сценарий: _024035 проверка стационарной формы подбора товара (реализация клиента - Sales invoice)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-379' с именем 'IRP-379'
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я заполняю общие реквизиты по заказу
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
	И я выбираю склад 
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
	Когда проверяю форму подбора товара с информацией по ценам в Sales invoice
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
	И я нажимаю на кнопку 'Post and close'
	И я проверяю сохранение заказа
		Тогда таблица "List" содержит строки:
			| 'Partner'     |'Σ'          |
			| 'Ferron BP'   | '2 050,00'  |
	И я закрыл все окна клиентского приложения



Сценарий: _024042 проверка наличия итогов в документе Sales invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И я выбираю документ SalesInvoice
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И в таблице "List" я выбираю текущую строку
	И я проверяю наличие итогов документа
		И     элемент формы с именем "ItemListTotalOffersAmount" стал равен '0,00'
		И     элемент формы с именем "ItemListTotalNetAmount" стал равен '3 686,44'
		И     элемент формы с именем "ItemListTotalTaxAmount" стал равен '663,56'
		И     элемент формы с именем "ItemListTotalTotalAmount" стал равен '4 350,00'
		И     элемент формы с именем "CurrencyTotalAmount" стал равен 'TRY'











	
















	



