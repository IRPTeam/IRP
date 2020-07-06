#language: ru
@tree
@Positive

Функционал: Check filling inи перезаполнения форм документов + подключение формы по валютам

Как тестировщик
Я хочу проверить заполнение и перезаполнение форм документов


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _0154100 preparation для тестирования заполнения и перезаполнения документов
	* Для теста по изменению цен и курсов в зависимости от даты
	#  проверка перезаполнения Sales order при изменении даты, проверка перезаполнения Sales invoice при изменении даты
		* Внесение курса валют лира к доллару 01.11.2018
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
		* Создание прайс листа прошлым периодом
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
		* Добавление Dress M/Brown в прайс-лист №100
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
	* Для теста по заполнению документов закупки
	#  проверка перезаполнения Sales order при изменении даты, проверка перезаполнения Sales invoice при изменении даты
		* Подготовка: создание соглашения с поставщиком для DFC
			И я открываю навигационную ссылку "e1cib/list/Catalog.Agreements"
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст 'Agreement vendor DFC'
			И я меняю значение переключателя 'Type' на 'Vendor'
			И я меняю значение переключателя 'AP-AR posting detail' на 'By documents'
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
			И я нажимаю кнопку выбора у поля "Currency movement type"
			И в таблице "List" я перехожу к строке:
				| 'Currency' |  'Source'       | 'Type'      |
				| 'TRY'      |  'Forex Seling' | 'Agreement' |
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
		* Подготовка: создание соглашения с поставщиком для Partner Kalipso Vendor
			И я открываю навигационную ссылку "e1cib/list/Catalog.Agreements"
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст 'Agreement vendor Partner Kalipso'
			И я меняю значение переключателя 'Type' на 'Vendor'
			И я меняю значение переключателя 'AP-AR posting detail' на 'By documents'
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
			И я нажимаю кнопку выбора у поля "Currency movement type"
			И в таблице "List" я перехожу к строке:
				| 'Currency' |  'Source'       | 'Type'      |
				| 'TRY'      |  'Forex Seling' | 'Agreement' |
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
	* Для теста по выбору Planing transaction basis в банковских/кассовых документах
		* Создание Cashtransfer order на перемещение ДС между кассами
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
		* Создание Cashtransfer order на обмен валюты между кассами
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
		* Создание Cashtransfer order на обмен валюты между банковскими счетами
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
		* Создание Cashtransfer order на перемещение между банковскими счетами в одной валюте
			* Создание еще одного банковского счета в EUR
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
			* Создание Cashtransfer order на перемещение между банковскими счетами в одной валюте
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


Сценарий: _0154101 Check filling inи перезаполнения Sales order
	И Я закрыл все окна клиентского приложения
	* Open the Sales order creation form
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling inlegal name если оно у партнера одно
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'
	* Check filling inAgreement если оно у партнера одно
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Agreement" стал равен 'Agreement DFC'
	* Check filling inCompany из Agreement
		* Изменение компании в Sales order
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Company" стал равен 'Second Company'
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я выбираю текущую строку
		* Проверка перезаполнения при выборе соглашения
			И     элемент формы с именем "Company" стал равен 'Main Company'
	* Check filling inStore из Agreement
		* В выбранном соглашении изменение склада
			И я нажимаю на кнопку открытия поля "Agreement"
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 03'    |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
		* Перевыбор соглашения и проверка перезаполнения склада (товар не добавлен)
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я выбираю текущую строку
	* Проверка очистки legal name, agreement при перевыборе партнера
		* Перевыбор партнера
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Kalipso'     |
			И в таблице "List" я выбираю текущую строку
		* Проверка очистки полей
			И     элемент формы с именем "Agreement" стал равен ''
		* Check filling inLegal name после перевыбора партнера
			И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		* Выбор соглашения
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Basic Agreements, without VAT' |
			И в таблице "List" я выбираю текущую строку
	* Check filling inсклада и компании из Agreement при перевыборе партнера
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Проверка авто заполнения item key при добавлении Item (у Item один item key)
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Router'      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
	* Check filling inцены при добавлении Item и выборе item key
		* Заполнение item и Item key
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
		* Check filling inцены
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' |
				| 'Trousers' | '338,98' | '38/Yellow' | '1,000' | 'pcs'  |
	* Проверка перезаполнения цены при перевыборе соглашения
		* Перевыбор соглашения
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Agreements, TRY' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Проверка перезаполнения склада в добавленной строке и цены
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 01' |
	* Check filling inцены по новым строкам при перевыборе соглашения
		* Добавление строки
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
		* Check filling inцены
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Procurement method' | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | 'Stock'              | '1,000' | 'pcs'  | 'Store 01' |
				| 'Shirt'    | '350,00' | '38/Black'  | 'Stock'              | '2,000' | 'pcs'  | 'Store 01' |
	* Проверка перерисовки формы по налогам при перевыборе компании
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
	* Tax calculation check при заполнении компании при перевыборе соглашения
		* Перевыбор соглашения
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Agreements, TRY' |
			И в таблице "List" я выбираю текущую строку
		* Tax calculation check
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Detail' | 'Item'     | 'VAT' | 'Item key'  | 'Procurement method' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | ''       | 'Trousers' | '18%' | '38/Yellow' | 'Stock'              | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | ''       | 'Shirt'    | '18%' | '38/Black'  | 'Stock'              | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
	* Check filling inцены и расчет налогов при добавлении товара через поиск штрих-кодов
		* Добавление товара через штрих-кодов
			И в таблице "ItemList" я нажимаю на кнопку 'SearchByBarcode'
			И в поле 'InputFld' я ввожу текст '2202283739'
			И Пауза 4
			И я нажимаю на кнопку 'OK'
			И Пауза 4
		* Check filling inцены и расчета налогов
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Procurement method' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | 'Stock'              | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | 'Shirt'    | '18%' | '38/Black'  | 'Stock'              | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | 'Stock'              | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
			И Пауза 4
	* Check filling inцены и расчет налогов при добавлении товара через форму подбора товаров
		* Добавление товара через форму Pickup
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
		* Check filling inцены и расчета налогов
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'Item key'  | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '38/Yellow' | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | 'Shirt'    | '38/Black'  | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | 'L/Green'   | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress'    | 'XS/Blue'   | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
	* Проверка очистки строки в дереве налогов при удалении строки из заказа
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице 'ItemList' я удаляю строку
		И я перехожу к закладке "Tax list"
		Тогда таблица "ItemList" не содержит строки:
			| 'Item'  | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Проверка перерачета налогов при снятии/повторной установке галочки Price include Tax
		* Снятие галочки Price include Tax
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я снимаю флаг 'Price include tax'
		* Проверка перерасчета налогов
			И я перехожу к закладке "Item list"
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '133,00'     | '2,000' | 'pcs'  | '700,00'     | '833,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '104,50'     | '1,000' | 'pcs'  | '550,00'     | '654,50'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '98,80'      | '1,000' | 'pcs'  | '520,00'     | '618,80'       | 'Store 01' |
		* Установка галочки Price include Tax и проверка расчета
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я устанавливаю флаг 'Price include tax'
			И я перехожу к закладке "Item list"
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
	* Check filling inгалочки Price include Tax при перевыборе соглашения и проверка пересчета налогов
		* Перевыбор соглашения на то у которого галочка Price include Tax не установлена
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Basic Agreements, without VAT' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Проверка того, что значение галочки Price include Tax заполнилось из соглашения
			И     элемент формы с именем "PriceIncludeTax" стал равен 'No'
		* Проверка перасчета налогов
			И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '296,61' | 'Shirt' | '18%' | '38/Black' | '112,71'     | '1%'       | '2,000' | 'pcs'  | '593,22'     | '705,93'       | 'Store 02' |
			| '466,10' | 'Dress' | '18%' | 'L/Green'  | '88,56'      | '1%'       | '1,000' | 'pcs'  | '466,10'     | '554,66'       | 'Store 02' |
			| '440,68' | 'Dress' | '18%' | 'XS/Blue'  | '83,73'      | '1%'       | '1,000' | 'pcs'  | '440,68'     | '524,41'       | 'Store 02' |
		* Изменение соглашения на то которое было раньше
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Agreements, TRY' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
			И     элемент формы с именем "PriceIncludeTax" стал равен 'Yes'
		* Проверка перерасчета налогов
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
		* Check filling inтаблицы валют
			И я нажимаю на кнопку 'Save'
			И я перехожу к закладке с именем "GroupCurrency"
			И     таблица "ObjectCurrencies" стала равной:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'TRY'                | 'Agreement' | 'TRY'           | 'TRY'      | '1'                 | '1 770'  | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '1 770'  | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '303,08' | '1'            |

