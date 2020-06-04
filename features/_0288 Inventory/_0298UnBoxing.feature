#language: ru
@tree
@Positive

Функционал: распаковка товара из короба

Как разработчик
Я хочу распаковать товар из короба
Чтобы принять перемещение со склада на магазин либо между магазинами


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

# Если документ боксинг не делает ни списание ни оприходование товара, то перед распаковкой короба должны 
# быть приняты приходным ордером по поступлению товаров от поставщика.
# Если документ Boxing не делает списание, а только поступление, то тогда дополнительно короба принимать перед распаковкой не нужно
Сценарий: _029801 создание документа Unboxing на основании документа Boxing с неордерного склада (документ Boxing делает списание и оприходование)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-262' с именем 'IRP-262'
	И я открываю навигационную ссылку "e1cib/list/Document.Boxing"
	И я выбираю нужный документ Boxing
		И в таблице "List" я перехожу к строке:
			| Item box  | Number |
			| Paper box | 1      |
		И в таблице "List" я активизирую поле "Date"
	И на основании него создаю документ Unboxing
		И я нажимаю на кнопку с именем 'FormDocumentUnboxingGenerateUnboxing'
		И я меняю номер документа
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '1'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01    |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
	И я проверяю заполнение табличной части
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Quantity' | 'Item key' | 'Unit' |
			| 'Shirt' | '5,000'    | '36/Red'   | 'pcs' |
			| 'Boots' | '5,000'    | '37/18SD'  | 'pcs' |
	И я нажимаю на кнопку 'Post and close'

Сценарий: _029802 проверка движения документа Unboxing с неордерного склада по регистру StockBalance
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'    | 'Store'    | 'Item key'           |
		| '1,000'    | 'Unboxing 1*' | 'Store 01' | '101/12150001908090' |
		| '5,000'    | 'Unboxing 1*' | 'Store 01' | '36/Red'             |
		| '5,000'    | 'Unboxing 1*' | 'Store 01' | '37/18SD'            |
	И Я закрыл все окна клиентского приложения

Сценарий: _029803 проверка движения документа Unboxing с неордерного склада по регистру StockReservation
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'    | 'Store'    | 'Item key'           |
		| '5,000'    | 'Unboxing 1*' | 'Store 01' | '36/Red'             |
		| '5,000'    | 'Unboxing 1*' | 'Store 01' | '37/18SD'            |
		| '1,000'    | 'Unboxing 1*' | 'Store 01' | '101/12150001908090' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029804 проверка отсутствия движения документа Unboxing с неордерного склада по регистру GoodsInTransitIncoming
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" не содержит строки:
		| 'Recorder'    |
		| 'Unboxing 1*' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029805 проверка отсутствия движения документа Unboxing с неордерного склада по регистру GoodsInTransitOutgoing
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" не содержит строки:
		| 'Recorder'    |
		| 'Unboxing 1*' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029806 создание документа Unboxing с ордерного склада из списка документов Unboxing (документ Boxing делает списание и оприходование)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-262' с именем 'IRP-262'
	И я открываю навигационную ссылку 'e1cib/list/Document.Unboxing'
	И я заполняю основные реквизиты для создания документа
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю номер документа
			И в поле 'Number' я ввожу текст '2'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item box"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Paper box    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item key box"
		И в таблице "List" я перехожу к строке:
			| Item      | Item key           |
			| Paper box | 101/12150001908091 |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02  |
		И в таблице "List" я выбираю текущую строку
	И я проверяю что в табличную часть подтянулись все товары из документа Boxing
	# товарная часть подтягивается при нажатии на кнопку Unbox
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку 'Unbox'
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' |
			| 'Dress'    | '4,000'    | 'L/Green'   | 'pcs' |
			| 'Trousers' | '12,000'   | '38/Yellow' | 'pcs' |
		И я нажимаю на кнопку 'Post and close'
		И Пауза 2
	
