#language: ru
@tree
@Positive

Функционал: ввод начального остатка

Как разработчик
Я хочу создать документ для ввода начального остатка
Чтобы перенести остатки клиента при начале работы с базой

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


# необходимо дописать тесты на ввод нач остатка по документам
Сценарий: _400000 preparation
	* Создание SI для ввода нач остатка по документам
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Partner" я выбираю по строке 'DFC'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Agreement DFC' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
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
		И в таблице "ItemList" я завершаю редактирование строки
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '5 900'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '5 900'
		И я устанавливаю флаг 'Is opening entry'
		И Пауза 1
		И я нажимаю на кнопку 'Post and close'
	* Создание PI для ввода нач остатка по документам
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Partner" я выбираю по строке 'DFC'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Agreement vendor DFC' |
		И в таблице "List" я выбираю текущую строку
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
		И в таблице "ItemList" я завершаю редактирование строки
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '5 900'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '5 900'
		И я устанавливаю флаг 'Is opening entry'
		И Пауза 1
		И я нажимаю на кнопку 'Post and close'


Сценарий: _400001 ввод начального остатка по кассовым и банковким счетам
	* Opening a document form для ввода начального остатка
		И я открываю навигационную ссылку 'e1cib/list/Document.OpeningEntry'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение информации о компании
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
	* Заполнение номера документа
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	* Filling in the tabular part по остаткам ДС в кассе и на банковских счетах
		И в таблице "AccountBalance" я нажимаю на кнопку с именем 'AccountBalanceAdd'
		И в таблице "AccountBalance" я нажимаю кнопку выбора у реквизита "Account"
		И в таблице "List" я выбираю текущую строку
		И в таблице "AccountBalance" я активизирую поле с именем "AccountBalanceCurrency"
		И в таблице "AccountBalance" я нажимаю кнопку выбора у реквизита "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| TRY  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AccountBalance" я активизирую поле с именем "AccountBalanceAmount"
		И в таблице "AccountBalance" в поле 'Amount' я ввожу текст '1 000,00'
		И в таблице "AccountBalance" я завершаю редактирование строки
		И в таблице "AccountBalance" я нажимаю на кнопку с именем 'AccountBalanceAdd'
		И в таблице "AccountBalance" я нажимаю кнопку выбора у реквизита "Account"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Cash desk №2 |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AccountBalance" я активизирую поле с именем "AccountBalanceCurrency"
		И в таблице "AccountBalance" я нажимаю кнопку выбора у реквизита "Currency"
		И в таблице "List" я перехожу к строке:
			| Code | Description     |
			| USD  | American dollar |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AccountBalance" я активизирую поле с именем "AccountBalanceAmount"
		И в таблице "AccountBalance" в поле 'Amount' я ввожу текст '1 000,00'
		И в таблице "AccountBalance" я завершаю редактирование строки
		И в таблице "AccountBalance" я нажимаю на кнопку с именем 'AccountBalanceAdd'
		И в таблице "AccountBalance" я нажимаю кнопку выбора у реквизита "Account"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Cash desk №3 |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AccountBalance" я активизирую поле с именем "AccountBalanceCurrency"
		И в таблице "AccountBalance" я нажимаю кнопку выбора у реквизита "Currency"
		И в таблице "List" я перехожу к строке:
			| Code | Description |
			| EUR  | Euro        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AccountBalance" я активизирую поле с именем "AccountBalanceAmount"
		И в таблице "AccountBalance" в поле 'Amount' я ввожу текст '1 000,00'
		И в таблице "AccountBalance" я завершаю редактирование строки
		И в таблице "AccountBalance" я нажимаю на кнопку с именем 'AccountBalanceAdd'
		И в таблице "AccountBalance" я нажимаю кнопку выбора у реквизита "Account"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Bank account, TRY |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AccountBalance" я активизирую поле с именем "AccountBalanceAmount"
		И в таблице "AccountBalance" в поле 'Amount' я ввожу текст '10 000,00'
		И в таблице "AccountBalance" я завершаю редактирование строки
		И в таблице "AccountBalance" я нажимаю на кнопку с именем 'AccountBalanceAdd'
		И в таблице "AccountBalance" я нажимаю кнопку выбора у реквизита "Account"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Bank account, USD |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AccountBalance" я активизирую поле с именем "AccountBalanceCurrency"
		И в таблице "AccountBalance" я активизирую поле с именем "AccountBalanceAmount"
		И в таблице "AccountBalance" в поле 'Amount' я ввожу текст '5 000,00'
		И в таблице "AccountBalance" я завершаю редактирование строки
		И в таблице "AccountBalance" я нажимаю на кнопку с именем 'AccountBalanceAdd'
		И в таблице "AccountBalance" я нажимаю кнопку выбора у реквизита "Account"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Bank account, EUR |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AccountBalance" я активизирую поле с именем "AccountBalanceAmount"
		И в таблице "AccountBalance" в поле 'Amount' я ввожу текст '8 000,00'
		И в таблице "AccountBalance" я завершаю редактирование строки
	* Check filling inкурса пересчета по вводу начальных остатков
		* Заполнение курса по остатку ДС в Cash desk №2
			И в таблице "AccountBalance" я перехожу к строке:
				| 'Account'      | 'Amount'   | 'Currency' |
				| 'Cash desk №2' | '1 000,00' | 'USD'      |
			И в таблице "CurrenciesAccountBalance" я перехожу к строке:
				| 'From' | 'Movement type'  | 'To'  | 'Type'  |
				| 'USD'  | 'Local currency' | 'TRY' | 'Legal' |
			И в таблице "CurrenciesAccountBalance" в поле с именем 'CurrenciesAccountBalanceRatePresentation' я ввожу текст '0,1756'
			И в таблице "CurrenciesAccountBalance" в поле с именем 'CurrenciesAccountBalanceMultiplicity' я ввожу текст '1'
			И в таблице "CurrenciesAccountBalance" я активизирую поле "Amount"
			И в таблице "CurrenciesAccountBalance" я завершаю редактирование строки
		* Заполнение курса по остатку ДС в Cash desk №3
			И в таблице "AccountBalance" я перехожу к строке:
				| 'Account'      | 'Amount'   | 'Currency' |
				| 'Cash desk №3' | '1 000,00' | 'EUR'      |
			И в таблице "AccountBalance" я активизирую поле "Account"
			И в таблице "CurrenciesAccountBalance" я перехожу к строке:
				| 'From' | 'Movement type'  | 'To'  | 'Type'  |
				| 'EUR'  | 'Local currency' | 'TRY' | 'Legal' |
			И в таблице "CurrenciesAccountBalance" я выбираю текущую строку
			И в таблице "CurrenciesAccountBalance" в поле с именем 'CurrenciesAccountBalanceRatePresentation' я ввожу текст '0,1758'
			И в таблице "CurrenciesAccountBalance" я завершаю редактирование строки
			И в таблице "CurrenciesAccountBalance" я перехожу к строке:
				| 'From' | 'Movement type'      | 'To'  | 'Type'      |
				| 'EUR'  | 'Reporting currency' | 'USD' | 'Reporting' |
			И в таблице "CurrenciesAccountBalance" я выбираю текущую строку
			И в таблице "CurrenciesAccountBalance" в поле с именем 'CurrenciesAccountBalanceRatePresentation' я ввожу текст '1,1000'
			И в таблице "CurrenciesAccountBalance" я завершаю редактирование строки
			И в таблице "CurrenciesAccountBalance" я перехожу к строке:
				| 'From' | 'Movement type'  | 'Type'  |
				| 'EUR'  | 'Local currency' | 'Legal' |
			И в таблице "CurrenciesAccountBalance" я выбираю текущую строку
			И в таблице "CurrenciesAccountBalance" в поле с именем 'CurrenciesAccountBalanceMultiplicity' я ввожу текст '1'
			И в таблице "CurrenciesAccountBalance" я завершаю редактирование строки
			И в таблице "CurrenciesAccountBalance" я перехожу к строке:
				| 'From' | 'Movement type'      | 'Rate'   | 'To'  | 'Type'      |
				| 'EUR'  | 'Reporting currency' | '1,1000' | 'USD' | 'Reporting' |
			И в таблице "CurrenciesAccountBalance" я выбираю текущую строку
			И в таблице "CurrenciesAccountBalance" в поле с именем 'CurrenciesAccountBalanceMultiplicity' я ввожу текст '1'
			И в таблице "CurrenciesAccountBalance" я завершаю редактирование строки
		* Заполнение курса по остатку ДС в Bank account, USD
			И в таблице "AccountBalance" я перехожу к строке:
				| 'Account'           | 'Currency' |
				| 'Bank account, USD' | 'USD'      |
			И в таблице "CurrenciesAccountBalance" я выбираю текущую строку
			И в таблице "CurrenciesAccountBalance" я перехожу к строке:
				| 'From' | 'Movement type'  | 'To'  | 'Type'  |
				| 'USD'  | 'Local currency' | 'TRY' | 'Legal' |
			И в таблице "CurrenciesAccountBalance" в поле с именем 'CurrenciesAccountBalanceRatePresentation' я ввожу текст '0,1758'
			И в таблице "CurrenciesAccountBalance" в поле с именем 'CurrenciesAccountBalanceMultiplicity' я ввожу текст '1'
			И в таблице "CurrenciesAccountBalance" я активизирую поле "Amount"
			И в таблице "CurrenciesAccountBalance" я завершаю редактирование строки
		* Заполнение курса по остатку ДС в Bank account, EUR
			И в таблице "AccountBalance" я перехожу к строке:
				| 'Account'           | 'Currency' |
				| 'Bank account, EUR' | 'EUR'      |
			И в таблице "CurrenciesAccountBalance" я перехожу к строке:
				| 'From' | 'Movement type'  | 'To'  | 'Type'  |
				| 'EUR'  | 'Local currency' | 'TRY' | 'Legal' |
			И в таблице "CurrenciesAccountBalance" я выбираю текущую строку
			И в таблице "CurrenciesAccountBalance" в поле с именем 'CurrenciesAccountBalanceRatePresentation'я ввожу текст '0,1758'
			И в таблице "CurrenciesAccountBalance" я завершаю редактирование строки
			И в таблице "CurrenciesAccountBalance" я перехожу к строке:
				| 'From' | 'Movement type'      | 'To'  | 'Type'      |
				| 'EUR'  | 'Reporting currency' | 'USD' | 'Reporting' |
			И в таблице "CurrenciesAccountBalance" я выбираю текущую строку
			И в таблице "CurrenciesAccountBalance" в поле с именем 'CurrenciesAccountBalanceRatePresentation' я ввожу текст '1,1000'
			И в таблице "CurrenciesAccountBalance" я завершаю редактирование строки
			И в таблице "CurrenciesAccountBalance" я перехожу к строке:
				| 'From' | 'Movement type'  | 'To'  | 'Type'  |
				| 'EUR'  | 'Local currency' | 'TRY' | 'Legal' |
			И в таблице "CurrenciesAccountBalance" я выбираю текущую строку
			И в таблице "CurrenciesAccountBalance" в поле с именем 'CurrenciesAccountBalanceMultiplicity' я ввожу текст '1'
			И в таблице "CurrenciesAccountBalance" я завершаю редактирование строки
			И в таблице "CurrenciesAccountBalance" я перехожу к строке:
				| 'From' | 'Movement type'      | 'Rate'   | 'To'  | 'Type'      |
				| 'EUR'  | 'Reporting currency' | '1,1000' | 'USD' | 'Reporting' |
			И в таблице "CurrenciesAccountBalance" я выбираю текущую строку
			И в таблице "CurrenciesAccountBalance" в поле с именем 'CurrenciesAccountBalanceMultiplicity' я ввожу текст '1'
			И в таблице "CurrenciesAccountBalance" я завершаю редактирование строки
	* Post document
		И я нажимаю на кнопку 'Post and close'
		И Пауза 5
		* Check movements документа
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.AccountBalance'
			Тогда таблица "List" содержит строки:
			| 'Currency' | 'Recorder'         | 'Company'      | 'Account'           | 'Currency movement type' | 'Amount'    |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №1'      | 'Local currency'         | '1 000,00'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №1'      | 'Reporting currency'     | '171,23'    |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №2'      | 'Local currency'         | '5 694,76'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №2'      | 'Reporting currency'     | '1 000,00'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №3'      | 'Local currency'         | '5 688,28'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №3'      | 'Reporting currency'     | '909,09'    |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, TRY' | 'Local currency'         | '10 000,00' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, TRY' | 'Reporting currency'     | '1 712,33'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, USD' | 'Local currency'         | '28 441,41' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, USD' | 'Reporting currency'     | '5 000,00'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, EUR' | 'Local currency'         | '45 506,26' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, EUR' | 'Reporting currency'     | '7 272,73'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №1'      | '*'                      | '1 000,00'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №2'      | '*'                      | '1 000,00'  |
			| 'EUR'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №3'      | '*'                      | '1 000,00'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, TRY' | '*'                      | '10 000,00' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, USD' | '*'                      | '5 000,00'  |
			| 'EUR'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, EUR' | '*'                      | '8 000,00'  |
			И Я закрыл все окна клиентского приложения
	* Clear postings документа и проверка отмены движений
		* Clear postings документа
			И я открываю навигационную ссылку 'e1cib/list/Document.OpeningEntry'
			И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
			И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		* Проверка отмены движений
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.AccountBalance'
			Тогда таблица "List" не содержит строки:
			| 'Currency' | 'Recorder'         | 'Company'      | 'Account'           | 'Currency movement type' | 'Amount'    |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №1'      | 'Local currency'         | '1 000,00'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №1'      | 'Reporting currency'     | '171,23'    |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №2'      | 'Local currency'         | '5 694,76'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №2'      | 'Reporting currency'     | '1 000,00'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №3'      | 'Local currency'         | '5 688,28'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №3'      | 'Reporting currency'     | '909,09'    |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, TRY' | 'Local currency'         | '10 000,00' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, TRY' | 'Reporting currency'     | '1 712,33'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, USD' | 'Local currency'         | '28 441,41' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, USD' | 'Reporting currency'     | '5 000,00'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, EUR' | 'Local currency'         | '45 506,26' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, EUR' | 'Reporting currency'     | '7 272,73'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №1'      | '*'                      | '1 000,00'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №2'      | '*'                      | '1 000,00'  |
			| 'EUR'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №3'      | '*'                      | '1 000,00'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, TRY' | '*'                      | '10 000,00' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, USD' | '*'                      | '5 000,00'  |
			| 'EUR'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, EUR' | '*'                      | '8 000,00'  |
			И Я закрыл все окна клиентского приложения
	* Posting the documentобратно и проверка движений
		* Post document
			И я открываю навигационную ссылку 'e1cib/list/Document.OpeningEntry'
			И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
			И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		* Check movements
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.AccountBalance'
			Тогда таблица "List" содержит строки:
			| 'Currency' | 'Recorder'         | 'Company'      | 'Account'           | 'Currency movement type' | 'Amount'    |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №1'      | 'Local currency'         | '1 000,00'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №1'      | 'Reporting currency'     | '171,23'    |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №2'      | 'Local currency'         | '5 694,76'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №2'      | 'Reporting currency'     | '1 000,00'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №3'      | 'Local currency'         | '5 688,28'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №3'      | 'Reporting currency'     | '909,09'    |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, TRY' | 'Local currency'         | '10 000,00' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, TRY' | 'Reporting currency'     | '1 712,33'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, USD' | 'Local currency'         | '28 441,41' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, USD' | 'Reporting currency'     | '5 000,00'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, EUR' | 'Local currency'         | '45 506,26' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, EUR' | 'Reporting currency'     | '7 272,73'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №1'      | '*'                      | '1 000,00'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №2'      | '*'                      | '1 000,00'  |
			| 'EUR'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №3'      | '*'                      | '1 000,00'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, TRY' | '*'                      | '10 000,00' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, USD' | '*'                      | '5 000,00'  |
			| 'EUR'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, EUR' | '*'                      | '8 000,00'  |
			И Я закрыл все окна клиентского приложения




