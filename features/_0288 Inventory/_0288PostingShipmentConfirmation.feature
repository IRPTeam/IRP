#language: ru
@tree
@Positive
Функционал: проведение документа Расходный ордер на товары по регистрам складского учета

Как Разработчик
Я хочу создать проводки документа расходного ордера на товара
Для того чтобы фиксировать какой товар отгружен склад

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий



Сценарий: _028801 создание документа расходный ордер (Shipment Confirmation) на основании реализации созданной по заказу клиента
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-193' с именем 'IRP-193'
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner'    |
		| '2'      | 'Ferron BP' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	* Заполнение реквизитов
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Изменение номера расходного ордера
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '95'
	* Проверка заполнения товарной части
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Quantity' | 'Item key' | 'Unit' | 'Shipment basis'   |
		| 'Dress'    | '10,000'   | 'L/Green'  | 'pcs' | 'Sales invoice 2*' |
		| 'Trousers' | '14,000'   | '36/Yellow'| 'pcs' | 'Sales invoice 2*' |
	* Проверка добавления склада в табличную часть
		# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-233' с именем 'IRP-233'
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  | 'Store'    |
		| 'Dress'    |  'L/Green'  | 'Store 02' |
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно
	

Сценарий: _028802 проверка движений документа Shipment Confirmation на основании реализации созданной без заказа клиента по регистру GoodsInTransitOutgoing (минус)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-194' с именем 'IRP-194'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                 | 'Shipment basis'   | 'Line number' | 'Store'    | 'Item key' |
		| '10,000'   | 'Shipment confirmation 95*' | 'Sales invoice 2*' | '1'           | 'Store 02' | 'L/Green'  |
		| '14,000'   | 'Shipment confirmation 95*' | 'Sales invoice 2*' | '2'           | 'Store 02' | '36/Yellow'   |

Сценарий: _028803 проверка движений документа Shipment Confirmation на основании реализации созданной без заказа клиента по регистру StockBalance (минус)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-194' с именем 'IRP-194'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key' |
		| '10,000'   | 'Shipment confirmation 95*' | '1'           | 'Store 02' | 'L/Green'  |
		| '14,000'   | 'Shipment confirmation 95*' | '2'           | 'Store 02' | '36/Yellow'   |


Сценарий: _028804 создание документа расходный ордер (Shipment Confirmation) на основании реализации созданной без заказа клиента
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-193' с именем 'IRP-193'
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner'    |
		| '4'      | 'Kalipso' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	* Заполнение реквизитов
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Изменение номера расходного ордера
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '98'
	* Проверка заполнения товарной части
		И     таблица "ItemList" содержит строки:
		| '#' | 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Shipment basis'   |
		| '1' | 'Dress' | '20,000'   | 'L/Green'  | 'pcs'  | 'Sales invoice 4*' |
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно

Сценарий: _028805 проверка движений документа Shipment Confirmation на основании реализации созданной без заказа клиента по регистру GoodsInTransitOutgoing (минус)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-194' с именем 'IRP-194'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                 | 'Shipment basis'   | 'Line number' | 'Store'    | 'Item key' |
		| '20,000'   | 'Shipment confirmation 98*' | 'Sales invoice 4*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _028806 проверка движений документа Shipment Confirmation на основании реализации созданной без заказа клиента по регистру StockBalance (минус)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-194' с именем 'IRP-194'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key' |
		| '20,000'   | 'Shipment confirmation 98*' | '1'           | 'Store 02' | 'L/Green'  |



Сценарий: _028807 создание расходного ордера на основании возврата поставщику
	Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-210' с именем 'IRP-210'
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
	И     элемент формы с именем "Company" стал равен 'Main Company'
	И     элемент формы с именем "Store" стал равен 'Store 02'
	* Изменение номера расходного ордера
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '101'
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Shipment basis'                              |
		| 'Dress' | '2,000'    | 'L/Green'  | 'pcs'  | 'Purchase return 1*' |
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно

Сценарий: _028808 проверка движения расходного ордера созданного на основании возврата поставщику по регистру StockBalance
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-194' с именем 'IRP-194'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key' |
		| '2,000'    | 'Shipment confirmation 101*' | '1'           | 'Store 02' | 'L/Green'  |



Сценарий: _028809 проверка движения расходного ордера созданного на основании возврата поставщику по регистру GoodsInTransitOutgoing
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-194' с именем 'IRP-194'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                 | 'Shipment basis'     | 'Line number' | 'Store'    | 'Item key' |
		| '2,000'   | 'Shipment confirmation 101*' | 'Purchase return 1*' | '1'           | 'Store 02' | 'L/Green'  |

Сценарий: _028810 создание расходного ордера на основании перемещения товара (склад отправитель ордерный)
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Store receiver' | 'Store sender' |
		| '2'      | 'Store 03'       | 'Store 02'     |
	И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
	И Пауза 1
	И     элемент формы с именем "Company" стал равен 'Main Company'
	* Изменение номера расходного ордера
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '102'
	И я нажимаю на кнопку 'Post and close'
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Store receiver' | 'Store sender' |
		| '3'      | 'Store 01'       | 'Store 02'     |
	И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
	И Пауза 1
	И     элемент формы с именем "Company" стал равен 'Main Company'
	* Изменение номера расходного ордера
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '103'
	И я нажимаю на кнопку 'Post and close'
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Store receiver' | 'Store sender' |
		| '6'      | 'Store 03'       | 'Store 02'     |
	И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
	И Пауза 1
	И     элемент формы с именем "Company" стал равен 'Main Company'
	* Изменение номера расходного ордера
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '104'
	И я нажимаю на кнопку 'Post and close'
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Store receiver' | 'Store sender' |
		| '7'      | 'Store 01'       | 'Store 02'     |
	И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
	И Пауза 1
	И     элемент формы с именем "Company" стал равен 'Main Company'
	* Изменение номера расходного ордера
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '105'
	И я нажимаю на кнопку 'Post and close'


