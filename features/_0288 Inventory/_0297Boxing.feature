#language: ru
@tree
@Positive

Функционал: объединение товара в коробки для перемещения

Как разработчик
Я хочу объединить товар в короб
Чтобы переместить его со склада на магазин либо между магазинами


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

	

Сценарий: _029701 создание документа Boxing с неордерного склада (делает списание и оприходование)
	# по умолчанию включен флаг 'Receipt' и 'Write off' (Делать списание и делать оприходование)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-261' с именем 'IRP-261'
	И я открываю навигационную ссылку "e1cib/list/Document.Boxing"
	И я нажимаю на кнопку 'Create'
	И я меняю номер документа
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '1'
	И я заполняю основные реквизиты документа
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item box"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01  |
		И в таблице "List" я выбираю текущую строку
		И я устанавливаю флаг 'Receipt'
		И я устанавливаю флаг 'Write off'
		И в поле 'Inv. number' я ввожу текст '101'
		И в поле 'barcode' я ввожу текст '12150001908090'
	И я заполняю товарную часть
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Shirt       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Shirt | 36/Red   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '5,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Boots       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Boots | 37/18SD  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '5,000'
		И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'
	И я жду закрытия окна 'Boxing (create) *' в течение 20 секунд
		
	
Сценарий: _029702 проверка движений документа Boxing по регистру Box content (при установленном переключателе Receipt и Write off) с неордерного склада
# Receipt - оприходования, Write off - списание
	И я открываю навигационную ссылку "e1cib/list/InformationRegister.BoxContents"
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'  | 'Item key box'       | 'Item key' |
		| '5,000'    | 'Boxing 1*' | '101/12150001908090' | '36/Red'   |
		| '5,000'    | 'Boxing 1*' | '101/12150001908090' | '37/18SD'  |
	И Я закрыл все окна клиентского приложения

Сценарий: _029703 проверка движений документа Boxing по регистру StockBalance (при установленном переключателе Receipt и Write off) с неордерного склада
# Receipt - оприходования, Write off - списание
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockBalance"
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'    | 'Store'    | 'Item key'           |
		| '1,000'    | 'Boxing 1*'   | 'Store 01' | '101/12150001908090' |
		| '5,000'    | 'Boxing 1*'   | 'Store 01' | '36/Red'             |
		| '5,000'    | 'Boxing 1*'   | 'Store 01' | '37/18SD'            |
	И Я закрыл все окна клиентского приложения

Сценарий: _029704 проверка движений документа Boxing по регистру StockReservation (при установленном переключателе Receipt и Write off) с неордерного склада
# Receipt - оприходования, Write off - списание
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockReservation"
	Тогда таблица "List" содержит строки:
		| 'Quantity' | Recorder    | 'Store'    | 'Item key'           |
		| '1,000'    | 'Boxing 1*' | 'Store 01' | '101/12150001908090' |
		| '5,000'    | 'Boxing 1*' | 'Store 01' | '36/Red'             |
		| '5,000'    | 'Boxing 1*' | 'Store 01' | '37/18SD'            |
	И Я закрыл все окна клиентского приложения

Сценарий: _029705 проверка отсутствия движений документа Boxing по регистру GoodsInTransitIncoming (при установленном переключателе Receipt и Write off) с неордерного склада
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	Тогда таблица "List" не содержит строки:
		| 'Recorder'  |
		| 'Boxing 1*' |
	И Я закрыл все окна клиентского приложения


Сценарий: _029706 проверка отсутствия движений документа Boxing по регистру GoodsInTransitOutgoing (при установленном переключателе Receipt и Write off) с неордерного склада
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	Тогда таблица "List" не содержит строки:
		| 'Recorder'  |
		| 'Boxing 1*' |
	И Я закрыл все окна клиентского приложения