Сценарий: _400002 ввод начального остатка по товарам
	* Opening a document form для ввода начального остатка
		И я открываю навигационную ссылку 'e1cib/list/Document.OpeningEntry'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение информации о компании
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
	* Заполнение номера документа
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	* Filling in the tabular part по остаткам товара
		И я перехожу к закладке "Inventory"
		И в таблице "Inventory" я нажимаю на кнопку с именем 'InventoryAdd'
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Dress | XS/Blue  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я активизирую поле "Quantity"
		И в таблице "Inventory" в поле 'Quantity' я ввожу текст '500,000'
		# И в таблице "Inventory" я активизирую поле с именем "InventoryAmount"
		# И в таблице "Inventory" в поле 'Amount' я ввожу текст '200 000,00'
		И в таблице "Inventory" я завершаю редактирование строки
		И в таблице "Inventory" я нажимаю на кнопку с именем 'InventoryAdd'
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Dress | S/Yellow |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я активизирую поле "Store"
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я активизирую поле "Quantity"
		И в таблице "Inventory" в поле 'Quantity' я ввожу текст '400,000'
		# И в таблице "Inventory" я активизирую поле с именем "InventoryAmount"
		# И в таблице "Inventory" в поле 'Amount' я ввожу текст '80 000,00'
		И в таблице "Inventory" я завершаю редактирование строки
		И в таблице "Inventory" я нажимаю на кнопку с именем 'InventoryAdd'
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Dress | XS/Blue  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я активизирую поле "Store"
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я завершаю редактирование строки
		И в таблице "Inventory" я активизирую поле "Quantity"
		И в таблице "Inventory" я выбираю текущую строку
		И в таблице "Inventory" в поле 'Quantity' я ввожу текст '400,000'
		# И в таблице "Inventory" я активизирую поле с именем "InventoryAmount"
		# И в таблице "Inventory" в поле 'Amount' я ввожу текст '80 000,00'
		И в таблице "Inventory" я завершаю редактирование строки
		И в таблице "Inventory" я нажимаю на кнопку с именем 'InventoryAdd'
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item     | Item key  |
			| Trousers | 38/Yellow |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я активизирую поле "Store"
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я активизирую поле "Quantity"
		И в таблице "Inventory" в поле 'Quantity' я ввожу текст '100,000'
		# И в таблице "Inventory" я активизирую поле с именем "InventoryAmount"
		# И в таблице "Inventory" в поле 'Amount' я ввожу текст '20 000,00'
		И в таблице "Inventory" я завершаю редактирование строки
		И в таблице "Inventory" я нажимаю на кнопку с именем 'InventoryAdd'
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item     | Item key  |
			| Trousers | 38/Yellow |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я активизирую поле "Quantity"
		И в таблице "Inventory" в поле 'Quantity' я ввожу текст '100,000'
		# И в таблице "Inventory" я активизирую поле с именем "InventoryAmount"
		# И в таблице "Inventory" в поле 'Amount' я ввожу текст '19 000,00'
		И в таблице "Inventory" я завершаю редактирование строки
		И в таблице "Inventory" я нажимаю на кнопку с именем 'InventoryAdd'
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Shirt | 36/Red   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я активизирую поле "Quantity"
		И в таблице "Inventory" в поле 'Quantity' я ввожу текст '100,000'
		# И в таблице "Inventory" я активизирую поле с именем "InventoryAmount"
		# И в таблице "Inventory" в поле 'Amount' я ввожу текст '21 000,00'
		И в таблице "Inventory" я завершаю редактирование строки
		И в таблице "Inventory" я нажимаю на кнопку с именем 'InventoryAdd'
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Shirt | 36/Red   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я активизирую поле "Quantity"
		И в таблице "Inventory" в поле 'Quantity' я ввожу текст '100,000'
		# И в таблице "Inventory" я активизирую поле с именем "InventoryAmount"
		# И в таблице "Inventory" в поле 'Amount' я ввожу текст '21 000,00'
		И в таблице "Inventory" я завершаю редактирование строки
		И в таблице "Inventory" я нажимаю на кнопку с именем 'InventoryAdd'
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Boots | 36/18SD  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я активизирую поле "Quantity"
		И в таблице "Inventory" в поле 'Quantity' я ввожу текст '200,000'
		# И в таблице "Inventory" я активизирую поле с именем "InventoryAmount"
		# И в таблице "Inventory" в поле 'Amount' я ввожу текст '40 000,00'
		И в таблице "Inventory" я завершаю редактирование строки
		И в таблице "Inventory" я нажимаю на кнопку с именем 'InventoryAdd'
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Boots | 36/18SD  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я активизирую поле "Store"
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я активизирую поле "Quantity"
		И в таблице "Inventory" в поле 'Quantity' я ввожу текст '300,000'
		# И в таблице "Inventory" я активизирую поле с именем "InventoryAmount"
		# И в таблице "Inventory" в поле 'Amount' я ввожу текст '60 000,00'
		И в таблице "Inventory" я завершаю редактирование строки
		И в таблице "Inventory" я нажимаю на кнопку с именем 'InventoryAdd'
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Dress | L/Green  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я активизирую поле "Store"
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я активизирую поле "Quantity"
		И в таблице "Inventory" в поле 'Quantity' я ввожу текст '500,000'
		# И в таблице "Inventory" я активизирую поле с именем "InventoryAmount"
		# И в таблице "Inventory" в поле 'Amount' я ввожу текст '200 000,00'
		И в таблице "Inventory" я завершаю редактирование строки
		И в таблице "Inventory" я нажимаю на кнопку с именем 'InventoryAdd'
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Dress | L/Green  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я активизирую поле "Store"
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я завершаю редактирование строки
		И в таблице "Inventory" я перехожу к строке:
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'L/Green'  | '500,000'  | 'Store 01' |
		И в таблице "Inventory" я активизирую поле "Quantity"
		И в таблице "Inventory" я перехожу к строке:
			| Item key | Store    |
			| L/Green  | Store 02 |
		И в таблице "Inventory" я выбираю текущую строку
		И в таблице "Inventory" в поле 'Quantity' я ввожу текст '100,000'
		# И в таблице "Inventory" я активизирую поле с именем "InventoryAmount"
		# И в таблице "Inventory" в поле 'Amount' я ввожу текст '40 000,00'
		И в таблице "Inventory" я завершаю редактирование строки
	* Post document
		И я нажимаю на кнопку 'Post'
	* Check movements документа
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.InventoryBalance'
		Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'         | 'Company'      | 'Item key'  |
		| '500,000'  | 'Opening entry 2*' | 'Main Company' | 'XS/Blue'   |
		| '400,000'  | 'Opening entry 2*' | 'Main Company' | 'S/Yellow'  |
		| '400,000'  | 'Opening entry 2*' | 'Main Company' | 'XS/Blue'   |
		| '100,000'  | 'Opening entry 2*' | 'Main Company' | '38/Yellow' |
		| '100,000'  | 'Opening entry 2*' | 'Main Company' | '38/Yellow' |
		| '100,000'  | 'Opening entry 2*' | 'Main Company' | '36/Red'    |
		| '100,000'  | 'Opening entry 2*' | 'Main Company' | '36/Red'    |
		| '200,000'  | 'Opening entry 2*' | 'Main Company' | '36/18SD'   |
		| '300,000'  | 'Opening entry 2*' | 'Main Company' | '36/18SD'   |
		| '500,000'  | 'Opening entry 2*' | 'Main Company' | 'L/Green'   |
		| '100,000'  | 'Opening entry 2*' | 'Main Company' | 'L/Green'   |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
		Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'         | 'Store'    | 'Item key'  |
		| '500,000'  | 'Opening entry 2*' | 'Store 01' | 'XS/Blue'   |
		| '400,000'  | 'Opening entry 2*' | 'Store 02' | 'S/Yellow'  |
		| '400,000'  | 'Opening entry 2*' | 'Store 01' | 'XS/Blue'   |
		| '100,000'  | 'Opening entry 2*' | 'Store 02' | '38/Yellow' |
		| '100,000'  | 'Opening entry 2*' | 'Store 01' | '38/Yellow' |
		| '100,000'  | 'Opening entry 2*' | 'Store 02' | '36/Red'    |
		| '100,000'  | 'Opening entry 2*' | 'Store 01' | '36/Red'    |
		| '200,000'  | 'Opening entry 2*' | 'Store 02' | '36/18SD'   |
		| '300,000'  | 'Opening entry 2*' | 'Store 01' | '36/18SD'   |
		| '500,000'  | 'Opening entry 2*' | 'Store 01' | 'L/Green'   |
		| '100,000'  | 'Opening entry 2*' | 'Store 02' | 'L/Green'   |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
		Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'         | 'Store'    | 'Item key'  |
		| '500,000'  | 'Opening entry 2*' | 'Store 01' | 'XS/Blue'   |
		| '400,000'  | 'Opening entry 2*' | 'Store 02' | 'S/Yellow'  |
		| '400,000'  | 'Opening entry 2*' | 'Store 01' | 'XS/Blue'   |
		| '100,000'  | 'Opening entry 2*' | 'Store 02' | '38/Yellow' |
		| '100,000'  | 'Opening entry 2*' | 'Store 01' | '38/Yellow' |
		| '100,000'  | 'Opening entry 2*' | 'Store 02' | '36/Red'    |
		| '100,000'  | 'Opening entry 2*' | 'Store 01' | '36/Red'    |
		| '200,000'  | 'Opening entry 2*' | 'Store 02' | '36/18SD'   |
		| '300,000'  | 'Opening entry 2*' | 'Store 01' | '36/18SD'   |
		| '500,000'  | 'Opening entry 2*' | 'Store 01' | 'L/Green'   |
		| '100,000'  | 'Opening entry 2*' | 'Store 02' | 'L/Green'   |
		И Я закрыл все окна клиентского приложения