Сценарий: _0154102 Check filling inи перезаполнения Sales invoice
	* Открытие формы Sales invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling inlegal name если оно у партнера одно
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'
	* Check filling inAgreement если оно у партнера одно
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Agreement" стал равен 'Agreement DFC'
	* Check filling inCompany из Agreement
		* Изменение компании в Sales order
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Company" стал равен 'Second Company'
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я выбираю текущую строку
		* Проверка перезаполнения при выборе соглашения
			И     элемент формы с именем "Company" стал равен 'Main Company'
	* Check filling inStore из Agreement
		* В выбранном соглашении изменение склада
			И я нажимаю на кнопку открытия поля "Agreement"
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 03'    |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
		* Перевыбор соглашения и проверка перезаполнения склада (товар не добавлен)
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я выбираю текущую строку
	* Проверка очистки legal name, agreement при перевыборе партнера
		* Перевыбор партнера
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Kalipso'     |
			И в таблице "List" я выбираю текущую строку
		* Проверка очистки полей
			И     элемент формы с именем "Agreement" стал равен ''
		* Check filling inLegal name после перевыбора партнера
			И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		* Выбор соглашения
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Basic Agreements, without VAT' |
			И в таблице "List" я выбираю текущую строку
	* Check filling inсклада и компании из Agreement при перевыборе партнера
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Проверка авто заполнения item key при добавлении Item (у Item один item key)
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Router'      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
	* Check filling inцены при добавлении Item и выборе item key
		* Заполнение item и Item key
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
		* Check filling inцены
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' |
				| 'Trousers' | '338,98' | '38/Yellow' | '1,000' | 'pcs'  |
	* Проверка перезаполнения цены при перевыборе соглашения
		* Перевыбор соглашения
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Agreements, TRY' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Проверка перезаполнения склада в добавленной строке и цены
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 01' |
	* Check filling inцены по новым строкам при перевыборе соглашения
		* Добавление строки
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
		* Check filling inцены
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 01' |
				| 'Shirt'    | '350,00' | '38/Black'  | '2,000' | 'pcs'  | 'Store 01' |
	* Проверка перерисовки формы по налогам при перевыборе компании
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
	* Tax calculation check при заполнении компании при перевыборе соглашения
		* Перевыбор соглашения
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Agreements, TRY' |
			И в таблице "List" я выбираю текущую строку
		* Tax calculation check
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Detail' | 'Item'     | 'VAT' | 'Item key'  | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | ''       | 'Trousers' | '18%' | '38/Yellow' | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | ''       | 'Shirt'    | '18%' | '38/Black'  | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
	* Check filling inцены и расчет налогов при добавлении товара через поиск штрих-кодов
		* Добавление товара через штрих-кодов
			И в таблице "ItemList" я нажимаю на кнопку 'SearchByBarcode'
			И в поле 'InputFld' я ввожу текст '2202283739'
			И Пауза 2
			И я нажимаю на кнопку 'OK'
			И Пауза 4
		* Check filling inцены и расчета налогов
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | 'Shirt'    | '18%' | '38/Black'  | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
			И Пауза 4
	* Check filling inцены и расчет налогов при добавлении товара через форму подбора товаров
		* Добавление товара через форму Pickup
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
		* Check filling inцены и расчета налогов
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'Item key'  | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '38/Yellow' | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | 'Shirt'    | '38/Black'  | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | 'L/Green'   | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress'    | 'XS/Blue'   | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
	* Проверка очистки строки в дереве налогов при удалении строки из заказа
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице 'ItemList' я удаляю строку
		И я перехожу к закладке "Tax list"
		Тогда таблица "ItemList" не содержит строки:
			| 'Item'  | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Проверка перерачета налогов при снятии/повторной установке галочки Price include Tax
		* Снятие галочки Price include Tax
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я снимаю флаг 'Price include tax'
		* Проверка перерасчета налогов
			И я перехожу к закладке "Item list"
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '133,00'     | '2,000' | 'pcs'  | '700,00'     | '833,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '104,50'     | '1,000' | 'pcs'  | '550,00'     | '654,50'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '98,80'      | '1,000' | 'pcs'  | '520,00'     | '618,80'       | 'Store 01' |
		* Установка галочки Price include Tax и проверка расчета
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я устанавливаю флаг 'Price include tax'
			И я перехожу к закладке "Item list"
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
	* Check filling inгалочки Price include Tax при перевыборе соглашения и проверка пересчета налогов
		* Перевыбор соглашения на то у которого галочка Price include Tax не установлена
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Basic Agreements, without VAT' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Проверка того, что значение галочки Price include Tax заполнилось из соглашения
			И     элемент формы с именем "PriceIncludeTax" стал равен 'No'
		* Проверка перасчета налогов
			И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '296,61' | 'Shirt' | '18%' | '38/Black' | '112,71'     | '1%'       | '2,000' | 'pcs'  | '593,22'     | '705,93'       | 'Store 02' |
			| '466,10' | 'Dress' | '18%' | 'L/Green'  | '88,56'      | '1%'       | '1,000' | 'pcs'  | '466,10'     | '554,66'       | 'Store 02' |
			| '440,68' | 'Dress' | '18%' | 'XS/Blue'  | '83,73'      | '1%'       | '1,000' | 'pcs'  | '440,68'     | '524,41'       | 'Store 02' |
		* Изменение соглашения на то которое было раньше
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Agreements, TRY' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
			И     элемент формы с именем "PriceIncludeTax" стал равен 'Yes'
		* Проверка перерасчета налогов
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
		* Check filling inтаблицы валют
			И я перехожу к закладке с именем "GroupCurrency"
			И     таблица "ObjectCurrencies" стала равной:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'TRY'                | 'Agreement' | 'TRY'           | 'TRY'         | '1'                 | '1 770'  | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'         | '1'                 | '1 770'  | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'         | '5,8400'            | '303,08' | '1'            |
		* Проверка пересчета налогов при выборе налоговой ставки вручную
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



Сценарий: _0154103 проверка перезаполнения Sales order при изменении даты
	* Open the Sales order creation form
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение партнера и Legal name
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я выбираю текущую строку
	* Filling in an Agreement
		И я нажимаю кнопку выбора у поля "Agreement"
		Тогда в таблице "List" количество строк "меньше или равно" 3
		И в таблице "List" я перехожу к строке:
			| 'Description'                   |
			| 'Basic Agreements, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Добавление товара и проверка цен на текущую дату
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
	* Изменение даты и проверка перерасчета цен и налогов
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
	* Проверка отображения списка соглашений
		И я нажимаю кнопку выбора у поля "Agreement"
		И     таблица "List" содержит строки:
			| 'Description'                   |
			| 'Basic Agreements, TRY'         |
			| 'Basic Agreements, $'           |
			| 'Basic Agreements, without VAT' |
			| 'Personal Agreements, $'        |
			| 'Sale autum, TRY'               |
		И Я закрываю окно 'Agreements'
	* Проверка пересчета таблицы валют при изменении даты
		И я перехожу к закладке с именем "GroupCurrency"
		И     таблица "ObjectCurrencies" стала равной:
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'TRY'                | 'Agreement' | 'TRY'           | 'TRY'      | '1'                 | '1 000'  | '1'            |
		| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '1 000'  | '1'            |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,0000'            | '200,00' | '1'            |

Сценарий: _0154104 проверка перезаполнения Sales invoice при изменении даты
	* Открытие формы Sales invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение партнера и Legal name
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я выбираю текущую строку
	* Filling in an Agreement
		И я нажимаю кнопку выбора у поля "Agreement"
		Тогда в таблице "List" количество строк "меньше или равно" 3
		И в таблице "List" я перехожу к строке:
			| 'Description'                   |
			| 'Basic Agreements, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Добавление товара и проверка цен на текущую дату
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
	* Изменение даты и проверка перерасчета цен и налогов
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Date' я ввожу текст '01.11.2018 10:00:00'
		И я перехожу к закладке "Item list"
		Когда открылось окно 'Update item list info'
		И я нажимаю на кнопку 'OK'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Price'    | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'Dress' | '1 000,00' | 'M/Brown'  | '1,000' | ''           | 'pcs'  | '1 000,00'     | '1 000,00'     | 'Store 01' |
	* Проверка отображения списка соглашений
		И я нажимаю кнопку выбора у поля "Agreement"
		И     таблица "List" содержит строки:
		| 'Description'                   |
		| 'Basic Agreements, TRY'         |
		| 'Basic Agreements, $'           |
		| 'Basic Agreements, without VAT' |
		| 'Personal Agreements, $'        |
		| 'Sale autum, TRY'               |
		И Я закрываю окно 'Agreements'
	* Проверка пересчета таблицы валют при изменении даты
		И я перехожу к закладке с именем "GroupCurrency"
		И     таблица "ObjectCurrencies" стала равной:
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'TRY'                | 'Agreement' | 'TRY'           | 'TRY'      | '1'                 | '1 000'  | '1'            |
		| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '1 000'  | '1'            |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,0000'            | '200,00' | '1'            |

