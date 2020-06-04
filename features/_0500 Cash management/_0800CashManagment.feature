#language: ru
@tree
@Positive

Функционал: планирование расходов и поступления ДС

Как Разработчик
Я хочу создать документы заявка на расходование ДС и заявка на поступление ДС
Для планирования расхода и поступления ДС

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _080001 создание заявки на планирования прихода ДС IncomingPaymentOrder
	И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Account"
	И в таблице "List" я перехожу к строке:
		| Description         |
		| Bank account, USD |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Currency"
	И в таблице "List" я перехожу к строке:
		| Code | Description     |
		| USD  | American dollar |
	И в таблице "List" я выбираю текущую строку
	И в поле "Planing date" я ввожу начало следующего месяца
	И я меняю номер документа
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	И я заполняю табличную часть
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Lomaniti    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payer"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я перехожу к строке:
			| Description     |
			| Company Kalipso |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле "Amount"
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '1 000,00'
		И в таблице "PaymentList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'
	Тогда таблица "List" содержит строки:
		| Number | Company       | Account           | Currency |
		| 1      |  Main Company |  Bank account, USD | USD      |
	И я закрыл все окна клиентского приложения

Сценарий: _080002 проверка движений документа IncomingPaymentOrder
	* Проверка движений
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
			| 'Currency' | 'Recorder'                  | 'Basis document'             | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Amount'    |
			| 'USD'      | 'Incoming payment order 1*' | 'Incoming payment order 1*'  | 'Main Company' | 'Bank account, USD' | 'Incoming'            | 'Lomaniti'  | 'Company Kalipso'   | '1 000,00'  |
		И я закрыл все окна клиентского приложения
	* Отмена проведения и проверка отмены движений
		И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" не содержит строки:
			| 'Currency' | 'Recorder'                  | 'Basis document'             | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Amount'    |
			| 'USD'      | 'Incoming payment order 1*' | 'Incoming payment order 1*'  | 'Main Company' | 'Bank account, USD' | 'Incoming'            | 'Lomaniti'  | 'Company Kalipso'   | '1 000,00'  |
		И я закрыл все окна клиентского приложения
	* Повторное проведение и проверка движений
		И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" не содержит строки:
			| 'Currency' | 'Recorder'                  | 'Basis document'             | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Amount'    |
			| 'USD'      | 'Incoming payment order 1*' | 'Incoming payment order 1*'  | 'Main Company' | 'Bank account, USD' | 'Incoming'            | 'Lomaniti'  | 'Company Kalipso'   | '1 000,00'  |
		И я закрыл все окна клиентского приложения
	

Сценарий: _080003 проверка подключения к документу IncomingPaymentOrder Отчета по движениям
	И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
	И я проверяю вывод отчета по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Incoming payment order 1*'             | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | ''                     |
		| 'Document registrations records'        | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | ''                     |
		| 'Register  "Planing cash transactions"' | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | ''                     |
		| ''                                      | 'Period' | 'Resources' | 'Dimensions'   | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | 'Attributes'           |
		| ''                                      | ''       | 'Amount'    | 'Company'      | 'Basis document'            | 'Account'           | 'Currency' | 'Cash flow direction' | 'Partner'  | 'Legal name'      | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'      | '1 000'     | 'Main Company' | 'Incoming payment order 1*' | 'Bank account, USD' | 'USD'      | 'Incoming'            | 'Lomaniti' | 'Company Kalipso' | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'      | '1 000'     | 'Main Company' | 'Incoming payment order 1*' | 'Bank account, USD' | 'USD'      | 'Incoming'            | 'Lomaniti' | 'Company Kalipso' | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'      | '5 649,72'  | 'Main Company' | 'Incoming payment order 1*' | 'Bank account, USD' | 'TRY'      | 'Incoming'            | 'Lomaniti' | 'Company Kalipso' | 'Local currency'           | 'No'                   |
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
	И я проверяю вывод отчета по выбранному документу
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Incoming payment order 1*'             | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | ''                     |
		| 'Document registrations records'        | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | ''                     |
		| 'Register  "Planing cash transactions"' | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | ''                     |
		| ''                                      | 'Period' | 'Resources' | 'Dimensions'   | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | 'Attributes'           |
		| ''                                      | ''       | 'Amount'    | 'Company'      | 'Basis document'            | 'Account'           | 'Currency' | 'Cash flow direction' | 'Partner'  | 'Legal name'      | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'      | '1 000'     | 'Main Company' | 'Incoming payment order 1*' | 'Bank account, USD' | 'USD'      | 'Incoming'            | 'Lomaniti' | 'Company Kalipso' | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'      | '1 000'     | 'Main Company' | 'Incoming payment order 1*' | 'Bank account, USD' | 'USD'      | 'Incoming'            | 'Lomaniti' | 'Company Kalipso' | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'      | '5 649,72'  | 'Main Company' | 'Incoming payment order 1*' | 'Bank account, USD' | 'TRY'      | 'Incoming'            | 'Lomaniti' | 'Company Kalipso' | 'Local currency'           | 'No'                   |
	И я закрыл все окна клиентского приложения