Сценарий: _400003 проверка ввода начального остатка по авансам поставщикам/клиентам
	* Opening a document form для ввода начального остатка
		И я открываю навигационную ссылку 'e1cib/list/Document.OpeningEntry'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение информации о компании
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
	* Заполнение номера документа
		И в поле 'Number' я ввожу текст '3'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '3'
	* Заполнение аванса от клиента
		И в таблице "AdvanceFromCustomers" я нажимаю на кнопку с именем 'AdvanceFromCustomersAdd'
		И в таблице "AdvanceFromCustomers" я нажимаю кнопку выбора у реквизита с именем "AdvanceFromCustomersPartner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AdvanceFromCustomers" я активизирую поле с именем "AdvanceFromCustomersCurrency"
		И в таблице "AdvanceFromCustomers" я нажимаю кнопку выбора у реквизита с именем "AdvanceFromCustomersCurrency"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AdvanceFromCustomers" я активизирую поле с именем "AdvanceFromCustomersAmount"
		И в таблице "AdvanceFromCustomers" в поле с именем 'AdvanceFromCustomersAmount' я ввожу текст '100,00'
		И в таблице "AdvanceFromCustomers" я завершаю редактирование строки
	* Заполнение аванса от поставщика
		И я перехожу к закладке "To suppliers"
		И в таблице "AdvanceToSuppliers" я нажимаю на кнопку с именем 'AdvanceToSuppliersAdd'
		И в таблице "AdvanceToSuppliers" я нажимаю кнопку выбора у реквизита с именем "AdvanceToSuppliersPartner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AdvanceToSuppliers" я завершаю редактирование строки
		И в таблице "AdvanceToSuppliers" я активизирую поле с именем "AdvanceToSuppliersLegalName"
		И в таблице "AdvanceToSuppliers" я выбираю текущую строку
		И в таблице "AdvanceToSuppliers" я нажимаю кнопку выбора у реквизита с именем "AdvanceToSuppliersLegalName"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Company Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AdvanceToSuppliers" я активизирую поле с именем "AdvanceToSuppliersCurrency"
		И в таблице "AdvanceToSuppliers" я нажимаю кнопку выбора у реквизита с именем "AdvanceToSuppliersCurrency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AdvanceToSuppliers" я активизирую поле с именем "AdvanceToSuppliersAmount"
		И в таблице "AdvanceToSuppliers" в поле с именем 'AdvanceToSuppliersAmount' я ввожу текст '100,00'
		И в таблице "AdvanceToSuppliers" я завершаю редактирование строки
	* Post document
		И я нажимаю на кнопку 'Post'
	* Check movements документа
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Opening entry 3*'                     | ''            | ''       | ''                    | ''               | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| 'Document registrations records'       | ''            | ''       | ''                    | ''               | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| 'Register  "Accounts statement"'       | ''            | ''       | ''                    | ''               | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| ''                                     | 'Record type' | 'Period' | 'Resources'           | ''               | ''                       | ''                  | 'Dimensions'   | ''                 | ''                         | ''                     | ''         |
		| ''                                     | ''            | ''       | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR'    | 'Company'      | 'Partner'          | 'Legal name'               | 'Basis document'       | 'Currency' |
		| ''                                     | 'Receipt'     | '*'      | ''                    | ''               | '100'                    | ''                  | 'Main Company' | 'Kalipso'          | 'Company Kalipso'          | ''                     | 'TRY'      |
		| ''                                     | 'Receipt'     | '*'      | '100'                 | ''               | ''                       | ''                  | 'Main Company' | 'Ferron BP'        | 'Company Ferron BP'        | ''                     | 'TRY'      |
		| ''                                     | ''            | ''       | ''                    | ''               | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| 'Register  "Reconciliation statement"' | ''            | ''       | ''                    | ''               | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| ''                                     | 'Record type' | 'Period' | 'Resources'           | 'Dimensions'     | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| ''                                     | ''            | ''       | 'Amount'              | 'Company'        | 'Legal name'             | 'Currency'          | ''             | ''                 | ''                         | ''                     | ''         |
		| ''                                     | 'Receipt'     | '*'      | '100'                 | 'Main Company'   | 'Company Ferron BP'      | 'TRY'               | ''             | ''                 | ''                         | ''                     | ''         |
		| ''                                     | 'Expense'     | '*'      | '100'                 | 'Main Company'   | 'Company Kalipso'        | 'TRY'               | ''             | ''                 | ''                         | ''                     | ''         |
		| ''                                     | ''            | ''       | ''                    | ''               | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| 'Register  "Advance from customers"'   | ''            | ''       | ''                    | ''               | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| ''                                     | 'Record type' | 'Period' | 'Resources'           | 'Dimensions'     | ''                       | ''                  | ''             | ''                 | ''                         | 'Attributes'           | ''         |
		| ''                                     | ''            | ''       | 'Amount'              | 'Company'        | 'Partner'                | 'Legal name'        | 'Currency'     | 'Receipt document' | 'Currency movement type'   | 'Deferred calculation' | ''         |
		| ''                                     | 'Receipt'     | '*'      | '17,12'               | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'   | 'USD'          | 'Opening entry 3*' | 'Reporting currency'       | 'No'                   | ''         |
		| ''                                     | 'Receipt'     | '*'      | '100'                 | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'   | 'TRY'          | 'Opening entry 3*' | 'en descriptions is empty' | 'No'                   | ''         |
		| ''                                     | 'Receipt'     | '*'      | '100'                 | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'   | 'TRY'          | 'Opening entry 3*' | 'Local currency'           | 'No'                   | ''         |
		| ''                                     | ''            | ''       | ''                    | ''               | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| 'Register  "Advance to suppliers"'     | ''            | ''       | ''                    | ''               | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| ''                                     | 'Record type' | 'Period' | 'Resources'           | 'Dimensions'     | ''                       | ''                  | ''             | ''                 | ''                         | 'Attributes'           | ''         |
		| ''                                     | ''            | ''       | 'Amount'              | 'Company'        | 'Partner'                | 'Legal name'        | 'Currency'     | 'Payment document' | 'Currency movement type'   | 'Deferred calculation' | ''         |
		| ''                                     | 'Receipt'     | '*'      | '17,12'               | 'Main Company'   | 'Ferron BP'              | 'Company Ferron BP' | 'USD'          | 'Opening entry 3*' | 'Reporting currency'       | 'No'                   | ''         |
		| ''                                     | 'Receipt'     | '*'      | '100'                 | 'Main Company'   | 'Ferron BP'              | 'Company Ferron BP' | 'TRY'          | 'Opening entry 3*' | 'en descriptions is empty' | 'No'                   | ''         |
		| ''                                     | 'Receipt'     | '*'      | '100'                 | 'Main Company'   | 'Ferron BP'              | 'Company Ferron BP' | 'TRY'          | 'Opening entry 3*' | 'Local currency'           | 'No'                   | ''         |
		И Я закрыл все окна клиентского приложения


