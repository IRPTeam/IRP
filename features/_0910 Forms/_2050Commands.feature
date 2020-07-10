#language: ru
@tree
@Positive


Функционал: check the addition of commands to documents and document lists



Контекст: 
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.

	
Сценарий: _0205001 preparation
	* Add test plugin
		* Open form to add plugin
			И я открываю навигационную ссылку 'e1cib/list/Catalog.ExternalDataProc'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling plugin data and adding it to the database
			И я буду выбирать внешний файл "#workingDir#\DataProcessor\CheckExternalCommands.epf"
			И я нажимаю на кнопку с именем "FormAddExtDataProc"
			И в поле 'Path to plugin for test' я ввожу текст ''
			И в поле 'Name' я ввожу текст 'PrintFormSalesOrder'
			И я нажимаю на кнопку открытия поля с именем "Description_en"
			И в поле 'ENG' я ввожу текст 'Test command'
			И в поле 'TR' я ввожу текст 'Test command tr'
			И я нажимаю на кнопку 'Ok'
			И я нажимаю на кнопку 'Save and close'
			И Пауза 5
		* Check the addition of plugin
			Тогда я проверяю наличие элемента справочника "ExternalDataProc" со значением поля "Description_en" "Test command"
	* Add test Purchase invoice
			И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
			И я нажимаю на кнопку с именем 'FormCreate'
			* Filling the document header
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
				И я нажимаю кнопку выбора у поля "Partner term"
				И в таблице "List" я перехожу к строке:
					| 'Description'  |
					| 'Vendor Ferron, TRY' |
				И в таблице "List" я выбираю текущую строку
				И я нажимаю кнопку выбора у поля "Store"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Store 02'    |
				И в таблице "List" я выбираю текущую строку
			* Filling in the tabular part
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
			* Change the document number
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '3 900'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '3 900'
			* Post and check saving
				И я нажимаю на кнопку 'Post and close'
				И таблица "List" содержит строки:
					| 'Number' |
					| '3 900'       |

Сценарий: _0205002 add test command to the list of documents Sales return
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Sales return
		* Create metadata for Sales return and select it for the command
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
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'  | 'Plugins' |
		| 'SalesReturn'             | 'Test command'       |
	* Check the command from the document list Sales Return
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'SalesReturn' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'SalesReturn' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205003 add test command to the list of documents Sales invoice
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Sales invoice
		* Create metadata for Sales invoice and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
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
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'  | 'Plugins' |
		| 'SalesInvoice'             | 'Test command'       |
	* Check the command from the document list Sales Invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'SalesInvoice' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'SalesInvoice' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205004 add test command to the list of documents Purchase order
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Purchase order
		* Create metadata for Purchase order and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
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
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'  | 'Plugins' |
		| 'PurchaseOrder'             | 'Test command'       |
	* Check the command from the document list Purchase order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'PurchaseOrder' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'PurchaseOrder' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205005 add test command to the list of documents Sales order
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Sales order
		* Create metadata for sales order and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
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
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'  | 'Plugins' |
		| 'SalesOrder'             | 'Test command'       |
	* Check the command from the document list SalesOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'SalesOrder' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'SalesOrder' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205006 add test command to the list of documents Purchase invoice
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Purchase invoice
		* Create metadata for Purchase invoice and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
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
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'  | 'Plugins' |
		| 'PurchaseInvoice'             | 'Test command'       |
	* Check the command from the document list PurchaseInvoice
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'PurchaseInvoice' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'PurchaseInvoice' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения


Сценарий: _0205007 add test command to the list of documents Cash transfer order
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Cash transfer order
		* Create metadata for Cash transfer order and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
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
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'  | 'Plugins' |
		| 'CashTransferOrder'             | 'Test command'       |
	* Check the command from the document list CashTransferOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.CashTransferOrder'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'CashTransferOrder' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.CashTransferOrder'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'CashTransferOrder' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения


Сценарий: _0205008 add test command to the list of documents Shipment confirmation
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Shipment confirmation
		* Create metadata for Shipment confirmation and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
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
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'           | 'Plugins' |
		| 'ShipmentConfirmation'             | 'Test command'       |
	* Check the command from the document list CashTransferOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'ShipmentConfirmation' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'ShipmentConfirmation' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения


Сценарий: _0205009 add test command to the list of documents Goods receipt
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Goods receipt
		* Create metadata for Goods receipt and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
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
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'           | 'Plugins' |
		| 'GoodsReceipt'             | 'Test command'       |
	* Check the command from the document list GoodsReceipt
		И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'GoodsReceipt' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'GoodsReceipt' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205010 add test command to the list of documents Sales return order
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Sales return order
		* Create metadata for Sales return order and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
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
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'SalesReturnOrder'             | 'Test command'       |
	* Check the command from the document list SalesReturnOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'SalesReturnOrder' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'SalesReturnOrder' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения


Сценарий: _0205011 add test command to the list of documents Purchase return order
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Purchase return order
		* Create metadata for Purchase return order and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
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
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'PurchaseReturnOrder'             | 'Test command'       |
	* Check the command from the document list PurchaseReturnOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'PurchaseReturnOrder' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'PurchaseReturnOrder' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205012 add test command to the list of documents ReconciliationStatement
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Reconciliation statement
		* Create metadata for ReconciliationStatement and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
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
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'ReconciliationStatement'                | 'Test command'       |
	* Check the command from the document list ReconciliationStatement
		И я открываю навигационную ссылку 'e1cib/list/Document.ReconciliationStatement'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'ReconciliationStatement' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.ReconciliationStatement'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'ReconciliationStatement' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения


Сценарий: _0205013 add test command to the list of documents BankPayment
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Bank payment
		* Create metadata for BankPayment and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'BankPayment'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'BankPayment'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'BankPayment'                | 'Test command'       |
	* Check the command from the document list Bank payment
		И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'BankPayment' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'BankPayment' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205014 add test command to the list of documents BankReceipt
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Bank receipt
		* Create metadata for BankReceipt and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'BankReceipt'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'BankReceipt'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'BankReceipt'                | 'Test command'       |
	* Check the command from the document list BankReceipt
		И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'BankReceipt' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'BankReceipt' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения


Сценарий: _0205016 add test command to the list of documents Bundling
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Bundling
		* Create metadata for Bundling and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'Bundling'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Bundling'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'Bundling'                | 'Test command'       |
	* Check the command from the document list Bundling
		И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Bundling' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Bundling' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205017 add test command to the list of documents CashExpense
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for CashExpense
		* Create metadata for CashExpense and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'CashExpense'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'CashExpense'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'CashExpense'                | 'Test command'       |
	* Check the command from the document list CashExpense
		И я открываю навигационную ссылку 'e1cib/list/Document.CashExpense'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'CashExpense' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.CashExpense'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'CashExpense' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения


Сценарий: _0205018 add test command to the list of documents CashPayment
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Cash payment
		* Create metadata for CashPayment and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'CashPayment'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'CashPayment'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'CashPayment'                | 'Test command'       |
	* Check the command from the document list CashPayment
		И я открываю навигационную ссылку 'e1cib/list/Document.CashPayment'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'CashPayment' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.CashPayment'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'CashPayment' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205019 add test command to the list of documents Cash Receipt
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Cash Receipt
		* Create metadata for CashReceipt and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'CashReceipt'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'CashReceipt'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'CashReceipt'                | 'Test command'       |
	* Check the command from the document list CashReceipt
		И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'CashReceipt' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'CashReceipt' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205020 add test command to the list of documents Cash Revenue
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for CashRevenue
		* Create metadata for CashRevenue and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'CashRevenue'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'CashRevenue'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'CashRevenue'                | 'Test command'       |
	* Check the command from the document list CashRevenue
		И я открываю навигационную ссылку 'e1cib/list/Document.CashRevenue'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'CashRevenue' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.CashRevenue'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'CashRevenue' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205021 add test command to the list of documents Cash transfer order
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Cash transfer order
		* Create metadata for CashTransferOrder and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
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
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'CashTransferOrder'                | 'Test command'       |
	* Check the command from the document list CashTransferOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.CashTransferOrder'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'CashTransferOrder' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.CashTransferOrder'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'CashTransferOrder' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения


Сценарий: _0205022 add test command to the list of documents Cheque bond transaction
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Cheque bond transaction
		* Create metadata for Cheque bond transaction and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'ChequeBondTransaction'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'ChequeBondTransaction'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'ChequeBondTransaction'                | 'Test command'       |
	* Check the command from the document list ChequeBondTransaction
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'ChequeBondTransaction' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'ChequeBondTransaction' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения



Сценарий: _0205023 add test command to the list of documents Credit Debit Note
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Credit Debit Note
		* Create metadata for CreditDebitNote and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'CreditDebitNote'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'CreditDebitNote'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'CreditDebitNote'                | 'Test command'       |
	* Check the command from the document list CreditDebitNote
		И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'CreditDebitNote' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'CreditDebitNote' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения


Сценарий: _0205024 add test command to the list of documents Incoming Payment Order
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for IncomingPaymentOrder
		* Create metadata for IncomingPaymentOrder and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'IncomingPaymentOrder'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'IncomingPaymentOrder'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'IncomingPaymentOrder'                | 'Test command'       |
	* Check the command from the document list IncomingPaymentOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.IncomingPaymentOrder'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'IncomingPaymentOrder' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.IncomingPaymentOrder'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'IncomingPaymentOrder' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205025 add test command to the list of documents Internal Supply Request
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for InternalSupplyRequest
		* Create metadata for InternalSupplyRequest and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'InternalSupplyRequest'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'InternalSupplyRequest'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'InternalSupplyRequest'                | 'Test command'       |
	* Check the command from the document list InternalSupplyRequest
		И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'InternalSupplyRequest' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'InternalSupplyRequest' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205026 add test command to the list of documents Inventory Transfer
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Inventory Transfer
		* Create metadata for Inventory Transfer and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'InventoryTransfer'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'InventoryTransfer'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'InventoryTransfer'                | 'Test command'       |
	* Check the command from the document list InventoryTransfer
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'InventoryTransfer' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'InventoryTransfer' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205027 add test command to the list of documents Inventory Transfer Order
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for InventoryTransferOrder
		* Create metadata for InventoryTransferOrder and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'InventoryTransferOrder'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'InventoryTransferOrder'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'InventoryTransferOrder'                | 'Test command'       |
	* Check the command from the document list InventoryTransferOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'InventoryTransferOrder' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'InventoryTransferOrder' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205028 add test command to the list of documents Invoice Match
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Invoice Match
		* Create metadata for InvoiceMatch and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'InvoiceMatch'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'InvoiceMatch'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'InvoiceMatch'                | 'Test command'       |
	* Check the command from the document list InvoiceMatch
		И я открываю навигационную ссылку 'e1cib/list/Document.InvoiceMatch'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'InvoiceMatch' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.InvoiceMatch'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'InvoiceMatch' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205029 add test command to the list of documents Labeling
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Labeling
		* Create metadata for Labeling and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'Labeling'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Labeling'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'Labeling'                | 'Test command'       |
	* Check the command from the document list Labeling
		И я открываю навигационную ссылку 'e1cib/list/Document.Labeling'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Labeling' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.Labeling'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Labeling' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205030 add test command to the list of documents Opening Entry
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for OpeningEntry
		* Create metadata for OpeningEntry and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'OpeningEntry'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'OpeningEntry'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'OpeningEntry'                | 'Test command'       |
	* Check the command from the document list OpeningEntry
		И я открываю навигационную ссылку 'e1cib/list/Document.OpeningEntry'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'OpeningEntry' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.OpeningEntry'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'OpeningEntry' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения


Сценарий: _0205031 add test command to the list of documents Outgoing Payment Order
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for OutgoingPaymentOrder
		* Create metadata for OutgoingPaymentOrder and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'OutgoingPaymentOrder'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'OutgoingPaymentOrder'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'OutgoingPaymentOrder'                | 'Test command'       |
	* Check the command from the document list OutgoingPaymentOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.OutgoingPaymentOrder'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'OutgoingPaymentOrder' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.OutgoingPaymentOrder'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'OutgoingPaymentOrder' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205032 add test command to the list of documents Physical Count By Location
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Physical Count By Location
		* Create metadata for Physical Count By Location and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'PhysicalCountByLocation'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'PhysicalCountByLocation'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'PhysicalCountByLocation'                | 'Test command'       |
	* Check the command from the document list PhysicalCountByLocation
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalCountByLocation'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'PhysicalCountByLocation' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalCountByLocation'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'PhysicalCountByLocation' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205033 add test command to the list of documents Price List
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Price List
		* Create metadata for PriceList and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'PriceList'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'PriceList'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'PriceList'                | 'Test command'       |
	* Check the command from the document list PriceList
		И я открываю навигационную ссылку 'e1cib/list/Document.PriceList'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'PriceList' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.PriceList'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'PriceList' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения



Сценарий: _0205035 add test command to the list of documents PurchaseReturn
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for PurchaseReturn
		* Create metadata for PurchaseReturn and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'PurchaseReturn'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'PurchaseReturn'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'PurchaseReturn'                | 'Test command'       |
	* Check the command from the document list PurchaseReturn
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'PurchaseReturn' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'PurchaseReturn' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения



Сценарий: _0205037 add test command to the list of documents Unbundling
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Unbundling
		* Create metadata for Unbundling and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'Unbundling'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Unbundling'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'Unbundling'                | 'Test command'       |
	* Check the command from the document list Unbundling
		И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Unbundling' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Unbundling' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205038 add test command to the list of documents Stock Adjustment As Write Off
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for StockAdjustmentAsWriteOff
		* Create metadata for StockAdjustmentAsWriteOff and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'StockAdjustmentAsWriteOff'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'StockAdjustmentAsWriteOff'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'StockAdjustmentAsWriteOff'                | 'Test command'       |
	* Check the command from the document list StockAdjustmentAsWriteOff
		И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsWriteOff'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'StockAdjustmentAsWriteOff' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsWriteOff'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'StockAdjustmentAsWriteOff' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205039 add test command to the list of documents Stock Adjustment As Surplus
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Stock Adjustment As Surplus
		* Create metadata for Stock Adjustment As Surplus and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'StockAdjustmentAsSurplus'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'StockAdjustmentAsSurplus'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'StockAdjustmentAsSurplus'                | 'Test command'       |
	* Check the command from the document list StockAdjustmentAsSurplus
		И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsSurplus'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'StockAdjustmentAsSurplus' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is not displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsSurplus'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'StockAdjustmentAsSurplus' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения

Сценарий: _0205040 add test command to the list of documents Physical Inventory
	* Open Command register
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling test command data for Physical Inventory
		* Create metadata for Physical Inventory and select it for the command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'Description' я ввожу текст 'PhysicalInventory'
			И я нажимаю кнопку выбора у поля "Parent"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Documents'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'PhysicalInventory'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			Тогда открылось окно 'Plugins'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'List form'
	* Save command
		И я нажимаю на кнопку 'Save and close'
	* Check command save
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
		Тогда таблица "List" содержит строки:
		| 'Configuration metadata'       | 'Plugins' |
		| 'PhysicalInventory'                | 'Test command'       |
	* Check the command from the document list PhysicalInventory
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
		И в таблице "List" я перехожу к последней строке
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
	* Check that the command is not displayed in the document
		И я нажимаю на кнопку 'Create'
		Когда Проверяю шаги на Исключение:
			|'И я нажимаю на кнопку "Test command"'|
		И Я закрыл все окна клиентского приложения
	* Connect a command to a document form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'PhysicalInventory' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Object form'
			И я нажимаю на кнопку 'Save and close'
	* Check that the command is displayed in the document
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
		И я нажимаю на кнопку 'Create'
		И я нажимаю на кнопку 'Test command'
		Затем я жду, что в сообщениях пользователю будет подстрока "Success client" в течение 10 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока "Success server" в течение 10 секунд
		И Я закрыл все окна клиентского приложения
	* Connect the command to the document selection form
		* Open Command register
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ExternalCommands'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in command
			И я нажимаю кнопку выбора у поля "Configuration metadata"
			И я нажимаю на кнопку 'List'
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'PhysicalInventory' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Plugins"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Test command' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Form type" я выбираю точное значение 'Choice form'
			И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения


Сценарий: _010017 command opening contact information in the partner list
	* Open catalog Partners and select partner
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso' |
		И я нажимаю на кнопку 'Contact info'
	* Check the display of contact information
		Тогда таблица "IDInfo" содержит строки:
			| 'Type'                       |
			| 'Location address (Partner)' |
			| 'GPS Ukraine'                |
			| 'Partner phone'              |
	И Я закрыл все окна клиентского приложения


Сценарий: _010018 check edit contact information from the Edit contact info form
	* Open catalog Partners and select partner
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso' |
		И я нажимаю на кнопку 'Contact info'
	* Edit contact info
		И в таблице "IDInfo" в поле 'Value' я ввожу текст 'Odessa, Bunina, 2, №33'
		И в таблице "IDInfo" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
	* Check saving of changed contact information
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Contact information"
		И     элемент формы с именем "_Adr_1" стал равен 'Odessa, Bunina, 2, №33'
	И Я закрыл все окна клиентского приложения



Сценарий: _010019 check the operation of the command to open an item list from Item type
	* Open catalog Item type
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ItemTypes'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shoes' |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Items'
	* Filter check by items
		Тогда таблица "List" содержит строки:
		| 'Description'| 'Item type' |
		| 'Boots'      | 'Shoes'     |
		| 'High shoes' | 'Shoes'     |
		Тогда таблица "List" не содержит строки:
		| 'Description'   | 'Item type' |
		| 'Dress'         | 'Shoes'     |
	И Я закрыл все окна клиентского приложения



