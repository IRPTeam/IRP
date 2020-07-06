#language: ru
@tree
@Positive
Функционал: cheque bond transaction

As an accountant
I want to create a Cheque bond transaction document
For settlements with partners

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _090001 check for metadata ( catalog and document) availability
	Дано Я открываю основную форму списка документа "ChequeBondTransaction"
	Дано Я открываю основную форму списка справочника "ChequeBonds"
	И я закрыл все окна клиентского приложения

Сценарий: _090002 create statuses for Cheque bond
	* Opening of the catalog Object Statuses and renaming of predefined elements for Cheque bond
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ObjectStatuses'
		И в таблице "List" я разворачиваю текущую строку
		И в таблице "List" я разворачиваю строку:
			| 'Predefined data item name' |
			| 'ChequeBondTransaction'     |
		И в таблице "List" я перехожу к строке:
			| 'Predefined data item name' |
			| 'ChequeBondIncoming'     |
		И в таблице "List" я активизирую поле "Predefined data item name"
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuChange'
		И в поле 'ENG' я ввожу текст 'ChequeBondIncoming'
		И я нажимаю на кнопку 'Save and close'
		И в таблице "List" я перехожу к строке:
			| 'Predefined data item name' |
			| 'ChequeBondOutgoing'     |
		И в таблице "List" я активизирую поле "Predefined data item name"
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuChange'
		И в поле 'ENG' я ввожу текст 'ChequeBondOutgoing'
		И я нажимаю на кнопку 'Save and close'
	* Create statuses for Cheque bond incoming
		* Create status Taken from partner
			И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'ChequeBondIncoming' |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст '01. TakenFromPartner'
			И я устанавливаю флаг 'Set by default'
			И я перехожу к закладке с именем "GroupPosting"
			И я меняю значение переключателя 'Cheque bond balance' на 'Posting'
			И я меняю значение переключателя 'Advanced' на 'Posting'
			И я меняю значение переключателя 'Partner account transactions' на 'Posting'
			И я меняю значение переключателя 'Reconciliation statement' на 'Posting'
			И я меняю значение переключателя 'Planning cash transactions' на 'Posting'
			И я нажимаю на кнопку 'Save and close'
		* Create status Payment received
			И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'ChequeBondIncoming' |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст '03. PaymentReceived'
			И я перехожу к закладке с именем "GroupPosting"
			И я меняю значение переключателя 'Account balance' на 'Posting'
			И я меняю значение переключателя 'Planning cash transactions' на 'Reversal'
			И я нажимаю на кнопку 'Save and close'
		* Create status Protested
			И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'ChequeBondIncoming' |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст '04. Protested'
			И я перехожу к закладке с именем "GroupPosting"
			И я меняю значение переключателя 'Cheque bond balance' на 'Reversal'
			И я меняю значение переключателя 'Advanced' на 'Reversal'
			И я меняю значение переключателя 'Partner account transactions' на 'Reversal'
			И я меняю значение переключателя 'Reconciliation statement' на 'Reversal'
			И я меняю значение переключателя 'Planning cash transactions' на 'Reversal'
			И я нажимаю на кнопку 'Save and close'
		* Create status Give to bank as assurance
			И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'ChequeBondIncoming' |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст '02. GiveToBankAsAssurance'
			И я нажимаю на кнопку 'Save and close'
	* Create statuses for Cheque bond outgoing
		* Create status Given to partner
			И в таблице "List" я перехожу к строке:
				| 'Description'        |
				| 'ChequeBondOutgoing' |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст '01. GivenToPartner'
			И я устанавливаю флаг 'Set by default'
			И я перехожу к закладке с именем "GroupPosting"
			И я меняю значение переключателя 'Cheque bond balance' на 'Posting'
			И я меняю значение переключателя 'Advanced' на 'Posting'
			И я меняю значение переключателя 'Partner account transactions' на 'Posting'
			И я меняю значение переключателя 'Reconciliation statement' на 'Posting'
			И я меняю значение переключателя 'Planning cash transactions' на 'Posting'
			И я нажимаю на кнопку 'Save and close'
		* Create status Payed
			И в таблице "List" я перехожу к строке:
				| 'Description'        |
				| 'ChequeBondOutgoing' |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст '02. Payed'
			И я перехожу к закладке с именем "GroupPosting"
			И я меняю значение переключателя 'Account balance' на 'Posting'
			И я меняю значение переключателя 'Planning cash transactions' на 'Reversal'
			И я нажимаю на кнопку 'Save and close'
		* Create status Protested
			И в таблице "List" я перехожу к строке:
				| 'Description'        |
				| 'ChequeBondOutgoing' |
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст '03. Protested'
			И я перехожу к закладке с именем "GroupPosting"
			И я меняю значение переключателя 'Cheque bond balance' на 'Reversal'
			И я меняю значение переключателя 'Advanced' на 'Reversal'
			И я меняю значение переключателя 'Partner account transactions' на 'Reversal'
			И я меняю значение переключателя 'Reconciliation statement' на 'Reversal'
			И я меняю значение переключателя 'Planning cash transactions' на 'Reversal'
			И я нажимаю на кнопку 'Save and close'
	* Setting the order of statuses for incoming cheques
		И в таблице "List" я перехожу к строке:
			| 'Description'          |
			| '01. TakenFromPartner' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "NextPossibleStatuses" я нажимаю на кнопку с именем 'NextPossibleStatusesAdd'
		И Пауза 2
		И в таблице "List" я перехожу к строке:
			| 'Description'               |
			| '02. GiveToBankAsAssurance' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "NextPossibleStatuses" я завершаю редактирование строки
		И в таблице "NextPossibleStatuses" я нажимаю на кнопку с именем 'NextPossibleStatusesAdd'
		И в таблице "List" я выбираю текущую строку
		И в таблице "NextPossibleStatuses" я завершаю редактирование строки
		И в таблице "NextPossibleStatuses" я нажимаю на кнопку с именем 'NextPossibleStatusesAdd'
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| '04. Protested' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "NextPossibleStatuses" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна '01. TakenFromPartner (Order status) *' в течение 20 секунд
		И в таблице "List" я перехожу к строке:
			| 'Description'               |
			| '02. GiveToBankAsAssurance' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "NextPossibleStatuses" я нажимаю на кнопку 'Add'
		И в таблице "List" я перехожу к строке:
			| 'Description'         |
			| '03. PaymentReceived' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "NextPossibleStatuses" я завершаю редактирование строки
		И в таблице "NextPossibleStatuses" я нажимаю на кнопку 'Add'
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| '04. Protested' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "NextPossibleStatuses" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
	* Setting the order of statuses for outgoing cheques
		И в таблице "List" я перехожу к строке:
			| 'Description'          |
			| '01. GivenToPartner' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "NextPossibleStatuses" я нажимаю на кнопку с именем 'NextPossibleStatusesAdd'
		И Пауза 2
		И в таблице "List" я перехожу к строке:
			| 'Description'               |
			| '02. Payed' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "NextPossibleStatuses" я завершаю редактирование строки
		И в таблице "NextPossibleStatuses" я нажимаю на кнопку 'Add'
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| '03. Protested' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "NextPossibleStatuses" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'