Сценарий: _0154105 Check filling inи перезаполнения Purchase order
	* Открытие формы Purchase order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling inlegal name если оно у партнера одно
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'
	* Check filling inAgreement если оно у партнера одно
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Agreement" стал равен 'Agreement vendor DFC'
	* Check filling inCompany из Agreement
		* Изменение компании в Sales order
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Company" стал равен 'Second Company'
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я выбираю текущую строку
		* Проверка перезаполнения при выборе соглашения
			И     элемент формы с именем "Company" стал равен 'Main Company'
	* Check filling inStore из Agreement
		* В выбранном соглашении изменение склада
			И я нажимаю на кнопку открытия поля "Agreement"
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 03'    |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
		* Перевыбор соглашения и проверка перезаполнения склада (товар не добавлен)
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я выбираю текущую строку
	* Проверка очистки legal name, agreement при перевыборе партнера
		* Перевыбор партнера
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Partner Kalipso'     |
			И в таблице "List" я выбираю текущую строку
		* Проверка очистки полей
			И     элемент формы с именем "Agreement" стал равен ''
		* Check filling inLegal name после перевыбора партнера
			И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		* Выбор соглашения
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'            |
				| 'Partner Kalipso Vendor' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку открытия поля "Agreement"
			И я нажимаю кнопку выбора у поля "Price type"
			И в таблице "List" я перехожу к строке:
				| 'Description'             |
				| 'Basic Price without VAT' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
	* Check filling inсклада и компании из Agreement при перевыборе партнера
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Проверка авто заполнения item key при добавлении Item (у Item один item key)
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Router'      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
	* Check filling inцены при добавлении Item и выборе item key
		* Заполнение item и Item key
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
		* Check filling inцены
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     |
				| 'Trousers' | '*'      | '38/Yellow' | '1,000' |
			И Пауза 2
	* Проверка перезаполнения цены при перевыборе соглашения
		* Перевыбор соглашения
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Agreement vendor Partner Kalipso' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Проверка перезаполнения склада в добавленной строке и цены
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
	* Check filling inцены по новым строкам при перевыборе соглашения
		* Добавление строки
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
		* Check filling inцены
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
				| 'Shirt'    | '350,00' | '38/Black'  | '2,000' | 'pcs'  | 'Store 03' |
	* Проверка перерисовки формы по налогам при перевыборе компании
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
	* Tax calculation check при заполнении компании при перевыборе соглашения
		* Перевыбор соглашения
			И я нажимаю кнопку выбора у поля "Agreement"
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
	* Check filling inцены и расчет налогов при добавлении товара через поиск штрих-кодов
		* Добавление товара через штрих-кодов
			И я нажимаю на кнопку 'ItemListSearchByBarcode'
			И в поле 'InputFld' я ввожу текст '2202283739'
			И Пауза 2
			И я нажимаю на кнопку 'OK'
			И Пауза 4
		* Check filling inцены и расчета налогов
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '51,71'      | 'pcs'  | '287,27'     | '338,98'       | 'Store 03' |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 03' |
	* Check filling inцены и расчет налогов при добавлении товара через форму подбора товаров
		* Добавление товара через форму Pickup
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
		* Check filling inцены и расчета налогов
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '51,71'      | 'pcs'  | '287,27'     | '338,98'       | 'Store 03' |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 03' |
				| '440,68' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | '67,22'      | 'pcs'  | '373,46'     | '440,68'       | 'Store 03' |
	* Проверка очистки строки в дереве налогов при удалении строки из заказа
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице 'ItemList' я удаляю строку
		И я перехожу к закладке "Tax list"
		Тогда таблица "ItemList" не содержит строки:
			| 'Item'     | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Проверка перерачета налогов при снятии/повторной установке галочки Price include Tax
		* Снятие галочки Price include Tax
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я снимаю флаг 'Price include tax'
		* Проверка перерасчета налогов
			И я перехожу к закладке "Item list"
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt' | '18%' | '38/Black' | '2,000' | '106,78'     | 'pcs'  | '593,22'     | '700,00'       | 'Store 03' |
				| '466,10' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '83,90'      | 'pcs'  | '466,10'     | '550,00'       | 'Store 03' |
				| '440,68' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '79,32'      | 'pcs'  | '440,68'     | '520,00'       | 'Store 03' |
		* Установка галочки Price include Tax и проверка расчета
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я устанавливаю флаг 'Price include tax'
			И я перехожу к закладке "Item list"
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 03' |
				| '440,68' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | '67,22'      | 'pcs'  | '373,46'     | '440,68'       | 'Store 03' |
	* Check filling inгалочки Price include Tax при перевыборе соглашения и проверка пересчета налогов
		* Перевыбор соглашения на то у которого галочка Price include Tax установлена
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Partner Kalipso Vendor' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Проверка того, что значение галочки Price include Tax заполнилось из соглашения
			И     элемент формы с именем "PriceIncludeTax" стал равен 'Yes'
		* Проверка перасчета налогов
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 02' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 02' |
				| '440,68' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | '67,22'      | 'pcs'  | '373,46'     | '440,68'       | 'Store 02' |
		* Изменение соглашения на то которое было раньше
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Agreement vendor Partner Kalipso' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
			И     элемент формы с именем "PriceIncludeTax" стал равен 'No'
		* Проверка перерасчета налогов
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | '126,00'     | 'pcs'  | '700,00'     | '826,00'       | 'Store 03' |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '99,00'      | 'pcs'  | '550,00'     | '649,00'       | 'Store 03' |
				| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '93,60'      | 'pcs'  | '520,00'     | '613,60'       | 'Store 03' |
		* Check filling inтаблицы валют
			И я перехожу к закладке с именем "GroupCurrency"
			И     таблица "ObjectCurrencies" стала равной:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'  | 'Multiplicity' |
			| 'TRY'                | 'Agreement' | 'TRY'           | 'TRY'      | '1'                 | '2 088,6' | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '2 088,6' | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '357,64'  | '1'            |
		* Проверка пересчета налогов при выборе налоговой ставки вручную
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



Сценарий: _0154106 Check filling inи перезаполнения Purchase invoice
	* Открытие формы Purchase invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling inlegal name если оно у партнера одно
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'
	* Check filling inAgreement если оно у партнера одно
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Agreement" стал равен 'Agreement vendor DFC'
	* Check filling inCompany из Agreement
		* Изменение компании в Sales order
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Company" стал равен 'Second Company'
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я выбираю текущую строку
		* Проверка перезаполнения при выборе соглашения
			И     элемент формы с именем "Company" стал равен 'Main Company'
	* Check filling inStore из Agreement
		* В выбранном соглашении изменение склада
			И я нажимаю на кнопку открытия поля "Agreement"
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 03'    |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
		* Перевыбор соглашения и проверка перезаполнения склада (товар не добавлен)
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я выбираю текущую строку
	* Проверка очистки legal name, agreement при перевыборе партнера
		* Перевыбор партнера
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Partner Kalipso'     |
			И в таблице "List" я выбираю текущую строку
		* Проверка очистки полей
			И     элемент формы с именем "Agreement" стал равен ''
		* Check filling inLegal name после перевыбора партнера
			И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		* Выбор соглашения
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'            |
				| 'Partner Kalipso Vendor' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку открытия поля "Agreement"
			И я нажимаю кнопку выбора у поля "Price type"
			И в таблице "List" я перехожу к строке:
				| 'Description'             |
				| 'Basic Price without VAT' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
	* Check filling inсклада и компании из Agreement при перевыборе партнера
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Проверка авто заполнения item key при добавлении Item (у Item один item key)
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Router'      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
	* Check filling inцены при добавлении Item и выборе item key
		* Заполнение item и Item key
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
		* Check filling inцены
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' |
				| 'Trousers' | '338,98' | '38/Yellow' | '1,000' | 'pcs'  |
	* Проверка перезаполнения цены при перевыборе соглашения
		* Перевыбор соглашения
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Agreement vendor Partner Kalipso' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Проверка перезаполнения склада в добавленной строке и цены
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
	* Check filling inцены по новым строкам при перевыборе соглашения
		* Добавление строки
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
		* Check filling inцены
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
				| 'Shirt'    | '350,00' | '38/Black'  | '2,000' | 'pcs'  | 'Store 03' |
	* Проверка перерисовки формы по налогам при перевыборе компании
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
	* Tax calculation check при заполнении компании при перевыборе соглашения
		* Перевыбор соглашения
			И я нажимаю кнопку выбора у поля "Agreement"
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
	* Check filling inцены и расчет налогов при добавлении товара через поиск штрих-кодов
		* Добавление товара через штрих-кодов
			И я нажимаю на кнопку 'SearchByBarcode'
			И в поле 'InputFld' я ввожу текст '2202283739'
			И Пауза 2
			И я нажимаю на кнопку 'OK'
			И Пауза 4
		* Check filling inцены и расчета налогов
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '51,71'      | 'pcs'  | '287,27'     | '338,98'       | 'Store 03' |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 03' |
	* Check filling inцены и расчет налогов при добавлении товара через форму подбора товаров
		* Добавление товара через форму Pickup
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
		* Check filling inцены и расчета налогов
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '51,71'      | 'pcs'  | '287,27'     | '338,98'       | 'Store 03' |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 03' |
				| '440,68' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | '67,22'      | 'pcs'  | '373,46'     | '440,68'       | 'Store 03' |
	* Проверка очистки строки в дереве налогов при удалении строки из заказа
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице 'ItemList' я удаляю строку
		И я перехожу к закладке "Tax list"
		Тогда таблица "ItemList" не содержит строки:
			| 'Item'     | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Проверка перерачета налогов при снятии/повторной установке галочки Price include Tax
		* Снятие галочки Price include Tax
			И я перехожу к закладке "Other"
			И я снимаю флаг 'Price include tax'
		* Проверка перерасчета налогов
			И я перехожу к закладке "Item list"
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt' | '18%' | '38/Black' | '2,000' | '106,78'     | 'pcs'  | '593,22'     | '700,00'       | 'Store 03' |
				| '466,10' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '83,90'      | 'pcs'  | '466,10'     | '550,00'       | 'Store 03' |
				| '440,68' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '79,32'      | 'pcs'  | '440,68'     | '520,00'       | 'Store 03' |
		* Установка галочки Price include Tax и проверка расчета
			И я перехожу к закладке "Other"
			И я устанавливаю флаг 'Price include tax'
			И я перехожу к закладке "Item list"
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 03' |
				| '440,68' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | '67,22'      | 'pcs'  | '373,46'     | '440,68'       | 'Store 03' |
	* Check filling inгалочки Price include Tax при перевыборе соглашения и проверка пересчета налогов
		* Перевыбор соглашения на то у которого галочка Price include Tax установлена
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Partner Kalipso Vendor' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Проверка того, что значение галочки Price include Tax заполнилось из соглашения
			И     элемент формы с именем "PriceIncludeTax" стал равен 'Yes'
		* Проверка перасчета налогов
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 02' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 02' |
				| '440,68' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | '67,22'      | 'pcs'  | '373,46'     | '440,68'       | 'Store 02' |
		* Изменение соглашения на то которое было раньше
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Agreement vendor Partner Kalipso' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
			И     элемент формы с именем "PriceIncludeTax" стал равен 'No'
		* Проверка перерасчета налогов
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | '126,00'     | 'pcs'  | '700,00'     | '826,00'       | 'Store 03' |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '99,00'      | 'pcs'  | '550,00'     | '649,00'       | 'Store 03' |
				| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '93,60'      | 'pcs'  | '520,00'     | '613,60'       | 'Store 03' |
		* Check filling inтаблицы валют
			И я перехожу к закладке с именем "GroupCurrency"
			И     таблица "ObjectCurrencies" стала равной:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'  | 'Multiplicity' |
			| 'TRY'                | 'Agreement' | 'TRY'           | 'TRY'      | '1'                 | '2 088,6' | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '2 088,6' | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '357,64'  | '1'            |
		* Проверка пересчета налогов при выборе налоговой ставки вручную
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

