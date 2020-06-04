#language: ru
@tree
@Positive


Функционал: проверка добавления команд в документы и списки документов



Контекст: 
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

	
Сценарий: _0205001 создание тестовых данных
	* Добавление тестовой обработки
		* Открытие формы для добавления обработки
			И я открываю навигационную ссылку 'e1cib/list/Catalog.ExternalDataProc'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение данных по обработке и добавление её в базу
			И я буду выбирать внешний файл "W:\IRP\DataProcessor\Новая папка\CheckExternalCommands.epf"
			И я нажимаю на кнопку с именем "FormAddExtDataProc"
			И в поле 'Path to ext data proc for test' я ввожу текст ''
			И в поле 'Name' я ввожу текст 'PrintFormSalesOrder'
			И я нажимаю на кнопку открытия поля с именем "Description_en"
			И в поле 'ENG' я ввожу текст 'Test command'
			И в поле 'TR' я ввожу текст 'Test command tr'
			И я нажимаю на кнопку 'Ok'
			И я нажимаю на кнопку 'Save and close'
			И Пауза 5
		* Проверка добавления обработки
			Тогда я проверяю наличие элемента справочника "ExternalDataProc" со значением поля "Description_en" "Test command"
	* Добавление тестового Purchase invoice
			И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
			И я нажимаю на кнопку с именем 'FormCreate'
			* Заполнение шапки документа
				И я нажимаю кнопку выбора у поля "Partner"
				И в таблице "List" я перехожу к строке:
					| 'Description'  |
					| 'Ferron BP' |
				И в таблице "List" я выбираю текущую строку
				И я нажимаю кнопку выбора у поля "Legal name"
				И в таблице "List" я перехожу к строке:
					| 'Description'  |
					| 'Company Ferron BP' |
				И в таблице "List" я выбираю текущую строку
				И я нажимаю кнопку выбора у поля "Company"
				И в таблице "List" я перехожу к строке:
					| 'Description'  |
					| 'Main Company' |
				И в таблице "List" я выбираю текущую строку
				И я нажимаю кнопку выбора у поля "Agreement"
				И в таблице "List" я перехожу к строке:
					| 'Description'  |
					| 'Vendor Ferron, TRY' |
				И в таблице "List" я выбираю текущую строку
				И я нажимаю кнопку выбора у поля "Store"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Store 02'    |
				И в таблице "List" я выбираю текущую строку
			* Заполнение табличной части
				И я нажимаю на кнопку 'Add'
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Boots'       |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле "Item key"
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
				И в таблице "List" я перехожу к строке:
					| 'Item'  | 'Item key' |
					| 'Boots' | '37/18SD'  |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле "Q"
				И в таблице "ItemList" в поле 'Q' я ввожу текст '15,000'
				И в таблице "ItemList" в поле 'Price' я ввожу текст '210,000'
				И в таблице "ItemList" я завершаю редактирование строки
				И я нажимаю на кнопку 'Add'
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Dress'       |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле "Item key"
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
				И в таблице "List" я перехожу к строке:
					| 'Item'  | 'Item key' |
					| 'Dress' | 'L/Green'  |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле "Q"
				И в таблице "ItemList" в поле 'Q' я ввожу текст '8,000'
				И в таблице "ItemList" в поле 'Price' я ввожу текст '350,000'
				И в таблице "ItemList" я завершаю редактирование строки
				И я нажимаю на кнопку 'Add'
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Service'       |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле "Item key"
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
				И в таблице "List" я перехожу к строке:
					| 'Item'  | 'Item key' |
					| 'Service' | 'Rent'  |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле "Q"
				И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
				И в таблице "ItemList" в поле 'Price' я ввожу текст '100,000'
				И в таблице "ItemList" я завершаю редактирование строки
			* Изменение номера документа
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '3 900'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '3 900'
			* Проведение и проверка создания
				И я нажимаю на кнопку 'Post and close'
				И таблица "List" содержит строки:
					| 'Number' |
					| '3 900'       |

Сценарий: _0205002 добавление тестовой команды в список документов Sales return
	* Открытие регистра команд
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение данных для команды печати Sales return
		* Создание метаданного для Sales return и его выбор для команды
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице  "List" я перехожу на один уровень вниз
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'SalesReturn'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'SalesReturn'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
	* Сохранение команды
		И я нажимаю на кнопку 'Save and close'
	* Проверка сохранения команды
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'  | 'External data proc' |
		| 'SalesReturn'             | 'Test command'       |
	* Проверка вызова команды из списка документов Sales Return
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд

Сценарий: _0205003 добавление тестовой команды в список документов Sales invoice
	* Открытие регистра команд
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение данных для команды печати Sales invoice
		* Создание метаданного для Sales invoice и его выбор для команды
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице  "List" я перехожу на один уровень вниз
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'SalesInvoice'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'SalesInvoice'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
	* Сохранение команды
		И я нажимаю на кнопку 'Save and close'
	* Проверка сохранения команды
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'  | 'External data proc' |
		| 'SalesInvoice'             | 'Test command'       |
	* Проверка вызова команды из списка документов SalesInvoice
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд

Сценарий: _0205004 добавление тестовой команды в список документов Purchase order
	* Открытие регистра команд
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение данных для команды печати Purchase order
		* Создание метаданного для Purchase order и его выбор для команды
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице  "List" я перехожу на один уровень вниз
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'PurchaseOrder'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'PurchaseOrder'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
	* Сохранение команды
		И я нажимаю на кнопку 'Save and close'
	* Проверка сохранения команды
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'  | 'External data proc' |
		| 'PurchaseOrder'             | 'Test command'       |
	* Проверка вызова команды из списка документов PurchaseOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд

Сценарий: _0205005 добавление тестовой команды в список документов Sales order
	* Открытие регистра команд
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение данных для команды печати Sales order
		* Создание метаданного для sales order и его выбор для команды
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице  "List" я перехожу на один уровень вниз
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'SalesOrder'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'SalesOrder'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
	* Сохранение команды
		И я нажимаю на кнопку 'Save and close'
	* Проверка сохранения команды
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'  | 'External data proc' |
		| 'SalesOrder'             | 'Test command'       |
	* Проверка вызова команды из списка документов SalesOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд

Сценарий: _0205006 добавление тестовой команды в список документов Purchase invoice
	* Открытие регистра команд
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение данных для команды печати Purchase invoice
		* Создание метаданного для Purchase invoice и его выбор для команды
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице  "List" я перехожу на один уровень вниз
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'PurchaseInvoice'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'PurchaseInvoice'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
	* Сохранение команды
		И я нажимаю на кнопку 'Save and close'
	* Проверка сохранения команды
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'  | 'External data proc' |
		| 'PurchaseInvoice'             | 'Test command'       |
	* Проверка вызова команды из списка документов PurchaseInvoice
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд


Сценарий: _0205007 добавление тестовой команды в список документов Cash transfer order
	* Открытие регистра команд
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение данных для команды печати Cash transfer order
		* Создание метаданного для Cash transfer order и его выбор для команды
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице  "List" я перехожу на один уровень вниз
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'CashTransferOrder'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'CashTransferOrder'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
	* Сохранение команды
		И я нажимаю на кнопку 'Save and close'
	* Проверка сохранения команды
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'  | 'External data proc' |
		| 'CashTransferOrder'             | 'Test command'       |
	* Проверка вызова команды из списка документов CashTransferOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.CashTransferOrder'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд


Сценарий: _0205008 добавление тестовой команды в список документов Shipment confirmation
	* Открытие регистра команд
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение данных для тестовой команды для Shipment confirmation
		* Создание метаданного для Shipment confirmation и его выбор для команды
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице  "List" я перехожу на один уровень вниз
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'ShipmentConfirmation'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'ShipmentConfirmation'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
	* Сохранение команды
		И я нажимаю на кнопку 'Save and close'
	* Проверка сохранения команды
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'           | 'External data proc' |
		| 'ShipmentConfirmation'             | 'Test command'       |
	* Проверка вызова команды из списка документов CashTransferOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд


Сценарий: _0205009 добавление тестовой команды в список документов Goods receipt
	* Открытие регистра команд
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение данных для тестовой команды для Goods receipt
		* Создание метаданного для Goods receipt и его выбор для команды
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице  "List" я перехожу на один уровень вниз
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'GoodsReceipt'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'GoodsReceipt'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
	* Сохранение команды
		И я нажимаю на кнопку 'Save and close'
	* Проверка сохранения команды
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'           | 'External data proc' |
		| 'GoodsReceipt'             | 'Test command'       |
	* Проверка вызова команды из списка документов GoodsReceipt
		И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд

Сценарий: _0205010 добавление тестовой команды в список документов Sales return order
	* Открытие регистра команд
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение данных для тестовой команды для Sales return order
		* Создание метаданного для Sales return order и его выбор для команды
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице  "List" я перехожу на один уровень вниз
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'SalesReturnOrder'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'SalesReturnOrder'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
	* Сохранение команды
		И я нажимаю на кнопку 'Save and close'
	* Проверка сохранения команды
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'External data proc' |
		| 'SalesReturnOrder'             | 'Test command'       |
	* Проверка вызова команды из списка документов SalesReturnOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд


Сценарий: _0205011 добавление тестовой команды в список документов Purchase return order
	* Открытие регистра команд
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение данных для тестовой команды для Purchase return order
		* Создание метаданного для Purchase return order и его выбор для команды
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице  "List" я перехожу на один уровень вниз
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'PurchaseReturnOrder'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'PurchaseReturnOrder'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
	* Сохранение команды
		И я нажимаю на кнопку 'Save and close'
	* Проверка сохранения команды
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'External data proc' |
		| 'PurchaseReturnOrder'             | 'Test command'       |
	* Проверка вызова команды из списка документов PurchaseReturnOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд

Сценарий: _0205012 добавление тестовой команды в список документов ReconciliationStatement
	* Открытие регистра команд
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение данных для тестовой команды для ReconciliationStatement
		* Создание метаданного для ReconciliationStatement и его выбор для команды
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице  "List" я перехожу на один уровень вниз
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'ReconciliationStatement'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'ReconciliationStatement'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
	* Сохранение команды
		И я нажимаю на кнопку 'Save and close'
	* Проверка сохранения команды
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'External data proc' |
		| 'ReconciliationStatement'                | 'Test command'       |
	* Проверка вызова команды из списка документов ReconciliationStatement
		И я открываю навигационную ссылку 'e1cib/list/Document.ReconciliationStatement'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд

Сценарий: _010017 проверка работы команды открытия контактной информации в списке клиентов
	* Открытие справочника Partners и выбор нужного партнера
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso' |
		И я нажимаю на кнопку 'IDInfo'
	* Проверка отображения контактной информации
		Тогда таблица "IDInfo" содержит строки:
			| 'Type'                       |
			| 'Location address (Partner)' |
			| 'GPS Ukraine'                |
			| 'Partner phone'              |
	И Я закрыл все окна клиентского приложения


Сценарий: _010018 проверка редактирования контактной информации из формы EditIDInfo
	* Открытие справочника Partners и выбор нужного партнера
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso' |
		И я нажимаю на кнопку 'IDInfo'
	* Редактирование контактной информации
		И в таблице "IDInfo" в поле 'Value' я ввожу текст 'Odessa, Bunina, 2, №33'
		И в таблице "IDInfo" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
	* Проверка сохранения измененной контактной информации
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Contact information"
		И     элемент формы с именем "_Adr_1" стал равен 'Odessa, Bunina, 2, №33'
	И Я закрыл все окна клиентского приложения



Сценарий: _010019 проверка работы команды открытия списка номенклатуры из Item type
	* Открытие справочника Item type и выбор нужного элемента
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ItemTypes'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shoes' |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Items'
	* Проверка фильтра по товарам
		Тогда таблица "List" содержит строки:
		| 'Description'| 'Item type' |
		| 'Boots'      | 'Shoes'     |
		| 'High shoes' | 'Shoes'     |
		Тогда таблица "List" не содержит строки:
		| 'Description'   | 'Item type' |
		| 'Dress'         | 'Shoes'     |
	И Я закрыл все окна клиентского приложения



