#language: ru
@tree
@Positive

Функционал: объединение товара в наборы

Как разработчик
Я хочу создать документ Unbundling
Чтобы разъединять товары из набора

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий



Сценарий: _029601 создание документа Unbundling по товару c размерной сеткой (спецификация создана заранее) с неордерного склада
# кнопка заполнения по спецификации. В спецификации указываются все доп свойства
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-264' с именем 'IRP-264'
	И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
	И я создаю документ Unbundling по Dress/A-8, все item key заранее по товару созданы
		И я нажимаю на кнопку с именем 'FormCreate'
		И я указываю номер документа
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '1'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item key bundle"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key  |
			| Dress | Dress/A-8 |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs      |
		И в таблице "List" я выбираю текущую строку
		И в поле с именем 'Quantity' я ввожу текст '2,000'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01  |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку 'By specification'
		И я нажимаю на кнопку 'Post and close'
	И я проверяю создание документа Unbundling
		Тогда таблица "List" содержит строки:
			| Item key bundle | Company      |
			| Dress/A-8       | Main Company |
	И Я закрыл все окна клиентского приложения
	
Сценарий: _029602 проверка движений документа Unbundling с неордерного склада по регистру Stock Balance
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                   | 'Store'    | 'Item key'                            |
		| '2,000'    | 'Unbundling 1*'              | 'Store 01' | 'S/Yellow'                            |
		| '2,000'    | 'Unbundling 1*'              | 'Store 01' | 'XS/Blue'                             |
		| '4,000'    | 'Unbundling 1*'              | 'Store 01' | 'L/Green'                             |
		| '4,000'    | 'Unbundling 1*'              | 'Store 01' | 'M/Brown'                             |
		| '2,000'    | 'Unbundling 1*'              | 'Store 01' | 'Dress/A-8'                           |
	И Я закрыл все окна клиентского приложения

Сценарий: _029603 проверка движений документа Unbundling с неордерного склада по регистру Stock Reservation
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Store'     | 'Item key'                                                            |
		| '2,000'    | 'Unbundling 1*'               | 'Store 01'  | 'S/Yellow'                                                            |
		| '2,000'    | 'Unbundling 1*'               | 'Store 01'  | 'XS/Blue'                                                             |
		| '4,000'    | 'Unbundling 1*'               | 'Store 01'  | 'L/Green'                                                             |
		| '4,000'    | 'Unbundling 1*'               | 'Store 01'  | 'M/Brown'                                                             |
		| '2,000'    | 'Unbundling 1*'               | 'Store 01'  | 'Dress/A-8'                                                           |
	И Я закрыл все окна клиентского приложения

Сценарий: _029604 создание документа Unbundling по товару c размерной сеткой (спецификация создана заранее) с ордерного склада
	Когда создаю Purchase invoice по закупке наборов и размерных сеток на склад Store 02
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-264' с именем 'IRP-264'
	И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
	И я создаю документ Unbundling по Boots/S-8, все item key заранее по товару созданы
		И я нажимаю на кнопку с именем 'FormCreate'
		И я указываю номер документа
			И в поле 'Number' я ввожу текст '2'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Boots       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item key bundle"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key  |
			| Boots | Boots/S-8 |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs      |
		И в таблице "List" я выбираю текущую строку
		И в поле с именем 'Quantity' я ввожу текст '2,000'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02  |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку 'By specification'
		И я нажимаю на кнопку 'Post and close'
	И я проверяю создание документа Unbundling
		Тогда таблица "List" содержит строки:
			| Item key bundle | Company      |
			| Boots/S-8       | Main Company |
	И Я закрыл все окна клиентского приложения

Сценарий: _029605 проверка отсутсвтвия движений документа Unbundling с неордерного склада по регистру Stock Balance
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
		| 'Recorder'                   |
		| 'Unbundling 2*'              |
	И Я закрыл все окна клиентского приложения

Сценарий: _029606 проверка движений документа Unbundling с неордерного склада по регистру Stock Reservation
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity'   | 'Recorder'                  | 'Store'        | 'Item key'                                                            |
		| '2,000'    | 'Unbundling 2*'               | 'Store 02'     | 'Boots/S-8'                                                           |
	И Я закрыл все окна клиентского приложения

Сценарий: _029607 проверка движений документа Unbundling с неордерного склада по регистру GoodsInTransitOutgoing
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                   | 'Shipment basis'        | 'Store'    | 'Item key'  |
		| '2,000'    | 'Unbundling 2*'              | 'Unbundling 2*'         | 'Store 02' | 'Boots/S-8' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029608 проверка движений документа Unbundling с неордерного склада по регистру GoodsInTransitIncoming
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" содержит строки:
		| 'Quantity'   | 'Recorder'                | 'Receipt basis'       | 'Store'    | 'Item key'  |
		| '2,000'      | 'Unbundling 2*'         | 'Unbundling 2*'         | 'Store 02' | '36/18SD'                             |
		| '2,000'      | 'Unbundling 2*'         | 'Unbundling 2*'         | 'Store 02' | '37/18SD'                             |
		| '2,000'      | 'Unbundling 2*'         | 'Unbundling 2*'         | 'Store 02' | '38/18SD'                             |
		| '2,000'      | 'Unbundling 2*'         | 'Unbundling 2*'         | 'Store 02' | '39/18SD'                             |
	И Я закрыл все окна клиентского приложения