Сценарий: _0154107 Check filling inи перезаполнения Cash reciept (вид операции Payment from customer)
	* Открытие формы Cash reciept
		И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Проверка установки вида операции 'Payment from customer' по умолчанию
		И     элемент формы с именем "TransactionType" стал равен 'Payment from customer'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
	* Check filling inкомпании
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
	* Check filling inвалюты до выбора кассы
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| USD  |
		И в таблице "List" я выбираю текущую строку
	* Check filling inкассы (мультивалютная)
		И я нажимаю кнопку выбора у поля "Cash account"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №1 |
		И в таблице "List" я выбираю текущую строку
	* Перевыбор кассы с фиксированной валютой и проверка перезаполнения поля Currency
		И я нажимаю кнопку выбора у поля "Cash account"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №4 |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Currency" стал равен 'TRY'
	* Проверка перевыбора валюты и очистка поля "Cash account" в случае если валюта зафиксированна по кассе
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| USD  |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "CashAccount" стал равен ''
	* Выбор мультивалютной кассы и проверка что поле Currency не очистится
		И я нажимаю кнопку выбора у поля "Cash account"
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
	* Проверка выбора партнера в табличной части и заполнения по нему контрагента если он один
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
	* Check filling inAgreement при добавлении партнера если оно у партнера одно
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayer"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Nicoletta'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Agreement'                              | 'Payer'             |
			| 'Nicoletta' | 'Posting by standart agreement Customer' | 'Company Nicoletta' |
		И в таблице "PaymentList" я нажимаю на кнопку 'Delete'
	* Проверка отображения для выбора только доступных соглашений по партнеру
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
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
		Тогда таблица "List" содержит строки:
			| 'Description'                   |
			| 'Basic Agreements, TRY'         |
			| 'Basic Agreements, without VAT' |
			| 'Vendor Ferron, TRY'            |
			| 'Vendor Ferron, USD'            |
			| 'Vendor Ferron, EUR'            |
			| 'Ferron, USD'                   |
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Agreements, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Проверка фильтра по документам-основаниям в зависимости от Agreement
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
	* Проверка очистки basis document при очистке соглашения
		И в таблице "PaymentList" я выбираю текущую строку
		И я нажимаю кнопку очистить у поля "Agreement"
		И в таблице "PaymentList" я завершаю редактирование строки
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Agreement' | 'Amount' | 'Payer'             | 'Basis document' |
			| 'Ferron BP' | ''          | ''       | 'Company Ferron BP' | ''               |
	* Проверка добавления basis document без выбора документа основания
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Когда Проверяю шаги на Исключение:
			|'Дано В активном окне открылась форма с заголовком "Documents for incoming payment"'|
	* Проверка недоступности выбора документа-основания при выборе Agreement с расчетом by standart agreement
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
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Posting by standart agreement Customer' |
		И в таблице "List" я выбираю текущую строку
	* Проверка добавления basis document без выбора документа основания
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Когда Проверяю шаги на Исключение:
			|'Дано В активном окне открылась форма с заголовком "Documents for incoming payment"'|
	* Проверка подключения формы по валютам
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
	* Проверка перерасчета по курсу в случае изменения даты
		И я перехожу к закладке "Other"
		И в поле 'Date' я ввожу текст '01.11.2018  0:00:00'
		И я перехожу к закладке "Payments"
		И     таблица "CurrenciesPaymentList" содержит строки:
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5*'                | '20*'    | '1'            |
		| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '100'    | '1'            |
		| 'TRY'                | 'Agreement' | 'TRY'           | 'TRY'      | '1'                 | '200'    | '1'            |
		| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '200'    | '1'            |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '*'                 | '40*'     | '1'            |
		И Пауза 5
	* Проверка невозможности провести документ без заполненного документа-основания при выборе соглашения с учетом по документам
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   | 'Payer'             |
			| 'Ferron BP' | 'Company Ferron BP' |
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Agreements, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post'
		Если в сообщениях пользователю есть строка "Basis document is required on line 1" Тогда

Сценарий: _0154108 проверка расчета Total amount в Cash reciept
	* Открытие формы Cash reciept
		И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Проверка пересчета Total amount при добавлении строк
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
	* Проверка пересчета Total amount при удалении строки
		И в таблице "PaymentList" я перехожу к строке:
		| 'Amount' |
		| '50,00'  |
		И в таблице 'PaymentList' я удаляю строку
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '380,00'
	* Проверка пересчета Total amount при добавлении строки
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '80,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '460,00'
		
Сценарий: _0154109 Check filling inи перезаполнения Bank reciept (вид операции Payment from customer)
	* Открытие формы Bank reciept
		И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Проверка установки вида операции 'Payment from customer' по умолчанию
		И     элемент формы с именем "TransactionType" стал равен 'Payment from customer'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
	* Check filling inкомпании
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
	* Check filling inвалюты до выбора счета
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| USD  |
		И в таблице "List" я выбираю текущую строку
	* Выбор банковского счета и проверка перезаполнения поля Currency
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Bank account, TRY |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Currency" стал равен 'TRY'
	* Проверка перевыбора валюты и очистка поля "Account"
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
	* Проверка выбора партнера в табличной части и заполнения по нему контрагента если он один
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
	* Check filling inAgreement при добавлении партнера если оно у партнера одно
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayer"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Nicoletta'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Agreement'                              | 'Payer'             |
			| 'Nicoletta' | 'Posting by standart agreement Customer' | 'Company Nicoletta' |
		И в таблице "PaymentList" я нажимаю на кнопку 'Delete'
	* Проверка отображения для выбора только доступных соглашений по партнеру
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
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
		Тогда таблица "List" содержит строки:
			| 'Description'                   |
			| 'Basic Agreements, TRY'         |
			| 'Basic Agreements, without VAT' |
			| 'Vendor Ferron, TRY'            |
			| 'Vendor Ferron, USD'            |
			| 'Vendor Ferron, EUR'            |
			| 'Ferron, USD'                   |
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Agreements, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Проверка фильтра по документам-основаниям в зависимости от Agreement
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
	* Проверка очистки basis document при очистке соглашения
		И в таблице "PaymentList" я выбираю текущую строку
		И я нажимаю кнопку очистить у поля "Agreement"
		И в таблице "PaymentList" я завершаю редактирование строки
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Agreement' | 'Amount' | 'Payer'             | 'Basis document' |
			| 'Ferron BP' | ''          | ''       | 'Company Ferron BP' | ''               |
	* Проверка добавления basis document без выбора документа основания
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Когда Проверяю шаги на Исключение:
			|'Дано В активном окне открылась форма с заголовком "Documents for incoming payment"'|
	* Проверка недоступности выбора документа-основания при выборе Agreement с расчетом by standart agreement
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
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Posting by standart agreement Customer' |
		И в таблице "List" я выбираю текущую строку
	* Проверка добавления basis document без выбора документа основания
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Когда Проверяю шаги на Исключение:
			|'Дано В активном окне открылась форма с заголовком "Documents for incoming payment"'|
	* Проверка подключения формы по валютам
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
	* Проверка перерасчета по курсу в случае изменения даты
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
	* Проверка невозможности провести документ без заполненного документа-основания при выборе соглашения с учетом по документам
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   | 'Payer'             |
			| 'Ferron BP' | 'Company Ferron BP' |
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Agreements, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post'
		Если в сообщениях пользователю есть строка "Basis document is required on line 1" Тогда

Сценарий: _0154110 проверка расчета Total amount в Bank reciept
	* Открытие формы Bank reciept
		И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Проверка пересчета Total amount при добавлении строк
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
	* Проверка пересчета Total amount при удалении строки
		И в таблице "PaymentList" я перехожу к строке:
		| 'Amount' |
		| '50,00'  |
		И в таблице 'PaymentList' я удаляю строку
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '380,00'
	* Проверка пересчета Total amount при добавлении строки
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '80,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '460,00'



Сценарий: _0154111 Check filling inи перезаполнения Cash payment (вид операции Payment to the vendor)
	* Открытие формы Cash payment
		И я открываю навигационную ссылку 'e1cib/list/Document.CashPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Проверка установки вида операции 'Payment from customer' по умолчанию
		И     элемент формы с именем "TransactionType" стал равен 'Payment to the vendor'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
	* Check filling inкомпании
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
	* Check filling inвалюты до выбора кассы
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| USD  |
		И в таблице "List" я выбираю текущую строку
	* Check filling inкассы (мультивалютная)
		И я нажимаю кнопку выбора у поля "Cash account"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №1 |
		И в таблице "List" я выбираю текущую строку
	* Перевыбор кассы с фиксированной валютой и проверка перезаполнения поля Currency
		И я нажимаю кнопку выбора у поля "Cash account"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №4 |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Currency" стал равен 'TRY'
	* Проверка перевыбора валюты и очистка поля "Cash account" в случае если валюта зафиксированна по кассе
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| USD  |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "CashAccount" стал равен ''
	* Выбор мультивалютной кассы и проверка что поле Currency не очистится
		И я нажимаю кнопку выбора у поля "Cash account"
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
	* Проверка выбора партнера в табличной части и заполнения по нему контрагента если он один
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
	* Check filling inAgreement при добавлении партнера если оно у партнера одно
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayee"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Veritas'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Agreement'                               | 'Payee'             |
			| 'Veritas'   | 'Posting by standart agreement (Veritas)' | 'Company Veritas' |
		И в таблице "PaymentList" я нажимаю на кнопку 'Delete'
	* Проверка отображения для выбора только доступных соглашений по партнеру
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
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
		Тогда таблица "List" содержит строки:
			| 'Description'                   |
			| 'Basic Agreements, TRY'         |
			| 'Basic Agreements, without VAT' |
			| 'Vendor Ferron, TRY'            |
			| 'Vendor Ferron, USD'            |
			| 'Vendor Ferron, EUR'            |
			| 'Ferron, USD'                   |
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Проверка фильтра по документам-основаниям в зависимости от Agreement
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
	* Проверка очистки basis document при очистке соглашения
		И в таблице "PaymentList" я выбираю текущую строку
		И я нажимаю кнопку очистить у поля "Agreement"
		И в таблице "PaymentList" я завершаю редактирование строки
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Agreement' | 'Amount' | 'Payee'             | 'Basis document' |
			| 'Ferron BP' | ''          | ''       | 'Company Ferron BP' | ''               |
	* Проверка добавления basis document без выбора документа основания
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Когда Проверяю шаги на Исключение:
			|'Дано В активном окне открылась форма с заголовком "Documents for incoming payment"'|
	* Проверка недоступности выбора документа-основания при выборе Agreement с расчетом by standart agreement
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
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Posting by standart agreement (Veritas)' |
		И в таблице "List" я выбираю текущую строку
	* Проверка добавления basis document без выбора документа основания
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Когда Проверяю шаги на Исключение:
			|'Дано В активном окне открылась форма с заголовком "Documents for incoming payment"'|
	* Проверка подключения формы по валютам
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
	* Проверка перерасчета по курсу в случае изменения даты
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
	* Проверка невозможности провести документ без заполненного документа-основания при выборе соглашения с учетом по документам
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   | 'Payee'             |
			| 'Ferron BP' | 'Company Ferron BP' |
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post'
		Если в сообщениях пользователю есть строка "Basis document is required on line 1" Тогда

Сценарий: _0154112 проверка расчета Total amount в Cash payment
	* Открытие формы Cash payment
		И я открываю навигационную ссылку 'e1cib/list/Document.CashPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Проверка пересчета Total amount при добавлении строк
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
	* Проверка пересчета Total amount при удалении строки
		И в таблице "PaymentList" я перехожу к строке:
		| 'Amount' |
		| '50,00'  |
		И в таблице 'PaymentList' я удаляю строку
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '380,00'
	* Проверка пересчета Total amount при добавлении строки
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '80,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '460,00'