Сценарий: _029707 создание документа Boxing с ордерного склада (делает списание и оприходование)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-261' с именем 'IRP-261'
	И я открываю навигационную ссылку "e1cib/list/Document.Boxing"
	И я нажимаю на кнопку 'Create'
	И я меняю номер документа
			И в поле 'Number' я ввожу текст '2'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2'
	И я заполняю основные реквизиты документа
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item box"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02  |
		И в таблице "List" я выбираю текущую строку
		И я устанавливаю флаг 'Receipt'
		И я устанавливаю флаг 'Write off'
		И в поле 'Inv. number' я ввожу текст '101'
		И в поле 'barcode' я ввожу текст '12150001908091'
	И я заполняю товарную часть
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Trousers       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Trousers | 38/Yellow   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '12,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Dress | L/Green  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '4,000'
		И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'
	И я жду закрытия окна 'Boxing (create) *' в течение 20 секунд

Сценарий: _029708 проверка движений документа Boxing по регистру Box content (при установленном переключателе Receipt и Write off) с ордерного склада
# Receipt - оприходования, Write off - списание
	И я открываю навигационную ссылку "e1cib/list/InformationRegister.BoxContents"
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'  | 'Item key box'       | 'Item key'  |
		| '4,000'    | 'Boxing 2*' | '101/12150001908091' | 'L/Green'   |
		| '12,000'   | 'Boxing 2*' | '101/12150001908091' | '38/Yellow' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029709 проверка отсутствия движений документа Boxing по регистру StockBalance (при установленном переключателе Receipt и Write off) с ордерного склада
# Receipt - оприходования, Write off - списание
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockBalance"
	Тогда таблица "List" не содержит строки:
		| 'Recorder'    |
		| 'Boxing 2*'   |
	И Я закрыл все окна клиентского приложения

Сценарий: _029710 проверка движений документа Boxing по регистру StockReservation (при установленном переключателе Receipt и Write off) с ордерного склада
# Receipt - оприходования, Write off - списание
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockReservation"
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'  | 'Store'    | 'Item key'  |
		| '4,000'    | 'Boxing 2*' | 'Store 02' | 'L/Green'   |
		| '12,000'   | 'Boxing 2*' | 'Store 02' | '38/Yellow' |
	И Я закрыл все окна клиентского приложения


Сценарий: _029711 проверка движений документа Boxing по регистру GoodsInTransitIncoming (при установленном переключателе Receipt и Write off) с ордерного склада
# Receipt - оприходования, Write off - списание
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'  | 'Receipt basis' | 'Store'    | 'Item key'           |
		| '1,000'    | 'Boxing 2*' | 'Boxing 2*'    | 'Store 02' | '101/12150001908091' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029712 проверка движений документа Boxing по регистру GoodsInTransitOutgoing (при установленном переключателе Receipt и Write off) с ордерного склада
# Receipt - оприходования, Write off - списание
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'  | 'Shipment basis'  | 'Store'    | 'Item key'  |
		| '4,000'    | 'Boxing 2*' | 'Boxing 2*'       | 'Store 02' | 'L/Green'   |
		| '12,000'   | 'Boxing 2*' | 'Boxing 2*'       | 'Store 02' | '38/Yellow' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029713 проведение приходного и расходного ордера по документу Boxing с ордерного склада
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-261' с именем 'IRP-261'
	И я открываю навигационную ссылку "e1cib/list/Document.Boxing"
	И в таблице "List" я перехожу к строке:
		| Item box  | Number |
		| Paper box | 2      |
	И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
	И     элемент формы с именем "Company" стал равен 'Main Company'
	И в поле 'Number' я ввожу текст '0'
	Тогда открылось окно '1C:Enterprise'
	И я нажимаю на кнопку 'Yes'
	И в поле 'Number' я ввожу текст '170'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
	И     элемент формы с именем "Company" стал равен 'Main Company'
	И в поле 'Number' я ввожу текст '0'
	Тогда открылось окно '1C:Enterprise'
	И я нажимаю на кнопку 'Yes'
	И в поле 'Number' я ввожу текст '170'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	И Я закрыл все окна клиентского приложения