Сценарий: _090003 create an incoming and outgoing check in the Cheque bonds catalog
	* Open catalog form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ChequeBonds'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Create an incoming check
		И в поле 'Cheque No' я ввожу текст 'Partner cheque 1'
		И в поле 'Cheque serial No' я ввожу текст 'AA'
		И из выпадающего списка "Type" я выбираю точное значение 'Partner cheque'
		И в поле "Due date" я ввожу конец текущего месяца
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Amount' я ввожу текст '2 000,00'
		И я нажимаю на кнопку 'Save and close'
	* Create an outgoing check
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'Cheque No' я ввожу текст 'Own cheque 1'
		И в поле 'Cheque serial No' я ввожу текст 'BB'
		И из выпадающего списка "Type" я выбираю точное значение 'Own cheque'
		И в поле "Due date" я ввожу конец текущего месяца
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Amount' я ввожу текст '5 000,00'
		И я нажимаю на кнопку 'Save and close'
	* Create cheque bond
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ChequeBonds'
		Тогда таблица "List" содержит строки:
		| 'Cheque No'        | 'Cheque serial No' | 'Amount'   | 'Type'           | 'Currency' |
		| 'Own cheque 1'     | 'BB'               | '5 000,00' | 'Own cheque'     | 'TRY'      |
		| 'Partner cheque 1' | 'AA'               | '2 000,00' | 'Partner cheque' | 'TRY'      |
		И я закрыл все окна клиентского приложения
	* Check that fields are required to be filled in
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ChequeBonds'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку 'Save'
		Затем я жду, что в сообщениях пользователю будет подстрока '"Cheque No" is a required field' в течение 5 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока '"Type" is a required field' в течение 5 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока '"Due date" is a required field' в течение 5 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока '"Currency" is a required field' в течение 5 секунд
		Затем я жду, что в сообщениях пользователю будет подстрока '"Amount" is a required field' в течение 5 секунд
		И я закрыл все окна клиентского приложения


