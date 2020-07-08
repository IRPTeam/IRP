#language: ru
@tree
@Positive

Функционал: check filling in and re-filling in documents forms + currency form connection



Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: _0154100 preparation
	* For a test of price and rate changes depending on the date
	# check the Sales order reset when the date changes, check the Sales invoice reset when the date changes
		* Input lira exchange rate to dollar 01.11.2018
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.CurrencyRates'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Currency from"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Currency to"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'     |
				| 'USD'  | 'American dollar' |
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я выбираю текущую строку
			И в поле 'Period' я ввожу текст '01.11.2018  0:00:00'
			И я нажимаю кнопку выбора у поля "Source"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Forex Seling' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Multiplicity' я ввожу текст '1'
			И в поле 'Rate' я ввожу текст '5,0000'
			И я нажимаю на кнопку 'Save and close'
			И я закрыл все окна клиентского приложения
		* Create price list of the previous period
			И я открываю навигационную ссылку 'e1cib/list/Document.PriceList'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я меняю значение переключателя 'Set price' на 'By Item keys'
			И я нажимаю кнопку выбора у поля "Price type"
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Basic Price Types' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку с именем 'ItemKeyListAdd'
			И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Dress'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemKeyList" я активизирую поле "Item key"
			И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/Brown'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemKeyList" я активизирую поле "Price"
			И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '1 000,00'
			И в таблице "ItemKeyList" я завершаю редактирование строки
			И я перехожу к закладке "Other"
			И в поле 'Date' я ввожу текст '18.11.2017  0:00:00'
			И я нажимаю на кнопку 'Post and close'
		* Add Dress M/Brown to price list 100
			И в таблице "List" я перехожу к строке:
				| 'Description' | 'Number' |
				| 'Basic price' | '100'    |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку с именем 'ItemKeyListAdd'
			И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Dress'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemKeyList" я активизирую поле "Item key"
			И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/Brown'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemKeyList" я активизирую поле "Price"
			И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '500,00'
			И в таблице "ItemKeyList" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post and close'
	* For the test of completing the purchase documents
		* Preparation: creating a vendor partner term for DFC
			И я открываю навигационную ссылку "e1cib/list/Catalog.Agreements"
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст 'Partner term vendor DFC'
			И я меняю значение переключателя 'Type' на 'Vendor'
			И я меняю значение переключателя 'AP/AR posting detail' на 'By documents'
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'DFC'         |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Multi currency movement type"
			И в таблице "List" я перехожу к строке:
				| 'Currency' |  'Source'       | 'Type'      |
				| 'TRY'      |  'Forex Seling' | 'Partner term' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Price type"
			И в таблице "List" я перехожу к строке:
				| 'Currency' | 'Description'       | 'Reference'         |
				| 'TRY'      | 'Basic Price Types' | 'Basic Price Types' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Start using' я ввожу текст '01.11.2018'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 03'    |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И я закрыл все окна клиентского приложения
		* Preparation: creating a vendor partner term for Partner Kalipso Vendor
			И я открываю навигационную ссылку "e1cib/list/Catalog.Agreements"
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст 'Partner term vendor Partner Kalipso'
			И я меняю значение переключателя 'Type' на 'Vendor'
			И я меняю значение переключателя 'AP/AR posting detail' на 'By documents'
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Partner Kalipso'         |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Multi currency movement type"
			И в таблице "List" я перехожу к строке:
				| 'Currency' |  'Source'       | 'Type'      |
				| 'TRY'      |  'Forex Seling' | 'Partner term' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Price type"
			И в таблице "List" я перехожу к строке:
				| 'Currency' | 'Description'       | 'Reference'         |
				| 'TRY'      | 'Basic Price Types' | 'Basic Price Types' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Start using' я ввожу текст '01.11.2018'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 03'    |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И я закрыл все окна клиентского приложения
	И Пауза 5
	* For the test of choice Planing transaction basis in bank/cash documents
		* Creating a Cashtransfer order to move money between cash accounts
			И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
			* Filling Sender and Send amount
				И я нажимаю кнопку выбора у поля "Sender"
				И в таблице "List" я перехожу к строке:
					| Description    |
					| Cash desk №1 |
				И в таблице "List" я выбираю текущую строку
				И в поле 'Send amount' я ввожу текст '400,00'
				И я нажимаю кнопку выбора у поля "Send currency"
				И в таблице "List" я перехожу к строке:
					| Code | Description     |
					| USD  | American dollar |
				И в таблице "List" я выбираю текущую строку
			* Filling Receiver and Receive amount
				И я нажимаю кнопку выбора у поля "Receiver"
				И в таблице "List" я перехожу к строке:
					| Description    |
					| Cash desk №2 |
				И в таблице "List" я выбираю текущую строку
				И в поле 'Receive amount' я ввожу текст '400,00'
				И я нажимаю кнопку выбора у поля "Receive currency"
				И в таблице "List" я перехожу к строке:
					| Code | Description     |
					| USD  | American dollar |
				И в таблице "List" я активизирую поле "Description"
				И в таблице "List" я выбираю текущую строку
			* Change the document number
				И в поле 'Number' я ввожу текст '10'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '10'
			И я нажимаю на кнопку 'Post and close'
			И Пауза 5
			* Check creation
				И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
				Тогда таблица "List" содержит строки:
				| Number | Sender        | Receiver     | Company      |
				| 10      | Cash desk №1 | Cash desk №2 | Main Company |
			И Я закрыл все окна клиентского приложения
		И Пауза 5
		* Create Cashtransfer order for currency exchange (cash accounts)
			И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
			* Filling Sender and Send amount
				И я нажимаю кнопку выбора у поля "Sender"
				И в таблице "List" я перехожу к строке:
					| Description    |
					| Cash desk №2 |
				И в таблице "List" я выбираю текущую строку
				И в поле 'Send amount' я ввожу текст '210,00'
				И я нажимаю кнопку выбора у поля "Send currency"
				И в таблице "List" я перехожу к строке:
					| Code | Description     |
					| USD  | American dollar |
				И в таблице "List" я выбираю текущую строку
			* Filling Receiver and Receive amount
				И я нажимаю кнопку выбора у поля "Receiver"
				И в таблице "List" я перехожу к строке:
					| Description    |
					| Cash desk №1 |
				И в таблице "List" я выбираю текущую строку
				И в поле 'Receive amount' я ввожу текст '1200,00'
				И я нажимаю кнопку выбора у поля "Receive currency"
				И в таблице "List" я перехожу к строке:
					| Code | Description  |
					| TRY  | Turkish lira |
				И в таблице "List" я активизирую поле "Description"
				И в таблице "List" я выбираю текущую строку
				И я нажимаю кнопку выбора у поля "Cash advance holder"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Arina Brown' |
				И в таблице "List" я выбираю текущую строку
			* Change the document number на 11
				И в поле 'Number' я ввожу текст '11'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '11'
			И я нажимаю на кнопку 'Post and close'
			И Пауза 5
			* Check creation
				И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
				Тогда таблица "List" содержит строки:
				| Number | Sender       | Receiver     | Company      |
				| 11      | Cash desk №2 | Cash desk №1 | Main Company |
			И Я закрыл все окна клиентского приложения
		И Пауза 5
		* Create Cashtransfer order for currency exchange (bank accounts)
			И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
			* Filling Sender and Send amount
				И я нажимаю кнопку выбора у поля "Sender"
				И в таблице "List" я перехожу к строке:
					| Description    |
					| Bank account, TRY |
				И в таблице "List" я выбираю текущую строку
				И в поле 'Send amount' я ввожу текст '1150,00'
			* Filling Receiver and Receive amount
				И я нажимаю кнопку выбора у поля "Receiver"
				И в таблице "List" я перехожу к строке:
					| Description    |
					| Bank account, EUR |
				И в таблице "List" я выбираю текущую строку
				И в поле 'Receive amount' я ввожу текст '175,00'
			* Change the document number на 13
				И в поле 'Number' я ввожу текст '13'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '13'
			И я нажимаю на кнопку 'Post and close'
			И Пауза 5
			* Check creation
				И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
				Тогда таблица "List" содержит строки:
				| Number  | Sender            | Receiver          | Company      |
				| 13      | Bank account, TRY | Bank account, EUR | Main Company |
			И Я закрыл все окна клиентского приложения
		И Пауза 5
		* Create Cash transfer order for cash transfer between bank accounts in one currency
			* Create one more bank account in EUR
				И я открываю навигационную ссылку "e1cib/list/Catalog.CashAccounts"
				И Пауза 2
				И я нажимаю на кнопку с именем 'FormCreate'
				И я нажимаю на кнопку открытия поля с именем "Description_en"
				И в поле с именем 'Description_en' я ввожу текст 'Bank account 2, EUR'
				И в поле с именем 'Description_tr' я ввожу текст 'Bank account 2, EUR TR'
				И я нажимаю на кнопку 'Ok'
				И я меняю значение переключателя с именем "Type" на 'Bank'
				И в поле 'Number' я ввожу текст '1120000000'
				И в поле 'Bank name' я ввожу текст 'OTP'
				И я нажимаю кнопку выбора у поля "Company"
				И в таблице "List" я перехожу к строке:
					| Description  |
					| Main Company |
				И в таблице "List" я выбираю текущую строку
				И я нажимаю кнопку выбора у поля с именем "Currency"
				И в таблице "List" я перехожу к строке:
					| Code |
					| EUR  |
				И в таблице "List" я выбираю текущую строку
				И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
			* Create Cash transfer order for cash transfer between bank accounts in one currency
				И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
				И я нажимаю на кнопку с именем 'FormCreate'
				И я нажимаю кнопку выбора у поля "Company"
				И в таблице "List" я перехожу к строке:
					| Description  |
					| Main Company |
				И в таблице "List" я выбираю текущую строку
				* Filling Sender and Send amount
					И я нажимаю кнопку выбора у поля "Sender"
					И в таблице "List" я перехожу к строке:
						| Description    |
						| Bank account 2, EUR |
					И в таблице "List" я выбираю текущую строку
					И в поле 'Send amount' я ввожу текст '1150,00'
				* Filling Receiver and Receive amount
					И я нажимаю кнопку выбора у поля "Receiver"
					И в таблице "List" я перехожу к строке:
						| Description    |
						| Bank account, EUR |
					И в таблице "List" я выбираю текущую строку
					И в поле 'Receive amount' я ввожу текст '1150,00'
				* Change the document number на 14
					И в поле 'Number' я ввожу текст '14'
					Тогда открылось окно '1C:Enterprise'
					И я нажимаю на кнопку 'Yes'
					И в поле 'Number' я ввожу текст '14'
				И я нажимаю на кнопку 'Post and close'
				И Пауза 5
				* Check creation
					И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
					Тогда таблица "List" содержит строки:
					| Number  | Sender              | Receiver          | Company      |
					| 14      | Bank account 2, EUR | Bank account, EUR | Main Company |
				И Я закрыл все окна клиентского приложения


Сценарий: _0154101 check filling in and re-filling Sales order
	И Я закрыл все окна клиентского приложения
	* Open the Sales order creation form
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling in legal name if the partner has only one
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'
	* Check filling in Partner term if the partner has only one
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Agreement" стал равен 'Partner term DFC'
	* Check filling in Company from Partner term
		* Изменение компании в Sales order
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Company" стал равен 'Second Company'
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
		* Check the refill when selecting a partner term
			И     элемент формы с именем "Company" стал равен 'Main Company'
	* Check filling in Store from Partner term
		* Change of store in the selected partner term
			И я нажимаю на кнопку открытия поля "Partner term"
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 03'    |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
		* Re-selection of the agreement and check of the store refill (items not added)
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
	* Check clearing legal name, Partner term when re-selecting a partner
		* Re-select partner
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Kalipso'     |
			И в таблице "List" я выбираю текущую строку
		* Check clearing fields
			И     элемент формы с именем "Agreement" стал равен ''
		* Check filling in legal name after re-selection partner
			И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		* Select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Basic Partner terms, without VAT' |
			И в таблице "List" я выбираю текущую строку
	* Check filling in Store and Compane from Partner term when re-selection partner
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Check the item key autofill when adding Item (Item has one item key)
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Router'      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			И в таблице 'ItemList' я удаляю строку
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Procurement method"
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" я завершаю редактирование строки
		* Check filling in prices
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' |
				| 'Trousers' | '338,98' | '38/Yellow' | '1,000' | 'pcs'  |
	* Check re-filling  price when reselection partner term
		* Re-select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Check store and price re-filling in the added line
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 01' |
	* Check filling in prices on new lines at agreement reselection
		* Add line
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Shirt'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Procurement method"
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
			И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
		* Check filling in prices
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Procurement method' | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | 'Stock'              | '1,000' | 'pcs'  | 'Store 01' |
				| 'Shirt'    | '350,00' | '38/Black'  | 'Stock'              | '2,000' | 'pcs'  | 'Store 01' |
	* Check the re-drawing of the form for taxes at company re-selection.
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Procurement method' | 'Tax amount'  | 'SalesTax'  | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '*'    | '38/Yellow' | 'Stock'              | '*'           | '*'         | '1,000' | 'pcs'  | '*'          | '*'            | 'Store 01' |
				| '350,00' | 'Shirt'    | '*'    | '38/Black'  | 'Stock'              | '*'           | '*'         | '2,000' | 'pcs'  | '*'          | '*'            | 'Store 01' |
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			Если в таблице "ItemList" нет колонки "VAT" Тогда
	* Tax calculation check when filling in the company at reselection of the partner term
		* Re-select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			И в таблице "List" я выбираю текущую строку
		* Tax calculation check
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Detail' | 'Item'     | 'VAT' | 'Item key'  | 'Procurement method' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | ''       | 'Trousers' | '18%' | '38/Yellow' | 'Stock'              | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | ''       | 'Shirt'    | '18%' | '38/Black'  | 'Stock'              | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
	* Check filling in prices and calculate taxes when adding items via barcode search
		* Add item via barcodes
			И в таблице "ItemList" я нажимаю на кнопку 'SearchByBarcode'
			И в поле 'InputFld' я ввожу текст '2202283739'
			И Пауза 4
			И я нажимаю на кнопку 'OK'
			И Пауза 4
		* Check filling in prices and tax calculation
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Procurement method' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | 'Stock'              | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | 'Shirt'    | '18%' | '38/Black'  | 'Stock'              | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | 'Stock'              | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
			И Пауза 4
	* Check filling in prices and calculation of taxes when adding items through the goods selection form
		* Add items via Pickup form
			И в таблице "ItemList" я нажимаю на кнопку 'Pickup'
			И в таблице "ItemList" я перехожу к строке:
				| 'Title' |
				| 'Dress' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemKeyList" я перехожу к строке:
				| 'Price'  | 'Title'   | 'Unit' |
				| '520,00' | 'XS/Blue' | 'pcs'  |
			И в таблице "ItemKeyList" я выбираю текущую строку
			И я нажимаю на кнопку 'Transfer to document'
		* Check filling in prices and tax calculation
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'Item key'  | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '38/Yellow' | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | 'Shirt'    | '38/Black'  | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | 'L/Green'   | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress'    | 'XS/Blue'   | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
	* Check the line clearing in the tax tree when deleting a line from an order
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице 'ItemList' я удаляю строку
		И я перехожу к закладке "Tax list"
		Тогда таблица "ItemList" не содержит строки:
			| 'Item'  | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Check tax recalculation when uncheck/re-check Price include Tax
		* Unchecking box Price include Tax
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я снимаю флаг 'Price include tax'
		* Tax recalculation check
			И я перехожу к закладке "Item list"
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '133,00'     | '2,000' | 'pcs'  | '700,00'     | '833,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '104,50'     | '1,000' | 'pcs'  | '550,00'     | '654,50'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '98,80'      | '1,000' | 'pcs'  | '520,00'     | '618,80'       | 'Store 01' |
		* Tick Price include Tax and check the calculation
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я устанавливаю флаг 'Price include tax'
			И я перехожу к закладке "Item list"
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
	* Check filling in the Price include Tax check boxes when re-selecting an agreement and check tax recalculation
		* Re-select partner term for which Price include Tax is not ticked 
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Basic Partner terms, without VAT' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Check that the Price include Tax checkbox value has been filled out from the partner term
			И     элемент формы с именем "PriceIncludeTax" стал равен 'No'
		* Check tax recalculation 
			И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '296,61' | 'Shirt' | '18%' | '38/Black' | '112,71'     | '1%'       | '2,000' | 'pcs'  | '593,22'     | '705,93'       | 'Store 02' |
			| '466,10' | 'Dress' | '18%' | 'L/Green'  | '88,56'      | '1%'       | '1,000' | 'pcs'  | '466,10'     | '554,66'       | 'Store 02' |
			| '440,68' | 'Dress' | '18%' | 'XS/Blue'  | '83,73'      | '1%'       | '1,000' | 'pcs'  | '440,68'     | '524,41'       | 'Store 02' |
		* Change of partner term to what was earlier
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
			И     элемент формы с именем "PriceIncludeTax" стал равен 'Yes'
		* Tax recalculation check
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
		* Check filling in currency tab
			И я нажимаю на кнопку 'Save'
			И я перехожу к закладке с именем "GroupCurrency"
			И     таблица "ObjectCurrencies" стала равной:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '1 770'  | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '1 770'  | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '303,08' | '1'            |

