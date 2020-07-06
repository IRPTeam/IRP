#language: ru
@tree
@Positive

Функционал: expense and income planning


As a financier
I want to create documents Incoming payment order and Outgoing payment order
For expense and income planning



Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _080001 create Incoming payment order
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
	И в поле "Planning date" я ввожу начало следующего месяца
	* Change the document number
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	* Filling in tabular part
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

Сценарий: _080002 check Incoming payment order movements
	* Check movements
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
			| 'Currency' | 'Recorder'                  | 'Basis document'             | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Amount'    |
			| 'USD'      | 'Incoming payment order 1*' | 'Incoming payment order 1*'  | 'Main Company' | 'Bank account, USD' | 'Incoming'            | 'Lomaniti'  | 'Company Kalipso'   | '1 000,00'  |
		И я закрыл все окна клиентского приложения
	* Clear postings and check that there is no movement on the registers
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
	* Re-posting the document and checking postings on the registers
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
	

Сценарий: _080003 check connection to Incoming payment order of the Registration report
	И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
	* Check the report output for the selected document from the list
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Incoming payment order 1*'             | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | ''                     |
		| 'Document registrations records'        | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | ''                     |
		| 'Register  "Planing cash transactions"' | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | ''                     |
		| ''                                      | 'Period' | 'Resources' | 'Dimensions'   | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | 'Attributes'           |
		| ''                                      | ''       | 'Amount'    | 'Company'      | 'Basis document'            | 'Account'           | 'Currency' | 'Cash flow direction' | 'Partner'  | 'Legal name'      | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'      | '1 000'     | 'Main Company' | 'Incoming payment order 1*' | 'Bank account, USD' | 'USD'      | 'Incoming'            | 'Lomaniti' | 'Company Kalipso' | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'      | '1 000'     | 'Main Company' | 'Incoming payment order 1*' | 'Bank account, USD' | 'USD'      | 'Incoming'            | 'Lomaniti' | 'Company Kalipso' | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'      | '5 649,72'  | 'Main Company' | 'Incoming payment order 1*' | 'Bank account, USD' | 'TRY'      | 'Incoming'            | 'Lomaniti' | 'Company Kalipso' | 'Local currency'           | 'No'                   |
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
	* Check the report output from the selected document
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Incoming payment order 1*'             | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | ''                     |
		| 'Document registrations records'        | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | ''                     |
		| 'Register  "Planing cash transactions"' | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | ''                     |
		| ''                                      | 'Period' | 'Resources' | 'Dimensions'   | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | 'Attributes'           |
		| ''                                      | ''       | 'Amount'    | 'Company'      | 'Basis document'            | 'Account'           | 'Currency' | 'Cash flow direction' | 'Partner'  | 'Legal name'      | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'      | '1 000'     | 'Main Company' | 'Incoming payment order 1*' | 'Bank account, USD' | 'USD'      | 'Incoming'            | 'Lomaniti' | 'Company Kalipso' | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'      | '1 000'     | 'Main Company' | 'Incoming payment order 1*' | 'Bank account, USD' | 'USD'      | 'Incoming'            | 'Lomaniti' | 'Company Kalipso' | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'      | '5 649,72'  | 'Main Company' | 'Incoming payment order 1*' | 'Bank account, USD' | 'TRY'      | 'Incoming'            | 'Lomaniti' | 'Company Kalipso' | 'Local currency'           | 'No'                   |
	И я закрыл все окна клиентского приложения

Сценарий: _080004 check Description in IncomingPaymentOrder
	И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
	Когда проверяю работу Description
	И я закрыл все окна клиентского приложения

Сценарий: _080005 create Bank reciept based on Incoming payment order
	И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
	* Create Bank receipt from Incoming Payment Order
		И я нажимаю на кнопку с именем 'FormDocumentBankReceiptGenarateBankReceipt'
		И в таблице "PaymentList" я активизирую поле "Amount"
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '250,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		* Change the document number to 20
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '20'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '20'
		И я нажимаю на кнопку 'Post and close'
	* Create one more Bank receipt from Incoming Payment Order list form
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
		* Change the document number to 21
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '21'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '21'
		И я нажимаю на кнопку 'Post and close'
	* Check movements by register Planing cash transactions
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'                  | 'Basis document'            | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'  | 'Legal name'      | 'Amount'   |
		| 'USD'      | 'Bank receipt 20*'          | 'Incoming payment order 1*' | 'Main Company' | 'Bank account, USD' | 'Incoming'            | 'Lomaniti' | '*'               | '-250,00'  |
		| 'USD'      | 'Bank receipt 21*'          | 'Incoming payment order 1*' | 'Main Company' | 'Bank account, USD' | 'Incoming'            | 'Lomaniti' | '*'               | '-250,00'  |
	

Сценарий: _080006 create Outgoing payment order
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
	И в поле "Planning date" я ввожу начало следующего месяца
	* Change the document number
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	* Change status
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
	* Filling in tabular part
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