Сценарий: _0154113 Check filling inи перезаполнения Bank payment (вид операции Payment to the vendor)
	* Открытие формы Bank payment
		И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Проверка установки вида операции 'Payment from customer' по умолчанию
		И     элемент формы с именем "TransactionType" стал равен 'Payment to the vendor'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
	* Check filling inкомпании
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
	* Выбор банковского счета и проверка перезаполнения поля Currency
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Bank account, TRY |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Currency" стал равен 'TRY'
	* Проверка перевыбора валюты и очистка поля "Account" в случае если валюта зафиксированна по кассе
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
	* Проверка выбора партнера в табличной части и заполнения по нему контрагента если он один
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
	* Check filling inAgreement при добавлении партнера если оно у партнера одно
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayee"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Veritas'         |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Agreement'                               | 'Payee'             |
			| 'Veritas'   | 'Posting by standart agreement (Veritas)' | 'Company Veritas' |
		И в таблице "PaymentList" я нажимаю на кнопку 'Delete'
	* Проверка отображения для выбора только доступных соглашений по партнеру
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
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
		Тогда таблица "List" содержит строки:
			| 'Description'                   |
			| 'Basic Agreements, TRY'         |
			| 'Basic Agreements, without VAT' |
			| 'Vendor Ferron, TRY'            |
			| 'Vendor Ferron, USD'            |
			| 'Vendor Ferron, EUR'            |
			| 'Ferron, USD'                   |
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Проверка фильтра по документам-основаниям в зависимости от Agreement
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
	* Проверка очистки basis document при очистке соглашения
		И в таблице "PaymentList" я выбираю текущую строку
		И я нажимаю кнопку очистить у поля "Agreement"
		И в таблице "PaymentList" я завершаю редактирование строки
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Agreement' | 'Amount' | 'Payee'             | 'Basis document' |
			| 'Ferron BP' | ''          | ''       | 'Company Ferron BP' | ''               |
	* Проверка добавления basis document без выбора документа основания
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Когда Проверяю шаги на Исключение:
			|'Дано В активном окне открылась форма с заголовком "Documents for incoming payment"'|
	* Проверка недоступности выбора документа-основания при выборе Agreement с расчетом by standart agreement
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
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Posting by standart agreement (Veritas)' |
		И в таблице "List" я выбираю текущую строку
	* Проверка добавления basis document без выбора документа основания
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Когда Проверяю шаги на Исключение:
			|'Дано В активном окне открылась форма с заголовком "Documents for incoming payment"'|
	* Проверка подключения формы по валютам
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
	* Проверка перерасчета по курсу в случае изменения даты
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
	* Проверка невозможности провести документ без заполненного документа-основания при выборе соглашения с учетом по документам
		И в таблице "PaymentList" я перехожу к строке:
			| 'Partner'   | 'Payee'             |
			| 'Ferron BP' | 'Company Ferron BP' |
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post'
		Если в сообщениях пользователю есть строка "Basis document is required on line 1" Тогда

Сценарий: _0154114 проверка расчета Total amount в Bank payment
	* Открытие формы Bank payment
		И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Проверка пересчета Total amount при добавлении строк
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
	* Проверка пересчета Total amount при удалении строки
		И в таблице "PaymentList" я перехожу к строке:
		| 'Amount' |
		| '50,00'  |
		И в таблице 'PaymentList' я удаляю строку
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '380,00'
	* Проверка пересчета Total amount при добавлении строки
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '80,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '460,00'

Сценарий: _01541140 проверка расчета Total amount в Incoming payment order
	* Открытие формы Bank payment
		И я открываю навигационную ссылку 'e1cib/list/Document.IncomingPaymentOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Проверка пересчета Total amount при добавлении строк
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
	* Проверка пересчета Total amount при удалении строки
		И в таблице "PaymentList" я перехожу к строке:
		| 'Amount' |
		| '50,00'  |
		И в таблице 'PaymentList' я удаляю строку
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '380,00'
	* Проверка пересчета Total amount при добавлении строки
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '80,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '460,00'

Сценарий: _01541141 проверка расчета Total amount в Outgoing payment order
	* Открытие формы Bank payment
		И я открываю навигационную ссылку 'e1cib/list/Document.OutgoingPaymentOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Проверка пересчета Total amount при добавлении строк
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
	* Проверка пересчета Total amount при удалении строки
		И в таблице "PaymentList" я перехожу к строке:
		| 'Amount' |
		| '50,00'  |
		И в таблице 'PaymentList' я удаляю строку
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '380,00'
	* Проверка пересчета Total amount при добавлении строки
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '80,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     у элемента формы с именем "DocumentAmount" текст редактирования стал равен '460,00'

Сценарий: _0154115 Check filling inи перезаполнения Cash transfer order
	* Открытие формы Cash transfer order
		И я открываю навигационную ссылку 'e1cib/list/Document.CashTransferOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Check filling inвалюты пи выборе банка/кассы если она зафиксированна
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
	* Проверка перезаполнения валюты при перевыборе "Sender" и "Receiver"
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
	* Check filling inсуммы в Receive amount из Send amount в случае совпадения валют
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
	* Check filling inSend date и Receive date
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
	* Проверка прорисовки поля Cash advance holder в случае обмена валюты через кассы
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
	* Проверка формы по валютам
			И в поле 'Receive amount' я ввожу текст '584,00'
			И я перехожу к следующему реквизиту
			И     таблица "ObjectCurrencies" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Local currency'     | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'            | '564,97' | '1'            |
			| 'Reporting currency' | 'Reporting' | 'USD'           | 'USD'      | '1'                 | '100'    | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '584'    | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '100,00' | '1'            |

Сценарий: _01541151 проверка на совпадение суммы отправки и получения в Cash transfer order
	* Проверка при перемещении ДС между двумя кассами
		* Открытие формы Cash transfer order
			И я открываю навигационную ссылку 'e1cib/list/Document.CashTransferOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
		* Заполнение данных
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
		* Проверка сообщения при проведении
			И я нажимаю на кнопку 'Post'
			Затем я жду, что в сообщениях пользователю будет подстрока "Currency transfer is possible only when amounts is equal." в течение 10 секунд
			И я закрыл все окна клиентского приложения
	* Проверка при перемещении ДС между кассой и банком
		* Открытие формы Cash transfer order
			И я открываю навигационную ссылку 'e1cib/list/Document.CashTransferOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
		* Заполнение данных
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
		* Проверка сообщения при проведении
			И я нажимаю на кнопку 'Post'
			Затем я жду, что в сообщениях пользователю будет подстрока "Currency transfer is possible only when amounts is equal." в течение 10 секунд
			И я закрыл все окна клиентского приложения
	* Проверка при перемещении ДС между банком и кассой
		* Открытие формы Cash transfer order
			И я открываю навигационную ссылку 'e1cib/list/Document.CashTransferOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
		* Заполнение данных
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
		* Проверка сообщения при проведении
			И я нажимаю на кнопку 'Post'
			Затем я жду, что в сообщениях пользователю будет подстрока "Currency transfer is possible only when amounts is equal." в течение 10 секунд
			И я закрыл все окна клиентского приложения
	* Проверка при перемещении ДС между двумя банковскими счетами
		* Открытие формы Cash transfer order
			И я открываю навигационную ссылку 'e1cib/list/Document.CashTransferOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
		* Заполнение данных
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
		* Проверка сообщения при проведении
			И я нажимаю на кнопку 'Post'
			Затем я жду, что в сообщениях пользователю будет подстрока "Currency transfer is possible only when amounts is equal." в течение 10 секунд
			И я закрыл все окна клиентского приложения



Сценарий: _0154116 Check filling inи перезаполнения Cash expence
	* Открытие формы Cash expence
		И я открываю навигационную ссылку 'e1cib/list/Document.CashExpense'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Проверка фильтра по Account в зависимости от компании
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
		И Я закрываю окно 'Cash accounts'
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
	* Проверка расчета Net amount и VAT при заполнении Total amount
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
	* Проверка перерасчета Total amount при изменении Tax
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
	* Проверка перерасчета Net amount при изменении Total amount с изменениями по налогам
		И в таблице "PaymentList" в поле с именем 'PaymentListTotalAmount' я ввожу текст '220,00'
		Тогда таблица "PaymentList" содержит строки:
			| 'Net amount' | 'Business unit'      | 'Expense type'             | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '186,45'     | 'Accountants office' | 'Telephone communications' | 'TRY'      | '18%' | '33,55'      | '220,00'       |
	* Проверка перерасчета Total amount при изменении Net amount с изменениями по налогам
		И в таблице "PaymentList" в поле с именем 'PaymentListNetAmount' я ввожу текст '187,00'
		Тогда таблица "PaymentList" содержит строки:
			| 'Net amount' | 'Expense type'                     | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '187,00'     | 'Telephone communications'         | 'TRY'      | '18%' | '33,55'      | '220,55'       |
	* Проверка подключения формы по валютам
		И     таблица "PaymentListCurrencies" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '37,77'  | '1'            |
	* Добавление ещё одной строки
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
	* Ручная корректировка налога по строке
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
	* Удаление строки и проверка пересчета общей суммы
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListCurrency"
		И в таблице "PaymentList" я перехожу к строке:
			| 'Business unit'      | 'Currency' | 'Expense type'             | 'Net amount' | 'Tax amount' | 'Total amount' | 'VAT' |
			| 'Accountants office' | 'TRY'      | 'Telephone communications' | '187,00'     | '33,55'      | '220,55'       | '18%' |
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListContextMenuDelete'
		И     у элемента формы с именем "PaymentListTotalNetAmount" текст редактирования стал равен '200,00'
		И     у элемента формы с именем "PaymentListTotalTaxAmount" текст редактирования стал равен '38,00'
		И     у элемента формы с именем "PaymentListTotalTotalAmount" текст редактирования стал равен '238,00'
	* Изменение счета
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
	* Проверка неизменения счета при нажатии в окне-сообщении No
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
	* Изменение компании (без налогов) и проверка удаления колонки VAT
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		И я жду, что таблица "PaymentList" не станет содержать строки в течение 20 секунд:
		| 'VAT' | 'Tax amount' |
		| '18%' | '38,00'      |
	* Изменение компании на ту у которой есть налоги и проверка формы по валютам
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
	* Добавление ещё одной строки с другой валютой
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
	* Проверка добавления строки в форму по валютам
		И  в таблице "PaymentListCurrencies" я перехожу к строке:
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'Local currency'     | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'             | '564,97' | '1'            |
	* Изменение валюты по первой строке и проверка формы по валютам
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
	* Ручная корректировка налоговой ставки и проверка расчетов налога
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