Сценарий: _010020 проверка работы обработки QuantityCompare (сравнение плана/факта в Goods reciept)
	* Создание Goods reciept на основании PI 3900
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '3 900' |
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
	* Проверка заполнения GoodsReceipt
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Quantity' | 'Currency' | 'Item key' | 'Store'    | 'Unit' | 'Receipt basis'           |
			| 'Dress' | '8,000'    | 'TRY'      | 'L/Green'  | 'Store 02' | 'pcs'  | 'Purchase invoice 3 900*' |
			| 'Boots' | '15,000'   | 'TRY'      | '37/18SD'  | 'Store 02' | 'pcs'  | 'Purchase invoice 3 900*' |
	* Открытие формы сравнения
		И я нажимаю на кнопку 'Compare quantity'
	* Проверка добавления товара по поиску штрих-кода 
		И в таблице "PhysItemList" я нажимаю на кнопку с именем 'PhysItemListSearchByBarcode'
		И в поле 'InputFld' я ввожу текст '978020137962'
		И я нажимаю на кнопку 'OK'
		И в таблице "PhysItemList" я нажимаю на кнопку с именем 'PhysItemListSearchByBarcode'
		И в поле 'InputFld' я ввожу текст '978020137962'
		И я нажимаю на кнопку 'OK'
		И в таблице "PhysItemList" я нажимаю на кнопку с именем 'PhysItemListSearchByBarcode'
		И в поле 'InputFld' я ввожу текст '2202283739'
		И я нажимаю на кнопку 'OK'
		И в таблице "PhysItemList" я нажимаю на кнопку с именем 'PhysItemListSearchByBarcode'
		И в поле 'InputFld' я ввожу текст '2202283739'
		И я нажимаю на кнопку 'OK'
		И в таблице "PhysItemList" я нажимаю на кнопку с именем 'PhysItemListSearchByBarcode'
		И в поле 'InputFld' я ввожу текст '2202283739'
		И я нажимаю на кнопку 'OK'
		Тогда таблица "PhysItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Unit' | 'Q'     |
			| 'Boots' | '37/18SD'  | 'pcs'  | '2,000' |
			| 'Dress' | 'L/Green'  | 'pcs'  | '3,000' |
	* Добавление товара вручную через кнопку Add
		И в таблице "PhysItemList" я нажимаю на кнопку с именем 'PhysItemListAdd'
		И в таблице "PhysItemList" я нажимаю кнопку выбора у реквизита с именем "PhysItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PhysItemList" я нажимаю кнопку выбора у реквизита с именем "PhysItemListItemKey"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		И в таблице "List" я выбираю текущую строку
		# временно
		И в таблице "PhysItemList" я нажимаю кнопку выбора у реквизита с именем "PhysItemListUnit"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'pcs'         |
		И в таблице "List" я выбираю текущую строку
		# временно
		И в таблице "PhysItemList" я активизирую поле с именем "PhysItemListCount"
		И в таблице "PhysItemList" в поле с именем 'PhysItemListCount' я ввожу текст '1,000'
		Тогда таблица "PhysItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Unit' | 'Q'     |
			| 'Boots' | '37/18SD'  | 'pcs'  | '2,000' |
			| 'Dress' | 'L/Green'  | 'pcs'  | '3,000' |
			| 'Boots' | '38/18SD'  | 'pcs'  | '1,000' |
	* Добавление товара через кнопку Pick up
		И в таблице "PhysItemList" я нажимаю на кнопку с именем 'PhysItemListOpenPickupItems'
		И в таблице "ItemList" я перехожу к строке:
			| Title |
			| Dress |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemKeyList" я перехожу к строке:
			| Title   |
			| L/Green |
		И в таблице "ItemKeyList" я выбираю текущую строку
		И в таблице "ItemTableValue" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green' |
		И в таблице "ItemTableValue" я выбираю текущую строку
		И в таблице "ItemTableValue" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'FormCommandSaveAndClose'
		Тогда таблица "PhysItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Unit' | 'Q'     |
			| 'Boots' | '37/18SD'  | 'pcs'  | '2,000' |
			| 'Dress' | 'L/Green'  | 'pcs'  | '4,000' |
			| 'Boots' | '38/18SD'  | 'pcs'  | '1,000' |
	* Сверка разницы
		И в таблице "PhysItemList" я нажимаю на кнопку с именем 'PhysItemListSwitchItemLists'
		Тогда в таблице "CompareItemList" количество строк "меньше или равно" 3
		Тогда таблица "CompareItemList" стала равной:
			| 'Item'  | 'Quantity' | 'Difference' | 'Item key' | 'Unit' | 'Count' |
			| 'Dress' | '8,000'    | '-4,000'     | 'L/Green'  | 'pcs'  | '4,000' |
			| 'Boots' | '15,000'   | '-13,000'    | '37/18SD'  | 'pcs'  | '2,000' |
			| 'Boots' | ''         | '1,000'      | '38/18SD'  | 'pcs'  | '1,000' |
	* Проверка изменения количества вручную на вкладке сканирования
		И в таблице "CompareItemList" я нажимаю на кнопку с именем 'CompareItemListSwitchItemLists'
		И в таблице "PhysItemList" я активизирую поле с именем "PhysItemListCount"
		И в таблице "PhysItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Q'     | 'Unit' |
			| 'Dress' | 'L/Green'  | '4,000' | 'pcs'  |
		И в таблице "PhysItemList" я выбираю текущую строку
		И в таблице "PhysItemList" в поле с именем "PhysItemListCount" я ввожу текст '5,000'
		И в таблице "PhysItemList" я завершаю редактирование строки
		Тогда таблица "PhysItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Unit' | 'Q'     |
			| 'Boots' | '37/18SD'  | 'pcs'  | '2,000' |
			| 'Dress' | 'L/Green'  | 'pcs'  | '5,000' |
	* Проверка изменения количества вручную на вкладке сравнения
		И в таблице "PhysItemList" я нажимаю на кнопку с именем 'PhysItemListSwitchItemLists'
		Тогда таблица "CompareItemList" содержит строки:
			| 'Item'  | 'Quantity' | 'Difference' | 'Item key' | 'Unit' | 'Count' |
			| 'Dress' | '8,000'    | '-3,000'     | 'L/Green'  | 'pcs'  | '5,000' |
			| 'Boots' | '15,000'   | '-13,000'    | '37/18SD'  | 'pcs'  | '2,000' |
			| 'Boots' | ''         | '1,000'      | '38/18SD'  | 'pcs'  | '1,000' |
		И в таблице "CompareItemList" я перехожу к строке:
			| 'Count' | 'Difference' | 'Item'  | 'Item key' | 'Quantity' | 'Unit' |
			| '2,000' | '-13,000'    | 'Boots' | '37/18SD'  | '15,000'   | 'pcs'  |
		И в таблице "CompareItemList" я выбираю текущую строку
		И в таблице "CompareItemList" в поле 'Count' я ввожу текст '3,000'
		И в таблице "CompareItemList" я завершаю редактирование строки
		Тогда таблица "CompareItemList" содержит строки:
			| 'Item'  | 'Quantity' | 'Difference' | 'Item key' | 'Unit' | 'Count' |
			| 'Dress' | '8,000'    | '-3,000'     | 'L/Green'  | 'pcs'  | '5,000' |
			| 'Boots' | '15,000'   | '-12,000'    | '37/18SD'  | 'pcs'  | '3,000' |
			| 'Boots' | ''         | '1,000'      | '38/18SD'  | 'pcs'  | '1,000' |
	* Удаление строк на вкладке сканирования
		И в таблице "CompareItemList" я нажимаю на кнопку с именем 'CompareItemListSwitchItemLists'
		И в таблице "PhysItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Q'     | 'Unit' |
			| 'Dress' | 'L/Green'  | '5,000' | 'pcs'  |
		И в таблице "PhysItemList" я нажимаю на кнопку с именем 'PhysItemListDelete'
		Тогда в таблице "PhysItemList" количество строк "меньше или равно" 2
	* Добавление товаров путем сканирования на вкладке "CompareItemList"
		И в таблице "PhysItemList" я нажимаю на кнопку с именем 'PhysItemListSwitchItemLists'
		И в таблице "CompareItemList" я нажимаю на кнопку с именем 'CompareItemListSearchByBarcode'
		И в поле 'InputFld' я ввожу текст '978020137962'
		И я нажимаю на кнопку 'OK'
		Тогда таблица "CompareItemList" содержит строки:
			| 'Item'  | 'Quantity' | 'Difference' | 'Item key' | 'Unit' | 'Count' |
			| 'Boots' | '15,000'   | '-11,000'    | '37/18SD'  | 'pcs'  | '4,000' |
			| 'Boots' | ''         | '1,000'      | '38/18SD'  | 'pcs'  | '1,000' |
		Тогда в таблице "CompareItemList" количество строк "меньше или равно" 2
	* Добавление товара на вкладке "CompareItemList" через кнопку Add
		И в таблице "CompareItemList" я нажимаю на кнопку с именем 'CompareItemListAdd'
		И в таблице "CompareItemList" я нажимаю кнопку выбора у реквизита с именем "CompareItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "CompareItemList" я активизирую поле с именем "CompareItemListItemKey"
		И в таблице "CompareItemList" я нажимаю кнопку выбора у реквизита с именем "CompareItemListItemKey"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Shirt' | '38/Black' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "CompareItemList" я активизирую поле с именем "CompareItemListUnit"
		И в таблице "CompareItemList" я нажимаю кнопку выбора у реквизита с именем "CompareItemListUnit"
		И в таблице "List" я выбираю текущую строку
		И в таблице "CompareItemList" я активизирую поле "Count"
		И в таблице "CompareItemList" в поле 'Count' я ввожу текст '1,000'
		И в таблице "CompareItemList" я завершаю редактирование строки
		Тогда таблица "CompareItemList" содержит строки:
			| 'Item'  | 'Quantity' | 'Difference' | 'Item key' | 'Unit' | 'Count' |
			| 'Boots' | '15,000'   | '-11,000'    | '37/18SD'  | 'pcs'  | '4,000' |
			| 'Boots' | ''         | '1,000'      | '38/18SD'  | 'pcs'  | '1,000' |
			| 'Shirt' | ''         | '1,000'      | '38/Black' | 'pcs'  | '1,000' |
		Тогда в таблице "CompareItemList" количество строк "меньше или равно" 3
	* Добавление товара на вкладке "CompareItemList" через кнопку Pick up
		И в таблице "CompareItemList" я нажимаю на кнопку с именем 'CompareItemListOpenPickupItems'
		И в таблице "ItemList" я перехожу к строке:
			| 'Title' |
			| 'Shirt' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemKeyList" я перехожу к строке:
			| 'Title'  | 'Unit' |
			| '36/Red' | 'pcs'  |
		И в таблице "ItemKeyList" я выбираю текущую строку
		И я нажимаю на кнопку 'Transfer to document'
		Тогда таблица "CompareItemList" содержит строки:
			| 'Item'  | 'Quantity' | 'Difference' | 'Item key' | 'Unit' | 'Count' |
			| 'Boots' | '15,000'   | '-11,000'    | '37/18SD'  | 'pcs'  | '4,000' |
			| 'Boots' | ''         | '1,000'      | '38/18SD'  | 'pcs'  | '1,000' |
			| 'Shirt' | ''         | '1,000'      | '38/Black' | 'pcs'  | '1,000' |
			| 'Shirt' | ''         | '1,000'      | '36/Red'   | 'pcs'  | '1,000' |
		Тогда в таблице "CompareItemList" количество строк "меньше или равно" 4
	* Сворачивание табличной части с данными по документам-основаниям
		И     таблица "ExpItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Base on'                 | 'Unit' | 'Q'      |
			| 'Dress' | 'L/Green'  | 'Purchase invoice 3 900*' | 'pcs'  | '8,000'  |
			| 'Boots' | '37/18SD'  | 'Purchase invoice 3 900*' | 'pcs'  | '15,000' |
		* Проверка сворачивания таблицы "ExpItemList"
			И я нажимаю на кнопку 'Show hide exp. item list'
			Когда Проверяю шаги на Исключение:
			|'Тогда в таблице "ExpItemList" я выделяю все строки'|
		* Проверка разворачивания таблицы "ExpItemList"
			И я нажимаю на кнопку 'Show hide exp. item list'
			И     таблица "ExpItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Base on'                 | 'Unit' | 'Q'      |
			| 'Dress' | 'L/Green'  | 'Purchase invoice 3 900*' | 'pcs'  | '8,000'  |
			| 'Boots' | '37/18SD'  | 'Purchase invoice 3 900*' | 'pcs'  | '15,000' |
	* Проверка переноса заполненных товаров в Goods reciept
		И в таблице "PhysItemList" я нажимаю на кнопку с именем 'PhysItemListSwitchItemLists'
		Тогда таблица "CompareItemList" содержит строки:
			| 'Item'  | 'Quantity' | 'Difference' | 'Item key' | 'Unit' | 'Count' |
			| 'Boots' | '15,000'   | '-12,000'    | '37/18SD'  | 'pcs'  | '3,000' |
			| 'Boots' | ''         | '1,000'      | '38/18SD'  | 'pcs'  | '1,000' |
		И я нажимаю на кнопку 'Transfer to document'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Quantity' | 'Item key' | 'Store'    | 'Unit' | 'Receipt basis'                    |
			| 'Boots' | '3,000'    | '37/18SD'  | 'Store 02' | 'pcs'  | 'Purchase invoice 3 900*'          |
			| 'Boots' | '1,000'    | '38/18SD'  | 'Store 02' | 'pcs'  | ''                                 |
		И Я закрыл все окна клиентского приложения