Сценарий: _400004 проверка ввода начального остатка по задолженности поставщику по соглашению
	* Opening a document form для ввода начального остатка
		И я открываю навигационную ссылку 'e1cib/list/Document.OpeningEntry'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение информации о компании
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
	* Заполнение номера документа
		И в поле 'Number' я ввожу текст '4'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '4'
	* Заполнение ввода начального остатка по задолженности поставщику
		* Заполнение партнера и Legal name
			И я перехожу к закладке "Account payable"
			И в таблице "AccountPayableByAgreements" я нажимаю на кнопку 'Add'
			И в таблице "AccountPayableByAgreements" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'DFC'         |
			И в таблице "List" я выбираю текущую строку
			И в таблице "AccountPayableByAgreements" я завершаю редактирование строки
		* Check filling inLegal name
				И     таблица "AccountPayableByAgreements" содержит строки:
				| 'Partner' | 'Legal name' |
				| 'DFC'     | 'DFC'        |
		* Создание тестового соглашения с взаиморасчетами по соглашениям
			И в таблице "AccountPayableByAgreements" я нажимаю кнопку выбора у реквизита "Agreement"
			И я нажимаю на кнопку с именем 'FormCreate'
			И я меняю значение переключателя 'AP-AR posting detail' на 'By agreements'
			И я меняю значение переключателя 'Type' на 'Vendor'
			И в поле 'ENG' я ввожу текст 'DFC Vendor by agreements'
			И в поле 'Date' я ввожу текст '01.12.2019'
			И я нажимаю кнопку выбора у поля "Currency movement type"
			И в таблице "List" я перехожу к строке:
				| 'Currency' | 'Description' | 'Source'       | 'Type'      |
				| 'TRY'      | 'TRY'         | 'Forex Seling' | 'Agreement' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Price type"
			И в таблице "List" я перехожу к строке:
				| 'Currency' | 'Description'       | 'Reference'         |
				| 'TRY'      | 'Vendor price, TRY' | 'Vendor price, TRY' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Start using' я ввожу текст '01.12.2019'
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'DFC Vendor by agreements' |
			И я нажимаю на кнопку с именем 'FormChoose'
		* Заполнение суммы и валюты
			И в таблице "AccountPayableByAgreements" я активизирую поле "Currency"
			И в таблице "AccountPayableByAgreements" я выбираю текущую строку
			И в таблице "AccountPayableByAgreements" я нажимаю кнопку выбора у реквизита "Currency"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "AccountPayableByAgreements" я активизирую поле "Amount"
			И в таблице "AccountPayableByAgreements" в поле 'Amount' я ввожу текст '100,00'
			И в таблице "AccountPayableByAgreements" я завершаю редактирование строки
		* Проверка расчета Reporting currency
			И в таблице "CurrenciesAccountPayableByAgreements" я перехожу к строке:
			| 'Movement type'      | 'Type'      |
			| 'Reporting currency' | 'Reporting' |
			И в таблице "CurrenciesAccountPayableByAgreements" я выбираю текущую строку
			И в таблице "CurrenciesAccountPayableByAgreements" в поле с именем "CurrenciesAccountPayableByAgreementsRatePresentation" я ввожу текст '5,8400'
			И в таблице "CurrenciesAccountPayableByAgreements" в поле с именем "CurrenciesAccountPayableByAgreementsMultiplicity" я ввожу текст '1'
			И в таблице "CurrenciesAccountPayableByAgreements" я завершаю редактирование строки
			И     таблица "CurrenciesAccountPayableByDocuments" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate'   | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400' | '17,12'  | '1'            |
	* Post document
		И я нажимаю на кнопку 'Post and close'
		И Пауза 5
		* Check movements документа
			И я нажимаю на кнопку 'Registrations report'
			Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Opening entry 4*'                     | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                         | ''         | ''                         | ''                     |
			| 'Document registrations records'       | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                         | ''         | ''                         | ''                     |
			| 'Register  "Accounts statement"'           | ''            | ''                   | ''                    | ''               | ''                       | ''               | ''             | ''                         | ''           | ''                         | ''                     |
			| ''                                         | 'Record type' | 'Period'             | 'Resources'           | ''               | ''                       | ''               | 'Dimensions'   | ''                         | ''           | ''                         | ''                     |
			| ''                                         | ''            | ''                   | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'                  | 'Legal name' | 'Basis document'           | 'Currency'             |
			| ''                                         | 'Receipt'     | '*'                  | ''                    | '100'            | ''                       | ''               | 'Main Company' | 'DFC'                      | 'DFC'        | ''                         | 'TRY'                  |
			| ''                                         | ''            | ''                   | ''                    | ''               | ''                       | ''               | ''             | ''                         | ''           | ''                         | ''                     |
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                         | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''         | ''           | ''                         | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'     | 'Currency' | ''           | ''                         | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company' | 'DFC'            | 'TRY'      | ''           | ''                         | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                         | ''         | ''                         | ''                     |
			| 'Register  "Partner AP transactions"'  | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                         | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''         | ''           | ''                         | ''         | ''                         | 'Attributes'           |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner'  | 'Legal name' | 'Agreement'                | 'Currency' | 'Currency movement type'   | 'Deferred calculation' |
			| ''                                     | 'Receipt'     | '*'      | '17,12'     | 'Main Company' | ''               | 'DFC'      | 'DFC'        | 'DFC Vendor by agreements' | 'USD'      | 'Reporting currency'       | 'No'                   |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company' | ''               | 'DFC'      | 'DFC'        | 'DFC Vendor by agreements' | 'TRY'      | 'en descriptions is empty' | 'No'                   |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company' | ''               | 'DFC'      | 'DFC'        | 'DFC Vendor by agreements' | 'TRY'      | 'Local currency'           | 'No'                   |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company' | ''               | 'DFC'      | 'DFC'        | 'DFC Vendor by agreements' | 'TRY'      | 'TRY'                      | 'No'                   |


	