Сценарий: _080004 проверка Description в документе IncomingPaymentOrder
	И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
	Когда проверяю работу Description
	И я закрыл все окна клиентского приложения

Сценарий: _080005 создание Bank reciept на основании IncomingPaymentOrder
	И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
	# И в таблице "List" я выбираю текущую строку
	И я создаю поступление безнала из документа Incoming Payment Order
		И я нажимаю на кнопку с именем 'FormDocumentBankReceiptGenarateBankReceipt'
		И в таблице "PaymentList" я активизирую поле "Amount"
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '250,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И я меняю номер документа на 20
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '20'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '20'
		И я нажимаю на кнопку 'Post and close'
	И я создаю второе поступление безнала из списка документов Incoming Payment Order
		И я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И я нажимаю на кнопку с именем 'FormDocumentBankReceiptGenarateBankReceipt'
		И в таблице "PaymentList" я активизирую поле "Amount"
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '250,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И я меняю номер документа на 21
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '21'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '21'
		И я нажимаю на кнопку 'Post and close'
	И я проверяю движения документов по регистру PlaningCashTransactions
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'                  | 'Basis document'            | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'  | 'Legal name'      | 'Amount'   |
		| 'USD'      | 'Bank receipt 20*'          | 'Incoming payment order 1*' | 'Main Company' | 'Bank account, USD' | 'Incoming'            | 'Lomaniti' | '*'               | '-250,00'  |
		| 'USD'      | 'Bank receipt 21*'          | 'Incoming payment order 1*' | 'Main Company' | 'Bank account, USD' | 'Incoming'            | 'Lomaniti' | '*'               | '-250,00'  |
	

Сценарий: _080006 создание заявки на планирования расхода ДС OutgoingPaymentOrder
	И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Account"
	И в таблице "List" я перехожу к строке:
		| Description         |
		| Bank account, TRY |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Currency"
	И в таблице "List" я перехожу к строке:
		| Code |
		| TRY  |
	И в таблице "List" я выбираю текущую строку
	И в поле "Planing date" я ввожу начало следующего месяца
	И я меняю номер документа
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	И я меняю статус документа 
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
	И я заполняю табличную часть
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ferron BP    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payee"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Company Ferron BP |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле "Amount"
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '3 000,00'
		И в таблице "PaymentList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'
	Тогда таблица "List" содержит строки:
		| Number | Company       | Account           | Currency |
		| 1      |  Main Company |  Bank account, TRY | TRY      |
	И я закрыл все окна клиентского приложения

Сценарий: _080007 проверка движений документа OutgoingPaymentOrder
	* Проверка движений
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
		| 'Currency'   | 'Recorder'                    | 'Basis document'            | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Amount'    |
		| 'TRY'        | 'Outgoing payment order 1*'   | 'Outgoing payment order 1*' | 'Main Company' | 'Bank account, TRY' | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | '3 000,00'  |
		И я закрыл все окна клиентского приложения
	* Отмена проведения и проверка отмены движений
		И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" не содержит строки:
			| 'Currency'   | 'Recorder'                    | 'Basis document'            | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Amount'    |
			| 'TRY'        | 'Outgoing payment order 1*'   | 'Outgoing payment order 1*' | 'Main Company' | 'Bank account, TRY' | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | '3 000,00'  |
		И я закрыл все окна клиентского приложения
	* Повторное проведение и проверка движений
		И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" не содержит строки:
			| 'Currency'   | 'Recorder'                    | 'Basis document'            | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Amount'    |
			| 'TRY'        | 'Outgoing payment order 1*'   | 'Outgoing payment order 1*' | 'Main Company' | 'Bank account, TRY' | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | '3 000,00'  |
		И я закрыл все окна клиентского приложения

	