Сценарий: _029609 проведение расходного и приходного ордера по документу Unbundling (ордерный склад) и проверка движений по регистрам
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-264' с именем 'IRP-264'
	И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
	И я создаю расходный и приходный ордер со склада
		И в таблице "List" я перехожу к строке:
			| Company      | Item key bundle | Number |
			| Main Company | Boots/S-8       | 2      |
		И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И я меняю номер ShipmentConfirmation на 152
			И в поле 'Number' я ввожу текст '152'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '152'
		И я нажимаю на кнопку 'Post and close'
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И я меняю номер GoodsReceipt на 153
			И в поле 'Number' я ввожу текст '153'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '153'
		И я нажимаю на кнопку 'Post and close'
		И Пауза 5
		И Я закрыл все окна клиентского приложения
	И я проверяю проводки документа по регистрам
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'                   | 'Store'    | 'Item key'                            |
			| '2,000'    | 'Goods receipt 153*'         | 'Store 02' | '36/18SD'                             |
			| '2,000'    | 'Goods receipt 153*'         | 'Store 02' | '37/18SD'                             |
			| '2,000'    | 'Goods receipt 153*'         | 'Store 02' | '38/18SD'                             |
			| '2,000'    | 'Goods receipt 153*'         | 'Store 02' | '39/18SD'                             |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
		Тогда таблица "List" содержит строки:
			| 'Quantity'   | 'Recorder'                    | 'Store'    | 'Item key'                          |
			| '2,000'    | 'Goods receipt 153*'            | 'Store 02' | '36/18SD'                             |
			| '2,000'    | 'Goods receipt 153*'            | 'Store 02' | '37/18SD'                             |
			| '2,000'    | 'Goods receipt 153*'            | 'Store 02' | '38/18SD'                             |
			| '2,000'    | 'Goods receipt 153*'            | 'Store 02' | '39/18SD'                             |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
		Тогда таблица "List" содержит строки:
			| 'Quantity'   | 'Recorder'                   | 'Shipment basis'       | 'Store'    | 'Item key'  |
			| '2,000'      | 'Shipment confirmation 152*' | 'Unbundling 2*'        | 'Store 02' | 'Boots/S-8' |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
		Тогда таблица "List" содержит строки:
		| 'Quantity'   | 'Recorder'                | 'Receipt basis'        |  'Store'    | 'Item key'  |
		| '2,000'        | 'Goods receipt 153*'    | 'Unbundling 2*'         | 'Store 02' | '36/18SD'                             |
		| '2,000'        | 'Goods receipt 153*'    | 'Unbundling 2*'         | 'Store 02' | '37/18SD'                             |
		| '2,000'        | 'Goods receipt 153*'    | 'Unbundling 2*'         | 'Store 02' | '38/18SD'                             |
		| '2,000'        | 'Goods receipt 153*'    | 'Unbundling 2*'         | 'Store 02' | '39/18SD'                             |
		И Я закрыл все окна клиентского приложения


Сценарий: _029610 проведение документа Unbundling (+проверка движений) по bundl который был создан самостоятельно
# При проведении документа Unbundling по набору от поставщика дополнительно создаются по номенклатуре недостающие item key. Например есть банл кола+шоколадка,
# на этот бандл создается для распаковки 2 номенклатуры Кола и Шоколадка. Создается спецификация и после этого при распаковке программа создаст по коле и шоколадке 
# недостающие item key
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-264' с именем 'IRP-264'
	И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
	И я создаю документ Unbundling по Bound Dress+Shirt, все item key заранее по товару созданы
		И я нажимаю на кнопку с именем 'FormCreate'
		И я указываю номер документа
			И в поле 'Number' я ввожу текст '3'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '3'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Bound Dress+Shirt       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item key bundle"
		И в таблице "List" я перехожу к строке:
			| Item              | Item key  |
			| Bound Dress+Shirt | Bound Dress+Shirt/Dress+Shirt |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs      |
		И в таблице "List" я выбираю текущую строку
		И в поле с именем 'Quantity' я ввожу текст '2,000'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01  |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку 'By specification'
		И я нажимаю на кнопку 'Post and close'
		И я проверяю создание документа Unbundling
			Тогда таблица "List" содержит строки:
				| Item key bundle | Company      |
				| Bound Dress+Shirt/Dress+Shirt       | Main Company |
		И Я закрыл все окна клиентского приложения

