#language: ru
@tree
@Positive
Функционал: write off expenses and record income directly to/from the account

As an accountant
I want to create Cash revenue and Cash expence documents
For write off expenses and record income directly to/from the account

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

# Cash revenue

Сценарий: check tax calculation in the document Cash revenue
	* Opening a document form
		И я открываю навигационную ссылку "e1cib/list/Document.CashRevenue"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in company and account
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Filling in the tabular part by cost
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListBusinessUnit"
		И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'Accountants office' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListRevenueType"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListRevenueType"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Fuel'        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListNetAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListNetAmount' я ввожу текст '100,00'
		И в таблице "PaymentList" я завершаю редактирование строки
	* Tax calculation check
		И     таблица "PaymentList" содержит строки:
			| 'Net amount' | 'Business unit'      | 'Revenue type' | 'Total amount' | 'Currency' | 'VAT' | 'Tax amount' |
			| '100,00'     | 'Accountants office' | 'Fuel'         | '118,00'       | 'TRY'      | '18%' | '18,00'      |
		И     таблица "TaxTree" содержит строки:
			| 'Tax' | 'Tax rate' | 'Currency' | 'Business unit'      | 'Amount' | 'Revenue type' | 'Manual amount' |
			| 'VAT' | ''         | 'TRY'      | ''                   | '18,00'  | ''             | '18,00'         |
			| 'VAT' | '18%'      | 'TRY'      | 'Accountants office' | '18,00'  | 'Fuel'         | '18,00'         |
		И я закрыл все окна клиентского приложения