Сценарий: _090004 preparation
	* Create a partner and legal name from whom the cheque bond was received and to whom the heque bond was issued
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'DFC'
		И я изменяю флаг 'Vendor'
		И я изменяю флаг 'Customer'
		И я изменяю флаг 'Shipment confirmations before sales invoice'
		И я изменяю флаг 'Goods receipt before purchase invoice'
		И я нажимаю на кнопку 'Save'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Partner segments'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Segment"
		Тогда открылось окно 'Partner segments'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Retail'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Partner segments (create) *' в течение 20 секунд
		И В текущем окне я нажимаю кнопку командного интерфейса 'Company'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'DFC'
		И я нажимаю кнопку выбора у поля "Country"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Turkey'      |
		И в таблице "List" я выбираю текущую строку
		Тогда открылось окно 'Company (create) *'
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Company (create) *' в течение 20 секунд
		И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'DFC (Partner)' в течение 20 секунд
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Big foot'
		И я изменяю флаг 'Customer'
		И я изменяю флаг 'Vendor'
		И я изменяю флаг 'Shipment confirmations before sales invoice'
		И я изменяю флаг 'Goods receipt before purchase invoice'
		И я нажимаю на кнопку 'Save'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Partner segments'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Segment"
		Тогда открылось окно 'Partner segments'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Retail'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Partner segments (create) *' в течение 20 секунд
		И В текущем окне я нажимаю кнопку командного интерфейса 'Company'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Big foot'
		И я нажимаю кнопку выбора у поля "Country"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Turkey'      |
		И в таблице "List" я выбираю текущую строку
		Тогда открылось окно 'Company (create) *'
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Company (create) *' в течение 20 секунд
		Тогда открылось окно 'Big foot (Partner)'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Big foot (Partner)' в течение 20 секунд
	* Create test Sales invoice for DFC
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Partner" я выбираю по строке 'dfc'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
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
		И я разворачиваю группу "Currency"
		И я перехожу к закладке с именем "GroupCurrency"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '3 000'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '3 000'
		И я нажимаю на кнопку 'Post and close'