Сценарий: _0154102 check filling in and re-filling Sales invoice
	* Open the Sales invoice creation form
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling in legal name if the partner has only one
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'
	* Check filling in Partner term if the partner has only one
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Agreement" стал равен 'Partner term DFC'
	* Check filling in Company from Partner term
		* Изменение компании в Sales order
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Company" стал равен 'Second Company'
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
		* Check the refill when selecting a partner term
			И     элемент формы с именем "Company" стал равен 'Main Company'
	* Check filling in Store from Partner term
		* Change of store in the selected partner term
			И я нажимаю на кнопку открытия поля "Partner term"
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 03'    |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
		* Re-selection of the agreement and check of the store refill (items not added)
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
	* Check clearing legal name, Partner term when re-selecting a partner
		* Re-select partner
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Kalipso'     |
			И в таблице "List" я выбираю текущую строку
		* Check clearing fields
			И     элемент формы с именем "Agreement" стал равен ''
		* Check filling in legal name after re-selecting a partner
			И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		* Select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Basic Partner terms, without VAT' |
			И в таблице "List" я выбираю текущую строку
	* Check filling in Store and Compane from Partner term when re-selection partner
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Check the item key autofill when adding Item (Item has one item key)
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Router'      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			И в таблице 'ItemList' я удаляю строку
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" я завершаю редактирование строки
		* Check filling in prices
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' |
				| 'Trousers' | '338,98' | '38/Yellow' | '1,000' | 'pcs'  |
	* Check re-filling  price when reselection partner term
		* Re-select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Check store and price re-filling in the added line
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 01' |
	* Check filling in prices on new lines at agreement reselection
		* Add line
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Shirt'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
		* Check filling in prices
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 01' |
				| 'Shirt'    | '350,00' | '38/Black'  | '2,000' | 'pcs'  | 'Store 01' |
	* Check the re-drawing of the form for taxes at company re-selection.
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Tax amount'  | 'SalesTax'  | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '*'    | '38/Yellow' | '*'           | '*'         | '1,000' | 'pcs'  | '*'          | '*'            | 'Store 01' |
				| '350,00' | 'Shirt'    | '*'    | '38/Black'  | '*'           | '*'         | '2,000' | 'pcs'  | '*'          | '*'            | 'Store 01' |
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			Если в таблице "ItemList" нет колонки "VAT" Тогда
	* Tax calculation check when filling in the company at reselection of the partner term
		* Re-select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			И в таблице "List" я выбираю текущую строку
		* Tax calculation check
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Detail' | 'Item'     | 'VAT' | 'Item key'  | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | ''       | 'Trousers' | '18%' | '38/Yellow' | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | ''       | 'Shirt'    | '18%' | '38/Black'  | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
	* Check filling in prices and calculate taxes when adding items via barcode search
		* Add item via barcodes
			И в таблице "ItemList" я нажимаю на кнопку 'SearchByBarcode'
			И в поле 'InputFld' я ввожу текст '2202283739'
			И Пауза 2
			И я нажимаю на кнопку 'OK'
			И Пауза 4
		* Check filling in prices and tax calculation
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | 'Shirt'    | '18%' | '38/Black'  | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
			И Пауза 4
	* Check filling in prices and calculation of taxes when adding items through the goods selection form
		* Add items via Pickup form
			И в таблице "ItemList" я нажимаю на кнопку 'Pickup'
			И в таблице "ItemList" я перехожу к строке:
				| 'Title' |
				| 'Dress' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemKeyList" я перехожу к строке:
				| 'Price'  | 'Title'   | 'Unit' |
				| '520,00' | 'XS/Blue' | 'pcs'  |
			И в таблице "ItemKeyList" я выбираю текущую строку
			И я нажимаю на кнопку 'Transfer to document'
		* Check filling in prices and tax calculation
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'Item key'  | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '38/Yellow' | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | 'Shirt'    | '38/Black'  | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | 'L/Green'   | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress'    | 'XS/Blue'   | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
	* Check the line clearing in the tax tree when deleting a line from an order
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице 'ItemList' я удаляю строку
		И я перехожу к закладке "Tax list"
		Тогда таблица "ItemList" не содержит строки:
			| 'Item'  | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Check tax recalculation when uncheck/re-check Price include Tax
		* Unchecking box Price include Tax
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я снимаю флаг 'Price include tax'
		* Tax recalculation check
			И я перехожу к закладке "Item list"
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '133,00'     | '2,000' | 'pcs'  | '700,00'     | '833,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '104,50'     | '1,000' | 'pcs'  | '550,00'     | '654,50'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '98,80'      | '1,000' | 'pcs'  | '520,00'     | '618,80'       | 'Store 01' |
		* Tick Price include Tax and check the calculation
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я устанавливаю флаг 'Price include tax'
			И я перехожу к закладке "Item list"
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
	* Check filling in the Price include Tax check boxes when re-selecting an agreement and check tax recalculation
		* Re-select partner term for which Price include Tax is not ticked 
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Basic Partner terms, without VAT' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Check that the Price include Tax checkbox value has been filled out from the partner term
			И     элемент формы с именем "PriceIncludeTax" стал равен 'No'
		* Check tax recalculation 
			И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '296,61' | 'Shirt' | '18%' | '38/Black' | '112,71'     | '1%'       | '2,000' | 'pcs'  | '593,22'     | '705,93'       | 'Store 02' |
			| '466,10' | 'Dress' | '18%' | 'L/Green'  | '88,56'      | '1%'       | '1,000' | 'pcs'  | '466,10'     | '554,66'       | 'Store 02' |
			| '440,68' | 'Dress' | '18%' | 'XS/Blue'  | '83,73'      | '1%'       | '1,000' | 'pcs'  | '440,68'     | '524,41'       | 'Store 02' |
		* Change of partner term to what was earlier
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
			И     элемент формы с именем "PriceIncludeTax" стал равен 'Yes'
		* Tax recalculation check
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
		* Check filling in currency tab
			И я перехожу к закладке с именем "GroupCurrency"
			И     таблица "ObjectCurrencies" стала равной:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'         | '1'                 | '1 770'  | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'         | '1'                 | '1 770'  | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'         | '5,8400'            | '303,08' | '1'            |
		* Check tax recalculation when choosing a tax rate manually
			И  в таблице "ItemList" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			И в таблице "ItemList" я активизирую поле "VAT"
			И в таблице "ItemList" из выпадающего списка "VAT" я выбираю точное значение '0%'
			И     таблица "TaxTree" содержит строки:
				| 'Tax'      | 'Tax rate' | 'Item'  | 'Item key' | 'Analytics' | 'Amount' | 'Manual amount' |
				| 'VAT'      | ''         | ''      | ''         | ''          | '163,22' | '163,22'        |
				| 'VAT'      | '18%'      | 'Dress' | 'L/Green'  | ''          | '83,90'  | '83,90'         |
				| 'VAT'      | '18%'      | 'Dress' | 'XS/Blue'  | ''          | '79,32'  | '79,32'         |
				| 'VAT'      | '0%'       | 'Shirt' | '38/Black' | ''          | ''       | ''              |
				| 'SalesTax' | ''         | ''      | ''         | ''          | '17,53'  | '17,53'         |
				| 'SalesTax' | '1%'       | 'Dress' | 'L/Green'  | ''          | '5,45'   | '5,45'          |
				| 'SalesTax' | '1%'       | 'Dress' | 'XS/Blue'  | ''          | '5,15'   | '5,15'          |
				| 'SalesTax' | '1%'       | 'Shirt' | '38/Black' | ''          | '6,93'   | '6,93'          |
			И я закрыл все окна клиентского приложения



Сценарий: _0154103 check Sales order when changing date
	* Open the Sales order creation form
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in partner and Legal name
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я выбираю текущую строку
	* Filling in an Partner term
		И я нажимаю кнопку выбора у поля "Partner term"
		Тогда в таблице "List" количество строк "меньше или равно" 3
		И в таблице "List" я перехожу к строке:
			| 'Description'                   |
			| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Add items and check prices on the current date
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/Brown'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '500,00' | 'Dress' | '18%' | 'M/Brown'  | '81,22'      | '1%'       | '1,000' | 'pcs'  | '418,78'     | '500,00'       | 'Store 01' |
	* Change of date and check of price and tax recalculation
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Date' я ввожу текст '01.11.2018 10:00:00'
		И я перехожу к закладке "Item list"
		Когда открылось окно 'Update item list info'
		И     элемент формы с именем "Prices" стал равен 'Yes'
		И я нажимаю на кнопку 'OK'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Price'    | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'Dress' | '1 000,00' | 'M/Brown'  | '1,000' | ''           | 'pcs'  | '1 000,00'     | '1 000,00'     | 'Store 01' |
	* Check the list of partner terms
		И я нажимаю кнопку выбора у поля "Partner term"
		И     таблица "List" содержит строки:
			| 'Description'                   |
			| 'Basic Partner terms, TRY'         |
			| 'Basic Partner terms, $'           |
			| 'Basic Partner terms, without VAT' |
			| 'Personal Partner terms, $'        |
			| 'Sale autum, TRY'               |
		И Я закрываю окно 'Partner terms'
	* Check the recount of the currency table when the date is changed
		И я перехожу к закладке с именем "GroupCurrency"
		И     таблица "ObjectCurrencies" стала равной:
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '1 000'  | '1'            |
		| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '1 000'  | '1'            |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,0000'            | '200,00' | '1'            |

Сценарий: _0154104 check Sales invoice when changing date
	* Open the Sales invoice creation form
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in partner and Legal name
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я выбираю текущую строку
	* Filling in an Partner term
		И я нажимаю кнопку выбора у поля "Partner term"
		Тогда в таблице "List" количество строк "меньше или равно" 3
		И в таблице "List" я перехожу к строке:
			| 'Description'                   |
			| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Add items and check prices on the current date
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/Brown'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '500,00' | 'Dress' | '18%' | 'M/Brown'  | '81,22'      | '1%'       | '1,000' | 'pcs'  | '418,78'     | '500,00'       | 'Store 01' |
	* Change of date and check of price and tax recalculation
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Date' я ввожу текст '01.11.2018 10:00:00'
		И я перехожу к закладке "Item list"
		Когда открылось окно 'Update item list info'
		И я нажимаю на кнопку 'OK'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Price'    | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'Dress' | '1 000,00' | 'M/Brown'  | '1,000' | ''           | 'pcs'  | '1 000,00'     | '1 000,00'     | 'Store 01' |
	* Check the list of partner terms
		И я нажимаю кнопку выбора у поля "Partner term"
		И     таблица "List" содержит строки:
		| 'Description'                   |
		| 'Basic Partner terms, TRY'         |
		| 'Basic Partner terms, $'           |
		| 'Basic Partner terms, without VAT' |
		| 'Personal Partner terms, $'        |
		| 'Sale autum, TRY'               |
		И Я закрываю окно 'Partner terms'
	* Check the recount of the currency table when the date is changed
		И я перехожу к закладке с именем "GroupCurrency"
		И     таблица "ObjectCurrencies" стала равной:
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '1 000'  | '1'            |
		| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '1 000'  | '1'            |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,0000'            | '200,00' | '1'            |