Сценарий: check movements of the document Cash revenue
	* Opening a document form
		И я открываю навигационную ссылку "e1cib/list/Document.CashRevenue"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in company and account
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Filling in the tabular part by cost
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListBusinessUnit"
		И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'Accountants office' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListRevenueType"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListRevenueType"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Fuel'        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListNetAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListNetAmount' я ввожу текст '100,00'
		И в таблице "PaymentList" я завершаю редактирование строки
	* Change the document number
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
		И я нажимаю на кнопку 'Post'
	* Check movements
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Cash revenue 1*'                | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| 'Document registrations records' | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'    | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''              | ''                   | 'Dimensions'        | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | 'Attributes'           |
		| ''                               | ''            | 'Amount'    | 'Manual amount' | 'Net amount'         | 'Document'          | 'Tax'      | 'Analytics'                | 'Tax rate'             | 'Include to total amount'  | 'Row key'              | 'Currency' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                               | '*'           | '3,08'      | '3,08'          | '17,12'              | 'Cash revenue 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'USD'      | 'Reporting currency'       | 'No'                   |
		| ''                               | '*'           | '18'        | '18'            | '100'                | 'Cash revenue 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'TRY'      | 'en descriptions is empty' | 'No'                   |
		| ''                               | '*'           | '18'        | '18'            | '100'                | 'Cash revenue 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'TRY'      | 'Local currency'           | 'No'                   |
		| ''                               | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| 'Register  "Revenues turnovers"' | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Period'      | 'Resources' | 'Dimensions'    | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | 'Attributes'           | ''         | ''                         | ''                     |
		| ''                               | ''            | 'Amount'    | 'Company'       | 'Business unit'      | 'Revenue type'      | 'Item key' | 'Currency'                 | 'Additional analytic'  | 'Currency movement type'   | 'Deferred calculation' | ''         | ''                         | ''                     |
		| ''                               | '*'           | '17,12'     | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'USD'                      | ''                     | 'Reporting currency'       | 'No'                   | ''         | ''                         | ''                     |
		| ''                               | '*'           | '100'       | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'TRY'                      | ''                     | 'en descriptions is empty' | 'No'                   | ''         | ''                         | ''                     |
		| ''                               | '*'           | '100'       | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'TRY'                      | ''                     | 'Local currency'           | 'No'                   | ''         | ''                         | ''                     |
		| ''                               | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| 'Register  "Account balance"'    | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'         | ''                  | ''         | ''                         | 'Attributes'           | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Amount'        | 'Company'            | 'Account'           | 'Currency' | 'Currency movement type'   | 'Deferred calculation' | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '20,21'         | 'Main Company'       | 'Bank account, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '118'           | 'Main Company'       | 'Bank account, TRY' | 'TRY'      | 'en descriptions is empty' | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '118'           | 'Main Company'       | 'Bank account, TRY' | 'TRY'      | 'Local currency'           | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
		И я закрыл все окна клиентского приложения
	* Clear postings and check that there is no movement on the registers
		* Clear postings Cash revenue 1
			И я открываю навигационную ссылку "e1cib/list/Document.CashRevenue"
			И в таблице "List" я перехожу к строке:
				| 'Account'           | 'Company'      | 'Number' |
				| 'Bank account, TRY' | 'Main Company' | '1'      |
			И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		* Сheck that there is no movement on the registers
			И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.TaxesTurnovers"
			Тогда таблица "List" не содержит строки:
			| 'Recorder'        |
			| 'Cash revenue 1*' |
			И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.RevenuesTurnovers"
			Тогда таблица "List" не содержит строки:
			| 'Recorder'        |
			| 'Cash revenue 1*' |
			И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.AccountBalance"
			Тогда таблица "List" не содержит строки:
			| 'Recorder'        |
			| 'Cash revenue 1*' |
			И я закрыл все окна клиентского приложения
	* Re-posting the document and checking postings on the registers
		* Post document
			И я открываю навигационную ссылку "e1cib/list/Document.CashRevenue"
			И в таблице "List" я перехожу к строке:
				| 'Account'           | 'Company'      | 'Number' |
				| 'Bank account, TRY' | 'Main Company' | '1'      |
			И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		* Check movements
			И я нажимаю на кнопку 'Registrations report'
			Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Cash revenue 1*'                | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| 'Document registrations records' | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| 'Register  "Taxes turnovers"'    | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Period'      | 'Resources' | ''              | ''                   | 'Dimensions'        | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | 'Attributes'           |
			| ''                               | ''            | 'Amount'    | 'Manual amount' | 'Net amount'         | 'Document'          | 'Tax'      | 'Analytics'                | 'Tax rate'             | 'Include to total amount'  | 'Row key'              | 'Currency' | 'Currency movement type'   | 'Deferred calculation' |
			| ''                               | '*'           | '3,08'      | '3,08'          | '17,12'              | 'Cash revenue 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'USD'      | 'Reporting currency'       | 'No'                   |
			| ''                               | '*'           | '18'        | '18'            | '100'                | 'Cash revenue 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'TRY'      | 'en descriptions is empty' | 'No'                   |
			| ''                               | '*'           | '18'        | '18'            | '100'                | 'Cash revenue 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'TRY'      | 'Local currency'           | 'No'                   |
			| ''                               | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| 'Register  "Revenues turnovers"' | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Period'      | 'Resources' | 'Dimensions'    | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | 'Attributes'           | ''         | ''                         | ''                     |
			| ''                               | ''            | 'Amount'    | 'Company'       | 'Business unit'      | 'Revenue type'      | 'Item key' | 'Currency'                 | 'Additional analytic'  | 'Currency movement type'   | 'Deferred calculation' | ''         | ''                         | ''                     |
			| ''                               | '*'           | '17,12'     | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'USD'                      | ''                     | 'Reporting currency'       | 'No'                   | ''         | ''                         | ''                     |
			| ''                               | '*'           | '100'       | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'TRY'                      | ''                     | 'en descriptions is empty' | 'No'                   | ''         | ''                         | ''                     |
			| ''                               | '*'           | '100'       | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'TRY'                      | ''                     | 'Local currency'           | 'No'                   | ''         | ''                         | ''                     |
			| ''                               | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| 'Register  "Account balance"'    | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'         | ''                  | ''         | ''                         | 'Attributes'           | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | ''            | ''          | 'Amount'        | 'Company'            | 'Account'           | 'Currency' | 'Currency movement type'   | 'Deferred calculation' | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Receipt'     | '*'         | '20,21'         | 'Main Company'       | 'Bank account, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Receipt'     | '*'         | '118'           | 'Main Company'       | 'Bank account, TRY' | 'TRY'      | 'en descriptions is empty' | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Receipt'     | '*'         | '118'           | 'Main Company'       | 'Bank account, TRY' | 'TRY'      | 'Local currency'           | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
			И я закрыл все окна клиентского приложения





Сценарий: check the unavailability of currency selection in Cash revenue when it is strongly fixed in the Account
	* Opening a document form
		И я открываю навигационную ссылку "e1cib/list/Document.CashRevenue"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Check the Currency field unavailability
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListCurrency"'|

Сценарий: check the availability of currency selection in Cash revenue (not fixed in the Account)
	* Opening a document form
		И я открываю навигационную ссылку "e1cib/list/Document.CashRevenue"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Cash desk №1' |
		И в таблице "List" я выбираю текущую строку
	* Check the Currency field availability
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" поле "Currency" доступно