Сценарий: _0154117 Check filling inи перезаполнения Cash revenue
	* Открытие формы Cash revenue
		И я открываю навигационную ссылку 'e1cib/list/Document.CashRevenue'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Проверка фильтра по Account в зависимости от компании
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
		И Я закрываю окно 'Cash accounts'
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
	* Проверка расчета Net amount и VAT при заполнении Total amount
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
	* Проверка перерасчета Total amount при изменении Tax
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
	* Проверка перерасчета Net amount при изменении Total amount с изменениями по налогам
		И в таблице "PaymentList" в поле с именем 'PaymentListTotalAmount' я ввожу текст '220,00'
		Тогда таблица "PaymentList" содержит строки:
		| 'Net amount' | 'Business unit'      | 'Revenue type'             | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
		| '186,45'     | 'Accountants office' | 'Telephone communications' | 'TRY'      | '18%' | '33,55'      | '220,00'       |
	* Проверка перерасчета Total amount при изменении Net amount с изменениями по налогам
		И в таблице "PaymentList" в поле с именем 'PaymentListNetAmount' я ввожу текст '187,00'
		Тогда таблица "PaymentList" содержит строки:
		| 'Net amount' | 'Revenue type'                     | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
		| '187,00'     | 'Telephone communications'         | 'TRY'      | '18%' | '33,55'      | '220,55'       |
	* Проверка подключения формы по валютам
		И     таблица "PaymentListCurrencies" содержит строки:
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '37,77'  | '1'            |
	* Добавление ещё одной строки
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
	* Ручная корректировка налога по строке
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
	* Удаление строки и проверка пересчета общей суммы
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListCurrency"
		И в таблице "PaymentList" я перехожу к строке:
			| 'Business unit'      | 'Currency' | 'Revenue type'             | 'Net amount' | 'Tax amount' | 'Total amount' | 'VAT' |
			| 'Accountants office' | 'TRY'      | 'Telephone communications' | '187,00'     | '33,55'      | '220,55'       | '18%' |
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListContextMenuDelete'
		И     у элемента формы с именем "PaymentListTotalNetAmount" текст редактирования стал равен '200,00'
		И     у элемента формы с именем "PaymentListTotalTaxAmount" текст редактирования стал равен '38,00'
		И     у элемента формы с именем "PaymentListTotalTotalAmount" текст редактирования стал равен '238,00'
	* Изменение счета
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
	* Проверка неизменения счета при нажатии в окне-сообщении No
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
	* Изменение компании (без налогов) и проверка удаления колонки VAT
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		И я жду, что таблица "PaymentList" не станет содержать строки в течение 20 секунд:
		| 'VAT' | 'Tax amount' |
		| '18%' | '38,00'      |
	* Проверка корректировки налоговой ставки вручную
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

Сценарий: _0154118 проверка очистки реквизитов на форме Cash reciept при перевыборе вида операции
	* Открытие формы CashReceipt
		И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document CashReceipt
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Cash account"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №2 |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| TRY  |
		И в таблице "List" я выбираю текущую строку
	* Заполнение информации по Partner, Payer и Agreement
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле "Partner"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Nicoletta   |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
		| 'Partner'   | 'Agreement'                              | 'Payer'             |
		| 'Nicoletta' | 'Posting by standart agreement Customer' | 'Company Nicoletta' |
	* Проверка очистки полей 'Agreement' и 'Payer' при перевыборе вида операции на Currency exchange
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner'   | 'Amount' | 'Amount exchange' | 'Planing transaction basis' |
		| '1' | 'Nicoletta' | ''       | ''                | ''                          |
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner'   | 'Agreement' | 'Amount' | 'Payer' | 'Basis document' | 'Planing transaction basis' |
		| '1' | 'Nicoletta' | ''          | ''       | ''      | ''               | ''                          |
	* Проверка очистки полей 'Partner' при перевыборе вида операции на Cash transfer order
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner' | 'Agreement' | 'Amount' | 'Payer' | 'Basis document' | 'Planing transaction basis' |
		| '1' | ''        | ''          | ''       | ''      | ''               | ''                          |
		И Я закрыл все окна клиентского приложения


Сценарий: _0154119 проверка очистки реквизитов на форме Cash payment при перевыборе вида операции
	* Открытие формы CashPayment
		И я открываю навигационную ссылку 'e1cib/list/Document.CashPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document CashPayment
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Cash account"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №2 |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| TRY  |
		И в таблице "List" я выбираю текущую строку
	* Заполнение информации по Partner, Payee и Agreement
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле "Partner"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Nicoletta   |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
		| 'Partner'   | 'Agreement'                              | 'Payee'             |
		| 'Nicoletta' | 'Posting by standart agreement Customer' | 'Company Nicoletta' |
	* Проверка очистки полей 'Agreement' и 'Payee' при перевыборе вида операции на Currency exchange
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner'   | 'Amount' | 'Planing transaction basis' |
		| '1' | 'Nicoletta' | ''       | ''                          |
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner'   | 'Agreement' | 'Amount' | 'Payee' | 'Basis document' | 'Planing transaction basis' |
		| '1' | 'Nicoletta' | ''          | ''       | ''      | ''               | ''                          |
	* Проверка очистки полей 'Partner' при перевыборе вида операции на Cash transfer order
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner' | 'Agreement' | 'Amount' | 'Payee' | 'Basis document' | 'Planing transaction basis' |
		| '1' | ''        | ''          | ''       | ''      | ''               | ''                          |
		И Я закрыл все окна клиентского приложения

Сценарий: _0154120 проверка очистки реквизитов на форме Bank reciept при перевыборе вида операции
	* Открытие формы BankReceipt
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
	* Заполнение информации по Partner, Payer и Agreement
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле "Partner"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Nicoletta   |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
		| 'Partner'   | 'Agreement'                              | 'Payer'             |
		| 'Nicoletta' | 'Posting by standart agreement Customer' | 'Company Nicoletta' |
	* Проверка очистки полей 'Agreement' и 'Payer' при перевыборе вида операции на Currency exchange
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Amount' | 'Amount exchange' | 'Planing transaction basis' |
		| '1' | ''       | ''                | ''                          |
		* Check filling inTransit account из Accountant
			И     элемент формы с именем "TransitAccount" стал равен 'Transit Main'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner'   | 'Agreement' | 'Amount' | 'Payer' | 'Basis document' | 'Planing transaction basis' |
		| '1' | ''          | ''          | ''       | ''      | ''               | ''                          |
		И     элемент формы с именем "TransitAccount" стал равен ''
	* Проверка очистки полей 'Partner' при перевыборе вида операции на Cash transfer order
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner' | 'Agreement' | 'Amount' | 'Payer' | 'Basis document' | 'Planing transaction basis' |
		| '1' | ''        | ''          | ''       | ''      | ''               | ''                          |
		И Я закрыл все окна клиентского приложения


Сценарий: _0154121 проверка очистки реквизитов на форме Bank payment при перевыборе вида операции
	* Открытие формы BankPayment
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
	* Заполнение информации по Partner, Payee и Agreement
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я активизирую поле "Partner"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Nicoletta   |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
		| 'Partner'   | 'Agreement'                              | 'Payee'             |
		| 'Nicoletta' | 'Posting by standart agreement Customer' | 'Company Nicoletta' |
	* Проверка очистки полей 'Agreement' и 'Payee' при перевыборе вида операции на Currency exchange
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Amount' | 'Planing transaction basis' |
		| '1' | ''       | ''                          |
		* Check filling inTransit account из Accountant
			И     элемент формы с именем "TransitAccount" стал равен 'Transit Main'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner'   | 'Agreement' | 'Amount' | 'Payee' | 'Basis document' | 'Planing transaction basis' |
		| '1' | ''          | ''          | ''       | ''      | ''               | ''                          |
		И     элемент формы с именем "TransitAccount" стал равен ''
	* Проверка очистки полей 'Partner' при перевыборе вида операции на Cash transfer order
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И     таблица "PaymentList" стала равной:
		| '#' | 'Partner' | 'Agreement' | 'Amount' | 'Payee' | 'Basis document' | 'Planing transaction basis' |
		| '1' | ''        | ''          | ''       | ''      | ''               | ''                          |
		И Я закрыл все окна клиентского приложения


Сценарий: _0154122 Check filling inи перезаполнения Reconcilation statement
	* Opening a document form
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
	* Проверка что таблица транзакций заполнилась
		И Пока в таблице "Transactions" количество строк ">" 0 Тогда
		И я нажимаю на кнопку 'Post'
		И     таблица "Transactions" не содержит строки:
			| 'Document'            | 'Credit'     | 'Debit'     |
			| 'Purchase invoice 1*' | '137 000,00' | ''          |
			| 'Sales invoice 1*'    | ''           | '4 350,00'  |
			| 'Sales invoice 2*'    | ''           | '11 099,93' |
	* Проверка перезаполнения при перевыборе партнера
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
	* Проверка перезаполнения при перевыборе валюты
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
	* Проверка перезаполнения при перевыборе компании
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я нажимаю на кнопку 'Fill'
		Тогда в таблице "Transactions" количество строк "равно" 0
	* Проверка перезаполнения при перевыборе контрагента (партнер прежний)
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


Сценарий: _0154123 заполнение Transit account из Account при обмене валюты в BankReceipt
	И Я закрыл все окна клиентского приложения
	* Открытие формы BankReceipt и выбор типа операции Currency exchange
		И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
	* Check filling inTransit account 
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Bank account, USD' |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "TransitAccount" стал равен 'Transit Second'
	* Check filling inTransit account при перевыборе Bank account
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "TransitAccount" стал равен 'Transit Main'
		И Я закрыл все окна клиентского приложения