Сценарий: _0154105 check filling in and re-filling Purchase order
	* Open the Purchase order creation form
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling in legal name if the partner has only one
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'
	* Check filling in Partner term if the partner has only one
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Agreement" стал равен 'Partner term vendor DFC'
	* Check filling in Company from Partner term
		* Change company in the Purchase order
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Company" стал равен 'Second Company'
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
		* Check the refill when selecting a partner term
			И     элемент формы с именем "Company" стал равен 'Main Company'
	* Check filling in Store from Partner term
		* Change of store in the selected partner term
			И я нажимаю на кнопку открытия поля "Partner term"
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 03'    |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
		* Re-selection of the agreement and check of the store refill (items not added)
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
	* Check clearing legal name, Partner term when re-selecting a partner
		* Re-select partner
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Partner Kalipso'     |
			И в таблице "List" я выбираю текущую строку
		* Check clearing fields
			И     элемент формы с именем "Agreement" стал равен ''
		* Check filling in legal name after re-selecting a partner
			И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		* Select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'            |
				| 'Partner Kalipso Vendor' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку открытия поля "Partner term"
			И я нажимаю кнопку выбора у поля "Price type"
			И в таблице "List" я перехожу к строке:
				| 'Description'             |
				| 'Basic Price without VAT' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
	* Check filling in Store and Compane from Partner term when re-selection partner
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Check the item key autofill when adding Item (Item has one item key)
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Router'      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			И в таблице 'ItemList' я удаляю строку
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И Пауза 2
		* Check filling in prices
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     |
				| 'Trousers' | '*'      | '38/Yellow' | '1,000' |
			И Пауза 2
	* Check re-filling  price when reselection partner term
		* Re-select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Partner term vendor Partner Kalipso' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Check store and price re-filling in the added line
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
	* Check filling in prices on new lines at agreement reselection
		* Add line
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Shirt'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
		* Check filling in prices
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
				| 'Shirt'    | '350,00' | '38/Black'  | '2,000' | 'pcs'  | 'Store 03' |
	* Check the re-drawing of the form for taxes at company re-selection.
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Tax amount'  | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '*'    | '38/Yellow' | '*'           | '1,000' | 'pcs'  | '*'          | '*'            | 'Store 03' |
				| '350,00' | 'Shirt'    | '*'    | '38/Black'  | '*'           | '2,000' | 'pcs'  | '*'          | '*'            | 'Store 03' |
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			Если в таблице "ItemList" нет колонки "VAT" Тогда
	* Tax calculation check when filling in the company at reselection of the partner term
		* Re-select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Partner Kalipso Vendor' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я изменяю флаг 'Update filled stores on Store 02'
			И я нажимаю на кнопку 'OK'
		* Tax calculation check
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '51,71'      | 'pcs'  | '287,27'     | '338,98'       | 'Store 03' |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
	* Check filling in prices and calculate taxes when adding items via barcode search
		* Add item via barcodes
			И я нажимаю на кнопку 'ItemListSearchByBarcode'
			И в поле 'InputFld' я ввожу текст '2202283739'
			И Пауза 2
			И я нажимаю на кнопку 'OK'
			И Пауза 4
		* Check filling in prices and tax calculation
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '51,71'      | 'pcs'  | '287,27'     | '338,98'       | 'Store 03' |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 03' |
	* Check filling in prices and calculation of taxes when adding items through the goods selection form
		* Add items via Pickup form
			И я нажимаю на кнопку 'Pickup'
			И в таблице "ItemList" я перехожу к строке:
				| 'Title' |
				| 'Dress' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemKeyList" я перехожу к строке:
				| 'Price'  | 'Title'   | 'Unit' |
				| '440,68' | 'XS/Blue' | 'pcs'  |
			И в таблице "ItemKeyList" я выбираю текущую строку
			И я нажимаю на кнопку 'Transfer to document'
		* Check filling in prices and tax calculation
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '51,71'      | 'pcs'  | '287,27'     | '338,98'       | 'Store 03' |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 03' |
				| '440,68' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | '67,22'      | 'pcs'  | '373,46'     | '440,68'       | 'Store 03' |
	* Check the line clearing in the tax tree when deleting a line from an order
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице 'ItemList' я удаляю строку
		И я перехожу к закладке "Tax list"
		Тогда таблица "ItemList" не содержит строки:
			| 'Item'     | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Check tax recalculation when uncheck/re-check Price include Tax
		* Unchecking box Price include Tax
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я снимаю флаг 'Price include tax'
		* Tax recalculation check
			И я перехожу к закладке "Item list"
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt' | '18%' | '38/Black' | '2,000' | '106,78'     | 'pcs'  | '593,22'     | '700,00'       | 'Store 03' |
				| '466,10' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '83,90'      | 'pcs'  | '466,10'     | '550,00'       | 'Store 03' |
				| '440,68' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '79,32'      | 'pcs'  | '440,68'     | '520,00'       | 'Store 03' |
		* Tick Price include Tax and check the calculation
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я устанавливаю флаг 'Price include tax'
			И я перехожу к закладке "Item list"
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 03' |
				| '440,68' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | '67,22'      | 'pcs'  | '373,46'     | '440,68'       | 'Store 03' |
	* Check filling in the Price include Tax check boxes when re-selecting an agreement and check tax recalculation
		* Re-select partner term на то у которого галочка Price include Tax установлена
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Partner Kalipso Vendor' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Check that the Price include Tax checkbox value has been filled out from the partner term
			И     элемент формы с именем "PriceIncludeTax" стал равен 'Yes'
		* Check tax recalculation 
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 02' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 02' |
				| '440,68' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | '67,22'      | 'pcs'  | '373,46'     | '440,68'       | 'Store 02' |
		* Change of partner term to what was earlier
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Partner term vendor Partner Kalipso' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
			И     элемент формы с именем "PriceIncludeTax" стал равен 'No'
		* Tax recalculation check
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | '126,00'     | 'pcs'  | '700,00'     | '826,00'       | 'Store 03' |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '99,00'      | 'pcs'  | '550,00'     | '649,00'       | 'Store 03' |
				| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '93,60'      | 'pcs'  | '520,00'     | '613,60'       | 'Store 03' |
		* Check filling in currency tab
			И я перехожу к закладке с именем "GroupCurrency"
			И     таблица "ObjectCurrencies" стала равной:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'  | 'Multiplicity' |
			| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '2 088,6' | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '2 088,6' | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '357,64'  | '1'            |
		* Check tax recalculation when choosing a tax rate manually
			И  в таблице "ItemList" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			И в таблице "ItemList" я активизирую поле "VAT"
			И в таблице "ItemList" из выпадающего списка "VAT" я выбираю точное значение '0%'
			И     таблица "TaxTree" содержит строки:
				| 'Tax' | 'Tax rate' | 'Item'  | 'Item key' | 'Analytics' | 'Amount' | 'Manual amount' |
				| 'VAT' | ''         | ''      | ''         | ''          | '192,60' | '192,60'        |
				| 'VAT' | '18%'      | 'Dress' | 'L/Green'  | ''          | '99,00'  | '99,00'         |
				| 'VAT' | '18%'      | 'Dress' | 'XS/Blue'  | ''          | '93,60'  | '93,60'         |
				| 'VAT' | '0%'       | 'Shirt' | '38/Black' | ''          | ''       | ''              |
			И я закрыл все окна клиентского приложения



Сценарий: _0154106 check filling in and re-filling Purchase invoice
	* Open the Purchase invoice creation form
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling in legal name if the partner has only one
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'
	* Check filling in Partner term if the partner has only one
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Agreement" стал равен 'Partner term vendor DFC'
	* Check filling in Company from Partner term
		* Change company in the Purchase invoice
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Company" стал равен 'Second Company'
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
		* Check the refill when selecting a partner term
			И     элемент формы с именем "Company" стал равен 'Main Company'
	* Check filling in Store from Partner term
		* Change of store in the selected partner term
			И я нажимаю на кнопку открытия поля "Partner term"
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 03'    |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
		* Re-selection of the agreement and check of the store refill (items not added)
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
	* Check clearing legal name, Partner term when re-selecting a partner
		* Re-select partner
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Partner Kalipso'     |
			И в таблице "List" я выбираю текущую строку
		* Check clearing fields
			И     элемент формы с именем "Agreement" стал равен ''
		* Check filling in legal name after re-selecting a partner
			И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		* Select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'            |
				| 'Partner Kalipso Vendor' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку открытия поля "Partner term"
			И я нажимаю кнопку выбора у поля "Price type"
			И в таблице "List" я перехожу к строке:
				| 'Description'             |
				| 'Basic Price without VAT' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
	* Check filling in Store and Compane from Partner term when re-selection partner
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Check the item key autofill when adding Item (Item has one item key)
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Router'      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			И в таблице 'ItemList' я удаляю строку
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" я завершаю редактирование строки
		* Check filling in prices
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' |
				| 'Trousers' | '338,98' | '38/Yellow' | '1,000' | 'pcs'  |
	* Check re-filling  price when reselection partner term
		* Re-select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Partner term vendor Partner Kalipso' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Check store and price re-filling in the added line
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
	* Check filling in prices on new lines at agreement reselection
		* Add line
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Shirt'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
		* Check filling in prices
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
				| 'Shirt'    | '350,00' | '38/Black'  | '2,000' | 'pcs'  | 'Store 03' |
	* Check the re-drawing of the form for taxes at company re-selection.
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Tax amount'  | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '*'    | '38/Yellow' | '*'           | '1,000' | 'pcs'  | '*'          | '*'            | 'Store 03' |
				| '350,00' | 'Shirt'    | '*'    | '38/Black'  | '*'           | '2,000' | 'pcs'  | '*'          | '*'            | 'Store 03' |
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			Если в таблице "ItemList" нет колонки "VAT" Тогда
	* Tax calculation check when filling in the company at reselection of the partner term
		* Re-select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Partner Kalipso Vendor' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я изменяю флаг 'Update filled stores on Store 02'
			И я нажимаю на кнопку 'OK'
		* Tax calculation check
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '51,71'      | 'pcs'  | '287,27'     | '338,98'       | 'Store 03' |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
	* Check filling in prices and calculate taxes when adding items via barcode search
		* Add item via barcodes
			И я нажимаю на кнопку 'SearchByBarcode'
			И в поле 'InputFld' я ввожу текст '2202283739'
			И Пауза 2
			И я нажимаю на кнопку 'OK'
			И Пауза 4
		* Check filling in prices and tax calculation
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '51,71'      | 'pcs'  | '287,27'     | '338,98'       | 'Store 03' |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 03' |
	* Check filling in prices and calculation of taxes when adding items through the goods selection form
		* Add items via Pickup form
			И я нажимаю на кнопку 'Pickup'
			И в таблице "ItemList" я перехожу к строке:
				| 'Title' |
				| 'Dress' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemKeyList" я перехожу к строке:
				| 'Price'  | 'Title'   | 'Unit' |
				| '440,68' | 'XS/Blue' | 'pcs'  |
			И в таблице "ItemKeyList" я выбираю текущую строку
			И я нажимаю на кнопку 'Transfer to document'
		* Check filling in prices and tax calculation
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '51,71'      | 'pcs'  | '287,27'     | '338,98'       | 'Store 03' |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 03' |
				| '440,68' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | '67,22'      | 'pcs'  | '373,46'     | '440,68'       | 'Store 03' |
	* Check the line clearing in the tax tree when deleting a line from an order
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице 'ItemList' я удаляю строку
		И я перехожу к закладке "Tax list"
		Тогда таблица "ItemList" не содержит строки:
			| 'Item'     | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Check tax recalculation when uncheck/re-check Price include Tax
		* Unchecking box Price include Tax
			И я перехожу к закладке "Other"
			И я снимаю флаг 'Price include tax'
		* Tax recalculation check
			И я перехожу к закладке "Item list"
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt' | '18%' | '38/Black' | '2,000' | '106,78'     | 'pcs'  | '593,22'     | '700,00'       | 'Store 03' |
				| '466,10' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '83,90'      | 'pcs'  | '466,10'     | '550,00'       | 'Store 03' |
				| '440,68' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '79,32'      | 'pcs'  | '440,68'     | '520,00'       | 'Store 03' |
		* Tick Price include Tax and check the calculation
			И я перехожу к закладке "Other"
			И я устанавливаю флаг 'Price include tax'
			И я перехожу к закладке "Item list"
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 03' |
				| '440,68' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | '67,22'      | 'pcs'  | '373,46'     | '440,68'       | 'Store 03' |
	* Check filling in the Price include Tax check boxes when re-selecting an agreement and check tax recalculation
		* Re-select partner term на то у которого галочка Price include Tax установлена
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Partner Kalipso Vendor' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Check that the Price include Tax checkbox value has been filled out from the partner term
			И     элемент формы с именем "PriceIncludeTax" стал равен 'Yes'
		* Check tax recalculation 
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 02' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 02' |
				| '440,68' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | '67,22'      | 'pcs'  | '373,46'     | '440,68'       | 'Store 02' |
		* Change of partner term to what was earlier
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Partner term vendor Partner Kalipso' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
			И     элемент формы с именем "PriceIncludeTax" стал равен 'No'
		* Tax recalculation check
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | '126,00'     | 'pcs'  | '700,00'     | '826,00'       | 'Store 03' |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '99,00'      | 'pcs'  | '550,00'     | '649,00'       | 'Store 03' |
				| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '93,60'      | 'pcs'  | '520,00'     | '613,60'       | 'Store 03' |
		* Check filling in currency tab
			И я перехожу к закладке с именем "GroupCurrency"
			И     таблица "ObjectCurrencies" стала равной:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'  | 'Multiplicity' |
			| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '2 088,6' | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '2 088,6' | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '357,64'  | '1'            |
		* Check tax recalculation when choosing a tax rate manually
			И  в таблице "ItemList" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			И в таблице "ItemList" я активизирую поле "VAT"
			И в таблице "ItemList" из выпадающего списка "VAT" я выбираю точное значение '0%'
			И     таблица "TaxTree" содержит строки:
				| 'Tax' | 'Tax rate' | 'Item'  | 'Item key' | 'Analytics' | 'Amount' | 'Manual amount' |
				| 'VAT' | ''         | ''      | ''         | ''          | '192,60' | '192,60'        |
				| 'VAT' | '18%'      | 'Dress' | 'L/Green'  | ''          | '99,00'  | '99,00'         |
				| 'VAT' | '18%'      | 'Dress' | 'XS/Blue'  | ''          | '93,60'  | '93,60'         |
				| 'VAT' | '0%'       | 'Shirt' | '38/Black' | ''          | ''       | ''              |
			И я закрыл все окна клиентского приложения