Сценарий: _080007 check Outgoing payment order movements
	* Check movements
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
		| 'Currency'   | 'Recorder'                    | 'Basis document'            | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Amount'    |
		| 'TRY'        | 'Outgoing payment order 1*'   | 'Outgoing payment order 1*' | 'Main Company' | 'Bank account, TRY' | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | '3 000,00'  |
		И я закрыл все окна клиентского приложения
	* Clear postings and check that there is no movement on the registers
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
	* * Re-posting the document and checking postings on the registers
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

	
Сценарий: _080008 check connection to Outgoing payment order of the Registration report
	И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
	* Check the report output for the selected document from the list
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Outgoing payment order 1*'             | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''          | ''                  | ''                         | ''                     |
		| 'Document registrations records'        | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''          | ''                  | ''                         | ''                     |
		| 'Register  "Planing cash transactions"' | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''          | ''                  | ''                         | ''                     |
		| ''                                      | 'Period' | 'Resources' | 'Dimensions'   | ''                          | ''                  | ''         | ''                    | ''          | ''                  | ''                         | 'Attributes'           |
		| ''                                      | ''       | 'Amount'    | 'Company'      | 'Basis document'            | 'Account'           | 'Currency' | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'      | '513,7'     | 'Main Company' | 'Outgoing payment order 1*' | 'Bank account, TRY' | 'USD'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'      | '3 000'     | 'Main Company' | 'Outgoing payment order 1*' | 'Bank account, TRY' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'      | '3 000'     | 'Main Company' | 'Outgoing payment order 1*' | 'Bank account, TRY' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Local currency'           | 'No'                   |
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
	* Check the report output from the selected document
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Outgoing payment order 1*'             | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''          | ''                  | ''                         | ''                     |
		| 'Document registrations records'        | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''          | ''                  | ''                         | ''                     |
		| 'Register  "Planing cash transactions"' | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''          | ''                  | ''                         | ''                     |
		| ''                                      | 'Period' | 'Resources' | 'Dimensions'   | ''                          | ''                  | ''         | ''                    | ''          | ''                  | ''                         | 'Attributes'           |
		| ''                                      | ''       | 'Amount'    | 'Company'      | 'Basis document'            | 'Account'           | 'Currency' | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'      | '513,7'     | 'Main Company' | 'Outgoing payment order 1*' | 'Bank account, TRY' | 'USD'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'      | '3 000'     | 'Main Company' | 'Outgoing payment order 1*' | 'Bank account, TRY' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'      | '3 000'     | 'Main Company' | 'Outgoing payment order 1*' | 'Bank account, TRY' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Local currency'           | 'No'                   |
	И я закрыл все окна клиентского приложения

Сценарий: _080009 check Description in Outgoing payment order
	И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
	Когда проверяю работу Description
	И я закрыл все окна клиентского приложения

Сценарий: _080010 create Bank payment based on Outgoing payment order
	И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
	* Create Bank payment from Outgoing payment order
		И я нажимаю на кнопку с именем 'FormDocumentBankPaymentGenarateBankPayment'
		И в таблице "PaymentList" я активизирую поле "Amount"
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '250,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		* Change the document number to 20
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '20'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '20'
		И я нажимаю на кнопку 'Post and close'
	* Create Bank payment from Outgoing payment order list
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
		* Change the document number to 21
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '21'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '21'
		И я нажимаю на кнопку 'Post and close'
	* Check movements by register Planing cash transactions
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'                 | 'Basis document'            | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Amount'   |
		| 'TRY'      | 'Bank payment 20*'         | 'Outgoing payment order 1*' | 'Main Company' | 'Bank account, TRY' | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | '-250,00'  |
		| 'TRY'      | 'Bank payment 21*'         | 'Outgoing payment order 1*' | 'Main Company' | 'Bank account, TRY' | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | '-250,00'  |
		И я закрыл все окна клиентского приложения

# TODO дописать на создание Cash reciept/Cash payment

# Filters

Сценарий: _080011 filter check by own companies in the document Incoming payment order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
	Когда проверяю фильтр по собственным компаниям
	
Сценарий: _080012 проверка ввода Description в Incoming payment order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
	Когда проверяю ввод Description


Сценарий: _080013 filter check by own companies in the document Outgoing payment order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
	Когда проверяю фильтр по собственным компаниям

Сценарий: _080014 check Description in Outgoing payment order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
	Когда проверяю ввод Description

# EndFilters

Сценарий: _080015 check the display of the header of the collapsible group in Incoming payment order
	И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
	Когда check the display of the header of the collapsible group in planned incoming/outgoing documents
	И в поле с именем "PlaningDate" я ввожу текущую дату
	И     я перехожу к следующему реквизиту
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Cash desk №2   Currency: TRY   Planning date:"
	И Я закрыл все окна клиентского приложения

Сценарий: _080016 check the display of the header of the collapsible group in Outgoing payment order
	И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
	Когда check the display of the header of the collapsible group in planned incoming/outgoing documents
	И в поле с именем "PlaningDate" я ввожу текущую дату
	И     я перехожу к следующему реквизиту
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Cash desk №2   Currency: TRY   Planning date:"
	И Я закрыл все окна клиентского приложения

