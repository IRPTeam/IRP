#language: ru
@tree
@Positive

Функционал: check filling in user settings

As a developer
I want to create a system of custom settings
For ease of filling in documents


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: _200001 customize the CI user settings
	И я открываю навигационную ссылку 'e1cib/list/Catalog.Users'
	И в таблице "List" я перехожу к строке:
		| 'Login' |
		| 'CI'          |
	И в таблице "List" я выбираю текущую строку
	И в поле 'ENG' я ввожу текст 'CI'
	И в поле 'Interface localization code' я ввожу текст 'en'
	И я нажимаю на кнопку 'Save'
	И я нажимаю на кнопку 'Settings'
	* Fill in custom settings for Sales order
		И в таблице "MetadataTree" я перехожу к строке:
		| 'Group name'  |
		| 'Sales order' |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Partner term'  | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Store'      | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Use"
		И в таблице "MetadataTree" я изменяю флаг 'Use'
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
	* Fill in custom settings for Sales invoice
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'  |
			| 'Sales invoice' |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Partner term'  | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Store'      | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Use"
		И в таблице "MetadataTree" я изменяю флаг 'Use'
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
	* Fill in custom settings for Purchase order
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'  |
			| 'Purchase order' |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Store'      | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Use"
		И в таблице "MetadataTree" я изменяю флаг 'Use'
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 03'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
	* Fill in custom settings for Purchase invoice
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'  |
			| 'Purchase invoice' |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Store'      | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Use"
		И в таблице "MetadataTree" я изменяю флаг 'Use'
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
	* Fill in custom settings for Bank payment
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'   |
			| 'Bank payment' |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Account'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Currency'   | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
	* Fill in custom settings for Bank receipt
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'   |
			| 'Bank receipt' |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Account'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Bank account, USD' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Currency'   | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'USD'  | 'American dollar' |
		И в таблице "List" я выбираю текущую строку
	* Fill in custom settings for Bundling
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' |
			| 'Bundling'   |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		Тогда открылось окно 'Companies'
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Company Ferron BP' |
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Store'      | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		Тогда открылось окно 'Stores'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
	* Fill in custom settings for Cash transfer order
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'          |
			| 'Cash transfer order' |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Sender'     | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Cash desk №3' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Receiver'   | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'USD'      | 'Bank account, USD' |
		И в таблице "List" я выбираю текущую строку
	* Fill in custom settings for Invoice match
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'    |
			| 'Invoice match' |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		Тогда открылось окно 'Companies'
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Company Ferron BP' |
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Fill in custom settings for GoodsReceipt
		И в таблице "MetadataTree" я перехожу к строке:
		| 'Group name'    |
		| 'Goods receipt' |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Fill in custom settings for Purchase return
		И в таблице "MetadataTree" я перехожу к строке:
		| 'Group name'    |
		| 'Purchase return' |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
	* Fill in custom settings for Purchase return order
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'    |
			| 'Purchase return order' |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
	* Fill in custom settings for Sales return order
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'    |
			| 'Sales return order' |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
	* Fill in custom settings for Sales return
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'    |
			| 'Sales return' |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
	* Fill in custom settings for Reconciliation statement
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'    |
			| 'Reconciliation statement' |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
	* Fill in custom settings for Cash payment
		И в таблице "MetadataTree" я перехожу к строке:
		| 'Group name'   |
		| 'Cash payment' |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'   | 'Use' |
			| 'Cash account' | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Cash desk №3' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Company Ferron BP' |
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Currency'   | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		Тогда открылось окно 'Currencies'
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description' |
			| 'EUR'  | 'Euro'        |
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
	* Fill in custom settings for Cash receipt
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'   |
			| 'Cash receipt' |
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'   | 'Use' |
			| 'Cash account' | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Cash desk №3' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Currency'   | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		Тогда открылось окно 'Currencies'
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
	* Fill in custom settings for Cash expense
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'   |
			| 'Cash expense' |
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Account'    | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Cash desk №3' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
	* Fill in custom settings for Cash expense
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'   |
			| 'Cash revenue' |
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Account'    | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Cash desk №3' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
	* Fill in custom settings for Credit debit note
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'        |
			| 'Credit debit note' |
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Fill in custom settings for Incoming payment order
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'             |
			| 'Incoming payment order' |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Account'    | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Cash desk №2' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Currency'   | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я выбираю текущую строку
	* Fill in custom settings for Outgoing payment order
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'             |
			| 'Outgoing payment order' |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Account'    | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Cash desk №3' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Currency'   | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я выбираю текущую строку
	* Fill in custom settings for Inventory transfer
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'         |
			| 'Inventory transfer' |
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'   | 'Use' |
			| 'Store sender' | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'     | 'Use' |
			| 'Store receiver' | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 03'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'    | 'Use' |
			| 'Store transit' | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'               |
			| 'Inventory transfer order' |
	* Fill in custom settings for Inventory transfer order
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'               |
			| 'Inventory transfer order' |
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'   | 'Use' |
			| 'Store sender' | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'     | 'Use' |
			| 'Store receiver' | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 03'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Fill in custom settings for Shipment confirmation
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'            |
			| 'Shipment confirmation' |
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Store'      | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
	* Fill in custom settings for Unbundling
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' |
			| 'Unbundling' |
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Store'      | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 03'    |
		И в таблице "List" я выбираю текущую строку
	* Fill in custom settings for Internal supply request 
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'              |
			| 'Internal supply request' |
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' | 'Use' |
			| 'Store'      | 'No'  |
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "MetadataTree" я завершаю редактирование строки
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку 'Save and close'