Сценарий: _0154107 check filling in and re-filling Cash reciept (transaction type Payment from customer)
	* Open the Cash reciept creation form
		И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check the default transaction type 'Payment from customer'
		И     элемент формы с именем "TransactionType" стал равен 'Payment from customer'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
	* Check filling in company
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
	* Check filling in currency before select cash account
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| USD  |
		И в таблице "List" я выбираю текущую строку
	* Check filling in cash account (multicurrency)
		И я нажимаю кнопку выбора у поля "Cash/Bank accounts"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №1 |
		И в таблице "List" я выбираю текущую строку
	* Re-selection of cash registers with a fixed currency and verification of overfilling of the Currency field
		И я нажимаю кнопку выбора у поля "Cash/Bank accounts"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №4 |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Currency" стал равен 'TRY'
	* Check currency re-selection and clearing the "Cash / Bank accounts" field if the currency is fixed at the cash account
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| USD  |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "CashAccount" стал равен ''
	* Select a multi-currency cash account and checking that the Currency field will not be cleared
		И я нажимаю кнопку выбора у поля "Cash/Bank accounts"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Cash desk №1 |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Currency" стал равен 'USD'
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| TRY  |
		И в таблице "List" я выбираю текущую строку
	* Check the choice of a partner in the tabular section and filling in the legal name if one
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Payer'|
			| 'DFC'       | 'DFC'  |
		И в таблице "PaymentList" я нажимаю на кнопку 'Delete'
	* Check filling in partner term when adding a partner if the partner has only one
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayer"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Nicoletta'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Partner term'                              | 'Payer'             |
			| 'Nicoletta' | 'Posting by Standard Partner term Customer' | 'Company Nicoletta' |
		И в таблице "PaymentList" я нажимаю на кнопку 'Delete'
	* Check the display to select only available partner terms
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayer"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payer"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Company Ferron BP |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
		Тогда таблица "List" содержит строки:
			| 'Description'                   |
			| 'Basic Partner terms, TRY'         |
			| 'Basic Partner terms, without VAT' |
			| 'Vendor Ferron, TRY'            |
			| 'Vendor Ferron, USD'            |
			| 'Vendor Ferron, EUR'            |
			| 'Ferron, USD'                   |
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Filter check on the basis documents depending on Partner term
		# temporarily
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		# temporarily
		Дано В активном окне открылась форма с заголовком "Documents for incoming payment"
		И таблица  "List" не содержит строки:
			| 'Reference'          | 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
			| 'Sales invoice 234*' | '200,00'          | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
		И в таблице "List" я перехожу к строке:
			| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
			| '4 350,00'        | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
		И я нажимаю на кнопку 'Select'
	* Check clearing basis document when clearing partner term
		И в таблице "PaymentList" я выбираю текущую строку
		И я нажимаю кнопку очистить у поля "Partner term"
		И в таблице "PaymentList" я завершаю редактирование строки
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Partner term' | 'Amount' | 'Payer'             | 'Basis document' |
			| 'Ferron BP' | ''          | ''       | 'Company Ferron BP' | ''               |
	* Check the addition of a base document without selecting a base document
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Когда Проверяю шаги на Исключение:
			|'Дано В активном окне открылась форма с заголовком "Documents for incoming payment"'|
	* Checking the unavailability of the choice of the base document when choosing Partner term with the Ap/ar  by Standard Partner term
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayer"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Nicoletta   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payer"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Company Nicoletta |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Posting by Standard Partner term Customer' |
		И в таблице "List" я выбираю текущую строку
	* Check the addition of a base document without selecting a base document
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Когда Проверяю шаги на Исключение:
			|'Дано В активном окне открылась форма с заголовком "Documents for incoming payment"'|
	* Check the currency form connection
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   | 'Payer'             |
			| 'Ferron BP' | 'Company Ferron BP' |
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '100,00'
		И в таблице "PaymentList" я завершаю редактирование строки
			И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   | 'Payer'             |
			| 'Nicoletta' | 'Company Nicoletta' |
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '200,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     таблица "CurrenciesPaymentList" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,84*'            | '17,12'  | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,84*'            | '34,25'  | '1'            |
	* Check the recalculation at the rate in case of date change
		И я перехожу к закладке "Other"
		И в поле 'Date' я ввожу текст '01.11.2018  0:00:00'
		И я перехожу к закладке "Payments"
		И     таблица "CurrenciesPaymentList" содержит строки:
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5*'                | '20*'    | '1'            |
		| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '100'    | '1'            |
		| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '200'    | '1'            |
		| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '200'    | '1'            |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '*'                 | '40*'     | '1'            |
		И Пауза 5
	* Check that it is impossible to post the document without a completed basis document when choosing a partner term with Ap-Ar By documents
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   | 'Payer'             |
			| 'Ferron BP' | 'Company Ferron BP' |
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post'
		Если в сообщениях пользователю есть строка "Basis document is required on line 1" Тогда

Сценарий: _0154108 total amount calculation in Cash reciept
	* Open form Cash reciept
		И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check the Total amount calculation when adding rows
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '200,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '50,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '180,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '430,00'
	* Check the Total amount re-calculation when deleting rows
		И в таблице "PaymentList" я перехожу к строке:
		| 'Amount' |
		| '50,00'  |
		И в таблице 'PaymentList' я удаляю строку
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '380,00'
	* Check the Total amount calculation when adding rows
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '80,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '460,00'
		
Сценарий: _0154109 check filling in and re-filling Bank reciept (transaction type Payment from customer)
	* Open form Bank reciept
		И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check the default transaction type 'Payment from customer'
		И     элемент формы с именем "TransactionType" стал равен 'Payment from customer'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
	* Check filling in company
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
	* Check filling in currencies before select an account
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| USD  |
		И в таблице "List" я выбираю текущую строку
	* Bank account selection and check of Currency field refilling
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Bank account, TRY |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Currency" стал равен 'TRY'
	* Check currency re-selection and clearing the "Account" field
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| USD  |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Account" стал равен ''
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Bank account, TRY |
		И в таблице "List" я выбираю текущую строку
	* Check the choice of a partner in the tabular section and filling in the legal name if one
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Payer'|
			| 'DFC'       | 'DFC'  |
		И в таблице "PaymentList" я нажимаю на кнопку 'Delete'
	* Check filling in partner term when adding a partner if the partner has only one
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayer"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Nicoletta'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Partner term'                              | 'Payer'             |
			| 'Nicoletta' | 'Posting by Standard Partner term Customer' | 'Company Nicoletta' |
		И в таблице "PaymentList" я нажимаю на кнопку 'Delete'
	* Check the display to select only available partner terms
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayer"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payer"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Company Ferron BP |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
		Тогда таблица "List" содержит строки:
			| 'Description'                   |
			| 'Basic Partner terms, TRY'         |
			| 'Basic Partner terms, without VAT' |
			| 'Vendor Ferron, TRY'            |
			| 'Vendor Ferron, USD'            |
			| 'Vendor Ferron, EUR'            |
			| 'Ferron, USD'                   |
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Filter check on the basis documents depending on Partner term
		# temporarily
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		# temporarily
		Дано В активном окне открылась форма с заголовком "Documents for incoming payment"
		И таблица  "List" не содержит строки:
			| 'Reference'          | 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
			| 'Sales invoice 234*' | '200,00'          | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
		И в таблице "List" я перехожу к строке:
			| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
			| '4 350,00'        | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
		И я нажимаю на кнопку 'Select'
	* Check clearing basis document when clearing partner term
		И в таблице "PaymentList" я выбираю текущую строку
		И я нажимаю кнопку очистить у поля "Partner term"
		И в таблице "PaymentList" я завершаю редактирование строки
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Partner term' | 'Amount' | 'Payer'             | 'Basis document' |
			| 'Ferron BP' | ''          | ''       | 'Company Ferron BP' | ''               |
	* Check the addition of a base document without selecting a base document
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Когда Проверяю шаги на Исключение:
			|'Дано В активном окне открылась форма с заголовком "Documents for incoming payment"'|
	* Checking the unavailability of the choice of the base document when choosing Partner term with the Ap/ar  by Standard Partner term
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayer"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Nicoletta   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payer"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Company Nicoletta |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Posting by Standard Partner term Customer' |
		И в таблице "List" я выбираю текущую строку
	* Check the addition of a base document without selecting a base document
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Когда Проверяю шаги на Исключение:
			|'Дано В активном окне открылась форма с заголовком "Documents for incoming payment"'|
	* Check the currency form connection
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   | 'Payer'             |
			| 'Ferron BP' | 'Company Ferron BP' |
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '100,00'
		И в таблице "PaymentList" я завершаю редактирование строки
			И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   | 'Payer'             |
			| 'Nicoletta' | 'Company Nicoletta' |
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '200,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     таблица "CurrenciesPaymentList" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,84*'            | '17,12'  | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,84*'            | '34,25'  | '1'            |
	* Check the recalculation at the rate in case of date change
		И я перехожу к закладке "Other"
		И в поле 'Date' я ввожу текст '01.11.2018  0:00:00'
		И я перехожу к закладке "Payments"
		И в таблице "PaymentList" я перехожу к строке:
		| 'Amount' | 'Partner'   | 'Payer'             |
		| '200,00' | 'Nicoletta' | 'Company Nicoletta' |
		И     таблица "CurrenciesPaymentList" содержит строки:
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5*'                | '40,00'  | '1'            |
		И в таблице "PaymentList" я перехожу к строке:
		| 'Amount' | 'Partner'   | 'Payer'             |
		| '100,00' | 'Ferron BP' | 'Company Ferron BP' |
		И     таблица "CurrenciesPaymentList" содержит строки:
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5*'                | '20,00'  | '1'            |
	* Check that it is impossible to post the document without a completed basis document when choosing a partner term with Ap-Ar By documents
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   | 'Payer'             |
			| 'Ferron BP' | 'Company Ferron BP' |
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post'
		Если в сообщениях пользователю есть строка "Basis document is required on line 1" Тогда

Сценарий: _0154110 total amount calculation in в Bank reciept
	* Open form Bank reciept
		И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check the Total amount calculation when adding rows
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '200,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '50,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '180,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '430,00'
	* Check the Total amount re-calculation when deleting rows
		И в таблице "PaymentList" я перехожу к строке:
		| 'Amount' |
		| '50,00'  |
		И в таблице 'PaymentList' я удаляю строку
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '380,00'
	* Check the Total amount calculation when adding rows
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '80,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '460,00'



Сценарий: _0154111 check filling in and re-filling Cash payment (transaction type Payment to the vendor)
	* Open form Cash payment
		И я открываю навигационную ссылку 'e1cib/list/Document.CashPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check the default transaction type 'Payment from customer'
		И     элемент формы с именем "TransactionType" стал равен 'Payment to the vendor'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
	* Check filling in company
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
	* Check filling in currency before select cash account
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| USD  |
		И в таблице "List" я выбираю текущую строку
	* Check filling in cash account (multicurrency)
		И я нажимаю кнопку выбора у поля "Cash/Bank accounts"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №1 |
		И в таблице "List" я выбираю текущую строку
	* Re-selection of cash registers with a fixed currency and verification of overfilling of the Currency field
		И я нажимаю кнопку выбора у поля "Cash/Bank accounts"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №4 |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Currency" стал равен 'TRY'
	* Check currency re-selection and clearing the "Cash / Bank accounts" field if the currency is fixed at the cash account
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| USD  |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "CashAccount" стал равен ''
	* Select a multi-currency cash account and checking that the Currency field will not be cleared
		И я нажимаю кнопку выбора у поля "Cash/Bank accounts"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Cash desk №1 |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Currency" стал равен 'USD'
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| TRY  |
		И в таблице "List" я выбираю текущую строку
	* Check the choice of a partner in the tabular section and filling in the legal name if one
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Payee'|
			| 'DFC'       | 'DFC'  |
		И в таблице "PaymentList" я нажимаю на кнопку 'Delete'
	* Check filling in partner term when adding a partner if the partner has only one
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayee"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Veritas'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Partner term'                               | 'Payee'             |
			| 'Veritas'   | 'Posting by Standard Partner term (Veritas)' | 'Company Veritas' |
		И в таблице "PaymentList" я нажимаю на кнопку 'Delete'
	* Check the display to select only available partner terms
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayee"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payee"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Company Ferron BP |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
		Тогда таблица "List" содержит строки:
			| 'Description'                   |
			| 'Basic Partner terms, TRY'         |
			| 'Basic Partner terms, without VAT' |
			| 'Vendor Ferron, TRY'            |
			| 'Vendor Ferron, USD'            |
			| 'Vendor Ferron, EUR'            |
			| 'Ferron, USD'                   |
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Filter check on the basis documents depending on Partner term
		# temporarily
		Когда Проверяю шаги на Исключение:
		|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		# temporarily
		И таблица  "List" не содержит строки:
			| 'Document amount'| 'Company'      | 'Legal name'        | 'Partner'   |
			| '7 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
		И в таблице "List" я перехожу к строке:
			| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
			| '137 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
		И я нажимаю на кнопку 'Select'
	* Check clearing basis document when clearing partner term
		И в таблице "PaymentList" я выбираю текущую строку
		И я нажимаю кнопку очистить у поля "Partner term"
		И в таблице "PaymentList" я завершаю редактирование строки
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Partner term' | 'Amount' | 'Payee'             | 'Basis document' |
			| 'Ferron BP' | ''          | ''       | 'Company Ferron BP' | ''               |
	* Check the addition of a base document without selecting a base document
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Когда Проверяю шаги на Исключение:
			|'Дано В активном окне открылась форма с заголовком "Documents for incoming payment"'|
	* Checking the unavailability of the choice of the base document when choosing Partner term with the Ap/ar  by Standard Partner term
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayee"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Veritas   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payee"
		И в таблице "List" я перехожу к строке:
			| 'Description'      |
			| 'Company Veritas ' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Posting by Standard Partner term (Veritas)' |
		И в таблице "List" я выбираю текущую строку
	* Check the addition of a base document without selecting a base document
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Когда Проверяю шаги на Исключение:
			|'Дано В активном окне открылась форма с заголовком "Documents for incoming payment"'|
	* Check the currency form connection
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   | 'Payee'             |
			| 'Ferron BP' | 'Company Ferron BP' |
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '100,00'
		И в таблице "PaymentList" я завершаю редактирование строки
			И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   | 'Payee'             |
			| 'Veritas'   | 'Company Veritas '  |
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '200,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   |
			| 'Ferron BP' |
		И     таблица "PaymentListCurrencies" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,84*'             | '17,12'  | '1'            |
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   |
			| 'Veritas' |
		И     таблица "PaymentListCurrencies" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,84*'            | '34,25'  | '1'            |
	* Check the recalculation at the rate in case of date change
		И я перехожу к закладке "Other"
		И в поле 'Date' я ввожу текст '01.11.2018  0:00:00'
		И я перехожу к закладке "Payments"
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   |
			| 'Ferron BP' |
		И     таблица "PaymentListCurrencies" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5*'                | '20,00'  | '1'            |
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   |
			| 'Veritas' |
		И     таблица "PaymentListCurrencies" содержит строки:	
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5*'                | '40*'     | '1'            |
	* Check that it is impossible to post the document without a completed basis document when choosing a partner term with Ap-Ar By documents
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   | 'Payee'             |
			| 'Ferron BP' | 'Company Ferron BP' |
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post'
		Если в сообщениях пользователю есть строка "Basis document is required on line 1" Тогда

Сценарий: _0154112 total amount calculation in в Cash payment
	* Open form Cash payment
		И я открываю навигационную ссылку 'e1cib/list/Document.CashPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check the Total amount calculation when adding rows
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '200,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '50,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '180,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '430,00'
	* Check the Total amount re-calculation when deleting rows
		И в таблице "PaymentList" я перехожу к строке:
		| 'Amount' |
		| '50,00'  |
		И в таблице 'PaymentList' я удаляю строку
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '380,00'
	* Check the Total amount calculation when adding rows
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '80,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '460,00'