Сценарий: _029714 проверка проводок расходного и приходного ордера по документу Boxing
	И я проверяю проводки по регистру StockBalance
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockBalance"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'                   | 'Store'    | 'Item key'  |
			| '4,000'    | 'Shipment confirmation 170*' | 'Store 02' | 'L/Green'   |
			| '12,000'   | 'Shipment confirmation 170*' | 'Store 02' | '38/Yellow' |
		И Я закрыл все окна клиентского приложения
	И я проверяю проводки по регистру GoodsInTransitOutgoing
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'                    | 'Shipment basis'  | 'Store'    | 'Item key'  |
			| '4,000'    | 'Shipment confirmation 170*'  | 'Boxing 2*'       | 'Store 02' | 'L/Green'   |
			| '12,000'   | 'Shipment confirmation 170*'  | 'Boxing 2*'       | 'Store 02' | '38/Yellow' |
		И Я закрыл все окна клиентского приложения
	И я проверяю проводки по регистру GoodsInTransitIncoming
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'           | 'Receipt basis'   | 'Store'    | 'Item key'           |
			| '1,000'    | 'Goods receipt 170*' | 'Boxing 2*'       | 'Store 02' | '101/12150001908091' |
		И Я закрыл все окна клиентского приложения
	И я проверяю проводки по регистру StockBalance
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockBalance"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'             | 'Store'    | 'Item key'           |
			| '1,000'    | 'Goods receipt 170*'   | 'Store 02' | '101/12150001908091' |
		И Я закрыл все окна клиентского приложения
	И я проверяю проводки по регистру StockReservation
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockReservation"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'           | 'Store'    | 'Item key'           |
			| '1,000'    | 'Goods receipt 170*' | 'Store 02' | '101/12150001908091' |
		И Я закрыл все окна клиентского приложения

Сценарий: _029715 создания документа Boxing без списания товара с ордерного склада
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-261' с именем 'IRP-261'
	И я открываю навигационную ссылку "e1cib/list/Document.Boxing"
	И я нажимаю на кнопку 'Create'
	И я меняю номер документа
			И в поле 'Number' я ввожу текст '3'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '3'
	И я заполняю основные реквизиты документа
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item box"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02  |
		И в таблице "List" я выбираю текущую строку
		И я снимаю флаг 'Write off'
		И я устанавливаю флаг 'Receipt'
		И в поле 'Inv. number' я ввожу текст '101'
		И в поле 'barcode' я ввожу текст '12150001908092'
	И я заполняю товарную часть
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Trousers       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Trousers | 36/Yellow   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '3,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Dress | XS/Blue  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '8,000'
		И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'
	И я жду закрытия окна 'Boxing (create) *' в течение 20 секунд


Сценарий: _029716 проверка движений документа Boxing по регистру Box content (при установленном переключателе Receipt) с ордерного склада
	# Receipt - оприходования, Write off - списание
	И я открываю навигационную ссылку "e1cib/list/InformationRegister.BoxContents"
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'   | 'Item key box'        | 'Item key'  |
		| '8,000'    | 'Boxing 3*'  | '101/12150001908092'  | 'XS/Blue'   |
		| '3,000'    | 'Boxing 3*'  | '101/12150001908092'  | '36/Yellow' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029717 проверка отсутствия движений документа Boxing по регистру StockBalance (при установленном переключателе Receipt) с ордерного склада
# Receipt - оприходования, Write off - списание
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockBalance"
	Тогда таблица "List" не содержит строки:
		| 'Recorder'    |
		| 'Boxing 3*'   |
	И Я закрыл все окна клиентского приложения

Сценарий: _029718 проверка отсутствия движений документа Boxing по регистру StockReservation (при установленном переключателе Receipt) с ордерного склада
# Receipt - оприходования, Write off - списание
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockReservation"
	Тогда таблица "List" не содержит строки:
		| 'Recorder'    |
		| 'Boxing 3*'   |
	И Я закрыл все окна клиентского приложения


Сценарий: _029719 проверка движений документа Boxing по регистру GoodsInTransitIncoming (при установленном переключателе Receipt) с ордерного склада
# Receipt - оприходования, Write off - списание
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'  | 'Receipt basis' | 'Store'    | 'Item key'           |
		| '1,000'    | 'Boxing 3*' | 'Boxing 3*'     | 'Store 02' | '101/12150001908092' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029720 проверка отсутствия движений документа Boxing по регистру GoodsInTransitOutgoing (при установленном переключателе Receipt) с ордерного склада