Сценарий: _010020 check the operation of Quantity Compare plugin (comparison of the plan / fact in Goods reciept)
	* Create Goods reciept based on PI 3900
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '3 900' |
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
	* Check filling in Goods Receipt
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Quantity' | 'Currency' | 'Item key' | 'Store'    | 'Unit' | 'Receipt basis'           |
			| 'Dress' | '8,000'    | 'TRY'      | 'L/Green'  | 'Store 02' | 'pcs'  | 'Purchase invoice 3 900*' |
			| 'Boots' | '15,000'   | 'TRY'      | '37/18SD'  | 'Store 02' | 'pcs'  | 'Purchase invoice 3 900*' |
	* Open Quantity Compare
		И я нажимаю на кнопку 'Compare quantity'
	* Check of adding goods by barcode search
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
	* Add items manually via the Add button
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
		# temporarily
		И в таблице "PhysItemList" я нажимаю кнопку выбора у реквизита с именем "PhysItemListUnit"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'pcs'         |
		И в таблице "List" я выбираю текущую строку
		# temporarily
		И в таблице "PhysItemList" я активизирую поле с именем "PhysItemListCount"
		И в таблице "PhysItemList" в поле с именем 'PhysItemListCount' я ввожу текст '1,000'
		Тогда таблица "PhysItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Unit' | 'Q'     |
			| 'Boots' | '37/18SD'  | 'pcs'  | '2,000' |
			| 'Dress' | 'L/Green'  | 'pcs'  | '3,000' |
			| 'Boots' | '38/18SD'  | 'pcs'  | '1,000' |
	* Add items via the Pick up button
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
	* Difference reconciliation
		И в таблице "PhysItemList" я нажимаю на кнопку с именем 'PhysItemListSwitchItemLists'
		Тогда в таблице "CompareItemList" количество строк "меньше или равно" 3
		Тогда таблица "CompareItemList" стала равной:
			| 'Item'  | 'Quantity' | 'Difference' | 'Item key' | 'Unit' | 'Count' |
			| 'Dress' | '8,000'    | '-4,000'     | 'L/Green'  | 'pcs'  | '4,000' |
			| 'Boots' | '15,000'   | '-13,000'    | '37/18SD'  | 'pcs'  | '2,000' |
			| 'Boots' | ''         | '1,000'      | '38/18SD'  | 'pcs'  | '1,000' |
	* Check quantity changes manually on the scan tab
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
	* Check quantity changes manually on the comparison tab
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
	* Delete lines in scan tab
		И в таблице "CompareItemList" я нажимаю на кнопку с именем 'CompareItemListSwitchItemLists'
		И в таблице "PhysItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Q'     | 'Unit' |
			| 'Dress' | 'L/Green'  | '5,000' | 'pcs'  |
		И в таблице "PhysItemList" я нажимаю на кнопку с именем 'PhysItemListDelete'
		Тогда в таблице "PhysItemList" количество строк "меньше или равно" 2
	* Add items by scanning on the tab "CompareItemList"
		И в таблице "PhysItemList" я нажимаю на кнопку с именем 'PhysItemListSwitchItemLists'
		И в таблице "CompareItemList" я нажимаю на кнопку с именем 'CompareItemListSearchByBarcode'
		И в поле 'InputFld' я ввожу текст '978020137962'
		И я нажимаю на кнопку 'OK'
		Тогда таблица "CompareItemList" содержит строки:
			| 'Item'  | 'Quantity' | 'Difference' | 'Item key' | 'Unit' | 'Count' |
			| 'Boots' | '15,000'   | '-11,000'    | '37/18SD'  | 'pcs'  | '4,000' |
			| 'Boots' | ''         | '1,000'      | '38/18SD'  | 'pcs'  | '1,000' |
		Тогда в таблице "CompareItemList" количество строк "меньше или равно" 2
	* Add items to the tab "CompareItemList" through the Add button
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
	* Add items to the tab "CompareItemList" through the Pick up button
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
	* Collapse of the tabular part with data on documents-bases
		И     таблица "ExpItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Base on'                 | 'Unit' | 'Q'      |
			| 'Dress' | 'L/Green'  | 'Purchase invoice 3 900*' | 'pcs'  | '8,000'  |
			| 'Boots' | '37/18SD'  | 'Purchase invoice 3 900*' | 'pcs'  | '15,000' |
		* Check the ExpItemList table collapse 
			И я нажимаю на кнопку 'Show hide exp. item list'
			Когда Проверяю шаги на Исключение:
			|'Тогда в таблице "ExpItemList" я выделяю все строки'|
		* Check the ExpItemList table uncolapse
			И я нажимаю на кнопку 'Show hide exp. item list'
			И     таблица "ExpItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Base on'                 | 'Unit' | 'Q'      |
			| 'Dress' | 'L/Green'  | 'Purchase invoice 3 900*' | 'pcs'  | '8,000'  |
			| 'Boots' | '37/18SD'  | 'Purchase invoice 3 900*' | 'pcs'  | '15,000' |
	* Check the transfer of filled items to Goods reciept
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