Сценарий: _0154113 check filling in and re-filling Bank payment (transaction type Payment to the vendor)
	* Open form Bank payment
		И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check the default transaction type 'Payment from customer'
		И     элемент формы с именем "TransactionType" стал равен 'Payment to the vendor'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
	* Check filling in company
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
	* Check filling inвалюты до выбора банковского счета
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| USD  |
		И в таблице "List" я выбираю текущую строку
	* Bank account selection and check of Currency field refilling
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Bank account, TRY |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Currency" стал равен 'TRY'
	* Check currency re-selection and clearing the "Account" field в случае если валюта зафиксированна по кассе
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| USD  |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Account" стал равен ''
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Bank account, TRY |
		И в таблице "List" я выбираю текущую строку
	* Check the choice of a partner in the tabular section and filling in the legal name if one
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayee"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Payee'|
			| 'DFC'       | 'DFC'  |
		И в таблице "PaymentList" я нажимаю на кнопку 'Delete'
	* Check filling in partner term when adding a partner if the partner has only one
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayee"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Veritas'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Partner term'                               | 'Payee'             |
			| 'Veritas'   | 'Posting by Standard Partner term (Veritas)' | 'Company Veritas' |
		И в таблице "PaymentList" я нажимаю на кнопку 'Delete'
	* Check the display to select only available partner terms
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayee"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payee"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Company Ferron BP |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
		Тогда таблица "List" содержит строки:
			| 'Description'                   |
			| 'Basic Partner terms, TRY'         |
			| 'Basic Partner terms, without VAT' |
			| 'Vendor Ferron, TRY'            |
			| 'Vendor Ferron, USD'            |
			| 'Vendor Ferron, EUR'            |
			| 'Ferron, USD'                   |
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Filter check on the basis documents depending on Partner term
		# temporarily
		Когда Проверяю шаги на Исключение:
		|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		# temporarily
		И таблица  "List" не содержит строки:
			| 'Document amount'| 'Company'      | 'Legal name'        | 'Partner'   |
			| '7 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
		И в таблице "List" я перехожу к строке:
			| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
			| '137 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
		И я нажимаю на кнопку 'Select'
	* Check clearing basis document when clearing partner term
		И в таблице "PaymentList" я выбираю текущую строку
		И я нажимаю кнопку очистить у поля "Partner term"
		И в таблице "PaymentList" я завершаю редактирование строки
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Partner term' | 'Amount' | 'Payee'             | 'Basis document' |
			| 'Ferron BP' | ''          | ''       | 'Company Ferron BP' | ''               |
	* Check the addition of a base document without selecting a base document
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Когда Проверяю шаги на Исключение:
			|'Дано В активном окне открылась форма с заголовком "Documents for incoming payment"'|
	* Checking the unavailability of the choice of the base document when choosing Partner term with the Ap/ar  by Standard Partner term
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayee"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Veritas   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payee"
		И в таблице "List" я перехожу к строке:
			| 'Description'      |
			| 'Company Veritas ' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Posting by Standard Partner term (Veritas)' |
		И в таблице "List" я выбираю текущую строку
	* Check the addition of a base document without selecting a base document
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Когда Проверяю шаги на Исключение:
			|'Дано В активном окне открылась форма с заголовком "Documents for incoming payment"'|
	* Check the currency form connection
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   | 'Payee'             |
			| 'Ferron BP' | 'Company Ferron BP' |
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '100,00'
		И в таблице "PaymentList" я завершаю редактирование строки
			И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   | 'Payee'             |
			| 'Veritas'   | 'Company Veritas '  |
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '200,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   |
			| 'Ferron BP' |
		И     таблица "PaymentListCurrencies" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,84*'             | '17,12'  | '1'            |
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   |
			| 'Veritas' |
		И     таблица "PaymentListCurrencies" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,84*'            | '34,25'  | '1'            |
	* Check the recalculation at the rate in case of date change
		И я перехожу к закладке "Other"
		И в поле 'Date' я ввожу текст '01.11.2018  0:00:00'
		И я перехожу к закладке "Payments"
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   |
			| 'Ferron BP' |
		И     таблица "PaymentListCurrencies" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5*'                | '20,00'  | '1'            |
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   |
			| 'Veritas' |
		И     таблица "PaymentListCurrencies" содержит строки:	
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5*'                | '40*'     | '1'            |
	* Check that it is impossible to post the document without a completed basis document when choosing a partner term with Ap-Ar By documents
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   | 'Payee'             |
			| 'Ferron BP' | 'Company Ferron BP' |
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post'
		Если в сообщениях пользователю есть строка "Basis document is required on line 1" Тогда

Сценарий: _0154114 total amount calculation in в Bank payment
	* Open form Bank payment
		И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check the Total amount calculation when adding rows
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '200,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '50,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '180,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '430,00'
	* Check the Total amount re-calculation when deleting rows
		И в таблице "PaymentList" я перехожу к строке:
		| 'Amount' |
		| '50,00'  |
		И в таблице 'PaymentList' я удаляю строку
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '380,00'
	* Check the Total amount calculation when adding rows
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '80,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '460,00'

Сценарий: _01541140 total amount calculation in в Incoming payment order
	* Open form Bank payment
		И я открываю навигационную ссылку 'e1cib/list/Document.IncomingPaymentOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check the Total amount calculation when adding rows
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '200,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '50,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '180,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '430,00'
	* Check the Total amount re-calculation when deleting rows
		И в таблице "PaymentList" я перехожу к строке:
		| 'Amount' |
		| '50,00'  |
		И в таблице 'PaymentList' я удаляю строку
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '380,00'
	* Check the Total amount calculation when adding rows
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '80,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '460,00'

Сценарий: _01541141 total amount calculation in в Outgoing payment order
	* Open form Bank payment
		И я открываю навигационную ссылку 'e1cib/list/Document.OutgoingPaymentOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check the Total amount calculation when adding rows
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '200,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '50,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '180,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '430,00'
	* Check the Total amount re-calculation when deleting rows
		И в таблице "PaymentList" я перехожу к строке:
		| 'Amount' |
		| '50,00'  |
		И в таблице 'PaymentList' я удаляю строку
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '380,00'
	* Check the Total amount calculation when adding rows
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '80,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '460,00'

Сценарий: _0154115 check filling in and re-filling Cash transfer order
	* Open form Cash transfer order
		И я открываю навигационную ссылку 'e1cib/list/Document.CashTransferOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Check filling in currency when selecting a bank/cash account with fixed currency
		И я нажимаю кнопку выбора у поля "Sender"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Receiver"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'USD'      | 'Bank account, USD' |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "ReceiveCurrency" стал равен 'USD'
		И     элемент формы с именем "SendCurrency" стал равен 'TRY'
	* Check filling in currency when re-select "Sender" and "Receiver"
		И я нажимаю кнопку выбора у поля "Sender"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'EUR'      | 'Bank account, EUR' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Receiver"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "ReceiveCurrency" стал равен 'TRY'
		И     элемент формы с именем "SendCurrency" стал равен 'EUR'
	* Check filling in ammount in Receive amount from Send amount in the case of the same currencies
		И я нажимаю кнопку выбора у поля "Sender"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Cash desk №2' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Send currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Send amount' я ввожу текст '100,00'
		И я перехожу к следующему реквизиту
		И     у элемента формы с именем "ReceiveAmount" текст редактирования стал равен '100,00'
		И     у элемента формы с именем "SendAmount" текст редактирования стал равен '100,00'
	* Check filling in Send date and Receive date
		И в поле 'Date' я ввожу текст '01.01.2020  0:00:00'
		И я перехожу к следующему реквизиту
		И я запоминаю значение поля "Send date" как "Senddate"
		Тогда переменная "Senddate" имеет значение "01.01.2020"
		И я запоминаю значение поля "Receive date" как "Receivedate"
		Тогда переменная "Receivedate" имеет значение "01.01.2020"
		И в поле 'Date' я ввожу текст '01.03.2020  0:00:00'
		И я перехожу к следующему реквизиту
		И я запоминаю значение поля "Send date" как "Senddate"
		Тогда переменная "Senddate" имеет значение "01.03.2020"
		И я запоминаю значение поля "Receive date" как "Receivedate"
		Тогда переменная "Receivedate" имеет значение "01.03.2020"
	* Checking the drawing of Cash advance holder field in case of currency exchange through cash accounts
		И я нажимаю кнопку выбора у поля "Sender"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Cash desk №2' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Send currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Receiver"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Cash desk №2' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Receive currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "CashAdvanceHolder" стал равен ''
		И я нажимаю кнопку выбора у поля "Cash advance holder"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Arina Brown' |
		И в таблице "List" я выбираю текущую строку
	* Check form by currency
			И в поле 'Receive amount' я ввожу текст '584,00'
			И я перехожу к следующему реквизиту
			И     таблица "ObjectCurrencies" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Local currency'     | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'            | '564,97' | '1'            |
			| 'Reporting currency' | 'Reporting' | 'USD'           | 'USD'      | '1'                 | '100'    | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '584'    | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '100,00' | '1'            |

Сценарий: _01541151 check that the amount sent and received in Cash transfer order is the same
	* Check cash transfer between two cash account
		* Open form Cash transfer order
			И я открываю навигационную ссылку 'e1cib/list/Document.CashTransferOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
		* Filling data
			И я нажимаю кнопку выбора у поля "Sender"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Cash desk №2' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Send currency"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Send amount' я ввожу текст '100,00'
			И я нажимаю кнопку выбора у поля "Receiver"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Cash desk №1' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Receive currency"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Receive amount' я ввожу текст '120,00'
		* Check message when post document
			И я нажимаю на кнопку 'Post'
			Затем я жду, что в сообщениях пользователю будет подстрока "Currency transfer is possible only when amounts is equal." в течение 10 секунд
			И я закрыл все окна клиентского приложения
	* Check cash transfer from cash account to bank account
		* Open form Cash transfer order
			И я открываю навигационную ссылку 'e1cib/list/Document.CashTransferOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
		* Filling data
			И я нажимаю кнопку выбора у поля "Sender"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Cash desk №2' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Send currency"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Send amount' я ввожу текст '100,00'
			И я нажимаю кнопку выбора у поля "Receiver"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Bank account, TRY' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Receive amount' я ввожу текст '120,00'
		* Check message when post document
			И я нажимаю на кнопку 'Post'
			Затем я жду, что в сообщениях пользователю будет подстрока "Currency transfer is possible only when amounts is equal." в течение 10 секунд
			И я закрыл все окна клиентского приложения
	* Check cash transfer from bank account to cash account
		* Open form Cash transfer order
			И я открываю навигационную ссылку 'e1cib/list/Document.CashTransferOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
		* Filling data
			И я нажимаю кнопку выбора у поля "Receiver"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Cash desk №2' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Receive currency"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Send amount' я ввожу текст '100,00'
			И я нажимаю кнопку выбора у поля "Sender"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Bank account, TRY' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Receive amount' я ввожу текст '120,00'
		* Check message when post document
			И я нажимаю на кнопку 'Post'
			Затем я жду, что в сообщениях пользователю будет подстрока "Currency transfer is possible only when amounts is equal." в течение 10 секунд
			И я закрыл все окна клиентского приложения
	* Check cash transfer between two bank account
		* Open form Cash transfer order
			И я открываю навигационную ссылку 'e1cib/list/Document.CashTransferOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
		* Filling data
			И я нажимаю кнопку выбора у поля "Receiver"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Bank account 2, EUR' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Send amount' я ввожу текст '100,00'
			И я нажимаю кнопку выбора у поля "Sender"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Bank account, EUR' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Receive amount' я ввожу текст '120,00'
		* Check message when post document
			И я нажимаю на кнопку 'Post'
			Затем я жду, что в сообщениях пользователю будет подстрока "Currency transfer is possible only when amounts is equal." в течение 10 секунд
			И я закрыл все окна клиентского приложения