# Receipt - оприходования, Write off - списание
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	Тогда таблица "List" не содержит строки:
		| 'Recorder'  |
		| 'Boxing 3*' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029721 создание приходного ордера по документу Boxing без списания товара с ордерного склада
	И я открываю навигационную ссылку "e1cib/list/Document.Boxing"
	И я создаю приходный ордер
		И в таблице "List" я перехожу к строке:
			| Item box  | Number |
			| Paper box | 3      |
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '171'
		И я нажимаю на кнопку 'Post and close'
		И Пауза 5
	И я проверяю создание приходного ордера
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
		И в таблице "List" я перехожу к строке:
		| 'Number' | 'Company'      |
		| '171'    | 'Main Company' |
	И Я закрыл все окна клиентского приложения
	И я проверяю проводки по регистру GoodsInTransitIncoming
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'           | 'Receipt basis'   | 'Line number' | 'Store'    | 'Item key'           |
			| '1,000'    | 'Goods receipt 171*' | 'Boxing 3*'       | '1'           | 'Store 02' | '101/12150001908092' |
		И Я закрыл все окна клиентского приложения
	И я проверяю проводки по регистру StockBalance
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockBalance"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'             | 'Line number' | 'Store'    | 'Item key'           |
			| '1,000'    | 'Goods receipt 171*'   | '1'           | 'Store 02' | '101/12150001908092' |
		И Я закрыл все окна клиентского приложения
	И я проверяю проводки по регистру StockReservation
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockReservation"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key'           |
			| '1,000'    | 'Goods receipt 171*' | '1'           | 'Store 02' | '101/12150001908092' |
		И Я закрыл все окна клиентского приложения
	
Сценарий: _029722 создания документа Boxing без списания товара с неордерного склада
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-261' с именем 'IRP-261'
	И я открываю навигационную ссылку "e1cib/list/Document.Boxing"
	И я нажимаю на кнопку 'Create'
	И я меняю номер документа
			И в поле 'Number' я ввожу текст '4'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '4'
	И я заполняю основные реквизиты документа
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item box"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01  |
		И в таблице "List" я выбираю текущую строку
		И я снимаю флаг 'Write off'
		И я устанавливаю флаг 'Receipt'
		И в поле 'Inv. number' я ввожу текст '101'
		И в поле 'barcode' я ввожу текст '12150001908093'
	И я заполняю товарную часть
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Trousers       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Trousers | 36/Yellow   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Dress | XS/Blue  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	И я проверяю проводки созданного документа по регистру BoxContents
		# Receipt - оприходования, Write off - списание
		И я открываю навигационную ссылку "e1cib/list/InformationRegister.BoxContents"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'   | 'Item key box'        | 'Item key'  |
			| '2,000'    | 'Boxing 4*'  | '101/12150001908093'  | 'XS/Blue'   |
			| '2,000'    | 'Boxing 4*'  | '101/12150001908093'  | '36/Yellow' |
		И Я закрыл все окна клиентского приложения
	И я проверяю проводки созданного документа по регистру StockBalance
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockBalance"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'  | 'Line number' | 'Store'    | 'Item key'           |
			| '1,000'    | 'Boxing 4*' | '1'           | 'Store 01' | '101/12150001908093' |
		И Я закрыл все окна клиентского приложения
	И я проверяю проводки созданного документа по регистру StockReservation
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockReservation"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'    | 'Line number' | 'Store'    | 'Item key'           |
			| '1,000'    | 'Boxing 4*'   | '1'           | 'Store 01' | '101/12150001908093' |
		И Я закрыл все окна клиентского приложения
	И я проверяю отсутствие движений по регистрам GoodsInTransitOutgoing и GoodsInTransitIncoming
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
		Тогда таблица "List" не содержит строки:
			| 'Recorder'  |
			| 'Boxing 4*' |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
		Тогда таблица "List" не содержит строки:
			| 'Recorder'  |
			| 'Boxing 4*' |
		И Я закрыл все окна клиентского приложения