Сценарий: _0154124 заполнение Transit account из Account при обмене валюты в BankPayment
	И Я закрыл все окна клиентского приложения
	* Открытие формы BankPayment и выбор типа операции Currency exchange
		И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
	* Check filling inTransit account 
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'USD'      | 'Bank account, USD' |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "TransitAccount" стал равен 'Transit Second'
	* Check filling inTransit account при перевыборе Bank account
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "TransitAccount" стал равен 'Transit Main'
		И Я закрыл все окна клиентского приложения
	* Проверка выбора Transit account

Сценарий: _0154125 проверка отбора по Planing transaction basis в документе BankPayment в случае обмена валюты
	* Открытие формы BankPayment и выбор типа операции Currency exchange
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
	* Проверка отбора по Planing transaction basis
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
	* Проверка того, что выбранный документ попал в BankPayment
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planing transaction basis' |
		| '100,00' | 'Cash transfer order 13*'   |
	* Проверка того, что в форме подбора Planing transaction basis отображается документ который уже выбран
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		И в таблице "List" я перехожу к строке:
		| 'Number' | 'Sender'            | 'Company'      | 'Send currency' |
		| '13'     | 'Bank account, TRY' | 'Main Company' | 'TRY'           |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '100,00'
	* Проверка того, что в форме подбора Planing transaction basis отображается документ который уже выбран при проведенном Bank Payment
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
	* Проверка того, что в форме подбора Planing transaction basis отображается документ который уже был выбран ранее (строка удалена)
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
	* Проверка не очистки Planing transaction basis в случае отмены при изменении вида транзакции
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Cancel'
	* Проверка очистки Planing transaction basis в случае изменения вида транзакции
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planing transaction basis' |
		| '200,00' | ''                          |
	И я закрыл все окна клиентского приложения
	# * Переоткрытие созданного BankPayment
	# 	И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
	# 	И в таблице "List" я перехожу к строке:
	# 		| 'Number' |
	# 		| '$Number$' |
	# 	И в таблице "List" я выбираю текущую строку
	# * Проверка очистки Planing transaction basis в случае изменения валюты
	# 	И я нажимаю кнопку выбора у поля "Account"
	# 	И в таблице "List" я перехожу к строке:
	# 		| 'Currency' | 'Description'         |
	# 		| 'USD'      | 'Bank account, USD' |
	# 	И в таблице "List" я выбираю текущую строку


Сценарий: _0154126 проверка отбора по Planing transaction basis в документе BankReceipt в случае обмена валюты
	* Открытие формы BankPayment и выбор типа операции Currency exchange
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
	* Проверка отбора по Planing transaction basis
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
	* Проверка того, что выбранный документ попал в BankPayment
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planing transaction basis' |
		| '100,00' | 'Cash transfer order 13*'   |
	* Проверка того, что в форме подбора Planing transaction basis отображается документ который уже выбран
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'            | 'Send currency'    | 'Company'      |
		| '13'     | 'Bank account, TRY' | 'TRY'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '100,00'
	* Проверка того, что в форме подбора Planing transaction basis отображается документ который уже выбран при проведенном Bank Receipt
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
	* Проверка того, что в форме подбора Planing transaction basis отображается документ который уже был выбран ранее (строка удалена)
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
	* Проверка не очистки Planing transaction basis в случае отмены при изменении вида транзакции
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Cancel'
	* Проверка очистки Planing transaction basis в случае изменения вида транзакции
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planing transaction basis' |
		| '200,00' | ''                          |
	И я закрыл все окна клиентского приложения


Сценарий: _0154127 проверка отбора по Planing transaction basis в документе CashPayment в случае обмена валюты
	* Открытие формы CashPayment и выбор типа операции Currency exchange
		И я открываю навигационную ссылку 'e1cib/list/Document.CashPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
	* Filling in the details of the document
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Cash account"
		И в таблице "List" я перехожу к строке:
			| 'Description'         |
			| 'Cash desk №2' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Currency"
		И в таблице "List" я перехожу к строке:
		| 'Code' | 'Description'     |
		| 'USD'  | 'American dollar' |
		И в таблице "List" я выбираю текущую строку
	* Проверка отбора по Planing transaction basis
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'       | 'Company'      | 'Send currency' |
		| '11'     | 'Cash desk №2' | 'Main Company' | 'USD'           |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '100,00'
	* Проверка того, что выбранный документ попал в CashPayment
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planing transaction basis' |
		| '100,00' | 'Cash transfer order 11*'   |
	* Проверка того, что в форме подбора Planing transaction basis отображается документ который уже выбран
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'       | 'Company'      | 'Send currency' |
		| '11'     | 'Cash desk №2' | 'Main Company' | 'USD'           |
		И я нажимаю на кнопку с именем 'FormChoose'
	* Проверка того, что в форме подбора Planing transaction basis отображается документ который уже выбран при проведенном CashPayment
		И я нажимаю на кнопку 'Post'
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'       | 'Company'      | 'Send currency' |
		| '11'     | 'Cash desk №2' | 'Main Company' | 'USD'           |
		И я нажимаю на кнопку с именем 'FormChoose'
	* Проверка того, что в форме подбора Planing transaction basis отображается документ который уже был выбран ранее (строка удалена)
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
	* Проверка не очистки Planing transaction basis в случае отмены при изменении вида транзакции
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Cancel'
	* Проверка очистки Planing transaction basis в случае изменения вида транзакции
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planing transaction basis' |
		| '200,00' | ''                          |
	И я закрыл все окна клиентского приложения


Сценарий: _0154128 проверка отбора по Planing transaction basis в документе CashReceipt в случае обмена валюты
	* Открытие формы CashReceipt и выбор типа операции Currency exchange
		И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
	* Filling in the details of the document
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Cash account"
		И в таблице "List" я перехожу к строке:
			| 'Description'         |
			| 'Cash desk №1' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' |
			| 'TRY'  |
		И в таблице "List" я выбираю текущую строку
	* Проверка отбора по Planing transaction basis
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
			| 'Number' | 'Sender'       | 'Send currency'    | 'Company'      |
			| '11'     | 'Cash desk №2' | 'USD'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '100,00'
	* Проверка того, что выбранный документ попал в CashReceipt
		Тогда таблица "PaymentList" содержит строки:
			| 'Amount' | 'Planing transaction basis' |
			| '100,00' | 'Cash transfer order 11*'   |
	* Проверка того, что в форме подбора Planing transaction basis отображается документ который уже выбран
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
			| 'Number' | 'Sender'       | 'Send currency'    | 'Company'      |
			| '11'     | 'Cash desk №2' | 'USD'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
	* Проверка того, что в форме подбора Planing transaction basis отображается документ который уже выбран при проведенном CashReceipt
		И я нажимаю на кнопку 'Post'
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'       | 'Send currency'    | 'Company'      |
		| '11'     | 'Cash desk №2' | 'USD'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
	* Проверка того, что в форме подбора Planing transaction basis отображается документ который уже был выбран ранее (строка удалена)
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
	* Проверка не очистки Planing transaction basis в случае отмены при изменении вида транзакции
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Cancel'
	* Проверка очистки Planing transaction basis в случае изменения вида транзакции
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planing transaction basis' |
		| '200,00' | ''                          |
	И я закрыл все окна клиентского приложения

Сценарий:  _0154129 проверка отбора по Planing transaction basis в документе BankPayment в случае перемещения ДС
	* Открытие формы BankPayment и выбор типа операции Cash transfer order
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
	* Проверка отбора по Planing transaction basis
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'              | 'Company'      | 'Send currency' |
		| '14'     | 'Bank account 2, EUR' | 'Main Company' | 'EUR'           |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '100,00'
	* Проверка того, что выбранный документ попал в BankPayment
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planing transaction basis' |
		| '100,00' | 'Cash transfer order 14*'   |
	* Проверка того, что в форме подбора Planing transaction basis отображается документ который уже выбран
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'              | 'Company'      | 'Send currency' |
		| '14'     | 'Bank account 2, EUR' | 'Main Company' | 'EUR'           |
		И я нажимаю на кнопку с именем 'FormChoose'
	* Проверка того, что в форме подбора Planing transaction basis отображается документ который уже выбран при проведенном Bank Payment
		И я нажимаю на кнопку 'Post'
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'              | 'Company'      | 'Send currency' |
		| '14'     | 'Bank account 2, EUR' | 'Main Company' | 'EUR'           |
		И я нажимаю на кнопку с именем 'FormChoose'
	* Проверка того, что в форме подбора Planing transaction basis отображается документ который уже был выбран ранее (строка удалена)
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
	* Проверка не очистки Planing transaction basis в случае отмены при изменении вида транзакции
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Cancel'
	* Проверка очистки Planing transaction basis в случае изменения вида транзакции
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planing transaction basis' |
		| '200,00' | ''                          |
	И я закрыл все окна клиентского приложения

Сценарий:  _0154130 проверка отбора по Planing transaction basis в документе BankReceipt в случае перемещения ДС
	* Открытие формы BankReceipt и выбор типа операции Cash transfer order
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
	* Проверка отбора по Planing transaction basis
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'              | 'Send currency'    | 'Company'      |
		| '14'     | 'Bank account 2, EUR' | 'EUR'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '100,00'
	* Проверка того, что выбранный документ попал в BankReceipt
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planing transaction basis' |
		| '100,00' | 'Cash transfer order 14*'   |
	* Проверка того, что в форме подбора Planing transaction basis отображается документ который уже выбран
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'              | 'Send currency'    | 'Company'      |
		| '14'     | 'Bank account 2, EUR' | 'EUR'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
	* Проверка того, что в форме подбора Planing transaction basis отображается документ который уже выбран при проведенном Bank Receipt
		И я нажимаю на кнопку 'Post'
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Planing transaction basis"
		И я запоминаю количество строк таблицы "List" как "Q"
		Тогда переменная "Q" имеет значение 1
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Sender'              | 'Send currency'    | 'Company'      |
		| '14'     | 'Bank account 2, EUR' | 'EUR'              | 'Main Company' |
		И я нажимаю на кнопку с именем 'FormChoose'
	* Проверка того, что в форме подбора Planing transaction basis отображается документ который уже был выбран ранее (строка удалена)
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
	* Проверка не очистки Planing transaction basis в случае отмены при изменении вида транзакции
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Cancel'
	* Проверка очистки Planing transaction basis в случае изменения вида транзакции
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		Тогда таблица "PaymentList" содержит строки:
		| 'Amount' | 'Planing transaction basis' |
		| '200,00' | ''                          |
	И я закрыл все окна клиентского приложения