Сценарий: _029807 проверка отсутствия движения документа Unboxing с ордерного склада по регистру StockBalance
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
		| 'Recorder'    |
		| 'Unboxing 2*' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029808 проверка движения документа Unboxing с ордерного склада по регистру StockReservation
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'    | 'Line number' | 'Store'    | 'Item key'           |
		| '1,000'    | 'Unboxing 2*' | '1'           | 'Store 02' | '101/12150001908091' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029809 проверка движения документа Unboxing с ордерного склада по регистру GoodsInTransitIncoming
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'      | 'Receipt basis' | 'Store'    | 'Item key'  |
		| '4,000'    | 'Unboxing 2*'   | 'Unboxing 2*'   | 'Store 02' | 'L/Green'   |
		| '12,000'   | 'Unboxing 2*'   | 'Unboxing 2*'   | 'Store 02' | '38/Yellow' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029810 проверка движения документа Unboxing с ордерного склада по регистру GoodsInTransitOutgoing
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'    | 'Shipment basis'  | 'Line number' | 'Store'    | 'Item key'           |
		| '1,000'    | 'Unboxing 2*' | 'Unboxing 2*'     | '1'           | 'Store 02' | '101/12150001908091' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029811 проведение приходного и расходного ордера по документу Unboxing с ордерного склада
	И я провожу приходный и расходный ордер
		И я открываю навигационную ссылку 'e1cib/list/Document.Unboxing'
		И в таблице "List" я перехожу к строке:
			| 'Item key box'       | 'Number' | 'Store'    |
			| '101/12150001908091' | '2'      | 'Store 02' |
		И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '173'
		И я нажимаю на кнопку 'Post and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '173'
		И я нажимаю на кнопку 'Post and close'
		И Пауза 2
	И я проверяю движения расходного ордера по регистру StockBalance
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockBalance"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'                   | 'Line number' | 'Store'    | 'Item key'           |
			| '1,000'    | 'Shipment confirmation 173*' | '1'           | 'Store 02' | '101/12150001908091' |
		И Я закрыл все окна клиентского приложения
	И я проверяю движения расходного ордера по регистру GoodsInTransitOutgoing
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'                   | 'Line number' | 'Store'    | 'Item key'           |
			| '1,000'    | 'Shipment confirmation 173*' | '1'           | 'Store 02' | '101/12150001908091' |
		И Я закрыл все окна клиентского приложения
	И я проверяю движения приходного ордера по регистру GoodsInTransitIncoming
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'           | 'Receipt basis'   | 'Store'    | 'Item key'  |
			| '4,000'    | 'Goods receipt 173*' | 'Unboxing 2*'     | 'Store 02' | 'L/Green'   |
			| '12,000'   | 'Goods receipt 173*' | 'Unboxing 2*'     | 'Store 02' | '38/Yellow' |
		И Я закрыл все окна клиентского приложения
	И я проверяю движения приходного ордера по регистру StockBalance
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockBalance"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'           | 'Store'    | 'Item key'  |
			| '4,000'    | 'Goods receipt 173*' | 'Store 02' | 'L/Green'   |
			| '12,000'   | 'Goods receipt 173*' | 'Store 02' | '38/Yellow' |
		И Я закрыл все окна клиентского приложения
	И я проверяю движения приходного ордера по регистру StockReservation
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockReservation"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'           | 'Store'    | 'Item key'  |
			| '4,000'    | 'Goods receipt 173*' | 'Store 02' | 'L/Green'   |
			| '12,000'   | 'Goods receipt 173*' | 'Store 02' | '38/Yellow' |
		И Я закрыл все окна клиентского приложения

Сценарий: _029812 частичная распаковка коробки
	# проверки на количество нет
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-262' с именем 'IRP-300'
	И я открываю навигационную ссылку 'e1cib/list/Document.Unboxing'
	И я заполняю основные реквизиты для создания документа
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item box"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Paper box    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item key box"
		И в таблице "List" я перехожу к строке:
			| Item      | Item key           |
			| Paper box | 101/12150001908092 |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01  |
		И в таблице "List" я выбираю текущую строку
		И я снимаю флаг с именем "WriteOff"
	# коробка списывается при установленном флаге WriteOff
	И я принимаю коробку частично
	# товарная часть подтягивается при нажатии на кнопку Unbox
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку 'Unbox'
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Quantity' |
			| 'Dress' | 'XS/Blue'  | '8,000'    |
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  | 'Quantity' |
			| 'Trousers' | '36/Yellow' | '3,000'    |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	И я проверяю что коробка осталась на остатках
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockBalance"
		Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'    | 'Item key'           |
		| '1,000'    | 'Unboxing 3*' | '101/12150001908092' |
		И Я закрыл все окна клиентского приложения
	И я распаковываю оставшуюся часть товара еще одним документом Unboxing
		И я открываю навигационную ссылку 'e1cib/list/Document.Unboxing'
	И я заполняю основные реквизиты для создания документа
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item box"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Paper box    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item key box"
		И в таблице "List" я перехожу к строке:
			| Item      | Item key           |
			| Paper box | 101/12150001908092 |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01  |
		И в таблице "List" я выбираю текущую строку
	И я принимаю коробку частично
	# товарная часть подтягивается при нажатии на кнопку Unbox
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку 'Unbox'
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Quantity' |
			| 'Dress' | 'XS/Blue'  | '8,000'    |
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '7,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  | 'Quantity' |
			| 'Trousers' | '36/Yellow' | '3,000'    |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	И я проверяю что коробка списалась с остатков
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockBalance"
		Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'    | 'Item key'           |
		| '1,000'    | 'Unboxing 4*' | '101/12150001908092' |
		И Я закрыл все окна клиентского приложения