Сценарий: _080008 проверка подключения к документу OutgoingPaymentOrder Отчета по движениям
	И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
	И я проверяю вывод отчета по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Outgoing payment order 1*'             | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''          | ''                  | ''                         | ''                     |
		| 'Document registrations records'        | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''          | ''                  | ''                         | ''                     |
		| 'Register  "Planing cash transactions"' | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''          | ''                  | ''                         | ''                     |
		| ''                                      | 'Period' | 'Resources' | 'Dimensions'   | ''                          | ''                  | ''         | ''                    | ''          | ''                  | ''                         | 'Attributes'           |
		| ''                                      | ''       | 'Amount'    | 'Company'      | 'Basis document'            | 'Account'           | 'Currency' | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'      | '513,7'     | 'Main Company' | 'Outgoing payment order 1*' | 'Bank account, TRY' | 'USD'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'      | '3 000'     | 'Main Company' | 'Outgoing payment order 1*' | 'Bank account, TRY' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'      | '3 000'     | 'Main Company' | 'Outgoing payment order 1*' | 'Bank account, TRY' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Local currency'           | 'No'                   |
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
	И я проверяю вывод отчета по выбранному документу
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Outgoing payment order 1*'             | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''          | ''                  | ''                         | ''                     |
		| 'Document registrations records'        | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''          | ''                  | ''                         | ''                     |
		| 'Register  "Planing cash transactions"' | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''          | ''                  | ''                         | ''                     |
		| ''                                      | 'Period' | 'Resources' | 'Dimensions'   | ''                          | ''                  | ''         | ''                    | ''          | ''                  | ''                         | 'Attributes'           |
		| ''                                      | ''       | 'Amount'    | 'Company'      | 'Basis document'            | 'Account'           | 'Currency' | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'      | '513,7'     | 'Main Company' | 'Outgoing payment order 1*' | 'Bank account, TRY' | 'USD'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'      | '3 000'     | 'Main Company' | 'Outgoing payment order 1*' | 'Bank account, TRY' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'      | '3 000'     | 'Main Company' | 'Outgoing payment order 1*' | 'Bank account, TRY' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Local currency'           | 'No'                   |
	И я закрыл все окна клиентского приложения

Сценарий: _080009 проверка Description в документе OutgoingPaymentOrder
	И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
	Когда проверяю работу Description
	И я закрыл все окна клиентского приложения

Сценарий: _080010 создание Bank payment на основании OutgoingPaymentOrder
	И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
	# И в таблице "List" я выбираю текущую строку
	И я создаю поступление безнала
		И я нажимаю на кнопку с именем 'FormDocumentBankPaymentGenarateBankPayment'
		И в таблице "PaymentList" я активизирую поле "Amount"
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '250,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И я меняю номер документа на 20
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '20'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '20'
		И я нажимаю на кнопку 'Post and close'
	И я создаю поступление безнала из списка документов Outgoing Payment Order
		И я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И я нажимаю на кнопку с именем 'FormDocumentBankPaymentGenarateBankPayment'
		И в таблице "PaymentList" я активизирую поле "Amount"
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '250,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И я меняю номер документа на 21
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '21'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '21'
		И я нажимаю на кнопку 'Post and close'
	И я проверяю движения документов по регистру PlaningCashTransactions
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'                 | 'Basis document'            | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Amount'   |
		| 'TRY'      | 'Bank payment 20*'         | 'Outgoing payment order 1*' | 'Main Company' | 'Bank account, TRY' | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | '-250,00'  |
		| 'TRY'      | 'Bank payment 21*'         | 'Outgoing payment order 1*' | 'Main Company' | 'Bank account, TRY' | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | '-250,00'  |
		И я закрыл все окна клиентского приложения

# TODO дописать на создание Cash reciept/Cash payment

# Filters

Сценарий: _080011 проверка фильтра по собственным компаниям в Incoming payment order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
	Когда проверяю фильтр по собственным компаниям
	
Сценарий: _080012 проверка ввода Description в Incoming payment order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
	Когда проверяю ввод Description


Сценарий: _080013 проверка фильтра по собственным компаниям в Outgoing payment order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
	Когда проверяю фильтр по собственным компаниям

Сценарий: _080014 проверка ввода Description в Outgoing payment order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
	Когда проверяю ввод Description

# EndFilters

Сценарий: _080015 проверяю отображения заголовка сворачиваемой группы в IncomingPaymentOrder
	И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
	Когда проверяю отображения заголовка сворачиваемой группы в плановых документах поступления/расхода ДС
	И в поле с именем "PlaningDate" я ввожу текущую дату
	И     я перехожу к следующему реквизиту
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Cash desk №2   Currency: TRY   Planing date:"
	И Я закрыл все окна клиентского приложения

Сценарий: _080016 проверяю отображения заголовка сворачиваемой группы в OutgoingPaymentOrder
	И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
	Когда проверяю отображения заголовка сворачиваемой группы в плановых документах поступления/расхода ДС
	И в поле с именем "PlaningDate" я ввожу текущую дату
	И     я перехожу к следующему реквизиту
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Cash desk №2   Currency: TRY   Planing date:"
	И Я закрыл все окна клиентского приложения