Сценарий: _053014 check the display of details on the form Bank payment with the type of operation Currency exchange
	И Я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
	И я нажимаю на кнопку с именем 'FormCreate'
	И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
	Then I check the display on the form of available fields
		И     элемент формы с именем "Company" доступен
		И     элемент формы с именем "Account" доступен
		И     элемент формы с именем "Description" доступен
		И     элемент формы с именем "TransactionType" стал равен 'Currency exchange'
		И     элемент формы с именем "Currency" доступен
		И     элемент формы с именем "Payee" не доступен
		И     элемент формы с именем "Date" доступен
		И     элемент формы с именем "TransitAccount" доступен
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
	And I check the display of the tabular part
		И     элемент формы с именем "TransitAccount" стал равен 'Transit Main'
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И     таблица "PaymentList" стала равной:
			| '#' | 'Amount' | 'Planing transaction basis' |
			| '1' | ''       | ''                          |



Сценарий: Check filling inи перезаполнения документа CreditDebitNote
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
		И в таблице "List" я перехожу к строке
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
	* Перевыбор партнера и проверка очистки данных в табличной части
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
	* Проверка фильтра документов-оснований по компании
		И из выпадающего списка "Operation type" я выбираю точное значение 'Payable'
	* Перевыбор компании
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
		Тогда таблица "List" содержит строки:
			| 'Number' | 'Legal name'    | 'Partner' | 'Amount'    | 'Currency' |
			| '2 900'  | 'Company Maxim' | 'Maxim'   | '11 000,00' | 'TRY'      |
			| '2 901'  | 'Company Maxim' | 'Maxim'   | '10 000,00' | 'TRY'      |
		И я закрыл все окна клиентского приложения

Сценарий: _0154131 проверка формы по валютам на примере Bank Receipt
	* Заполнение Bank Receipt
		* Заполнение шапки документа
			И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
			И я нажимаю на кнопку с именем 'FormCreate'
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
		* Выбор банковского счета и проверка перезаполнения поля Currency
			И я нажимаю кнопку выбора у поля "Account"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Bank account, TRY |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Currency" стал равен 'TRY'
		* Проверка выбора партнера в табличной части и заполнения по нему контрагента если он один
			И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
			И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayer"
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'DFC'         |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '200,00'
			И в таблице "PaymentList" я завершаю редактирование строки
	* Проверка формы по валютам
		* Базовый пересчет по курсу
			И в таблице "CurrenciesPaymentList" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '34,25'  | '1'            |
		* Пересчет Rate presentation при изменении Amount
			И в таблице "CurrenciesPaymentList" в поле с именем 'CurrenciesPaymentListAmount' я ввожу текст '35,00'
			И в таблице "CurrenciesPaymentList" я завершаю редактирование строки
			И в таблице "CurrenciesPaymentList" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,7143'            | '35,00'  | '1'            |
		* Пересчет Amount при изменении Multiplicity
			И в таблице "CurrenciesPaymentList" в поле 'Multiplicity' я ввожу текст '2'
			И в таблице "CurrenciesPaymentList" я завершаю редактирование строки
			И в таблице "CurrenciesPaymentList" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,7143'            | '17,50'  | '2'            |
		* Пересчет Amount при изменении Multiplicity Rate presentation
			И в таблице "CurrenciesPaymentList" в поле 'Rate presentation' я ввожу текст '6,0000'
			И в таблице "CurrenciesPaymentList" я завершаю редактирование строки
			И в таблице "CurrenciesPaymentList" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '6,0000'            | '16,67'  | '2'            |
		* Пересчет Amount при изменении суммы платежа
			И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '250,00'
			И в таблице "CurrenciesPaymentList" я завершаю редактирование строки
			И в таблице "CurrenciesPaymentList" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '6,0000'            | '20,83'  | '2'            |
		* Проверка стандартного курса при добавлении следующей строки
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
		* Пересчет при изменении валюты
			И я нажимаю кнопку выбора у поля "Account"
			И в таблице "List" я перехожу к строке:
				| 'Currency' | 'Description'       |
				| 'USD'      | 'Bank account, USD' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "CurrenciesPaymentList" я перехожу к строке:
				| 'Movement type'  | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'TRY'            | 'Agreement' | 'USD'           | 'TRY'      | '0,1770'             | '1 129,94' | '1'            |
			И в таблице "CurrenciesPaymentList" я перехожу к строке:
				| 'Movement type'  | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'TRY'            | 'Agreement' | 'USD'           | 'TRY'      | '0,1770'             | '1 129,94' | '1'            |
		* Проверка отображения обратного курса
			Дано двойной клик на картинку "reverse"
			И в таблице "PaymentList" я перехожу к строке:
				| 'Agreement'                               | 'Amount' | 'Partner' | 'Payer'            |
				| 'Posting by standart agreement (Veritas)' | '200,00' | 'Veritas' | 'Company Veritas ' |
			И в таблице "PaymentList" я активизирую поле "Agreement"
			Тогда таблица "CurrenciesPaymentList" содержит строки:
				| 'Movement type'  | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'Local currency' | 'Legal'     | 'USD'           | 'TRY'      | '5,6497'             | '1 129,94' | '1'            |
		И я закрыл все окна клиентского приложения

Сценарий: _0154132 проверка формы по валютам на примере Incoming payment order
	* Заполнение Incoming payment order
		* Заполнение шапки документа
			И я открываю навигационную ссылку 'e1cib/list/Document.IncomingPaymentOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
		* Выбор банковского счета и проверка перезаполнения поля Currency
			И я нажимаю кнопку выбора у поля "Account"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Bank account, TRY |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Currency" стал равен 'TRY'
		* Проверка выбора партнера в табличной части и заполнения по нему контрагента если он один
			И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'DFC'         |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '200,00'
			И в таблице "PaymentList" я завершаю редактирование строки
	* Проверка формы по валютам
		* Базовый пересчет по курсу
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '34,25'  | '1'            |
		* Пересчет Rate presentation при изменении Amount
			И в таблице "PaymentListCurrencies" в поле с именем 'PaymentListCurrenciesAmount' я ввожу текст '35,00'
			И в таблице "PaymentListCurrencies" я завершаю редактирование строки
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,7143'            | '35,00'  | '1'            |
		* Пересчет Amount при изменении Multiplicity
			И в таблице "PaymentListCurrencies" в поле 'Multiplicity' я ввожу текст '2'
			И в таблице "PaymentListCurrencies" я завершаю редактирование строки
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,7143'            | '17,50'  | '2'            |
		* Пересчет Amount при изменении Multiplicity Rate presentation
			И в таблице "PaymentListCurrencies" в поле 'Rate presentation' я ввожу текст '6,0000'
			И в таблице "PaymentListCurrencies" я завершаю редактирование строки
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '6,0000'            | '16,67'  | '2'            |
		* Пересчет Amount при изменении суммы платежа
			И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '250,00'
			И в таблице "PaymentListCurrencies" я завершаю редактирование строки
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '6,0000'            | '20,83'  | '2'            |
		* Проверка стандартного курса при добавлении следующей строки
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
		* Пересчет при изменении валюты
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
		* Проверка отображения обратного курса 
			Дано двойной клик на картинку "reverse"
			И в таблице "PaymentList" я перехожу к строке:
				| 'Amount' | 'Partner' | 'Payer'            |
				| '200,00' | 'Veritas' | 'Company Veritas ' |
			Тогда таблица "PaymentListCurrencies" содержит строки:
				| 'Movement type'  | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'Local currency' | 'Legal'     | 'USD'           | 'TRY'      | '5,6497'             | '1 129,94' | '1'            |
		И я закрыл все окна клиентского приложения


Сценарий: _0154133 проверка формы по валютам на примере  Outgoing payment order
	* Заполнение Outgoing Payment Order
		* Заполнение шапки документа
			И я открываю навигационную ссылку 'e1cib/list/Document.OutgoingPaymentOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
		* Выбор банковского счета и проверка перезаполнения поля Currency
			И я нажимаю кнопку выбора у поля "Account"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Bank account, TRY |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Currency" стал равен 'TRY'
		* Проверка выбора партнера в табличной части и заполнения по нему контрагента если он один
			И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'DFC'         |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '200,00'
			И в таблице "PaymentList" я завершаю редактирование строки
	* Проверка формы по валютам
		* Базовый пересчет по курсу
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '34,25'  | '1'            |
		* Пересчет Rate presentation при изменении Amount
			И в таблице "PaymentListCurrencies" в поле с именем 'PaymentListCurrenciesAmount' я ввожу текст '35,00'
			И в таблице "PaymentListCurrencies" я завершаю редактирование строки
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,7143'            | '35,00'  | '1'            |
		* Пересчет Amount при изменении Multiplicity
			И в таблице "PaymentListCurrencies" в поле 'Multiplicity' я ввожу текст '2'
			И в таблице "PaymentListCurrencies" я завершаю редактирование строки
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,7143'            | '17,50'  | '2'            |
		* Пересчет Amount при изменении Multiplicity Rate presentation
			И в таблице "PaymentListCurrencies" в поле 'Rate presentation' я ввожу текст '6,0000'
			И в таблице "PaymentListCurrencies" я завершаю редактирование строки
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '6,0000'            | '16,67'  | '2'            |
		* Пересчет Amount при изменении суммы платежа
			И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '250,00'
			И в таблице "PaymentListCurrencies" я завершаю редактирование строки
			И в таблице "PaymentListCurrencies" я перехожу к строке:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '6,0000'            | '20,83'  | '2'            |
		* Проверка стандартного курса при добавлении следующей строки
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
		* Пересчет при изменении валюты
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
		* Проверка отображения обратного курса 
			Дано двойной клик на картинку "reverse"
			И в таблице "PaymentList" я перехожу к строке:
				| 'Amount' | 'Partner' | 'Payee'            |
				| '200,00' | 'Veritas' | 'Company Veritas ' |
			Тогда таблица "PaymentListCurrencies" содержит строки:
				| 'Movement type'  | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'Local currency' | 'Legal'     | 'USD'           | 'TRY'      | '5,6497'             | '1 129,94' | '1'            |
		И я закрыл все окна клиентского приложения







