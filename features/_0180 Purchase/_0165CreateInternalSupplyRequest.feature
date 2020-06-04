#language: ru
@tree
@Positive


Функционал: создание документа Internal Supply Request

Как Разработчик
Я хочу создать документ предзаказа товара
Для того чтобы магазины могли подавать заявки на товар плановому отделу

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _016501 создание документа Internal Supply Request
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-275' с именем 'IRP-275'
	* Открытие формы создания Internal Supply Request
		И я открываю навигационную ссылку "e1cib/list/Document.InternalSupplyRequest"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Установка номера документа
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	* Заполнение основных реквизитов документа
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company | 
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01  |
		И в таблице "List" я выбираю текущую строку
	* Заполнение товарной части
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Trousers    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item     | Item key          |
			| Trousers | 36/Yellow |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '10,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Shirt       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '25,000'
		И в таблице "ItemList" я завершаю редактирование строки
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
			| Shirt | 38/Black |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '20,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Проведение документа
		И я нажимаю на кнопку 'Post and close'
	* Проверка создания документа
		Тогда таблица "List" содержит строки:
			| 'Number' | 'Company'      | 'Store'    |
			| '1'      | 'Main Company' | 'Store 01' |
		И Я закрыл все окна клиентского приложения
	* Проверка движения документа Internal Supply Request по регистру Order balance
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'                   | 'Store'    | 'Order'                      | 'Item key'          |
			| '10,000'   | 'Internal supply request 1*' | 'Store 01' | 'Internal supply request 1*' | '36/Yellow'|
			| '25,000'   | 'Internal supply request 1*' | 'Store 01' | 'Internal supply request 1*' | '36/Red'            |
			| '20,000'   | 'Internal supply request 1*' | 'Store 01' | 'Internal supply request 1*' | '38/Black'          |
		И Я закрыл все окна клиентского приложения
	* Создание на основании документа InternalSupplyRequest документа Inventory transfer order
		И я открываю навигационную ссылку "e1cib/list/Document.InternalSupplyRequest"
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Company'      | 'Store'    |
			| '1'      | 'Main Company' | 'Store 01' |
		И я нажимаю на кнопку с именем 'FormDocumentInventoryTransferOrderGenerateInventoryTransferOrder'
		И я нажимаю кнопку выбора у поля "Store sender"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 03  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я выбираю текущую строку
		И я меняю номер PurchaseOrder
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '200'
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'          | 'Quantity' | 'Unit' |
			| 'Trousers' | '36/Yellow' | '10,000'   | 'pcs' |
		И в таблице "ItemList" я активизирую поле "Item"
		И в таблице 'ItemList' я удаляю строку
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	* Проверка движения документа Inventory transfer order созданного на основании InternalSupplyRequest
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.OrderBalance"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'                      |'Store'    | 'Order'                      | 'Item key' |
			| '25,000'   | 'Inventory transfer order 200*' |'Store 01' | 'Internal supply request 1*' | '36/Red'   |
			| '20,000'   | 'Inventory transfer order 200*' |'Store 01' | 'Internal supply request 1*' | '38/Black' |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.StockReservation"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'                      |'Store'    | 'Item key' |
			| '25,000'   | 'Inventory transfer order 200*' |'Store 03' | '36/Red'   |
			| '20,000'   | 'Inventory transfer order 200*' |'Store 03' | '38/Black' |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.TransferOrderBalance"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'                      |'Store sender' | 'Store receiver' | 'Order'                         | 'Item key' |
			| '25,000'   | 'Inventory transfer order 200*' |'Store 03'     | 'Store 01'       | 'Inventory transfer order 200*' | '36/Red'   |
			| '20,000'   | 'Inventory transfer order 200*' |'Store 03'     | 'Store 01'       | 'Inventory transfer order 200*' | '38/Black' |
		И Я закрыл все окна клиентского приложения
	* Создание на основании документа InternalSupplyRequest документа Purchase order
		И я открываю навигационную ссылку "e1cib/list/Document.InternalSupplyRequest"
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Company'      | 'Store'    |
			| '1'      | 'Main Company' | 'Store 01' |
		И я нажимаю на кнопку с именем 'FormDocumentPurchaseOrderGeneratePurchaseOrder'
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И     элемент формы с именем "Store" стал равен 'Store 01'
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Company Ferron BP |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я перехожу к строке:
			| Description        |
			| Vendor Ferron, TRY |
		И в таблице "List" я выбираю текущую строку
		Затем Если появилось окно диалога я нажимаю на кнопку "No"
		И я нажимаю на кнопку 'OK'
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Q'        | 'Purchase basis'    | 'Item key'          | 'Store'    | 'Unit' |
			| 'Trousers' | '10,000'   | 'Internal supply request 1*' | '36/Yellow' | 'Store 01' | 'pcs' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '9,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я запоминаю количество строк таблицы "ItemList" как "Q1"
		И     я вывожу значение переменной "Q1"
		Тогда переменная "Q1" имеет значение 1
		И я устанавливаю номер документа 1
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '1'
		И я нажимаю на кнопку 'Post and close'
	* Проверка движения документа Purchase order созданного на основании InternalSupplyRequest
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.OrderBalance"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'            | 'Store'    | 'Order'                      | 'Item key'          |
			| '9,000'   | 'Purchase order 1*'    | 'Store 01' | 'Purchase order 1*'          | '36/Yellow' |
			| '9,000'   | 'Purchase order 1*'    | 'Store 01' | 'Internal supply request 1*' | '36/Yellow' |
		И Я закрыл все окна клиентского приложения
	

# Filters

Сценарий: _016503 проверяю работу фильтра по Company в документе Internal Supply Request
	* Открытие формы создания Internal Supply Request
		И я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Проверка визуального фильтра по Company
		И я нажимаю кнопку выбора у поля "Company"
		Тогда таблица "List" стала равной:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Company" стал равен 'Main Company'
	* Проверка фильтра по Company при вводе по строке
		И Пауза 2
		И в поле 'Company' я ввожу текст 'Company Kalipso'
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Store"
		Тогда открылось окно "Companies"
		Тогда таблица "List" не содержит строки:
			| Description  |
			| Company Kalipso |
		И я нажимаю на кнопку с именем 'FormChoose'
		Когда Проверяю шаги на Исключение:
			|'И     элемент формы с именем "Company" стал равен 'Company Kalipso''|
		И я закрыл все окна клиентского приложения
	
# EndFilters


# Сollapsible group

Сценарий: _016504 проверяю отображения заголовка сворачиваемой группы при создании документа Internal Supply Request
	* Открытие формы создания Internal Supply Request
		И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение номера документа
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '215'
	* Заполнение основных реквизитов документа
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company | 
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01  |
		И в таблице "List" я выбираю текущую строку
	* Проверка отображения заголовка сворачиваемой группы
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Number: 215   Company: Main Company   Store: Store 01"
		И Я закрыл все окна клиентского приложения


# EndСollapsible group








	



	