Сценарий: _0154116 check filling in and re-filling Cash expence
	* Open form Cash expence
		И я открываю навигационную ссылку 'e1cib/list/Document.CashExpense'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filter check by Account depending on the company
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		Тогда таблица "List" не содержит строки:
			| 'Description'       | 'Currency' |
			| 'Cash desk №1'      | ''         |
			| 'Cash desk №2'      | ''         |
		И Я закрываю окно 'Cash/Bank accounts'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		Тогда таблица "List" содержит строки:
			| 'Description'       | 'Currency' |
			| 'Cash desk №1'      | ''         |
			| 'Cash desk №2'      | ''         |
			| 'Cash desk №3'      | ''         |
			| 'Bank account, TRY' | 'TRY'      |
			| 'Bank account, USD' | 'USD'      |
			| 'Bank account, EUR' | 'EUR'      |
			| 'Cash desk №4'      | 'TRY'      |
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Check the Net amount and VAT calculation when filling in the Total amount
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListBusinessUnit"
		И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'Accountants office' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListExpenseType"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListExpenseType"
		И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'Telephone communications' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListTotalAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListTotalAmount' я ввожу текст '220,00'
		Тогда таблица "PaymentList" содержит строки:
			| 'Net amount' | 'Expense type'             | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '186,44'     | 'Telephone communications' | 'TRY'      | '18%' | '33,56'      | '220,00'       |
	* Check the recalculation of Total amount when Tax changes
		И я перехожу к закладке "Tax list"
		И в таблице "TaxTree" я активизирую поле "Manual amount"
		И в таблице "TaxTree" я перехожу к строке:
			| 'Business unit'     |
			| 'Accountants office' |
		И в таблице "TaxTree" я выбираю текущую строку
		И в таблице "TaxTree" в поле 'Manual amount' я ввожу текст '33,55'
		И в таблице "TaxTree" я завершаю редактирование строки
		И я перехожу к закладке "Payment list"
		Тогда таблица "PaymentList" содержит строки:
			| 'Net amount' | 'Expense type'               | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '186,44'     | 'Telephone communications'   | 'TRY'      | '18%' | '33,55'      | '219,99'       |
	* Check the Net amount recalculation when Total amount changes and with changes in taxes
		И в таблице "PaymentList" в поле с именем 'PaymentListTotalAmount' я ввожу текст '220,00'
		Тогда таблица "PaymentList" содержит строки:
			| 'Net amount' | 'Business unit'      | 'Expense type'             | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '186,45'     | 'Accountants office' | 'Telephone communications' | 'TRY'      | '18%' | '33,55'      | '220,00'       |
	* Check the Total amount recalculation when Net amount changes and with changes in taxes
		И в таблице "PaymentList" в поле с именем 'PaymentListNetAmount' я ввожу текст '187,00'
		Тогда таблица "PaymentList" содержит строки:
			| 'Net amount' | 'Expense type'                     | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '187,00'     | 'Telephone communications'         | 'TRY'      | '18%' | '33,55'      | '220,55'       |
	* Check the currency form connection
		И     таблица "PaymentListCurrencies" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '37,77'  | '1'            |
	* Add one more line
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListBusinessUnit"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Front office'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListExpenseType"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListExpenseType"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Software'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле "VAT"
		И в таблице "PaymentList" из выпадающего списка "VAT" я выбираю точное значение '18%'
		И в таблице "PaymentList" в поле с именем 'PaymentListNetAmount' я ввожу текст '200,00'
		И в таблице "TaxTree" я разворачиваю строку:
			| 'Amount' | 'Currency' | 'Manual amount' | 'Tax' |
			| '69,66'  | 'TRY'      | '69,55'         | 'VAT' |
		И в таблице "PaymentList" я завершаю редактирование строки
	* Manual tax correction by line
		И я перехожу к закладке "Tax list"
		И в таблице "TaxTree" я перехожу к строке:
			| 'Amount' | 'Business unit' | 'Currency' |
			| '36,00'  | 'Front office'  | 'TRY'      |
		И в таблице "TaxTree" я выбираю текущую строку
		И в таблице "TaxTree" в поле 'Manual amount' я ввожу текст '38,00'
		И в таблице "TaxTree" я завершаю редактирование строки
		И я перехожу к закладке "Payment list"
		И     таблица "PaymentList" содержит строки:
			| 'Net amount' | 'Business unit'      | 'Expense type'             | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '187,00'     | 'Accountants office' | 'Telephone communications' | 'TRY'      | '18%' | '33,55'      | '220,55'       |
			| '200,00'     | 'Front office'       | 'Software'                 | 'TRY'      | '18%' | '38,00'      | '238,00'       |
	* Delete a line and check the total amount conversion
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListCurrency"
		И в таблице "PaymentList" я перехожу к строке:
			| 'Business unit'      | 'Currency' | 'Expense type'             | 'Net amount' | 'Tax amount' | 'Total amount' | 'VAT' |
			| 'Accountants office' | 'TRY'      | 'Telephone communications' | '187,00'     | '33,55'      | '220,55'       | '18%' |
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListContextMenuDelete'
		И     у элемента формы с именем "PaymentListTotalNetAmount" текст редактирования стал равен '200,00'
		И     у элемента формы с именем "PaymentListTotalTaxAmount" текст редактирования стал равен '38,00'
		И     у элемента формы с именем "PaymentListTotalTotalAmount" текст редактирования стал равен '238,00'
	* Change Account
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'USD'      | 'Bank account, USD' |
		И в таблице "List" я выбираю текущую строку
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И     таблица "PaymentList" содержит строки:
			| 'Net amount' | 'Business unit' | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'  | 'Software'     | 'USD'      | '18%' | '38,00'      | '238,00'       |
	* Check that the Account does not change when you click No in the message window
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И     таблица "PaymentList" не содержит строки:
			| 'Net amount' | 'Business unit' | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'  | 'Software'     | 'USD'      | '18%' | '38,00'      | '238,00'       |
	* Change the company (without taxes) and check to delete the VAT column
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		И я жду, что таблица "PaymentList" не станет содержать строки в течение 20 секунд:
		| 'VAT' | 'Tax amount' |
		| '18%' | '38,00'      |
	* Change the company to the one with taxes and check the form by currency
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		* Изменение курса в форме по валютам
			И в таблице "PaymentListCurrencies" я перехожу к строке:
			| 'Amount' | 'Currency' | 'Currency from' | 'Movement type'      | 'Multiplicity' | 'Rate presentation' | 'Type'      |
			| '40,41'  | 'USD'      | 'TRY'           | 'Reporting currency' | '1'            | '5,8400'            | 'Reporting' |
			И в таблице "PaymentListCurrencies" я активизирую поле с именем "PaymentListCurrenciesAmount"
			И в таблице "PaymentListCurrencies" я выбираю текущую строку
			И в таблице "PaymentListCurrencies" в поле с именем 'PaymentListCurrenciesAmount' я ввожу текст '50,00'
			И в таблице "PaymentListCurrencies" я перехожу к строке:
			| 'Amount' | 'Currency' | 'Currency from' | 'Movement type'      | 'Multiplicity' | 'Rate presentation' | 'Type'      |
			| '50,00'  | 'USD'      | 'TRY'           | 'Reporting currency' | '1'            | '4,7200'            | 'Reporting' |
	* Add one more line with different cureency
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Cash desk №2' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListBusinessUnit"
		И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'Accountants office' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListExpenseType"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Software'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListCurrency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле "VAT"
		И в таблице "PaymentList" из выпадающего списка "VAT" я выбираю точное значение '0%'
		И в таблице "PaymentList" в поле с именем 'PaymentListNetAmount' я ввожу текст '100,00'
		И     таблица "PaymentList" содержит строки:
			| 'Net amount' | 'Business unit'      | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'       | 'Software'     | 'TRY'      | '18%' | '36,00'      | '236,00'       |
			| '100,00'     | 'Accountants office' | 'Software'     | 'USD'      | '0%'  | ''           | '100,00'       |
		И   в таблице "PaymentList" я перехожу к строке:
			| 'Net amount' | 'Business unit'      | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '100,00'     | 'Accountants office' | 'Software'     | 'USD'      | '0%'  | ''           | '100,00'       |
	* Check the addition of a line to the form by currency
		И  в таблице "PaymentListCurrencies" я перехожу к строке:
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'Local currency'     | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'             | '564,97' | '1'            |
	* Change of currency on the first line and check of form on currencies
		И   в таблице "PaymentList" я перехожу к строке:
			| 'Net amount' | 'Business unit'      | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'       | 'Software'     | 'TRY'      | '18%' | '36,00'      | '236,00'       |
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListCurrency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		И в таблице "List" я выбираю текущую строку
		И   в таблице "PaymentList" я перехожу к строке:
			| 'Net amount' | 'Business unit'      | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'       | 'Software'     | 'USD'      | '18%' | '36,00'      | '236,00'       |
		И   в таблице "PaymentListCurrencies" я перехожу к строке:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
			| 'Local currency'     | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'            | '1 333,33' | '1'            |
	* Manual correction of tax rate and check of tax calculations
		И в таблице "PaymentList" я перехожу к строке:
			| 'Business unit' | 'Currency' | 'Expense type' | 'Net amount' | 'Tax amount' | 'Total amount' | 'VAT' |
			| 'Front office'  | 'USD'      | 'Software'     | '200,00'     | '36,00'      | '236,00'       | '18%' |
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" из выпадающего списка "VAT" я выбираю точное значение '8%'
		И     таблица "PaymentList" содержит строки:
			| 'Net amount' | 'Business unit' | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'  | 'Software'     | 'USD'      | '8%'  | '16,00'      | '236,00'       |
		И     таблица "TaxTree" содержит строки:
			| 'Tax' | 'Tax rate' | 'Currency' | 'Amount' | 'Manual amount' |
			| 'VAT' | ''         | 'USD'      | '16,00'  | '16,00'         |
			| 'VAT' | '8%'       | 'USD'      | '16,00'  | '16,00'         |
	И я закрыл все окна клиентского приложения





Сценарий: _0154117 check filling in and re-filling Cash revenue
	* Open form Cash revenue
		И я открываю навигационную ссылку 'e1cib/list/Document.CashRevenue'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filter check by Account depending on the company
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		Тогда таблица "List" не содержит строки:
			| 'Description'       | 'Currency' |
			| 'Cash desk №1'      | ''         |
			| 'Cash desk №2'      | ''         |
		И Я закрываю окно 'Cash/Bank accounts'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		Тогда таблица "List" содержит строки:
			| 'Description'       | 'Currency' |
			| 'Cash desk №1'      | ''         |
			| 'Cash desk №2'      | ''         |
			| 'Cash desk №3'      | ''         |
			| 'Bank account, TRY' | 'TRY'      |
			| 'Bank account, USD' | 'USD'      |
			| 'Bank account, EUR' | 'EUR'      |
			| 'Cash desk №4'      | 'TRY'      |
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Check the Net amount and VAT calculation when filling in the Total amount
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListBusinessUnit"
		И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'Accountants office' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListRevenueType"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListRevenueType"
		И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'Telephone communications' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListTotalAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListTotalAmount' я ввожу текст '220,00'
		Тогда таблица "PaymentList" содержит строки:
			| 'Net amount' | 'Revenue type'             | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '186,44'     | 'Telephone communications' | 'TRY'      | '18%' | '33,56'      | '220,00'       |
	* Check the recalculation of Total amount when Tax changes
		И я перехожу к закладке "Tax list"
		И в таблице "TaxTree" я активизирую поле "Manual amount"
		И в таблице "TaxTree" я перехожу к строке:
		| 'Business unit'     |
		| 'Accountants office' |
		И в таблице "TaxTree" я выбираю текущую строку
		И в таблице "TaxTree" в поле 'Manual amount' я ввожу текст '33,55'
		И в таблице "TaxTree" я завершаю редактирование строки
		И я перехожу к закладке "Payment list"
		Тогда таблица "PaymentList" содержит строки:
		| 'Net amount' | 'Revenue type'               | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
		| '186,44'     | 'Telephone communications'   | 'TRY'      | '18%' | '33,55'      | '219,99'       |
	* Check the Net amount recalculation when Total amount changes and with changes in taxes
		И в таблице "PaymentList" в поле с именем 'PaymentListTotalAmount' я ввожу текст '220,00'
		Тогда таблица "PaymentList" содержит строки:
		| 'Net amount' | 'Business unit'      | 'Revenue type'             | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
		| '186,45'     | 'Accountants office' | 'Telephone communications' | 'TRY'      | '18%' | '33,55'      | '220,00'       |
	* Check the Total amount recalculation when Net amount changes and with changes in taxes
		И в таблице "PaymentList" в поле с именем 'PaymentListNetAmount' я ввожу текст '187,00'
		Тогда таблица "PaymentList" содержит строки:
		| 'Net amount' | 'Revenue type'                     | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
		| '187,00'     | 'Telephone communications'         | 'TRY'      | '18%' | '33,55'      | '220,55'       |
	* Check the currency form connection
		И     таблица "PaymentListCurrencies" содержит строки:
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '37,77'  | '1'            |
	* Add one more line
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListBusinessUnit"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Front office'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListRevenueType"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListRevenueType"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Software'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле "VAT"
		И в таблице "PaymentList" из выпадающего списка "VAT" я выбираю точное значение '18%'
		И в таблице "PaymentList" в поле с именем 'PaymentListNetAmount' я ввожу текст '200,00'
		И в таблице "TaxTree" я разворачиваю строку:
			| 'Amount' | 'Currency' | 'Manual amount' | 'Tax' |
			| '69,66'  | 'TRY'      | '69,55'         | 'VAT' |
		И в таблице "PaymentList" я завершаю редактирование строки
	* Manual tax correction by line
		И я перехожу к закладке "Tax list"
		И в таблице "TaxTree" я перехожу к строке:
			| 'Amount' | 'Business unit' | 'Currency' |
			| '36,00'  | 'Front office'  | 'TRY'      |
		И в таблице "TaxTree" я выбираю текущую строку
		И в таблице "TaxTree" в поле 'Manual amount' я ввожу текст '38,00'
		И в таблице "TaxTree" я завершаю редактирование строки
		И я перехожу к закладке "Payment list"
		И     таблица "PaymentList" содержит строки:
			| 'Net amount' | 'Business unit'      | 'Revenue type'             | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '187,00'     | 'Accountants office' | 'Telephone communications' | 'TRY'      | '18%' | '33,55'      | '220,55'       |
			| '200,00'     | 'Front office'       | 'Software'                 | 'TRY'      | '18%' | '38,00'      | '238,00'       |
	* Delete a line and check the total amount conversion
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListCurrency"
		И в таблице "PaymentList" я перехожу к строке:
			| 'Business unit'      | 'Currency' | 'Revenue type'             | 'Net amount' | 'Tax amount' | 'Total amount' | 'VAT' |
			| 'Accountants office' | 'TRY'      | 'Telephone communications' | '187,00'     | '33,55'      | '220,55'       | '18%' |
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListContextMenuDelete'
		И     у элемента формы с именем "PaymentListTotalNetAmount" текст редактирования стал равен '200,00'
		И     у элемента формы с именем "PaymentListTotalTaxAmount" текст редактирования стал равен '38,00'
		И     у элемента формы с именем "PaymentListTotalTotalAmount" текст редактирования стал равен '238,00'
	* Change Account
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'USD'      | 'Bank account, USD' |
		И в таблице "List" я выбираю текущую строку
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И     таблица "PaymentList" содержит строки:
			| 'Net amount' | 'Business unit' | 'Revenue type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'  | 'Software'     | 'USD'      | '18%' | '38,00'      | '238,00'       |
	* Check that the Account does not change when you click in the No message window
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И     таблица "PaymentList" не содержит строки:
			| 'Net amount' | 'Business unit' | 'Revenue type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'  | 'Software'     | 'USD'      | '18%' | '38,00'      | '238,00'       |
	* Change the company (without taxes) and check to delete the VAT column
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		И я жду, что таблица "PaymentList" не станет содержать строки в течение 20 секунд:
		| 'VAT' | 'Tax amount' |
		| '18%' | '38,00'      |
	* Check the manually tax rate correction
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле "VAT"
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" из выпадающего списка "VAT" я выбираю точное значение '8%'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     таблица "PaymentList" содержит строки:
			| 'Net amount' | 'Revenue type' | 'Total amount' | 'Currency' | 'VAT' | 'Tax amount' |
			| '200,00'     | 'Software'     | '236,00'       | 'TRY'      | '8%'  | '16,00'      |
		И     таблица "TaxTree" содержит строки:
			| 'Tax' | 'Tax rate' | 'Currency' | 'Amount' | 'Manual amount' |
			| 'VAT' | ''         | 'TRY'      | '16,00'  | '16,00'         |
			| 'VAT' | '8%'       | 'TRY'      | '16,00'  | '16,00'         |
		И я закрыл все окна клиентского приложения

Сценарий: _0154118 check the details cleaning on the form Cash reciept 
	* Open form CashReceipt
		И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document CashReceipt
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Cash/Bank accounts"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №2 |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| TRY  |
		И в таблице "List" я выбираю текущую строку
	* Fillin in Partner, Payer and Partner term
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле "Partner"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Nicoletta   |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
		| 'Partner'   | 'Partner term'                              | 'Payer'             |
		| 'Nicoletta' | 'Posting by Standard Partner term Customer' | 'Company Nicoletta' |
	* Check clearing fields 'Partner term' and 'Payer' when re-selecting the type of operation to Currency exchange
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner'   | 'Amount' | 'Amount exchange' | 'Planning transaction basis' |
		| '1' | 'Nicoletta' | ''       | ''                | ''                          |
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner'   | 'Partner term' | 'Amount' | 'Payer' | 'Basis document' | 'Planning transaction basis' |
		| '1' | 'Nicoletta' | ''          | ''       | ''      | ''               | ''                          |
	* Check clearing fields 'Partner' when re-selecting the type of operation to Cash transfer order
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner' | 'Partner term' | 'Amount' | 'Payer' | 'Basis document' | 'Planning transaction basis' |
		| '1' | ''        | ''          | ''       | ''      | ''               | ''                          |
		И Я закрыл все окна клиентского приложения


Сценарий: _0154119 check the details cleaning on the form Cash payment when re-selecting the type of operation
	* Open form CashPayment
		И я открываю навигационную ссылку 'e1cib/list/Document.CashPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document CashPayment
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Cash/Bank accounts"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №2 |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| TRY  |
		И в таблице "List" я выбираю текущую строку
	* Fillin in Partner, Payer and Partner term
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле "Partner"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Nicoletta   |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
		| 'Partner'   | 'Partner term'                              | 'Payee'             |
		| 'Nicoletta' | 'Posting by Standard Partner term Customer' | 'Company Nicoletta' |
	* Check clearing fields 'Partner term' and 'Payee' when re-selecting the type of operation to Currency exchange
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner'   | 'Amount' | 'Planning transaction basis' |
		| '1' | 'Nicoletta' | ''       | ''                          |
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner'   | 'Partner term' | 'Amount' | 'Payee' | 'Basis document' | 'Planning transaction basis' |
		| '1' | 'Nicoletta' | ''          | ''       | ''      | ''               | ''                          |
	* Check clearing fields 'Partner' when re-selecting the type of operation to Cash transfer order
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner' | 'Partner term' | 'Amount' | 'Payee' | 'Basis document' | 'Planning transaction basis' |
		| '1' | ''        | ''          | ''       | ''      | ''               | ''                          |
		И Я закрыл все окна клиентского приложения