Сценарий: _090005 create a document Cheque bond transaction (Cheque bond from partner + Cheque bond written to another partner)
	* Open a document form Cheque bond transaction
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in basic details
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Add Cheque bonds to the table part
		И в таблице "ChequeBonds" я нажимаю на кнопку с именем 'ChequeBondsAdd'
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Cheque"
		И в таблице "List" я перехожу к строке:
			| 'Amount'   | 'Cheque No'        |
			| '2 000,00' | 'Partner cheque 1' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я активизирую поле "New status"
		И в таблице "ChequeBonds" из выпадающего списка "New status" я выбираю точное значение '01. TakenFromPartner'
		И я перехожу к следующему реквизиту
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита с именем "ChequeBondsPartner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я активизирую поле "Legal name"
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'      |
			| 'DFC' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я активизирую поле "Agreement"
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Agreements, TRY' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я завершаю редактирование строки
		И в таблице "ChequeBonds" я нажимаю на кнопку с именем 'ChequeBondsAdd'
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Cheque"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я активизирую поле "New status"
		И в таблице "ChequeBonds" из выпадающего списка "New status" я выбираю точное значение '01. GivenToPartner'
		И я перехожу к следующему реквизиту
		И в таблице "ChequeBonds" я активизирую поле с именем "ChequeBondsPartner"
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита с именем "ChequeBondsPartner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Big foot'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я активизирую поле "Legal name"
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Big foot'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я активизирую поле "Cash account"
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Cash account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я завершаю редактирование строки
		И в таблице "ChequeBonds" я перехожу к строке:
			| 'Cheque'           | 'Partner' |
			| 'Partner cheque 1' | 'DFC'     |
		И в таблице "ChequeBonds" я выбираю текущую строку
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Cash account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я завершаю редактирование строки
	* Add bases dpcuments
		И в таблице "PaymentList" я нажимаю на кнопку 'Fill'
		И в таблице "DocumentsList" я выбираю текущую строку
		И в таблице "PickedDocuments" я активизирую поле "Amount balance"
		И в таблице "PickedDocuments" я выбираю текущую строку
		И в таблице "PickedDocuments" в поле 'Amount balance' я ввожу текст '1 800,00'
		И в таблице "PickedDocuments" я завершаю редактирование строки
		И в таблице "DocumentsList" я нажимаю на кнопку 'Transfer to document'
	* Change the document number
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	* Post document
		И я нажимаю на кнопку 'Post'
	* Check movements
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Cheque bond transaction 1*'            | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Document registrations records'        | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Cheque bond statuses"'      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'       | 'Attributes'       | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | ''            | 'Status'               | 'Cheque'           | 'Author'           | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | '*'           | '01. TakenFromPartner' | 'Partner cheque 1' | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | '*'           | '01. GivenToPartner'   | 'Own cheque 1'     | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Partner cheque 1'                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"'   | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'        | 'Dimensions'       | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | ''                     | 'Amount'           | 'Company'          | 'Basis document'       | 'Partner'    | 'Legal name'          | 'Agreement'             | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                      | 'Expense'     | '*'                    | '308,22'           | 'Main Company'     | 'Sales invoice 3 000*' | 'DFC'        | 'DFC'                 | 'Basic Agreements, TRY' | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                      | 'Expense'     | '*'                    | '1 800'            | 'Main Company'     | 'Sales invoice 3 000*' | 'DFC'        | 'DFC'                 | 'Basic Agreements, TRY' | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                      | 'Expense'     | '*'                    | '1 800'            | 'Main Company'     | 'Sales invoice 3 000*' | 'DFC'        | 'DFC'                 | 'Basic Agreements, TRY' | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                      | 'Expense'     | '*'                    | '1 800'            | 'Main Company'     | 'Sales invoice 3 000*' | 'DFC'        | 'DFC'                 | 'Basic Agreements, TRY' | 'TRY'                      | 'TRY'                      | 'No'                   |
		| ''                                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'       | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | 'Amount'               | 'Company'          | 'Basis document'   | 'Account'              | 'Currency'   | 'Cash flow direction' | 'Partner'               | 'Legal name'               | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'           | '342,47'               | 'Main Company'     | 'Partner cheque 1' | 'Bank account, TRY'    | 'USD'        | 'Incoming'            | 'DFC'                   | 'DFC'                      | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'           | '2 000'                | 'Main Company'     | 'Partner cheque 1' | 'Bank account, TRY'    | 'TRY'        | 'Incoming'            | 'DFC'                   | 'DFC'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'           | '2 000'                | 'Main Company'     | 'Partner cheque 1' | 'Bank account, TRY'    | 'TRY'        | 'Incoming'            | 'DFC'                   | 'DFC'                      | 'Local currency'           | 'No'                   |
		| ''                                      | '*'           | '2 000'                | 'Main Company'     | 'Partner cheque 1' | 'Bank account, TRY'    | 'TRY'        | 'Incoming'            | 'DFC'                   | 'DFC'                      | 'TRY'                      | 'No'                   |
		| ''                                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'                      | ''                    | ''                     | ''                    | ''                 | ''                                              | ''               | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                                    | 'Record type'         | 'Period'               | 'Resources'           | ''                 | ''                                              | ''               | 'Dimensions'          | ''                      | ''                         | ''                         | ''                     |
		| ''                                                    | ''                    | ''                     | 'Advance to supliers' | 'Transaction AP'   | 'Advance from customers'                        | 'Transaction AR' | 'Company'             | 'Partner'               | 'Legal name'               | 'Basis document'           | 'Currency'             |
		| ''                                                    | 'Receipt'             | '*'                    | '-200'                | ''                 | ''                                              | ''               | 'Main Company'     | 'DFC'                   | 'DFC'                      | ''                         | 'TRY'                  |
		| ''                                                    | 'Receipt'             | '*'                    | ''                    | ''                 | '200'                                           | ''               | 'Main Company'     | 'DFC'                   | 'DFC'                      | ''                         | 'TRY'                  |
		| ''                                                    | 'Expense'             | '*'                    | ''                    | ''                 | ''                                              | '1 800'          | 'Main Company'     | 'DFC'                   | 'DFC'                      | 'Sales invoice 3 000*'     | 'TRY'                  |
		| ''                                                    | ''                    | ''                     | ''                    | ''                 | ''                                              | ''               | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'        | 'Dimensions'       | ''                     | ''           | ''                    | ''                      | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'           | 'Company'          | 'Cheque'               | 'Partner'    | 'Legal name'          | 'Currency'              | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '342,47'           | 'Main Company'     | 'Partner cheque 1'     | 'DFC'        | 'DFC'                 | 'USD'                   | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'            | 'Main Company'     | 'Partner cheque 1'     | 'DFC'        | 'DFC'                 | 'TRY'                   | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'            | 'Main Company'     | 'Partner cheque 1'     | 'DFC'        | 'DFC'                 | 'TRY'                   | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'            | 'Main Company'     | 'Partner cheque 1'     | 'DFC'        | 'DFC'                 | 'TRY'                   | 'TRY'                      | 'No'                       | ''                     |
		| ''                                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'        | 'Dimensions'       | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'           | 'Company'          | 'Legal name'           | 'Currency'   | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'                    | '2 000'            | 'Main Company'     | 'DFC'                  | 'TRY'        | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Advance from customers"'    | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'        | 'Dimensions'       | ''                     | ''           | ''                    | ''                      | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'           | 'Company'          | 'Partner'              | 'Legal name' | 'Currency'            | 'Receipt document'      | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '34,25'            | 'Main Company'     | 'DFC'                  | 'DFC'        | 'USD'                 | 'Partner cheque 1'      | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '200'              | 'Main Company'     | 'DFC'                  | 'DFC'        | 'TRY'                 | 'Partner cheque 1'      | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '200'              | 'Main Company'     | 'DFC'                  | 'DFC'        | 'TRY'                 | 'Partner cheque 1'      | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Own cheque 1'                          | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'       | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | 'Amount'               | 'Company'          | 'Basis document'   | 'Account'              | 'Currency'   | 'Cash flow direction' | 'Partner'               | 'Legal name'               | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'           | '856,16'               | 'Main Company'     | 'Own cheque 1'     | 'Bank account, TRY'    | 'USD'        | 'Outgoing'            | 'Big foot'              | 'Big foot'                 | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'           | '5 000'                | 'Main Company'     | 'Own cheque 1'     | 'Bank account, TRY'    | 'TRY'        | 'Outgoing'            | 'Big foot'              | 'Big foot'                 | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'           | '5 000'                | 'Main Company'     | 'Own cheque 1'     | 'Bank account, TRY'    | 'TRY'        | 'Outgoing'            | 'Big foot'              | 'Big foot'                 | 'Local currency'           | 'No'                   |
		| ''                                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'                     | ''                   | ''                     | ''                    | ''                 | ''                                              | ''               | ''                    | ''                      | ''                         | ''                                              | ''                     |
		| ''                                                   | 'Record type'        | 'Period'               | 'Resources'           | ''                 | ''                                              | ''               | 'Dimensions'          | ''                      | ''                         | ''                                              | ''                     |
		| ''                                                   | ''                   | ''                     | 'Advance to supliers' | 'Transaction AP'   | 'Advance from customers'                        | 'Transaction AR' | 'Company'             | 'Partner'               | 'Legal name'               | 'Basis document'                                | 'Currency'             |
		| ''                                                   | 'Receipt'            | '*'                    | ''                    | ''                 | '-5 000'                                        | ''               | 'Main Company'        | 'Big foot'              | 'Big foot'                 | ''                                              | 'TRY'                  |
		| ''                                                   | 'Receipt'            | '*'                    | '5 000'               | ''                 | ''                                              | ''               | 'Main Company'        | 'Big foot'              | 'Big foot'                 | ''                                              | 'TRY'                  |
		| ''                                                   | ''                   | ''                     | ''                    | ''                 | ''                                              | ''               | ''                    | ''                      | ''                         | ''                                              | ''                     |
		| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'        | 'Dimensions'       | ''                     | ''           | ''                    | ''                      | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'           | 'Company'          | 'Cheque'               | 'Partner'    | 'Legal name'          | 'Currency'              | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '856,16'           | 'Main Company'     | 'Own cheque 1'         | 'Big foot'   | 'Big foot'            | 'USD'                   | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '5 000'            | 'Main Company'     | 'Own cheque 1'         | 'Big foot'   | 'Big foot'            | 'TRY'                   | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '5 000'            | 'Main Company'     | 'Own cheque 1'         | 'Big foot'   | 'Big foot'            | 'TRY'                   | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'        | 'Dimensions'       | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'           | 'Company'          | 'Legal name'           | 'Currency'   | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '5 000'            | 'Main Company'     | 'Big foot'             | 'TRY'        | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Advance to suppliers"'      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'        | 'Dimensions'       | ''                     | ''           | ''                    | ''                      | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'           | 'Company'          | 'Partner'              | 'Legal name' | 'Currency'            | 'Payment document'      | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '856,16'           | 'Main Company'     | 'Big foot'             | 'Big foot'   | 'USD'                 | 'Own cheque 1'          | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '5 000'            | 'Main Company'     | 'Big foot'             | 'Big foot'   | 'TRY'                 | 'Own cheque 1'          | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '5 000'            | 'Main Company'     | 'Big foot'             | 'Big foot'   | 'TRY'                 | 'Own cheque 1'          | 'Local currency'           | 'No'                       | ''                     |
		И я закрыл все окна клиентского приложения
	* Checking the deleting of the added bases document
		* Opening a document form Cheque bond transaction
			И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
			Тогда открылось окно 'Cheque bond transactions'
			И в таблице "List" я перехожу к строке:
				| 'Number' |
				| '1'      |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" я активизирую поле "Partner ar basis document"
			И в таблице 'PaymentList' я удаляю строку
			И я нажимаю на кнопку 'Post'
		* Check for movement changes
			И я нажимаю на кнопку 'Registrations report'
			Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Cheque bond transaction 1*'            | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Document registrations records'        | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Cheque bond statuses"'      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | 'Attributes'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | 'Status'               | 'Cheque'              | 'Author'           | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | '*'           | '01. TakenFromPartner' | 'Partner cheque 1'    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | '*'           | '01. GivenToPartner'   | 'Own cheque 1'        | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Partner cheque 1'                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | 'Attributes'           |
			| ''                                      | ''            | 'Amount'               | 'Company'             | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'          | 'Legal name'               | 'Currency movement type'   | 'Deferred calculation' |
			| ''                                      | '*'           | '342,47'               | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'USD'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'Reporting currency'       | 'No'                   |
			| ''                                      | '*'           | '2 000'                | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'en descriptions is empty' | 'No'                   |
			| ''                                      | '*'           | '2 000'                | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'Local currency'           | 'No'                   |
			| ''                                      | '*'           | '2 000'                | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'TRY'                      | 'No'                   |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Accounts statement"'        | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | ''                 | ''                       | ''               | 'Dimensions'          | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Advance to supliers' | 'Transaction AP'   | 'Advance from customers' | 'Transaction AR' | 'Company'             | 'Partner'          | 'Legal name'               | 'Basis document'           | 'Currency'             |
			| ''                                      | 'Receipt'     | '*'                    | '-2 000'              | ''                 | ''                       | ''               | 'Main Company'        | 'DFC'              | 'DFC'                      | ''                         | 'TRY'                  |
			| ''                                      | 'Receipt'     | '*'                    | ''                    | ''                 | '2 000'                  | ''               | 'Main Company'        | 'DFC'              | 'DFC'                      | ''                         | 'TRY'                  |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Cheque'                 | 'Partner'        | 'Legal name'          | 'Currency'         | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '342,47'              | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'USD'              | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'TRY'                      | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Reconciliation statement"'  | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Legal name'             | 'Currency'       | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Expense'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'TRY'            | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Advance from customers"'    | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Receipt document' | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '342,47'              | 'Main Company'     | 'DFC'                    | 'DFC'            | 'USD'                 | 'Partner cheque 1' | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Own cheque 1'                          | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | 'Attributes'           |
			| ''                                      | ''            | 'Amount'               | 'Company'             | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'          | 'Legal name'               | 'Currency movement type'   | 'Deferred calculation' |
			| ''                                      | '*'           | '856,16'               | 'Main Company'        | 'Own cheque 1'     | 'Bank account, TRY'      | 'USD'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                 | 'Reporting currency'       | 'No'                   |
			| ''                                      | '*'           | '5 000'                | 'Main Company'        | 'Own cheque 1'     | 'Bank account, TRY'      | 'TRY'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                 | 'en descriptions is empty' | 'No'                   |
			| ''                                      | '*'           | '5 000'                | 'Main Company'        | 'Own cheque 1'     | 'Bank account, TRY'      | 'TRY'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                 | 'Local currency'           | 'No'                   |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Accounts statement"'        | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | ''                 | ''                       | ''               | 'Dimensions'          | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Advance to supliers' | 'Transaction AP'   | 'Advance from customers' | 'Transaction AR' | 'Company'             | 'Partner'          | 'Legal name'               | 'Basis document'           | 'Currency'             |
			| ''                                      | 'Receipt'     | '*'                    | ''                    | ''                 | '-5 000'                 | ''               | 'Main Company'        | 'Big foot'         | 'Big foot'                 | ''                         | 'TRY'                  |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | ''                 | ''                       | ''               | 'Main Company'        | 'Big foot'         | 'Big foot'                 | ''                         | 'TRY'                  |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Cheque'                 | 'Partner'        | 'Legal name'          | 'Currency'         | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '856,16'              | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'USD'              | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'              | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'              | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Reconciliation statement"'  | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Legal name'             | 'Currency'       | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'TRY'            | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Advance to suppliers"'      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Payment document' | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '856,16'              | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'USD'                 | 'Own cheque 1'     | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'     | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'     | 'Local currency'           | 'No'                       | ''                     |
			И я закрыл все окна клиентского приложения
	* Clear postings Cheque bond transactions and check that there is no movements on the registers
		* Отмена проведения Cheque bond transactions
			И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
			И в таблице "List" я перехожу к строке:
				| 'Number' |
				| '1'      |
			И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		* Сheck that there is no movement on the registers
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.ChequeBondBalance'
			Тогда таблица "List" не содержит строки:
			| 'Cheque'           |
			| 'Partner cheque 1' |
			| 'Own cheque 1'     |
			И я открываю навигационную ссылку 'e1cib/list/InformationRegister.ChequeBondStatuses'
			Тогда таблица "List" не содержит строки:
			| 'Cheque'           | 'Recorder'                   | 'Status'               |
			| 'Partner cheque 1' | 'Cheque bond transaction 1*' | '01. TakenFromPartner' |
			| 'Own cheque 1'     | 'Cheque bond transaction 1*' | '01. GivenToPartner'   |
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PlaningCashTransactions'
			Тогда таблица "List" не содержит строки:
			| 'Recorder'           |
			| 'Partner cheque 1' |
			| 'Own cheque 1'     |
			И я закрыл все окна клиентского приложения
	* Re-Posting the document and check movements
		* Проведения Cheque bond transactions
			И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
			И в таблице "List" я перехожу к строке:
				| 'Number' |
				| '1'      |
			И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		* Check movements
			И я нажимаю на кнопку 'Registrations report'
			Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Cheque bond transaction 1*'            | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Document registrations records'        | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Cheque bond statuses"'      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | 'Attributes'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | 'Status'               | 'Cheque'              | 'Author'           | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | '*'           | '01. TakenFromPartner' | 'Partner cheque 1'    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | '*'           | '01. GivenToPartner'   | 'Own cheque 1'        | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Partner cheque 1'                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | 'Attributes'           |
			| ''                                      | ''            | 'Amount'               | 'Company'             | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'          | 'Legal name'               | 'Currency movement type'   | 'Deferred calculation' |
			| ''                                      | '*'           | '342,47'               | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'USD'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'Reporting currency'       | 'No'                   |
			| ''                                      | '*'           | '2 000'                | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'en descriptions is empty' | 'No'                   |
			| ''                                      | '*'           | '2 000'                | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'Local currency'           | 'No'                   |
			| ''                                      | '*'           | '2 000'                | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'TRY'                      | 'No'                   |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Accounts statement"'        | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | ''                 | ''                       | ''               | 'Dimensions'          | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Advance to supliers' | 'Transaction AP'   | 'Advance from customers' | 'Transaction AR' | 'Company'             | 'Partner'          | 'Legal name'               | 'Basis document'           | 'Currency'             |
			| ''                                      | 'Receipt'     | '*'                    | '-2 000'              | ''                 | ''                       | ''               | 'Main Company'        | 'DFC'              | 'DFC'                      | ''                         | 'TRY'                  |
			| ''                                      | 'Receipt'     | '*'                    | ''                    | ''                 | '2 000'                  | ''               | 'Main Company'        | 'DFC'              | 'DFC'                      | ''                         | 'TRY'                  |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Cheque'                 | 'Partner'        | 'Legal name'          | 'Currency'         | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '342,47'              | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'USD'              | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'TRY'                      | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Reconciliation statement"'  | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Legal name'             | 'Currency'       | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Expense'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'TRY'            | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Advance from customers"'    | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Receipt document' | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '342,47'              | 'Main Company'     | 'DFC'                    | 'DFC'            | 'USD'                 | 'Partner cheque 1' | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Own cheque 1'                          | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | 'Attributes'           |
			| ''                                      | ''            | 'Amount'               | 'Company'             | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'          | 'Legal name'               | 'Currency movement type'   | 'Deferred calculation' |
			| ''                                      | '*'           | '856,16'               | 'Main Company'        | 'Own cheque 1'     | 'Bank account, TRY'      | 'USD'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                 | 'Reporting currency'       | 'No'                   |
			| ''                                      | '*'           | '5 000'                | 'Main Company'        | 'Own cheque 1'     | 'Bank account, TRY'      | 'TRY'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                 | 'en descriptions is empty' | 'No'                   |
			| ''                                      | '*'           | '5 000'                | 'Main Company'        | 'Own cheque 1'     | 'Bank account, TRY'      | 'TRY'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                 | 'Local currency'           | 'No'                   |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Accounts statement"'        | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | ''                 | ''                       | ''               | 'Dimensions'          | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Advance to supliers' | 'Transaction AP'   | 'Advance from customers' | 'Transaction AR' | 'Company'             | 'Partner'          | 'Legal name'               | 'Basis document'           | 'Currency'             |
			| ''                                      | 'Receipt'     | '*'                    | ''                    | ''                 | '-5 000'                 | ''               | 'Main Company'        | 'Big foot'         | 'Big foot'                 | ''                         | 'TRY'                  |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | ''                 | ''                       | ''               | 'Main Company'        | 'Big foot'         | 'Big foot'                 | ''                         | 'TRY'                  |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Cheque'                 | 'Partner'        | 'Legal name'          | 'Currency'         | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '856,16'              | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'USD'              | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'              | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'              | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Reconciliation statement"'  | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Legal name'             | 'Currency'       | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'TRY'            | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Advance to suppliers"'      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Payment document' | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '856,16'              | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'USD'                 | 'Own cheque 1'     | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'     | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'     | 'Local currency'           | 'No'                       | ''                     |
			И я закрыл все окна клиентского приложения

