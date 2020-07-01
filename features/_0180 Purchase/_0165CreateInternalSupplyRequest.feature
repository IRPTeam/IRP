#language: ru
@tree
@Positive


Функционал: creating document an Internal supply request 

As a sales manager
I want to create an Internal supply request 
For ordering items to the planning department (purchasing or transfer from the store)


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _016501 creating document Internal Supply Request
	* Opening the creation form Internal Supply Request
		И я открываю навигационную ссылку "e1cib/list/Document.InternalSupplyRequest"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the document number
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	* Filling in the main details of the document
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
	* Filling in items table
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
	* Post document
		И я нажимаю на кнопку 'Post and close'
	* Checking document creation
		Тогда таблица "List" содержит строки:
			| 'Number' | 'Company'      | 'Store'    |
			| '1'      | 'Main Company' | 'Store 01' |
		И Я закрыл все окна клиентского приложения
	* Checking posting on the document Internal Supply Request (register OrderBalance)
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'                   | 'Store'    | 'Order'                      | 'Item key'          |
			| '10,000'   | 'Internal supply request 1*' | 'Store 01' | 'Internal supply request 1*' | '36/Yellow'|
			| '25,000'   | 'Internal supply request 1*' | 'Store 01' | 'Internal supply request 1*' | '36/Red'            |
			| '20,000'   | 'Internal supply request 1*' | 'Store 01' | 'Internal supply request 1*' | '38/Black'          |
		И Я закрыл все окна клиентского приложения
	* Creating an Inventory transfer order document based on an InternalSupplyRequest document
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
	* Checking posting of an Inventory transfer order document created based on InternalSupplyRequest
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
	* Create a Purchase order based on the InternalSupplyRequest document
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
		* Filling in the document number 1
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '1'
		И я нажимаю на кнопку 'Post and close'
	* Checking posting of a Purchase order document created based on InternalSupplyRequest
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.OrderBalance"
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'            | 'Store'    | 'Order'                      | 'Item key'          |
			| '9,000'   | 'Purchase order 1*'    | 'Store 01' | 'Purchase order 1*'          | '36/Yellow' |
			| '9,000'   | 'Purchase order 1*'    | 'Store 01' | 'Internal supply request 1*' | '36/Yellow' |
		И Я закрыл все окна клиентского приложения
	


Сценарий: _016503 checking the Company filter in the Internal Supply Request document.
	* Opening the creation form Internal Supply Request
		И я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Checking the visual filter by Company
		И я нажимаю кнопку выбора у поля "Company"
		Тогда таблица "List" стала равной:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Company" стал равен 'Main Company'
	* Checking filter by Company when inpute by string
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
	


Сценарий: _016504 checking display of the title of the collapsible group when creating the document Internal Supply Request
	* Opening the creation form Internal Supply Request
		И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the document number
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '215'
	* Filling in the main details of the document
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
	* Checking display of the title of the collapsible group
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Number: 215   Company: Main Company   Store: Store 01"
		И Я закрыл все окна клиентского приложения










	



	