Сценарий: _0154120 check the details cleaning on the form Bank reciept when re-selecting the type of operation
	* Open form BankReceipt
		И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document CashReceipt
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Bank account, TRY |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| TRY  |
		И в таблице "List" я выбираю текущую строку
	* Fillin in Partner, Payer and Partner term
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле "Partner"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Nicoletta   |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
		| 'Partner'   | 'Partner term'                              | 'Payer'             |
		| 'Nicoletta' | 'Posting by Standard Partner term Customer' | 'Company Nicoletta' |
	* Check clearing fields 'Partner term' and 'Payer' when re-selecting the type of operation to Currency exchange
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Amount' | 'Amount exchange' | 'Planning transaction basis' |
		| '1' | ''       | ''                | ''                          |
		* Check filling in Transit account из Accountant
			И     элемент формы с именем "TransitAccount" стал равен 'Transit Main'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner'   | 'Partner term' | 'Amount' | 'Payer' | 'Basis document' | 'Planning transaction basis' |
		| '1' | ''          | ''          | ''       | ''      | ''               | ''                          |
		И     элемент формы с именем "TransitAccount" стал равен ''
	* Check clearing fields 'Partner' when re-selecting the type of operation to Cash transfer order
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner' | 'Partner term' | 'Amount' | 'Payer' | 'Basis document' | 'Planning transaction basis' |
		| '1' | ''        | ''          | ''       | ''      | ''               | ''                          |
		И Я закрыл все окна клиентского приложения


Сценарий: _0154121 check the details cleaning on the form Bank payment when re-selecting the type of operation
	* Open form BankPayment
		И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document BankPayment
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Bank account, TRY |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| TRY  |
		И в таблице "List" я выбираю текущую строку
	* Fillin in Partner, Payer and Partner term
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле "Partner"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Nicoletta   |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
		| 'Partner'   | 'Partner term'                              | 'Payee'             |
		| 'Nicoletta' | 'Posting by Standard Partner term Customer' | 'Company Nicoletta' |
	* Check clearing fields 'Partner term' and 'Payee' when re-selecting the type of operation to Currency exchange
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Amount' | 'Planning transaction basis' |
		| '1' | ''       | ''                          |
		* Check filling in Transit account из Accountant
			И     элемент формы с именем "TransitAccount" стал равен 'Transit Main'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner'   | 'Partner term' | 'Amount' | 'Payee' | 'Basis document' | 'Planning transaction basis' |
		| '1' | ''          | ''          | ''       | ''      | ''               | ''                          |
		И     элемент формы с именем "TransitAccount" стал равен ''
	* Check clearing fields 'Partner' when re-selecting the type of operation to Cash transfer order
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner' | 'Partner term' | 'Amount' | 'Payee' | 'Basis document' | 'Planning transaction basis' |
		| '1' | ''        | ''          | ''       | ''      | ''               | ''                          |
		И Я закрыл все окна клиентского приложения


Сценарий: _0154122 check filling in and re-filling Reconcilation statement
	* Open document form
		И я открываю навигационную ссылку "e1cib/list/Document.ReconciliationStatement"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in basic details
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Begin period"
		И в поле 'Begin period' я ввожу текст '01.01.2020'
		И в поле 'End period' я ввожу текст   '01.01.2025'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Company Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я нажимаю на кнопку 'Fill'
	* Check that the transaction table is filled out
		И Пока в таблице "Transactions" количество строк ">" 0 Тогда
		И я нажимаю на кнопку 'Post'
		И     таблица "Transactions" не содержит строки:
			| 'Document'            | 'Credit'     | 'Debit'     |
			| 'Purchase invoice 1*' | '137 000,00' | ''          |
			| 'Sales invoice 1*'    | ''           | '4 350,00'  |
			| 'Sales invoice 2*'    | ''           | '11 099,93' |
	* Check re-filling when re-selecting a partner
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
		И в таблице "Transactions" я нажимаю на кнопку 'Fill'
		И     таблица "Transactions" содержит строки:
			| 'Document'            | 'Credit'     | 'Debit'     |
			| 'Purchase invoice 1*' | '137 000,00' | ''          |
			| 'Sales invoice 1*'    | ''           | '4 350,00'  |
			| 'Sales invoice 2*'    | ''           | '11 099,93' |
		И я нажимаю на кнопку 'Post'
	* Check re-filling when re-selecting a currency
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' |
			| 'USD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я нажимаю на кнопку 'Fill'
		И     таблица "Transactions" не содержит строки:
			| 'Document'            | 'Credit'     | 'Debit'     |
			| 'Purchase invoice 1*' | '137 000,00' | ''          |
			| 'Sales invoice 1*'    | ''           | '4 350,00'  |
			| 'Sales invoice 2*'    | ''           | '11 099,93' |
	* Проверка перезаполнения при перевыборе компании
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я нажимаю на кнопку 'Fill'
		Тогда в таблице "Transactions" количество строк "равно" 0
	* Check re-filling when re-selecting a legal name (partner previous)
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Second Company Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И Пока в таблице "Transactions" количество строк ">" 0 Тогда
		И я нажимаю на кнопку 'Post'
		И Я закрыл все окна клиентского приложения


Сценарий: _0154123 filling in Transit account from Account when exchanging currency (Bank Receipt)
	И Я закрыл все окна клиентского приложения
	* Open form Bank Receipt and select transaction type Currency exchange
		И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
	* Check filling in Transit account 
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Bank account, USD' |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "TransitAccount" стал равен 'Transit Second'
	* Check filling in Transit account when re-select Bank account
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "TransitAccount" стал равен 'Transit Main'
		И Я закрыл все окна клиентского приложения

Сценарий: _0154124 filling in Transit account from Account when exchanging currency (Bank Payment)
	И Я закрыл все окна клиентского приложения
	* Open form Bank Payment and select transaction type Currency exchange
		И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
	* Check filling in Transit account 
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'USD'      | 'Bank account, USD' |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "TransitAccount" стал равен 'Transit Second'
	* Check filling in Transit account when re-select Bank account
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "TransitAccount" стал равен 'Transit Main'
		И Я закрыл все окна клиентского приложения
	* Проверка выбора Transit account

Сценарий: _0154125 check the selection by Planing transaction basis in Bank payment document in case of currency exchange
	* Open form Bank Payment and select transaction type Currency exchange
		И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
	* Filling in the details of the document
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'         |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Check the selection by Planing transaction basis
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'            | 'Company'      | 'Send currency' |
		| '13'     | 'Bank account, TRY' | 'Main Company' | 'TRY'           |
		И в таблице "List" я перехожу к строке:
		| 'Number' | 'Sender'            | 'Company'      | 'Send currency' |
		| '13'     | 'Bank account, TRY' | 'Main Company' | 'TRY'           |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '100,00'
	* Check that the selected document is in BankPayment
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planning transaction basis' |
		| '100,00' | 'Cash transfer order 13*'   |
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		И в таблице "List" я перехожу к строке:
		| 'Number' | 'Sender'            | 'Company'      | 'Send currency' |
		| '13'     | 'Bank account, TRY' | 'Main Company' | 'TRY'           |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '100,00'
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form when post Bank Payment
		И я нажимаю на кнопку 'Post'
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		И в таблице "List" я перехожу к строке:
		| 'Number' | 'Sender'            | 'Company'      | 'Send currency' |
		| '13'     | 'Bank account, TRY' | 'Main Company' | 'TRY'           |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '100,00'
	* Check that the Planing transaction basis selection form displays the document that has already been selected earlier (line deleted)
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю на кнопку 'Delete'
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '200,00'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		И в таблице "List" я перехожу к строке:
		| 'Number' | 'Sender'            | 'Company'      | 'Send currency' |
		| '13'     | 'Bank account, TRY' | 'Main Company' | 'TRY'           |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '200,00'
		И я нажимаю на кнопку 'Post'
		И я запоминаю значение поля "Number" как "Number"
	* Check not clearing Planning transaction basis in case of cancellation when changing the type of transaction
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Cancel'
	* Check clearing Planing transaction basis in case of transaction type change
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planning transaction basis' |
		| '200,00' | ''                          |
	И я закрыл все окна клиентского приложения
	

Сценарий: _0154126 check the selection by Planing transaction basis in BankReceipt in case of currency exchange
	* Open form Bank Payment and select transaction type Currency exchange
		И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
	* Filling in the details of the document
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'         |
			| 'EUR'      | 'Bank account, EUR' |
		И в таблице "List" я выбираю текущую строку
	* Check the selection by Planing transaction basis
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '100,00'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'            | 'Send currency' | 'Company'      |
		| '13'     | 'Bank account, TRY' | 'TRY'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '100,00'
	* Check that the selected document is in BankPayment
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planning transaction basis' |
		| '100,00' | 'Cash transfer order 13*'   |
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'            | 'Send currency'    | 'Company'      |
		| '13'     | 'Bank account, TRY' | 'TRY'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '100,00'
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form при проведенном Bank Receipt
		И я нажимаю на кнопку 'Post'
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'            | 'Send currency' | 'Company'      |
		| '13'     | 'Bank account, TRY' | 'TRY'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '100,00'
	* Check that the Planing transaction basis selection form displays the document that has already been selected earlier (line deleted)
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю на кнопку 'Delete'
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'            | 'Send currency' | 'Company'      |
		| '13'     | 'Bank account, TRY' | 'TRY'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '200,00'
		И я нажимаю на кнопку 'Post'
	* Check not clearing Planning transaction basis in case of cancellation when changing the type of transaction
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Cancel'
	* Check clearing Planing transaction basis in case of transaction type change
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planning transaction basis' |
		| '200,00' | ''                          |
	И я закрыл все окна клиентского приложения


Сценарий: _0154127 check the selection by Planing transaction basis in Cash Payment in case of currency exchange
	* Open form CashPayment and select transaction type Currency exchange
		И я открываю навигационную ссылку 'e1cib/list/Document.CashPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
	* Filling in the details of the document
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Cash/Bank accounts"
		И в таблице "List" я перехожу к строке:
			| 'Description'         |
			| 'Cash desk №2' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Currency"
		И в таблице "List" я перехожу к строке:
		| 'Code' | 'Description'     |
		| 'USD'  | 'American dollar' |
		И в таблице "List" я выбираю текущую строку
	* Check the selection by Planing transaction basis
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'       | 'Company'      | 'Send currency' |
		| '11'     | 'Cash desk №2' | 'Main Company' | 'USD'           |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '100,00'
	* Check that the selected document is in Cash Payment
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planning transaction basis' |
		| '100,00' | 'Cash transfer order 11*'   |
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'       | 'Company'      | 'Send currency' |
		| '11'     | 'Cash desk №2' | 'Main Company' | 'USD'           |
		И я нажимаю на кнопку с именем 'FormChoose'
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form when Cash Payment posted
		И я нажимаю на кнопку 'Post'
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'       | 'Company'      | 'Send currency' |
		| '11'     | 'Cash desk №2' | 'Main Company' | 'USD'           |
		И я нажимаю на кнопку с именем 'FormChoose'
	* Check that the Planing transaction basis selection form displays the document that has already been selected earlier (line deleted)
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю на кнопку 'Delete'
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'       | 'Company'      | 'Send currency' |
		| '11'     | 'Cash desk №2' | 'Main Company' | 'USD'           |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '200,00'
		И я нажимаю на кнопку 'Post'
	* Check not clearing Planning transaction basis in case of cancellation when changing the type of transaction
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Cancel'
	* Check clearing Planing transaction basis in case of transaction type change
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planning transaction basis' |
		| '200,00' | ''                          |
	И я закрыл все окна клиентского приложения


Сценарий: _0154128 check the selection by Planing transaction basis in CashReceipt in case of currency exchange
	* Open form CashReceipt and select transaction type Currency exchange
		И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
	* Filling in the details of the document
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Cash/Bank accounts"
		И в таблице "List" я перехожу к строке:
			| 'Description'         |
			| 'Cash desk №1' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' |
			| 'TRY'  |
		И в таблице "List" я выбираю текущую строку
	* Check the selection by Planing transaction basis
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
			| 'Number' | 'Sender'       | 'Send currency'    | 'Company'      |
			| '11'     | 'Cash desk №2' | 'USD'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '100,00'
	* Check that the selected document is in CashReceipt
		Тогда таблица "PaymentList" содержит строки:
			| 'Amount' | 'Planning transaction basis' |
			| '100,00' | 'Cash transfer order 11*'   |
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
			| 'Number' | 'Sender'       | 'Send currency'    | 'Company'      |
			| '11'     | 'Cash desk №2' | 'USD'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form when Cash Receipt posted 
		И я нажимаю на кнопку 'Post'
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'       | 'Send currency'    | 'Company'      |
		| '11'     | 'Cash desk №2' | 'USD'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
	* Check that the Planing transaction basis selection form displays the document that has already been selected earlier (line deleted)
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю на кнопку 'Delete'
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'       | 'Send currency'    | 'Company'      |
		| '11'     | 'Cash desk №2' | 'USD'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '200,00'
		И я нажимаю на кнопку 'Post'
	* Check not clearing Planning transaction basis in case of cancellation when changing the type of transaction
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Cancel'
	* Check clearing Planing transaction basis in case of transaction type change
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planning transaction basis' |
		| '200,00' | ''                          |
	И я закрыл все окна клиентского приложения

Сценарий:  _0154129 check the selection by Planing transaction basis in BankPayment in case of cash transfer
	* Open form Bank Payment and select transaction type Cash transfer order
		И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
	* Filling in the details of the document
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'         |
			| 'EUR'      | 'Bank account 2, EUR' |
		И в таблице "List" я выбираю текущую строку
	* Check the selection by Planing transaction basis
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'              | 'Company'      | 'Send currency' |
		| '14'     | 'Bank account 2, EUR' | 'Main Company' | 'EUR'           |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '100,00'
	* Check that the selected document is in BankPayment
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planning transaction basis' |
		| '100,00' | 'Cash transfer order 14*'   |
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'              | 'Company'      | 'Send currency' |
		| '14'     | 'Bank account 2, EUR' | 'Main Company' | 'EUR'           |
		И я нажимаю на кнопку с именем 'FormChoose'
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form when Bank Payment posted
		И я нажимаю на кнопку 'Post'
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'              | 'Company'      | 'Send currency' |
		| '14'     | 'Bank account 2, EUR' | 'Main Company' | 'EUR'           |
		И я нажимаю на кнопку с именем 'FormChoose'
	* Check that the Planing transaction basis selection form displays the document that has already been selected earlier (line deleted)
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю на кнопку 'Delete'
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'              | 'Company'      | 'Send currency' |
		| '14'     | 'Bank account 2, EUR' | 'Main Company' | 'EUR'           |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '200,00'
		И я нажимаю на кнопку 'Post'
	* Check not clearing Planning transaction basis in case of cancellation when changing the type of transaction
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Cancel'
	* Check clearing Planing transaction basis in case of transaction type change
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planning transaction basis' |
		| '200,00' | ''                          |
	И я закрыл все окна клиентского приложения