# Cash expence

Сценарий: check tax calculation in the document Cash expense
	* Opening a document form
		И я открываю навигационную ссылку "e1cib/list/Document.CashExpense"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in company and account
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Filling in the tabular part by cost
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListBusinessUnit"
		И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'Accountants office' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListExpenseType"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListExpenseType"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Fuel'        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListNetAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListNetAmount' я ввожу текст '100,00'
		И в таблице "PaymentList" я завершаю редактирование строки
	* Tax calculation check
		И     таблица "PaymentList" содержит строки:
			| 'Net amount' | 'Business unit'      | 'Expense type' | 'Total amount' | 'Currency' | 'VAT' | 'Tax amount' |
			| '100,00'     | 'Accountants office' | 'Fuel'         | '118,00'       | 'TRY'      | '18%' | '18,00'      |
		И     таблица "TaxTree" содержит строки:
			| 'Tax' | 'Tax rate' | 'Currency' | 'Business unit'      | 'Amount' | 'Expense type' | 'Manual amount' |
			| 'VAT' | ''         | 'TRY'      | ''                   | '18,00'  | ''             | '18,00'         |
			| 'VAT' | '18%'      | 'TRY'      | 'Accountants office' | '18,00'  | 'Fuel'         | '18,00'         |
		И я закрыл все окна клиентского приложения