Сценарий: _400005 проверка ввода начального остатка по задолженности клиента по соглашению
	* Opening a document form для ввода начального остатка
		И я открываю навигационную ссылку 'e1cib/list/Document.OpeningEntry'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение информации о компании
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
	* Заполнение номера документа
		И в поле 'Number' я ввожу текст '5'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '5'
	* Заполнение ввода начального остатка по задолженности клиента
		* Заполнение партнера и Legal name
			И я перехожу к закладке "Account receivable"
			И в таблице "AccountReceivableByAgreements" я нажимаю на кнопку 'Add'
			И в таблице "AccountReceivableByAgreements" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'DFC'         |
			И в таблице "List" я выбираю текущую строку
			И в таблице "AccountReceivableByAgreements" я завершаю редактирование строки
		* Check filling inLegal name
				И     таблица "AccountReceivableByAgreements" содержит строки:
				| 'Partner' | 'Legal name' |
				| 'DFC'     | 'DFC'        |
		* Создание тестового соглашения с взаиморасчетами по соглашениям
			И в таблице "AccountReceivableByAgreements" я нажимаю кнопку выбора у реквизита "Agreement"
			И я нажимаю на кнопку с именем 'FormCreate'
			И я меняю значение переключателя 'AP-AR posting detail' на 'By agreements'
			И я меняю значение переключателя 'Type' на 'Customer'
			И в поле 'ENG' я ввожу текст 'DFC Customer by agreements'
			И в поле 'Date' я ввожу текст '01.12.2019'
			И я нажимаю кнопку выбора у поля "Currency movement type"
			И в таблице "List" я перехожу к строке:
				| 'Currency' | 'Description' | 'Source'       | 'Type'      |
				| 'TRY'      | 'TRY'         | 'Forex Seling' | 'Agreement' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Price type"
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Basic Price Types' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Start using' я ввожу текст '01.12.2019'
			И я нажимаю на кнопку 'Save and close'
			И в таблице "List" я перехожу к строке:
				| 'Description'              |
				| 'DFC Customer by agreements' |
			И я нажимаю на кнопку с именем 'FormChoose'
		* Заполнение суммы и валюты
			И в таблице "AccountReceivableByAgreements" я активизирую поле "Currency"
			И в таблице "AccountReceivableByAgreements" я выбираю текущую строку
			И в таблице "AccountReceivableByAgreements" я нажимаю кнопку выбора у реквизита "Currency"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "AccountReceivableByAgreements" я активизирую поле "Amount"
			И в таблице "AccountReceivableByAgreements" в поле 'Amount' я ввожу текст '100,00'
			И в таблице "AccountReceivableByAgreements" я завершаю редактирование строки
		* Проверка расчета Reporting currency
			И в таблице "CurrenciesAccountReceivableByAgreements" я перехожу к строке:
				| 'Movement type'      | 'Type'      |
				| 'Reporting currency' | 'Reporting' |
			И в таблице "CurrenciesAccountReceivableByAgreements" я выбираю текущую строку
			И в таблице "CurrenciesAccountReceivableByAgreements" в поле с именем "CurrenciesAccountReceivableByAgreementsRatePresentation" я ввожу текст '5,8400'
			И в таблице "CurrenciesAccountReceivableByAgreements" в поле с именем "CurrenciesAccountReceivableByAgreementsMultiplicity" я ввожу текст '1'
			И в таблице "CurrenciesAccountReceivableByAgreements" я завершаю редактирование строки
			И     таблица "CurrenciesAccountReceivableByDocuments" содержит строки:
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate'   | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400' | '17,12'  | '1'            |
	* Post document
		И я нажимаю на кнопку 'Post and close'
		И Пауза 5
	* Check movements документа
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Opening entry 5*'                     | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                           | ''         | ''                         | ''                     |
			| 'Document registrations records'       | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                           | ''         | ''                         | ''                     |
			| 'Register  "Partner AR transactions"'  | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                           | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''         | ''           | ''                           | ''         | ''                         | 'Attributes'           |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner'  | 'Legal name' | 'Agreement'                  | 'Currency' | 'Currency movement type'   | 'Deferred calculation' |
			| ''                                     | 'Receipt'     | '*'      | '17,12'     | 'Main Company' | ''               | 'DFC'      | 'DFC'        | 'DFC Customer by agreements' | 'USD'      | 'Reporting currency'       | 'No'                   |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company' | ''               | 'DFC'      | 'DFC'        | 'DFC Customer by agreements' | 'TRY'      | 'en descriptions is empty' | 'No'                   |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company' | ''               | 'DFC'      | 'DFC'        | 'DFC Customer by agreements' | 'TRY'      | 'Local currency'           | 'No'                   |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company' | ''               | 'DFC'      | 'DFC'        | 'DFC Customer by agreements' | 'TRY'      | 'TRY'                      | 'No'                   |
			| ''                                     | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                           | ''         | ''                         | ''                     |
			| 'Register  "Accounts statement"'           | ''            | ''                   | ''                    | ''               | ''                       | ''               | ''             | ''                           | ''           | ''                         | ''                     |
			| ''                                         | 'Record type' | 'Period'             | 'Resources'           | ''               | ''                       | ''               | 'Dimensions'   | ''                           | ''           | ''                         | ''                     |
			| ''                                         | ''            | ''                   | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'                    | 'Legal name' | 'Basis document'           | 'Currency'             |
			| ''                                         | 'Receipt'     | '*'                  | ''                    | ''               | ''                       | '100'            | 'Main Company' | 'DFC'                        | 'DFC'        | ''                         | 'TRY'                  |
			| ''                                         | ''            | ''                   | ''                    | ''               | ''                       | ''               | ''             | ''                           | ''           | ''                         | ''                     |
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                           | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''         | ''           | ''                           | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'     | 'Currency' | ''           | ''                           | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company' | 'DFC'            | 'TRY'      | ''           | ''                           | ''         | ''                         | ''                     |