Сценарий: _029611 проведение документа Unbundling (+проверка движений) по bundl (есть документ bundling) по которому спецификация была изменена
# недостающие item key по товару создаются автоматически
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-264' с именем 'IRP-264'
	И я изменяю спецификацию Dress+Trousers
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Specifications'
		И в таблице "List" я перехожу к строке:
			| Description | Type |
			| Trousers    | Set  |
		И в таблице "List" я перехожу к строке:
			| Description    | Type   |
			| Dress+Trousers | Bundle |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я нажимаю на кнопку с именем 'FormTable*'
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Size"
		И в таблице "List" я перехожу к строке:
			| Description |
			| M           |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Color"
		И в таблице "List" я перехожу к строке:
			| Description |
			| White       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле с именем "Quantity*"
		И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "FormTable*" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	И я провожу документ Unbundling по номенклатуре Dress+Trousers
		И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я указываю номер документа
			И в поле 'Number' я ввожу текст '4'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '4'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Bound Dress+Trousers       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item key bundle"
		И в таблице "List" я перехожу к строке:
			| Item              | Item key  |
			| Bound Dress+Trousers | Bound Dress+Trousers/Dress+Trousers |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs      |
		И в таблице "List" я выбираю текущую строку
		И в поле с именем 'Quantity' я ввожу текст '2,000'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01  |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку 'By bundle content'
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' |
			| 'Dress'    | '2,000'    | 'XS/Blue'   | 'pcs' |
			| 'Trousers' | '2,000'    | '36/Yellow' | 'pcs' |
		И я нажимаю на кнопку 'Post and close'
		И я проверяю создание документа Unbundling
			Тогда таблица "List" содержит строки:
				| Item key bundle | Company      |
				| Bound Dress+Trousers/Dress+Trousers       | Main Company |
		И Я закрыл все окна клиентского приложения

Сценарий: _029612 проведение документа Unbundling по складу ордерному на приемку
	* Открытие формы создания Unbundling
		И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Изменение номера документа
			И в поле 'Number' я ввожу текст '8'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '8'
	* Заполнение реквизитов
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Bound Dress+Shirt       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item key bundle"
		И в таблице "List" я перехожу к строке:
			| Item              | Item key  |
			| Bound Dress+Shirt | Bound Dress+Shirt/Dress+Shirt |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs      |
		И в таблице "List" я выбираю текущую строку
		И в поле с именем 'Quantity' я ввожу текст '2,000'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 07  |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку 'By specification'
	* Проведение и проверка движений
		И я нажимаю на кнопку 'Post'
		И Пауза 5
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Unbundling 8*'                         | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| 'Document registrations records'        | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                              | ''         | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Receipt basis'                 | 'Item key' | 'Row key' |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 07'   | 'Unbundling 8*'                 | 'XS/Blue'  | '*'       |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 07'   | 'Unbundling 8*'                 | '36/Red'   | '*'       |
			| ''                                      | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                              | ''         | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'                      | ''         | ''        |
			| ''                                      | 'Expense'     | '*'      | '2'         | 'Store 07'   | 'Bound Dress+Shirt/Dress+Shirt' | ''         | ''        |
			| ''                                      | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                              | ''         | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'                      | ''         | ''        |
			| ''                                      | 'Expense'     | '*'      | '2'         | 'Store 07'   | 'Bound Dress+Shirt/Dress+Shirt' | ''         | ''        |
		И Я закрыл все окна клиентского приложения
	
	Сценарий: _029613 проведение документа Unbundling по складу ордерному на отгрузку
	* Открытие формы создания Unbundling
		И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Изменение номера документа
			И в поле 'Number' я ввожу текст '9'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9'
	* Заполнение реквизитов
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Bound Dress+Shirt       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item key bundle"
		И в таблице "List" я перехожу к строке:
			| Item              | Item key  |
			| Bound Dress+Shirt | Bound Dress+Shirt/Dress+Shirt |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs      |
		И в таблице "List" я выбираю текущую строку
		И в поле с именем 'Quantity' я ввожу текст '2,000'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 08  |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку 'By specification'
	* Проведение и проверка движений
		И я нажимаю на кнопку 'Post'
		И Пауза 5
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Unbundling 9*'                         | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| 'Document registrations records'        | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| 'Register  "Goods in transit outgoing"' | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                              | ''                              | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Shipment basis'                | 'Item key'                      | 'Row key' |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 08'   | 'Unbundling 9*'                 | 'Bound Dress+Shirt/Dress+Shirt' | '*'       |
			| ''                                      | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                              | ''                              | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'                      | ''                              | ''        |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 08'   | 'XS/Blue'                       | ''                              | ''        |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 08'   | '36/Red'                        | ''                              | ''        |
			| ''                                      | 'Expense'     | '*'      | '2'         | 'Store 08'   | 'Bound Dress+Shirt/Dress+Shirt' | ''                              | ''        |
			| ''                                      | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                              | ''                              | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'                      | ''                              | ''        |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 08'   | 'XS/Blue'                       | ''                              | ''        |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 08'   | '36/Red'                        | ''                              | ''        |
		И Я закрыл все окна клиентского приложения