Сценарий: _090006 motion check when removing a cheque from document Cheque bond transaction
	* Select Cheque bond transaction
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я выбираю текущую строку
	* Delete cheque bond
		И в таблице "ChequeBonds" я перехожу к строке:
		| 'Amount'   | 'Cash account'      | 'Cheque'       | 'Currency' | 'Legal name' | 'New status'         | 'Partner'  |
		| '5 000,00' | 'Bank account, TRY' | 'Own cheque 1' | 'TRY'      | 'Big foot'   | '01. GivenToPartner' | 'Big foot' |
		И в таблице "ChequeBonds" я активизирую поле "Status"
		И в таблице "ChequeBonds" я нажимаю на кнопку 'Delete'
		И я нажимаю на кнопку 'Post'
	* Check movements
		И я нажимаю на кнопку 'Registrations report'
		Тогда открылось окно 'Document registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Cheque bond transaction 1*'            | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| 'Document registrations records'        | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| 'Register  "Cheque bond statuses"'      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | 'Attributes'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | ''            | 'Status'               | 'Cheque'              | 'Author'           | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | '*'           | '01. TakenFromPartner' | 'Partner cheque 1'    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| 'Partner cheque 1'                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | 'Amount'               | 'Company'             | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'          | 'Legal name'               | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'           | '342,47'               | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'USD'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'           | '2 000'                | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'           | '2 000'                | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'Local currency'           | 'No'                   |
		| ''                                      | '*'           | '2 000'                | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'TRY'                      | 'No'                   |
		| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'        | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'           | ''                 | ''                       | ''               | 'Dimensions'          | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                     | 'Advance to supliers' | 'Transaction AP'   | 'Advance from customers' | 'Transaction AR' | 'Company'             | 'Partner'          | 'Legal name'               | 'Basis document'           | 'Currency'             |
		| ''                                      | 'Receipt'     | '*'                    | '-2 000'              | ''                 | ''                       | ''               | 'Main Company'        | 'DFC'              | 'DFC'                      | ''                         | 'TRY'                  |
		| ''                                      | 'Receipt'     | '*'                    | ''                    | ''                 | '2 000'                  | ''               | 'Main Company'        | 'DFC'              | 'DFC'                      | ''                         | 'TRY'                  |
		| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Cheque'                 | 'Partner'        | 'Legal name'          | 'Currency'         | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '342,47'              | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'USD'              | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'TRY'                      | 'No'                       | ''                     |
		| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Legal name'             | 'Currency'       | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'TRY'            | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| 'Register  "Advance from customers"'    | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Receipt document' | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '342,47'              | 'Main Company'     | 'DFC'                    | 'DFC'            | 'USD'                 | 'Partner cheque 1' | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'Local currency'           | 'No'                       | ''                     |
	* Returning the second check bond recording and motion check
		И Я закрываю окно 'Document registrations report'
		И в таблице "ChequeBonds" я нажимаю на кнопку с именем 'ChequeBondsAdd'
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Cheque"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я активизирую поле "New status"
		И в таблице "ChequeBonds" из выпадающего списка "New status" я выбираю точное значение '01. GivenToPartner'
		И я перехожу к следующему реквизиту
		И в таблице "ChequeBonds" я активизирую поле с именем "ChequeBondsPartner"
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита с именем "ChequeBondsPartner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Big foot'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я активизирую поле "Legal name"
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Big foot'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я активизирую поле "Cash account"
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Cash account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Registrations report'
		Тогда открылось окно 'Document registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Cheque bond transaction 1*'            | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Document registrations records'        | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Cheque bond statuses"'      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | 'Attributes'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | 'Status'               | 'Cheque'              | 'Author'           | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | '*'           | '01. TakenFromPartner' | 'Partner cheque 1'    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | '*'           | '01. GivenToPartner'   | 'Own cheque 1'        | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Partner cheque 1'                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | 'Attributes'           |
			| ''                                      | ''            | 'Amount'               | 'Company'             | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'          | 'Legal name'               | 'Currency movement type'   | 'Deferred calculation' |
			| ''                                      | '*'           | '342,47'               | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'USD'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'Reporting currency'       | 'No'                   |
			| ''                                      | '*'           | '2 000'                | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'en descriptions is empty' | 'No'                   |
			| ''                                      | '*'           | '2 000'                | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'Local currency'           | 'No'                   |
			| ''                                      | '*'           | '2 000'                | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'TRY'                      | 'No'                   |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Accounts statement"'        | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | ''                 | ''                       | ''               | 'Dimensions'          | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Advance to supliers' | 'Transaction AP'   | 'Advance from customers' | 'Transaction AR' | 'Company'             | 'Partner'          | 'Legal name'               | 'Basis document'           | 'Currency'             |
			| ''                                      | 'Receipt'     | '*'                    | '-2 000'              | ''                 | ''                       | ''               | 'Main Company'        | 'DFC'              | 'DFC'                      | ''                         | 'TRY'                  |
			| ''                                      | 'Receipt'     | '*'                    | ''                    | ''                 | '2 000'                  | ''               | 'Main Company'        | 'DFC'              | 'DFC'                      | ''                         | 'TRY'                  |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Cheque'                 | 'Partner'        | 'Legal name'          | 'Currency'         | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '342,47'              | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'USD'              | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'TRY'                      | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Reconciliation statement"'  | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Legal name'             | 'Currency'       | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Expense'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'TRY'            | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Advance from customers"'    | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Receipt document' | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '342,47'              | 'Main Company'     | 'DFC'                    | 'DFC'            | 'USD'                 | 'Partner cheque 1' | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Own cheque 1'                          | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | 'Attributes'           |
			| ''                                      | ''            | 'Amount'               | 'Company'             | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'          | 'Legal name'               | 'Currency movement type'   | 'Deferred calculation' |
			| ''                                      | '*'           | '856,16'               | 'Main Company'        | 'Own cheque 1'     | 'Bank account, TRY'      | 'USD'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                 | 'Reporting currency'       | 'No'                   |
			| ''                                      | '*'           | '5 000'                | 'Main Company'        | 'Own cheque 1'     | 'Bank account, TRY'      | 'TRY'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                 | 'en descriptions is empty' | 'No'                   |
			| ''                                      | '*'           | '5 000'                | 'Main Company'        | 'Own cheque 1'     | 'Bank account, TRY'      | 'TRY'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                 | 'Local currency'           | 'No'                   |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Accounts statement"'        | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | ''                 | ''                       | ''               | 'Dimensions'          | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Advance to supliers' | 'Transaction AP'   | 'Advance from customers' | 'Transaction AR' | 'Company'             | 'Partner'          | 'Legal name'               | 'Basis document'           | 'Currency'             |
			| ''                                      | 'Receipt'     | '*'                    | ''                    | ''                 | '-5 000'                 | ''               | 'Main Company'        | 'Big foot'         | 'Big foot'                 | ''                         | 'TRY'                  |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | ''                 | ''                       | ''               | 'Main Company'        | 'Big foot'         | 'Big foot'                 | ''                         | 'TRY'                  |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Cheque'                 | 'Partner'        | 'Legal name'          | 'Currency'         | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '856,16'              | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'USD'              | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'              | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'              | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Reconciliation statement"'  | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Legal name'             | 'Currency'       | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'TRY'            | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Advance to suppliers"'      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Payment document' | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '856,16'              | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'USD'                 | 'Own cheque 1'     | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'     | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'     | 'Local currency'           | 'No'                       | ''                     |
		И я закрыл все окна клиентского приложения








			












	