Сценарий: _400008 проверка ввода начального остатка по остаткам ДС/остаткам товара/дебиторке/кредиторке/авансам в одном документе
	* Opening a document form для ввода начального остатка
		И я открываю навигационную ссылку 'e1cib/list/Document.OpeningEntry'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение информации о компании
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
	* Заполнение номера документа
		И в поле 'Number' я ввожу текст '8'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '8'
	* Filling in the tabular part по остаткам ДС в кассе
		И в таблице "AccountBalance" я нажимаю на кнопку с именем 'AccountBalanceAdd'
		И в таблице "AccountBalance" я нажимаю кнопку выбора у реквизита "Account"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Cash desk №2 |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AccountBalance" я активизирую поле с именем "AccountBalanceCurrency"
		И в таблице "AccountBalance" я нажимаю кнопку выбора у реквизита "Currency"
		И в таблице "List" я перехожу к строке:
			| Code | Description     |
			| USD  | American dollar |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AccountBalance" я активизирую поле с именем "AccountBalanceAmount"
		И в таблице "AccountBalance" в поле 'Amount' я ввожу текст '1 000,00'
		И в таблице "AccountBalance" я завершаю редактирование строки
		И в таблице "AccountBalance" я перехожу к строке:
			| 'Account'      | 'Amount'   | 'Currency' |
			| 'Cash desk №2' | '1 000,00' | 'USD'      |
		И в таблице "CurrenciesAccountBalance" я перехожу к строке:
			| 'From' | 'Movement type'  | 'To'  | 'Type'  |
			| 'USD'  | 'Local currency' | 'TRY' | 'Legal' |
		И в таблице "CurrenciesAccountBalance" в поле с именем 'CurrenciesAccountBalanceRatePresentation' я ввожу текст '0,1756'
		И в таблице "CurrenciesAccountBalance" в поле с именем 'CurrenciesAccountBalanceMultiplicity' я ввожу текст '1'
		И в таблице "CurrenciesAccountBalance" я активизирую поле "Amount"
		И в таблице "CurrenciesAccountBalance" я завершаю редактирование строки
	* Filling in the tabular part по остаткам товара
		И я перехожу к закладке "Inventory"
		И в таблице "Inventory" я нажимаю на кнопку с именем 'InventoryAdd'
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Dress | XS/Blue  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Inventory" я активизирую поле "Quantity"
		И в таблице "Inventory" в поле 'Quantity' я ввожу текст '10,000'
		И в таблице "Inventory" я завершаю редактирование строки
	* Заполнение аванса от клиента
		И в таблице "AdvanceFromCustomers" я нажимаю на кнопку с именем 'AdvanceFromCustomersAdd'
		И в таблице "AdvanceFromCustomers" я нажимаю кнопку выбора у реквизита с именем "AdvanceFromCustomersPartner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AdvanceFromCustomers" я активизирую поле с именем "AdvanceFromCustomersCurrency"
		И в таблице "AdvanceFromCustomers" я нажимаю кнопку выбора у реквизита с именем "AdvanceFromCustomersCurrency"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AdvanceFromCustomers" я активизирую поле с именем "AdvanceFromCustomersAmount"
		И в таблице "AdvanceFromCustomers" в поле с именем 'AdvanceFromCustomersAmount' я ввожу текст '525,00'
		И в таблице "AdvanceFromCustomers" я завершаю редактирование строки
	* Заполнение аванса от поставщика
		И я перехожу к закладке "To suppliers"
		И в таблице "AdvanceToSuppliers" я нажимаю на кнопку с именем 'AdvanceToSuppliersAdd'
		И в таблице "AdvanceToSuppliers" я нажимаю кнопку выбора у реквизита с именем "AdvanceToSuppliersPartner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AdvanceToSuppliers" я завершаю редактирование строки
		И в таблице "AdvanceToSuppliers" я активизирую поле с именем "AdvanceToSuppliersLegalName"
		И в таблице "AdvanceToSuppliers" я выбираю текущую строку
		И в таблице "AdvanceToSuppliers" я нажимаю кнопку выбора у реквизита с именем "AdvanceToSuppliersLegalName"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Company Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AdvanceToSuppliers" я активизирую поле с именем "AdvanceToSuppliersCurrency"
		И в таблице "AdvanceToSuppliers" я нажимаю кнопку выбора у реквизита с именем "AdvanceToSuppliersCurrency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AdvanceToSuppliers" я активизирую поле с именем "AdvanceToSuppliersAmount"
		И в таблице "AdvanceToSuppliers" в поле с именем 'AdvanceToSuppliersAmount' я ввожу текст '811,00'
		И в таблице "AdvanceToSuppliers" я завершаю редактирование строки
	* Заполнение ввода начального остатка по задолженности поставщику по соглашениям
		* Заполнение партнера и Legal name
			И я перехожу к закладке "Account payable"
			И в таблице "AccountPayableByAgreements" я нажимаю на кнопку 'Add'
			И в таблице "AccountPayableByAgreements" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'DFC'         |
			И в таблице "List" я выбираю текущую строку
			И в таблице "AccountPayableByAgreements" я завершаю редактирование строки
		* Check filling inLegal name
				И     таблица "AccountPayableByAgreements" содержит строки:
				| 'Partner' | 'Legal name' |
				| 'DFC'     | 'DFC'        |
		* Выбор тестового соглашения с взаиморасчетами по соглашениям
			И в таблице "AccountPayableByAgreements" я нажимаю кнопку выбора у реквизита "Agreement"
			И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'DFC Vendor by agreements' |
			И я нажимаю на кнопку с именем 'FormChoose'
		* Заполнение суммы и валюты
			И в таблице "AccountPayableByAgreements" я активизирую поле "Currency"
			И в таблице "AccountPayableByAgreements" я выбираю текущую строку
			И в таблице "AccountPayableByAgreements" я нажимаю кнопку выбора у реквизита "Currency"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "AccountPayableByAgreements" я активизирую поле "Amount"
			И в таблице "AccountPayableByAgreements" в поле 'Amount' я ввожу текст '111,00'
			И в таблице "AccountPayableByAgreements" я завершаю редактирование строки
		* Проверка расчета Reporting currency
			И в таблице "CurrenciesAccountPayableByAgreements" я перехожу к строке:
			| 'Movement type'      | 'Type'      |
			| 'Reporting currency' | 'Reporting' |
			И в таблице "CurrenciesAccountPayableByAgreements" я выбираю текущую строку
			И в таблице "CurrenciesAccountPayableByAgreements" в поле с именем "CurrenciesAccountPayableByAgreementsRatePresentation" я ввожу текст '5,8400'
			И в таблице "CurrenciesAccountPayableByAgreements" в поле с именем "CurrenciesAccountPayableByAgreementsMultiplicity" я ввожу текст '1'
			И в таблице "CurrenciesAccountPayableByAgreements" я завершаю редактирование строки
	* Заполнение ввода начального остатка по задолженности клиента  по соглашениям
		* Заполнение партнера и Legal name
			И я перехожу к закладке "Account receivable"
			И в таблице "AccountReceivableByAgreements" я нажимаю на кнопку 'Add'
			И в таблице "AccountReceivableByAgreements" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'DFC'         |
			И в таблице "List" я выбираю текущую строку
			И в таблице "AccountReceivableByAgreements" я завершаю редактирование строки
		* Check filling inLegal name
				И     таблица "AccountReceivableByAgreements" содержит строки:
				| 'Partner' | 'Legal name' |
				| 'DFC'     | 'DFC'        |
		* Выбор тестового соглашения с взаиморасчетами по соглашениям
			И в таблице "AccountReceivableByAgreements" я нажимаю кнопку выбора у реквизита "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'              |
				| 'DFC Customer by agreements' |
			И я нажимаю на кнопку с именем 'FormChoose'
		* Заполнение суммы и валюты
			И в таблице "AccountReceivableByAgreements" я активизирую поле "Currency"
			И в таблице "AccountReceivableByAgreements" я выбираю текущую строку
			И в таблице "AccountReceivableByAgreements" я нажимаю кнопку выбора у реквизита "Currency"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "AccountReceivableByAgreements" я активизирую поле "Amount"
			И в таблице "AccountReceivableByAgreements" в поле 'Amount' я ввожу текст '151,00'
			И в таблице "AccountReceivableByAgreements" я завершаю редактирование строки
		* Проверка расчета Reporting currency
			И в таблице "CurrenciesAccountReceivableByAgreements" я перехожу к строке:
				| 'Movement type'      | 'Type'      |
				| 'Reporting currency' | 'Reporting' |
			И в таблице "CurrenciesAccountReceivableByAgreements" я выбираю текущую строку
			И в таблице "CurrenciesAccountReceivableByAgreements" в поле с именем "CurrenciesAccountReceivableByAgreementsRatePresentation" я ввожу текст '5,8400'
			И в таблице "CurrenciesAccountReceivableByAgreements" в поле с именем "CurrenciesAccountReceivableByAgreementsMultiplicity" я ввожу текст '1'
			И в таблице "CurrenciesAccountReceivableByAgreements" я завершаю редактирование строки
	# * Заполнение ввода начального остатка по задолженности клиента  по документам
	# * Заполнение ввода начального остатка по задолженности поставщика  по документам