Сценарий: _029723 создание документа Boxing без списания и оприходования товара с неордерного склада
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-261' с именем 'IRP-261'
	И я открываю навигационную ссылку "e1cib/list/Document.Boxing"
	И я нажимаю на кнопку 'Create'
	И я меняю номер документа
			И в поле 'Number' я ввожу текст '5'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '5'
	И я заполняю основные реквизиты документа
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item box"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01  |
		И в таблице "List" я выбираю текущую строку
		И я снимаю флаг "Write off"
		И я снимаю флаг "Receipt"
		И в поле 'Inv. number' я ввожу текст '101'
		И в поле 'barcode' я ввожу текст '12150001908094'
	И я заполняю товарную часть
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Trousers       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Trousers | 36/Yellow   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '3,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Dress | XS/Blue  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '3,000'
		И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'
	И я проверяю проводки созданного документа по регистру BoxContents
		# Receipt - оприходования, Write off - списание
		И я открываю навигационную ссылку "e1cib/list/InformationRegister.BoxContents"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'   | 'Item key box'        | 'Item key'  |
			| '3,000'    | 'Boxing 5*'  | '101/12150001908094'  | 'XS/Blue'   |
			| '3,000'    | 'Boxing 5*'  | '101/12150001908094'  | '36/Yellow' |
		И Я закрыл все окна клиентского приложения
	И я проверяю отсутствие проводок созданного документа по регистру StockBalance
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockBalance"
		Тогда таблица "List" не содержит строки:
			| 'Recorder'  |
			| 'Boxing 5*' |
		И Я закрыл все окна клиентского приложения
	И я проверяю отсутствие проводок созданного документа по регистру StockReservation
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockReservation"
		Тогда таблица "List" не содержит строки:
			| 'Recorder'    |
			| 'Boxing 5*'   |
		И Я закрыл все окна клиентского приложения
	И я проверяю отсутствие движений по регистрам GoodsInTransitOutgoing и GoodsInTransitIncoming
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
		Тогда таблица "List" не содержит строки:
			| 'Recorder'  |
			| 'Boxing 5*' |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
		Тогда таблица "List" не содержит строки:
			| 'Recorder'  |
			| 'Boxing 5*' |
		И Я закрыл все окна клиентского приложения

Сценарий: _029724 создание документа Boxing без списания и оприходования товара с ордерного склада
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-261' с именем 'IRP-261'
	И я открываю навигационную ссылку "e1cib/list/Document.Boxing"
	И я нажимаю на кнопку 'Create'
	И я меняю номер документа
			И в поле 'Number' я ввожу текст '6'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '6'
	И я заполняю основные реквизиты документа
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item box"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02  |
		И в таблице "List" я выбираю текущую строку
		И я снимаю флаг "Write off"
		И я снимаю флаг "Receipt"
		И в поле 'Inv. number' я ввожу текст '101'
		И в поле 'barcode' я ввожу текст '12150001908095'
	И я заполняю товарную часть
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Trousers       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Trousers | 36/Yellow   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '4,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Dress | XS/Blue  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '4,000'
		И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'
	И я проверяю проводки созданного документа по регистру BoxContents
		# Receipt - оприходования, Write off - списание
		И я открываю навигационную ссылку "e1cib/list/InformationRegister.BoxContents"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'   | 'Item key box'        | 'Item key'  |
			| '4,000'    | 'Boxing 6*'  | '101/12150001908095'  | 'XS/Blue'   |
			| '4,000'    | 'Boxing 6*'  | '101/12150001908095'  | '36/Yellow' |
		И Я закрыл все окна клиентского приложения
	И я проверяю отсутствие проводок созданного документа по регистру StockBalance
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockBalance"
		Тогда таблица "List" не содержит строки:
			| 'Recorder'  |
			| 'Boxing 6*' |
		И Я закрыл все окна клиентского приложения
	И я проверяю отсутствие проводок созданного документа по регистру StockReservation
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockReservation"
		Тогда таблица "List" не содержит строки:
			| 'Recorder'    |
			| 'Boxing 6*'   |
		И Я закрыл все окна клиентского приложения
	И я проверяю отсутствие движений по регистрам GoodsInTransitOutgoing и GoodsInTransitIncoming
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
		Тогда таблица "List" не содержит строки:
			| 'Recorder'  |
			| 'Boxing 6*' |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
		Тогда таблица "List" не содержит строки:
			| 'Recorder'  |
			| 'Boxing 6*' |
		И Я закрыл все окна клиентского приложения