Сценарий: _029813 создание документа Unboxing на основании документа Boxing с ордерного склада на приемку товара(документ Boxing делает списание и оприходование)
	* Выбор нужного документа Boxing для создания на его основании Unboxing
		И я открываю навигационную ссылку "e1cib/list/Document.Boxing"
		И в таблице "List" я перехожу к строке:
			| Item box  | Number |
			| Paper box | 8      |
		И в таблице "List" я активизирую поле "Date"
	* Создание документа Unboxing
		И я нажимаю на кнопку с именем 'FormDocumentUnboxingGenerateUnboxing'
		* Изменение номера документа
			И в поле 'Number' я ввожу текст '6'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '6'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 07    |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		* Проверка заполнения табличной части
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Quantity' | 'Item key' | 'Unit' |
				| 'Shirt' | '5,000'    | '36/Red'   | 'pcs' |
				| 'Boots' | '5,000'    | '37/18SD'  | 'pcs' |
	* Проведение документа Unboxing и проверка его движений
		И я нажимаю на кнопку 'Post'
		И Пауза 5
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Unboxing 6*'                           | ''            | ''       | ''          | ''           | ''                 | ''         | ''        |
			| 'Document registrations records'        | ''            | ''       | ''          | ''           | ''                 | ''         | ''        |
			| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''           | ''                 | ''         | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                 | ''         | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Receipt basis'    | 'Item key' | 'Row key' |
			| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 07'   | 'Unboxing 6*'      | '36/Red'   | '*'       |
			| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 07'   | 'Unboxing 6*'      | '37/18SD'  | '*'       |
			| ''                                      | ''            | ''       | ''          | ''           | ''                 | ''         | ''        |
			| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''           | ''                 | ''         | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                 | ''         | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'         | ''         | ''        |
			| ''                                      | 'Expense'     | '*'      | '1'         | 'Store 07'   | '112/121500019080' | ''         | ''        |
			| ''                                      | ''            | ''       | ''          | ''           | ''                 | ''         | ''        |
			| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''           | ''                 | ''         | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                 | ''         | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'         | ''         | ''        |
			| ''                                      | 'Expense'     | '*'      | '1'         | 'Store 07'   | '112/121500019080' | ''         | ''        |
		И Я закрыл все окна клиентского приложения

Сценарий: _029814 создание документа Unboxing на основании документа Boxing с ордерного склада на отгрузку товара(документ Boxing делает списание и оприходование)
	* Выбор нужного документа Boxing для создания на его основании Unboxing
		И я открываю навигационную ссылку "e1cib/list/Document.Boxing"
		И в таблице "List" я перехожу к строке:
			| Item box  | Number |
			| Paper box | 9      |
		И в таблице "List" я активизирую поле "Date"
	* Создание документа Unboxing
		И я нажимаю на кнопку с именем 'FormDocumentUnboxingGenerateUnboxing'
		* Изменение номера документа
			И в поле 'Number' я ввожу текст '7'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '7'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 08    |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		* Проверка заполнения табличной части
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Quantity' | 'Item key' | 'Unit' |
				| 'Shirt' | '5,000'    | '36/Red'   | 'pcs' |
				| 'Boots' | '5,000'    | '37/18SD'  | 'pcs' |
	* Проведение документа Unboxing и проверка его движений
		И я нажимаю на кнопку 'Post'
		И Пауза 5
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Unboxing 7*'                           | ''            | ''       | ''          | ''           | ''                  | ''                  | ''        |
			| 'Document registrations records'        | ''            | ''       | ''          | ''           | ''                  | ''                  | ''        |
			| 'Register  "Goods in transit outgoing"' | ''            | ''       | ''          | ''           | ''                  | ''                  | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                  | ''                  | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Shipment basis'    | 'Item key'          | 'Row key' |
			| ''                                      | 'Receipt'     | '*'      | '1'         | 'Store 08'   | 'Unboxing 7*'       | '114/1215000190801' | '*'       |
			| ''                                      | ''            | ''       | ''          | ''           | ''                  | ''                  | ''        |
			| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''           | ''                  | ''                  | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                  | ''                  | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'          | ''                  | ''        |
			| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 08'   | '36/Red'            | ''                  | ''        |
			| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 08'   | '37/18SD'           | ''                  | ''        |
			| ''                                      | 'Expense'     | '*'      | '1'         | 'Store 08'   | '114/1215000190801' | ''                  | ''        |
			| ''                                      | ''            | ''       | ''          | ''           | ''                  | ''                  | ''        |
			| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''           | ''                  | ''                  | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                  | ''                  | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'          | ''                  | ''        |
			| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 08'   | '36/Red'            | ''                  | ''        |
			| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 08'   | '37/18SD'           | ''                  | ''        |
		И Я закрыл все окна клиентского приложения