Сценарий:  _0154130 check the selection by Planing transaction basis in Bank Receipt in case of cash transfer
	* Open form Bank Receipt and select transaction type Cash transfer order
		И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
	* Filling in the details of the document
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'         |
			| 'EUR'      | 'Bank account, EUR' |
		И в таблице "List" я выбираю текущую строку
	* Check the selection by Planing transaction basis
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'              | 'Send currency'    | 'Company'      |
		| '14'     | 'Bank account 2, EUR' | 'EUR'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '100,00'
	* Check that the selected document is in BankReceipt
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planning transaction basis' |
		| '100,00' | 'Cash transfer order 14*'   |
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'              | 'Send currency'    | 'Company'      |
		| '14'     | 'Bank account 2, EUR' | 'EUR'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form when Bank Receipt posted
		И я нажимаю на кнопку 'Post'
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'              | 'Send currency'    | 'Company'      |
		| '14'     | 'Bank account 2, EUR' | 'EUR'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
	* Check that the Planing transaction basis selection form displays the document that has already been selected earlier (line deleted)
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю на кнопку 'Delete'
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'              | 'Send currency'    | 'Company'      |
		| '14'     | 'Bank account 2, EUR' | 'EUR'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '200,00'
		И я нажимаю на кнопку 'Post'
	* Check not clearing Planning transaction basis in case of cancellation when changing the type of transaction
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Cancel'
	* Check clearing Planing transaction basis in case of transaction type change
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planning transaction basis' |
		| '200,00' | ''                          |
	И я закрыл все окна клиентского приложения

Сценарий: _053014 check the display of details on the form Bank payment with the type of operation Currency exchange
	И Я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
	И я нажимаю на кнопку с именем 'FormCreate'
	И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
	* Then I check the display on the form of available fields
		И     элемент формы с именем "Company" доступен
		И     элемент формы с именем "Account" доступен
		И     элемент формы с именем "Description" доступен
		И     элемент формы с именем "TransactionType" стал равен 'Currency exchange'
		И     элемент формы с именем "Currency" доступен
		И     элемент формы с именем "Date" доступен
		И     элемент формы с именем "TransitAccount" доступен
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
	* And I check the display of the tabular part
		И     элемент формы с именем "TransitAccount" стал равен 'Transit Main'
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И     таблица "PaymentList" стала равной:
			| '#' | 'Amount' | 'Planning transaction basis' |
			| '1' | ''       | ''                          |



Сценарий: check filling in and re-filling Credit debit note
	* Create a document
		И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document
		И из выпадающего списка "Operation type" я выбираю точное значение 'Receivable'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Lunch'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Company Lunch' |
		И в таблице "List" я выбираю текущую строку
	* Filling in the basis document for debt write-offs
		И в таблице "Transactions" я нажимаю на кнопку с именем 'TransactionsAdd'
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита "Partner ar transactions basis document"
		Тогда открылось окно 'Select data type'
		И в таблице "" я перехожу к строке:
			| ''                 |
			| 'Sales invoice' |
		И в таблице "" я выбираю текущую строку
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '2 900'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я активизирую поле с именем "TransactionsAmount"
		И в таблице "Transactions" в поле с именем 'TransactionsAmount' я ввожу текст '1 000,00'
		И в таблице "Transactions" я завершаю редактирование строки
		И в таблице "Transactions" я активизирую поле "Business unit"
		И в таблице "Transactions" я выбираю текущую строку
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита "Business unit"
		И в таблице "List" я перехожу к строке:
			| 'Description'             |
			| 'Distribution department' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я активизирую поле "Expense type"
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита "Expense type"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Software'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я завершаю редактирование строки
	* Change the document number
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '14'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '14'
		И я нажимаю на кнопку 'Post'
	* Re-select partner and check of data cleansing in the tabular section
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Maxim'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
		| 'Description'   |
		| 'Company Maxim' |
		И в таблице "List" я выбираю текущую строку
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		Тогда в таблице "Transactions" количество строк "равно" 0
	* Filter check basis documents (depend of company)
		И из выпадающего списка "Operation type" я выбираю точное значение 'Payable'
	* Re-select company
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я нажимаю на кнопку 'Add'
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита "Partner ap transactions basis document"
		И в таблице "" я перехожу к строке:
			| ''                 |
			| 'Purchase invoice' |
		И в таблице "" я выбираю текущую строку
		Тогда в таблице "List" количество строк "равно" 0
		И Я закрываю окно 'Purchase invoices'
		И в таблице "Transactions" я завершаю редактирование строки
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в таблице "Transactions" я нажимаю на кнопку 'Add'
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита "Partner ap transactions basis document"
		Тогда открылось окно 'Select data type'
		И в таблице "" я перехожу к строке:
			| ''                 |
			| 'Purchase invoice' |
		И в таблице "" я выбираю текущую строку
		И таблица "ИмяТаблицы" содержит строки:	
			| 'Number' | 'Legal name'    | 'Partner' | 'Amount'    | 'Currency' |
			| '2 900'  | 'Company Maxim' | 'Maxim'   | '11 000,00' | 'TRY'      |
			| '2 901'  | 'Company Maxim' | 'Maxim'   | '10 000,00' | 'TRY'      |
		И я закрыл все окна клиентского приложения

Сценарий: _0154131  check currency form in  Bank Receipt
	* Filling in Bank Receipt
		* Filling the document header
			И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
			И я нажимаю на кнопку с именем 'FormCreate'
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
		* Bank account selection and check of Currency field refilling
			И я нажимаю кнопку выбора у поля "Account"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Bank account, TRY |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Currency" стал равен 'TRY'
		* Check the choice of a partner in the tabular section and filling in the legal name if one
			И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
			И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayer"
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'DFC'         |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '200,00'
			И в таблице "PaymentList" я завершаю редактирование строки
	* Check form by currency
		* Basic recalculation at the rate
			И в таблице "CurrenciesPaymentList" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '34,25'  | '1'            |
		* Recalculation of Rate presentation when changing Amount
			И в таблице "CurrenciesPaymentList" в поле с именем 'CurrenciesPaymentListAmount' я ввожу текст '35,00'
			И в таблице "CurrenciesPaymentList" я завершаю редактирование строки
			И в таблице "CurrenciesPaymentList" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,7143'            | '35,00'  | '1'            |
		* Recount Amount when changing Multiplicity
			И в таблице "CurrenciesPaymentList" в поле 'Multiplicity' я ввожу текст '2'
			И в таблице "CurrenciesPaymentList" я завершаю редактирование строки
			И в таблице "CurrenciesPaymentList" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,7143'            | '17,50'  | '2'            |
		* Recount Amount when changing Multiplicity
			И в таблице "CurrenciesPaymentList" в поле 'Rate presentation' я ввожу текст '6,0000'
			И в таблице "CurrenciesPaymentList" я завершаю редактирование строки
			И в таблице "CurrenciesPaymentList" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '6,0000'            | '16,67'  | '2'            |
		* Recount Amount when changing payment amount
			И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '250,00'
			И в таблице "CurrenciesPaymentList" я завершаю редактирование строки
			И в таблице "CurrenciesPaymentList" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '6,0000'            | '20,83'  | '2'            |
		* Check the standard currency rate when adding the next line
			И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
			И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayer"
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Veritas   |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payer"
			И в таблице "List" я перехожу к строке:
				| 'Description'      |
				| 'Company Veritas ' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '200,00'
			И в таблице "CurrenciesPaymentList" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '34,25'  | '1'            |
		* Recount when currency changes
			И я нажимаю кнопку выбора у поля "Account"
			И в таблице "List" я перехожу к строке:
				| 'Currency' | 'Description'       |
				| 'USD'      | 'Bank account, USD' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "CurrenciesPaymentList" я перехожу к строке:
				| 'Movement type'  | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'TRY'            | 'Partner term' | 'USD'           | 'TRY'      | '0,1770'             | '1 129,94' | '1'            |
			И в таблице "CurrenciesPaymentList" я перехожу к строке:
				| 'Movement type'  | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'TRY'            | 'Partner term' | 'USD'           | 'TRY'      | '0,1770'             | '1 129,94' | '1'            |
		* Reverse rate display check
			Дано двойной клик на картинку "reverse"
			И в таблице "PaymentList" я перехожу к строке:
				| 'Partner term'                               | 'Amount' | 'Partner' | 'Payer'            |
				| 'Posting by Standard Partner term (Veritas)' | '200,00' | 'Veritas' | 'Company Veritas ' |
			И в таблице "PaymentList" я активизирую поле "Partner term"
			Тогда таблица "CurrenciesPaymentList" содержит строки:
				| 'Movement type'  | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'Local currency' | 'Legal'     | 'USD'           | 'TRY'      | '5,6497'             | '1 129,94' | '1'            |
		И я закрыл все окна клиентского приложения

Сценарий: _0154132  check currency form in Incoming payment order
	* Filling in Incoming payment order
		* Filling the document header
			И я открываю навигационную ссылку 'e1cib/list/Document.IncomingPaymentOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
		* Bank account selection and check of Currency field refilling
			И я нажимаю кнопку выбора у поля "Account"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Bank account, TRY |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Currency" стал равен 'TRY'
		* Check the choice of a partner in the tabular section and filling in the legal name if one
			И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'DFC'         |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '200,00'
			И в таблице "PaymentList" я завершаю редактирование строки
	* Check form by currency
		* Basic recalculation at the rate
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '34,25'  | '1'            |
		* Recalculation of Rate presentation when changing Amount
			И в таблице "PaymentListCurrencies" в поле с именем 'PaymentListCurrenciesAmount' я ввожу текст '35,00'
			И в таблице "PaymentListCurrencies" я завершаю редактирование строки
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,7143'            | '35,00'  | '1'            |
		* Recount Amount when changing Multiplicity
			И в таблице "PaymentListCurrencies" в поле 'Multiplicity' я ввожу текст '2'
			И в таблице "PaymentListCurrencies" я завершаю редактирование строки
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,7143'            | '17,50'  | '2'            |
		* Recount Amount when changing Multiplicity Rate presentation
			И в таблице "PaymentListCurrencies" в поле 'Rate presentation' я ввожу текст '6,0000'
			И в таблице "PaymentListCurrencies" я завершаю редактирование строки
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '6,0000'            | '16,67'  | '2'            |
		* Recount Amount when changing payment amount
			И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '250,00'
			И в таблице "PaymentListCurrencies" я завершаю редактирование строки
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '6,0000'            | '20,83'  | '2'            |
		* Check the standard currency rate when adding the next line
			И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Veritas   |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payer"
			И в таблице "List" я перехожу к строке:
				| 'Description'      |
				| 'Company Veritas ' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '200,00'
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '34,25'  | '1'            |
		* Recount when currency changes
			И я нажимаю кнопку выбора у поля "Account"
			И в таблице "List" я перехожу к строке:
				| 'Currency' | 'Description'       |
				| 'USD'      | 'Bank account, USD' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'             | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'Local currency'            | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'             | '1 129,94' | '1'            |
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'             | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'Local currency'            | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'             | '1 129,94' | '1'            |
		* Reverse rate display check 
			Дано двойной клик на картинку "reverse"
			И в таблице "PaymentList" я перехожу к строке:
				| 'Amount' | 'Partner' | 'Payer'            |
				| '200,00' | 'Veritas' | 'Company Veritas ' |
			Тогда таблица "PaymentListCurrencies" содержит строки:
				| 'Movement type'  | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'Local currency' | 'Legal'     | 'USD'           | 'TRY'      | '5,6497'             | '1 129,94' | '1'            |
		И я закрыл все окна клиентского приложения


Сценарий: _0154133  check currency form in Outgoing payment order
	* Filling in Outgoing Payment Order
		* Filling the document header
			И я открываю навигационную ссылку 'e1cib/list/Document.OutgoingPaymentOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
		* Bank account selection and check of Currency field refilling
			И я нажимаю кнопку выбора у поля "Account"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Bank account, TRY |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Currency" стал равен 'TRY'
		* Check the choice of a partner in the tabular section and filling in the legal name if one
			И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'DFC'         |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '200,00'
			И в таблице "PaymentList" я завершаю редактирование строки
	* Check form by currency
		* Basic recalculation at the rate
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '34,25'  | '1'            |
		* Recalculation of Rate presentation when changing Amount
			И в таблице "PaymentListCurrencies" в поле с именем 'PaymentListCurrenciesAmount' я ввожу текст '35,00'
			И в таблице "PaymentListCurrencies" я завершаю редактирование строки
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,7143'            | '35,00'  | '1'            |
		* Recount Amount when changing Multiplicity
			И в таблице "PaymentListCurrencies" в поле 'Multiplicity' я ввожу текст '2'
			И в таблице "PaymentListCurrencies" я завершаю редактирование строки
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,7143'            | '17,50'  | '2'            |
		* Recount Amount when changing Multiplicity Rate presentation
			И в таблице "PaymentListCurrencies" в поле 'Rate presentation' я ввожу текст '6,0000'
			И в таблице "PaymentListCurrencies" я завершаю редактирование строки
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '6,0000'            | '16,67'  | '2'            |
		* Recount Amount when changing payment amount
			И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '250,00'
			И в таблице "PaymentListCurrencies" я завершаю редактирование строки
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '6,0000'            | '20,83'  | '2'            |
		* Check the standard currency rate when adding the next line
			И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Veritas   |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payee"
			И в таблице "List" я перехожу к строке:
				| 'Description'      |
				| 'Company Veritas ' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '200,00'
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '34,25'  | '1'            |
		* Recount when currency changes
			И я нажимаю кнопку выбора у поля "Account"
			И в таблице "List" я перехожу к строке:
				| 'Currency' | 'Description'       |
				| 'USD'      | 'Bank account, USD' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'             | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'Local currency'            | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'             | '1 129,94' | '1'            |
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'             | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'Local currency'            | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'             | '1 129,94' | '1'            |
		* Reverse rate display check 
			Дано двойной клик на картинку "reverse"
			И в таблице "PaymentList" я перехожу к строке:
				| 'Amount' | 'Partner' | 'Payee'            |
				| '200,00' | 'Veritas' | 'Company Veritas ' |
			Тогда таблица "PaymentListCurrencies" содержит строки:
				| 'Movement type'  | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'Local currency' | 'Legal'     | 'USD'           | 'TRY'      | '5,6497'             | '1 129,94' | '1'            |
		И я закрыл все окна клиентского приложения