Сценарий: _029725 создание документа Boxing с ордерного склада на приемку товара (делает списание и оприходование)
	* Открытие формы создания документа
		И я открываю навигационную ссылку "e1cib/list/Document.Boxing"
		И я нажимаю на кнопку 'Create'
	* Изменение номера документа
			И в поле 'Number' я ввожу текст '8'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '8'
	* Заполнение основных реквизитов документа
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item box"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 07  |
		И в таблице "List" я выбираю текущую строку
		И я устанавливаю флаг 'Receipt'
		И я устанавливаю флаг 'Write off'
		И в поле 'Inv. number' я ввожу текст '112'
		И в поле 'barcode' я ввожу текст '121500019080'
	* Заполнение табличной части
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Shirt       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Shirt | 36/Red   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '5,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Boots       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Boots | 37/18SD  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '5,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Проведение и проверка движений
		И я нажимаю на кнопку 'Post'
		И Пауза 5
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Boxing 8*'                             | ''            | ''          | ''                 | ''           | ''              | ''                 | ''        |
			| 'Document registrations records'        | ''            | ''          | ''                 | ''           | ''              | ''                 | ''        |
			| 'Register  "Box contents"'              | ''            | ''          | ''                 | ''           | ''              | ''                 | ''        |
			| ''                                      | 'Period'      | 'Resources' | 'Dimensions'       | ''           | ''              | ''                 | ''        |
			| ''                                      | ''            | 'Quantity'  | 'Item key box'     | 'Item key'   | ''              | ''                 | ''        |
			| ''                                      | '*'           | '5'         | '112/121500019080' | '36/Red'     | ''              | ''                 | ''        |
			| ''                                      | '*'           | '5'         | '112/121500019080' | '37/18SD'    | ''              | ''                 | ''        |
			| ''                                      | ''            | ''          | ''                 | ''           | ''              | ''                 | ''        |
			| 'Register  "Goods in transit incoming"' | ''            | ''          | ''                 | ''           | ''              | ''                 | ''        |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'        | 'Dimensions' | ''              | ''                 | ''        |
			| ''                                      | ''            | ''          | 'Quantity'         | 'Store'      | 'Receipt basis' | 'Item key'         | 'Row key' |
			| ''                                      | 'Receipt'     | '*'         | '1'                | 'Store 07'   | 'Boxing 8*'     | '112/121500019080' | '*'       |
			| ''                                      | ''            | ''          | ''                 | ''           | ''              | ''                 | ''        |
			| 'Register  "Stock reservation"'         | ''            | ''          | ''                 | ''           | ''              | ''                 | ''        |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'        | 'Dimensions' | ''              | ''                 | ''        |
			| ''                                      | ''            | ''          | 'Quantity'         | 'Store'      | 'Item key'      | ''                 | ''        |
			| ''                                      | 'Expense'     | '*'         | '5'                | 'Store 07'   | '36/Red'        | ''                 | ''        |
			| ''                                      | 'Expense'     | '*'         | '5'                | 'Store 07'   | '37/18SD'       | ''                 | ''        |
			| ''                                      | ''            | ''          | ''                 | ''           | ''              | ''                 | ''        |
			| 'Register  "Stock balance"'             | ''            | ''          | ''                 | ''           | ''              | ''                 | ''        |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'        | 'Dimensions' | ''              | ''                 | ''        |
			| ''                                      | ''            | ''          | 'Quantity'         | 'Store'      | 'Item key'      | ''                 | ''        |
			| ''                                      | 'Expense'     | '*'         | '5'                | 'Store 07'   | '36/Red'        | ''                 | ''        |
			| ''                                      | 'Expense'     | '*'         | '5'                | 'Store 07'   | '37/18SD'       | ''                 | ''        |
		И Я закрыл все окна клиентского приложения