Сценарий: _200002 check filling in field from custom user settings in Sales order (partner has an agreement that's specified in the settings)
	# the store is filled from the agreement, if not specified in the agreement, then from the user settings
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, TRY'
		И     элемент формы с именем "Status" стал равен 'Approved'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 01'
	* Check the filling in of fields when selecting a partner who has an agreement 'Basic Partner terms, TRY'
	# completed fields should not be cleared
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Company Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, TRY'
		И     элемент формы с именем "Status" стал равен 'Approved'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 01'
		И я закрыл все окна клиентского приложения

Сценарий: _200003 check filling in field from custom user settings in Sales order (partner does not have an agreement that is specified in the settings)
	# the store is filled from the agreement, if not specified in the agreement, then from the user settings
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, TRY'
		И     элемент формы с именем "Status" стал равен 'Approved'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 01'
	* Check the filling in of fields when selecting a partner who has an agreement 'Basic Partner terms, TRY'
	# completed fields should not be cleared
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Anna Petrova'   |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен ''
		И     элемент формы с именем "Agreement" стал равен ''
		И     элемент формы с именем "Status" стал равен 'Approved'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 01'
		И я закрыл все окна клиентского приложения


Сценарий: _200004 check filling in field from custom user settings in Bank payment
	И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Account" стал равен 'Bank account, TRY'
		И     элемент формы с именем "Currency" стал равен 'TRY'
	И я закрыл все окна клиентского приложения

Сценарий: _200005 check filling in field from custom user settings in Bank receipt
	И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Account" стал равен 'Bank account, USD'
		И     элемент формы с именем "Currency" стал равен 'USD'
	И я закрыл все окна клиентского приложения



Сценарий:  _200008 check filling in field from custom user settings in Bundling
	И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я закрыл все окна клиентского приложения


Сценарий:  _200009 check filling in field from custom user settings in Cash payment
	И я открываю навигационную ссылку 'e1cib/list/Document.CashPayment'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "CashAccount" стал равен 'Cash desk №3'
		И     элемент формы с именем "Currency" стал равен 'EUR'
	И я закрыл все окна клиентского приложения

Сценарий:  _200010 check filling in field from custom user settings in Cash receipt
	И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "CashAccount" стал равен 'Cash desk №3'
		И     элемент формы с именем "Currency" стал равен 'USD'
	И я закрыл все окна клиентского приложения

Сценарий:  _200011 check filling in field from custom user settings in Cash transfer
	И я открываю навигационную ссылку 'e1cib/list/Document.CashTransferOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Sender" стал равен 'Cash desk №3'
		И     элемент формы с именем "Receiver" стал равен 'Bank account, USD'
	И я закрыл все окна клиентского приложения

Сценарий:  _200012 check filling in field from custom user settings in Invoice match
	И я открываю навигационную ссылку 'e1cib/list/Document.InvoiceMatch'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я закрыл все окна клиентского приложения

Сценарий:  _200013 check filling in field from custom user settings in Goods receipt
	И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я закрыл все окна клиентского приложения

Сценарий:  _200014 check filling in field from custom user settings in Incoming payment order
	И я открываю навигационную ссылку 'e1cib/list/Document.IncomingPaymentOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Company" стал равен 'Second Company'
	И я закрыл все окна клиентского приложения

Сценарий:  _200015 check filling in field from custom user settings in Internal supply request
	И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	И я закрыл все окна клиентского приложения


Сценарий:  _200016 check filling in field from custom user settings in Inventory transfer
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "StoreSender" стал равен 'Store 02'
		И     элемент формы с именем "StoreReceiver" стал равен 'Store 03'
		И     элемент формы с именем "StoreTransit" стал равен 'Store 02'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я закрыл все окна клиентского приложения

Сценарий:  _200017 check filling in field from custom user settings in Inventory transfer order
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "StoreSender" стал равен 'Store 02'
		И     элемент формы с именем "StoreReceiver" стал равен 'Store 03'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я закрыл все окна клиентского приложения

Сценарий:  _200018 check filling in field from custom user settings in Outgoing payment order
	И я открываю навигационную ссылку 'e1cib/list/Document.OutgoingPaymentOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Account" стал равен 'Cash desk №3'
		И     элемент формы с именем "Currency" стал равен 'USD'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я закрыл все окна клиентского приложения

Сценарий:  _200019 check filling in field from custom user settings in Purchase invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И     элемент формы с именем "Company" стал равен 'Second Company'
	И я закрыл все окна клиентского приложения

Сценарий:  _200020 check filling in field from custom user settings in Purchase order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Store" стал равен 'Store 03'
		И     элемент формы с именем "Company" стал равен 'Second Company'
	И я закрыл все окна клиентского приложения

Сценарий:  _200021 check filling in field from custom user settings in Purchase return
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Company" стал равен 'Second Company'
	И я закрыл все окна клиентского приложения

Сценарий:  _200022 check filling in field from custom user settings in Purchase return order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Company" стал равен 'Second Company'
	И я закрыл все окна клиентского приложения

Сценарий:  _200023 check filling in field from custom user settings in Sales invoice
	# the store is filled out of the agreement, if the agreement doesn't specify, then from user settings. So is the company.
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, TRY'
		И     элемент формы с именем "Store" стал равен 'Store 01'
	И я закрыл все окна клиентского приложения

Сценарий:  _200024 check filling in field from custom user settings in Sales return
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Company" стал равен 'Second Company'
	И я закрыл все окна клиентского приложения



Сценарий:  _200026 check filling in field from custom user settings in Unbundling
	И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 03'
	И я закрыл все окна клиентского приложения

Сценарий:  _200027 check filling in field from custom user settings in Reconciliation statement
	И я открываю навигационную ссылку 'e1cib/list/Document.ReconciliationStatement'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Check that fields are filled in from user settings
		И     элемент формы с именем "Company" стал равен 'Second Company'
	И я закрыл все окна клиентского приложения


Сценарий:  _200028 create a custom display setting for entering in a row objects marked for deletion
	* Open Chart of characteristic types - Custom user settings
		И я открываю навигационную ссылку 'e1cib/list/ChartOfCharacteristicTypes.CustomUserSettings'
	* Create custom user settings
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Use object with deletion mark'
		И в поле 'Unique ID' я ввожу текст 'Use_object_with_deletion_mark'
		И я нажимаю кнопку выбора у поля "Value type"
		И в таблице "" я перехожу к строке:
			| ''        |
			| 'Boolean' |
		И я нажимаю на кнопку 'OK'
		И в таблице "RefersToObjects" я нажимаю на кнопку 'Add refers to object'
		И в таблице "MetadataObjectsTable" я перехожу к строке:
			| 'Synonym' | 'Use' |
			| 'Items'   | 'No'  |
		И в таблице "MetadataObjectsTable" я изменяю флаг 'Use'
		И в таблице "MetadataObjectsTable" я завершаю редактирование строки
		И в таблице "MetadataObjectsTable" я перехожу к строке:
			| 'Synonym'                           | 'Use' |
			| 'Additional attribute values' | 'No'  |
		И в таблице "MetadataObjectsTable" я изменяю флаг 'Use'
		И в таблице "MetadataObjectsTable" я завершаю редактирование строки
		И в таблице "MetadataObjectsTable" я перехожу к строке:
			| 'Synonym'  | 'Use' |
			| 'Partners' | 'No'  |
		И в таблице "MetadataObjectsTable" я изменяю флаг 'Use'
		И в таблице "MetadataObjectsTable" я завершаю редактирование строки
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
	* Check custom user settings
		И я открываю навигационную ссылку 'e1cib/list/ChartOfCharacteristicTypes.CustomUserSettings'
		Тогда таблица "List" содержит строки:
		| 'Description'                   |
		| 'Use object with deletion mark' |

Сценарий: _200029 filling in user settings for a user group
	* Open catalog User Groups
		И я открываю навигационную ссылку 'e1cib/list/Catalog.UserGroups'
	* Creating a new group and filling out a user preference for displaying objects marked for deletion
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Admin'
		И я нажимаю на кнопку 'Save'
		И я нажимаю на кнопку 'Settings'
	* Filling in the settings for the display of Additional attribute values ​​marked for deletion when entering by line
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'                        |
			| 'Additional attribute values' |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'                    | 'Use' |
			| 'Use object with deletion mark' | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		Тогда открылось окно 'Select data type'
		И в таблице "" я перехожу к строке:
			| ''        |
			| 'Boolean' |
		И в таблице "" я выбираю текущую строку
		И в таблице "MetadataTree" из выпадающего списка "Value" я выбираю точное значение 'No'
		И в таблице "MetadataTree" я завершаю редактирование строки
	* Fill in the settings for displaying items marked for deletion when entering by line	
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' |
			| 'Items'      |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'                    | 'Use' |
			| 'Use object with deletion mark' | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		Тогда открылось окно 'Select data type'
		И в таблице "" я перехожу к строке:
			| ''        |
			| 'Boolean' |
		И в таблице "" я выбираю текущую строку
		И в таблице "MetadataTree" из выпадающего списка "Value" я выбираю точное значение 'No'
		И в таблице "MetadataTree" я завершаю редактирование строки
	* Fill in the settings for displaying partners marked for deletion when entering by line
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name' |
			| 'Partners'   |
		И в таблице "MetadataTree" я активизирую поле "Group name"
		И в таблице "MetadataTree" я перехожу к строке:
			| 'Group name'                    | 'Use' |
			| 'Use object with deletion mark' | 'No'  |
		И в таблице "MetadataTree" я активизирую поле "Value"
		И в таблице "MetadataTree" я выбираю текущую строку
		И в таблице "MetadataTree" я нажимаю кнопку выбора у реквизита "Value"
		Тогда открылось окно 'Select data type'
		И в таблице "" я перехожу к строке:
			| ''        |
			| 'Boolean' |
		И в таблице "" я выбираю текущую строку
		И в таблице "MetadataTree" из выпадающего списка "Value" я выбираю точное значение 'No'
		И в таблице "MetadataTree" я завершаю редактирование строки
		И я нажимаю на кнопку 'Ok'
	* Saving the group
		И я нажимаю на кнопку 'Save and close'

Сценарий: _200030  adding a group of user settings for the user
	* Open user catalog
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Users'
	* Select user
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'CI'          |
		И в таблице "List" я выбираю текущую строку
	* Specify custom settings group
		И я нажимаю кнопку выбора у поля "User group"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Admin'       |
		И в таблице "List" я выбираю текущую строку
	* Save settings
		И я нажимаю на кнопку 'Save and close'

Сценарий: _200031 line entry check of objects marked for deletion (AddAttributeAndPropertyValues and Partner)
	* Creating an AddAttributeAndPropertyValues and marking it for deletion
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertyValues'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст '100'
		И я нажимаю кнопку выбора у поля "Additional attribute"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Size'        |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И в таблице "List" я перехожу к строке:
			| 'Additional attribute' | 'Description' |
			| 'Size'          | '100'         |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuSetDeletionMark'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
	* Creating a Partner and marking it for deletion
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Delete'
		И я устанавливаю флаг 'Customer'
		И я нажимаю на кнопку 'Save and close'
		И в таблице "List" я перехожу к строке:
			| 'Description'      |
			| 'Delete' |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuSetDeletionMark'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
	* Checking the selection by line of partner marked for deletion
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		Когда Проверяю шаги на Исключение:
			|'И из выпадающего списка "Partner" я выбираю по строке 'Delete''|
		И в поле 'Partner' я ввожу текст ''
		И я закрыл все окна клиентского приложения
	* Check the selection by line marked for AddAttributeAndPropertyValues deletion
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
		И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
		И я нажимаю на кнопку с именем 'FormCreate'
		Когда Проверяю шаги на Исключение:
			|'И из выпадающего списка "Size" я выбираю по строке '100''|
		И в поле 'Size' я ввожу текст ''
		И я закрыл все окна клиентского приложения


Сценарий: _200032 check the availability of editing custom settings from the user list
	* Open user list
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Users'
	* Check that custom settings are opened from the user list
		И в таблице "List" я перехожу к строке:
		| 'Description'                          |
		| 'Alexander Orlov (Commercial Agent 2)' |
		И я нажимаю на кнопку 'Settings'
		Тогда открылось окно 'Edit user default settings'
	И я закрыл все окна клиентского приложения


	