Сценарий: _400009 проверка ввода начального остатка по остаткам AP и AR по документам
	* Opening a document form для ввода начального остатка
		И я открываю навигационную ссылку 'e1cib/list/Document.OpeningEntry'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение информации о компании
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
	* Заполнение номера документа
		И в поле 'Number' я ввожу текст '9'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '9'
	* Заполнение AP по документам
		И я перехожу к закладке "Account payable"
		И я перехожу к закладке с именем "GroupAccountPayableByDocuments"
		И в таблице "AccountPayableByDocuments" я нажимаю на кнопку с именем 'AccountPayableByDocumentsAdd'
		И в таблице "AccountPayableByDocuments" я нажимаю кнопку выбора у реквизита с именем "AccountPayableByDocumentsPartner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AccountPayableByDocuments" я завершаю редактирование строки
		И я перехожу к следующему реквизиту
		И в таблице "AccountPayableByDocuments" я активизирую поле с именем "AccountPayableByDocumentsAgreement"
		И в таблице "AccountPayableByDocuments" я нажимаю кнопку выбора у реквизита с именем "AccountPayableByDocumentsAgreement"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Agreement vendor DFC'         |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AccountPayableByDocuments" я выбираю текущую строку
		И в таблице "AccountPayableByDocuments" я активизирую поле с именем "AccountPayableByDocumentsCurrency"
		И в таблице "AccountPayableByDocuments" я нажимаю кнопку выбора у реквизита с именем "AccountPayableByDocumentsCurrency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AccountPayableByDocuments" я активизирую поле с именем "AccountPayableByDocumentsBasisDocument"
		И в таблице "AccountPayableByDocuments" я нажимаю кнопку выбора у реквизита с именем "AccountPayableByDocumentsBasisDocument"
		И в таблице "" я перехожу к строке:
			| ''                 |
			| 'Purchase invoice' |
		И в таблице "" я выбираю текущую строку
		Тогда в таблице "List" количество строк "меньше или равно" 1
		И в таблице "List" я перехожу к строке:
			| 'Legal name' | 'Number' |
			| 'DFC'        | '5 900'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AccountPayableByDocuments" я активизирую поле с именем "AccountPayableByDocumentsAmount"
		И в таблице "AccountPayableByDocuments" в поле с именем 'AccountPayableByDocumentsAmount' я ввожу текст '100,00'
		И в таблице "AccountPayableByDocuments" я завершаю редактирование строки
	* Заполнение AR по документам
		И я перехожу к закладке "Account receivable"
		И я перехожу к закладке с именем "GroupAccountReceivableByDocuments"
		И в таблице "AccountReceivableByDocuments" я нажимаю на кнопку с именем 'AccountReceivableByDocumentsAdd'
		И в таблице "AccountReceivableByDocuments" я нажимаю кнопку выбора у реквизита с именем "AccountReceivableByDocumentsPartner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к следующему реквизиту
		И в таблице "AccountReceivableByDocuments" я активизирую поле с именем "AccountReceivableByDocumentsAgreement"
		И в таблице "AccountReceivableByDocuments" я нажимаю кнопку выбора у реквизита с именем "AccountReceivableByDocumentsAgreement"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Agreement DFC'         |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AccountReceivableByDocuments" я активизирую поле с именем "AccountReceivableByDocumentsCurrency"
		И в таблице "AccountReceivableByDocuments" я нажимаю кнопку выбора у реквизита с именем "AccountReceivableByDocumentsCurrency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AccountReceivableByDocuments" я нажимаю кнопку выбора у реквизита с именем "AccountReceivableByDocumentsBasisDocument"
		И в таблице "" я перехожу к строке:
			| ''              |
			| 'Sales invoice' |
		И в таблице "" я выбираю текущую строку
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '5 900'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AccountReceivableByDocuments" я завершаю редактирование строки
		И в таблице "AccountReceivableByDocuments" я активизирую поле с именем "AccountReceivableByDocumentsAmount"
		И в таблице "AccountReceivableByDocuments" я выбираю текущую строку
		И в таблице "AccountReceivableByDocuments" в поле с именем 'AccountReceivableByDocumentsAmount' я ввожу текст '200,00'
		И в таблице "AccountReceivableByDocuments" я завершаю редактирование строки
	# * Проведение и проверка движений
	# 	И я нажимаю на кнопку 'Post'
	# 	И я нажимаю на кнопку 'Registrations report'
	# AccountByDocumentsMainTablePartnerOnChange
	# AccountPayableByDocumentsPartnerOnChange
	# AccountReceivableByDocumentsPartnerOnChange
	# MainTableLegalNameEditTextChange
	# AccountReceivableByDocumentsAgreementStartChoice
	# AccountPayableByDocumentsAgreementStartChoice
	# AccountReceivableByAgreementsAgreementEditTextChange
	# AccountReceivableByDocumentsAgreementEditTextChange
	# AgreementEditTextChange