Сценарий: _029726 создание документа Boxing с ордерного склада на приемку товара (делает списание и оприходование)
	* Открытие формы создания документа
		И я открываю навигационную ссылку "e1cib/list/Document.Boxing"
		И я нажимаю на кнопку 'Create'
	* Изменение номера документа
			И в поле 'Number' я ввожу текст '9'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9'
	* Заполнение основных реквизитов документа
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item box"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 08  |
		И в таблице "List" я выбираю текущую строку
		И я устанавливаю флаг 'Receipt'
		И я устанавливаю флаг 'Write off'
		И в поле 'Inv. number' я ввожу текст '114'
		И в поле 'barcode' я ввожу текст '1215000190801'
	* Заполнение табличной части
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Shirt       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Shirt | 36/Red   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '5,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Boots       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Boots | 37/18SD  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '5,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Проведение и проверка движений
		И я нажимаю на кнопку 'Post'
		И Пауза 5
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Boxing 9*'                             | ''            | ''          | ''                  | ''           | ''                  | ''         | ''        |
			| 'Document registrations records'        | ''            | ''          | ''                  | ''           | ''                  | ''         | ''        |
			| 'Register  "Goods in transit outgoing"' | ''            | ''          | ''                  | ''           | ''                  | ''         | ''        |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'         | 'Dimensions' | ''                  | ''         | ''        |
			| ''                                      | ''            | ''          | 'Quantity'          | 'Store'      | 'Shipment basis'    | 'Item key' | 'Row key' |
			| ''                                      | 'Receipt'     | '*'         | '5'                 | 'Store 08'   | 'Boxing 9*'         | '36/Red'   | '*'       |
			| ''                                      | 'Receipt'     | '*'         | '5'                 | 'Store 08'   | 'Boxing 9*'         | '37/18SD'  | '*'       |
			| ''                                      | ''            | ''          | ''                  | ''           | ''                  | ''         | ''        |
			| 'Register  "Box contents"'              | ''            | ''          | ''                  | ''           | ''                  | ''         | ''        |
			| ''                                      | 'Period'      | 'Resources' | 'Dimensions'        | ''           | ''                  | ''         | ''        |
			| ''                                      | ''            | 'Quantity'  | 'Item key box'      | 'Item key'   | ''                  | ''         | ''        |
			| ''                                      | '*'           | '5'         | '114/1215000190801' | '36/Red'     | ''                  | ''         | ''        |
			| ''                                      | '*'           | '5'         | '114/1215000190801' | '37/18SD'    | ''                  | ''         | ''        |
			| ''                                      | ''            | ''          | ''                  | ''           | ''                  | ''         | ''        |
			| 'Register  "Stock reservation"'         | ''            | ''          | ''                  | ''           | ''                  | ''         | ''        |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'         | 'Dimensions' | ''                  | ''         | ''        |
			| ''                                      | ''            | ''          | 'Quantity'          | 'Store'      | 'Item key'          | ''         | ''        |
			| ''                                      | 'Receipt'     | '*'         | '1'                 | 'Store 08'   | '114/1215000190801' | ''         | ''        |
			| ''                                      | 'Expense'     | '*'         | '5'                 | 'Store 08'   | '36/Red'            | ''         | ''        |
			| ''                                      | 'Expense'     | '*'         | '5'                 | 'Store 08'   | '37/18SD'           | ''         | ''        |
			| ''                                      | ''            | ''          | ''                  | ''           | ''                  | ''         | ''        |
			| 'Register  "Stock balance"'             | ''            | ''          | ''                  | ''           | ''                  | ''         | ''        |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'         | 'Dimensions' | ''                  | ''         | ''        |
			| ''                                      | ''            | ''          | 'Quantity'          | 'Store'      | 'Item key'          | ''         | ''        |
			| ''                                      | 'Receipt'     | '*'         | '1'                 | 'Store 08'   | '114/1215000190801' | ''         | ''        |
		И Я закрыл все окна клиентского приложения