Сценарий: check movements of the document Cash expense
	* Opening a document form
		И я открываю навигационную ссылку "e1cib/list/Document.CashExpense"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in company and account
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Filling in the tabular part by cost
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListBusinessUnit"
		И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'Accountants office' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListExpenseType"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListExpenseType"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Fuel'        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListNetAmount"
		И в таблице "PaymentList" в поле с именем 'PaymentListNetAmount' я ввожу текст '100,00'
		И в таблице "PaymentList" я завершаю редактирование строки
	* Change the document number
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
		И я нажимаю на кнопку 'Post'
	* Check movements документа
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Cash expense 1*'                | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| 'Document registrations records' | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| 'Register  "Expenses turnovers"' | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Period'      | 'Resources' | 'Dimensions'    | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | 'Attributes'           | ''         | ''                         | ''                     |
		| ''                               | ''            | 'Amount'    | 'Company'       | 'Business unit'      | 'Expense type'      | 'Item key' | 'Currency'                 | 'Additional analytic'  | 'Currency movement type'   | 'Deferred calculation' | ''         | ''                         | ''                     |
		| ''                               | '*'           | '17,12'     | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'USD'                      | ''                     | 'Reporting currency'       | 'No'                   | ''         | ''                         | ''                     |
		| ''                               | '*'           | '100'       | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'TRY'                      | ''                     | 'en descriptions is empty' | 'No'                   | ''         | ''                         | ''                     |
		| ''                               | '*'           | '100'       | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'TRY'                      | ''                     | 'Local currency'           | 'No'                   | ''         | ''                         | ''                     |
		| ''                               | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'    | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''              | ''                   | 'Dimensions'        | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | 'Attributes'           |
		| ''                               | ''            | 'Amount'    | 'Manual amount' | 'Net amount'         | 'Document'          | 'Tax'      | 'Analytics'                | 'Tax rate'             | 'Include to total amount'  | 'Row key'              | 'Currency' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                               | '*'           | '3,08'      | '3,08'          | '17,12'              | 'Cash expense 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'USD'      | 'Reporting currency'       | 'No'                   |
		| ''                               | '*'           | '18'        | '18'            | '100'                | 'Cash expense 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'TRY'      | 'en descriptions is empty' | 'No'                   |
		| ''                               | '*'           | '18'        | '18'            | '100'                | 'Cash expense 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'TRY'      | 'Local currency'           | 'No'                   |
		| ''                               | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| 'Register  "Account balance"'    | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'         | ''                  | ''         | ''                         | 'Attributes'           | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Amount'        | 'Company'            | 'Account'           | 'Currency' | 'Currency movement type'   | 'Deferred calculation' | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Expense'     | '*'         | '20,21'         | 'Main Company'       | 'Bank account, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Expense'     | '*'         | '118'           | 'Main Company'       | 'Bank account, TRY' | 'TRY'      | 'en descriptions is empty' | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Expense'     | '*'         | '118'           | 'Main Company'       | 'Bank account, TRY' | 'TRY'      | 'Local currency'           | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
		И я закрыл все окна клиентского приложения
	* Clear postings and check that there is no movement on the registers
		* Clear postings документа Cash expense 1
			И я открываю навигационную ссылку "e1cib/list/Document.CashExpense"
			И в таблице "List" я перехожу к строке:
				| 'Account'           | 'Company'      | 'Number' |
				| 'Bank account, TRY' | 'Main Company' | '1'      |
			И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		* Сheck that there is no movement on the registers
			И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.TaxesTurnovers"
			Тогда таблица "List" не содержит строки:
				| 'Recorder'        |
				| 'Cash expense 1*' |
			И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.RevenuesTurnovers"
			Тогда таблица "List" не содержит строки:
				| 'Recorder'        |
				| 'Cash expense 1*' |
			И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.AccountBalance"
			Тогда таблица "List" не содержит строки:
				| 'Recorder'        |
				| 'Cash expense 1*' |
			И я закрыл все окна клиентского приложения
	* Posting the documentобратно и проверка проводок
		* Post document
			И я открываю навигационную ссылку "e1cib/list/Document.CashExpense"
			И в таблице "List" я перехожу к строке:
				| 'Account'           | 'Company'      | 'Number' |
				| 'Bank account, TRY' | 'Main Company' | '1'      |
			И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		* Check movements
			И я нажимаю на кнопку 'Registrations report'
			Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Cash expense 1*'                | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| 'Document registrations records' | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| 'Register  "Expenses turnovers"' | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Period'      | 'Resources' | 'Dimensions'    | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | 'Attributes'           | ''         | ''                         | ''                     |
			| ''                               | ''            | 'Amount'    | 'Company'       | 'Business unit'      | 'Expense type'      | 'Item key' | 'Currency'                 | 'Additional analytic'  | 'Currency movement type'   | 'Deferred calculation' | ''         | ''                         | ''                     |
			| ''                               | '*'           | '17,12'     | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'USD'                      | ''                     | 'Reporting currency'       | 'No'                   | ''         | ''                         | ''                     |
			| ''                               | '*'           | '100'       | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'TRY'                      | ''                     | 'en descriptions is empty' | 'No'                   | ''         | ''                         | ''                     |
			| ''                               | '*'           | '100'       | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'TRY'                      | ''                     | 'Local currency'           | 'No'                   | ''         | ''                         | ''                     |
			| ''                               | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| 'Register  "Taxes turnovers"'    | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Period'      | 'Resources' | ''              | ''                   | 'Dimensions'        | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | 'Attributes'           |
			| ''                               | ''            | 'Amount'    | 'Manual amount' | 'Net amount'         | 'Document'          | 'Tax'      | 'Analytics'                | 'Tax rate'             | 'Include to total amount'  | 'Row key'              | 'Currency' | 'Currency movement type'   | 'Deferred calculation' |
			| ''                               | '*'           | '3,08'      | '3,08'          | '17,12'              | 'Cash expense 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'USD'      | 'Reporting currency'       | 'No'                   |
			| ''                               | '*'           | '18'        | '18'            | '100'                | 'Cash expense 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'TRY'      | 'en descriptions is empty' | 'No'                   |
			| ''                               | '*'           | '18'        | '18'            | '100'                | 'Cash expense 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'TRY'      | 'Local currency'           | 'No'                   |
			| ''                               | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| 'Register  "Account balance"'    | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'         | ''                  | ''         | ''                         | 'Attributes'           | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | ''            | ''          | 'Amount'        | 'Company'            | 'Account'           | 'Currency' | 'Currency movement type'   | 'Deferred calculation' | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Expense'     | '*'         | '20,21'         | 'Main Company'       | 'Bank account, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Expense'     | '*'         | '118'           | 'Main Company'       | 'Bank account, TRY' | 'TRY'      | 'en descriptions is empty' | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Expense'     | '*'         | '118'           | 'Main Company'       | 'Bank account, TRY' | 'TRY'      | 'Local currency'           | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
			И я закрыл все окна клиентского приложения



Сценарий: check the unavailability of currency selection in Cash expense when it is strongly fixed in the Account
	* Opening a document form
		И я открываю навигационную ссылку "e1cib/list/Document.CashExpense"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Check the Currency field unavailability
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита с именем "PaymentListCurrency"'|


Сценарий: check the availability of currency selection in Cash revenue (not fixed in the Account)
	* Opening a document form
		И я открываю навигационную ссылку "e1cib/list/Document.CashExpense"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Cash desk №1' |
		И в таблице "List" я выбираю текущую строку
	* Check the Currency field availability
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" поле "Currency" доступно
	
