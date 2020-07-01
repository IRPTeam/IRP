#language: ru
@tree
@Positive

Функционал: проверка подключения к документам отчета по движениям

Как тестировщик
Я хочу проверить подключение к документам отчета о движении


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _017002 проверка подключения к документу Purchase Order Отчета по движениям
	И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
	И я проверяю вывод отчета по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '2'      |
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Purchase order 2*'                  | ''            | ''       | ''          | ''             | ''                  | ''          | ''          | ''        | ''              |
		| 'Document registrations records'     | ''            | ''       | ''          | ''             | ''                  | ''          | ''          | ''        | ''              |
		| 'Register  "Goods receipt schedule"' | ''            | ''       | ''          | ''             | ''                  | ''          | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                  | ''          | ''          | ''        | 'Attributes'    |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'             | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                   | 'Receipt'     | '*'      | '100'       | 'Main Company' | 'Purchase order 2*' | 'Store 01'  | 'M/White'   | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '200'       | 'Main Company' | 'Purchase order 2*' | 'Store 01'  | 'L/Green'   | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '300'       | 'Main Company' | 'Purchase order 2*' | 'Store 01'  | '36/Yellow' | '*'       | '*'             |
		| ''                                   | ''            | ''       | ''          | ''             | ''                  | ''          | ''          | ''        | ''              |
		| 'Register  "Order balance"'          | ''            | ''       | ''          | ''             | ''                  | ''          | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                  | ''          | ''          | ''        | ''              |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Store'        | 'Order'             | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '100'       | 'Store 01'     | 'Purchase order 2*' | 'M/White'   | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '200'       | 'Store 01'     | 'Purchase order 2*' | 'L/Green'   | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '300'       | 'Store 01'     | 'Purchase order 2*' | '36/Yellow' | '*'         | ''        | ''              |
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
	И я проверяю вывод отчета по выбранному документу
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '2'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Purchase order 2*'                  | ''            | ''       | ''          | ''             | ''                  | ''          | ''          | ''        | ''              |
		| 'Document registrations records'     | ''            | ''       | ''          | ''             | ''                  | ''          | ''          | ''        | ''              |
		| 'Register  "Goods receipt schedule"' | ''            | ''       | ''          | ''             | ''                  | ''          | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                  | ''          | ''          | ''        | 'Attributes'    |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'             | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                   | 'Receipt'     | '*'      | '100'       | 'Main Company' | 'Purchase order 2*' | 'Store 01'  | 'M/White'   | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '200'       | 'Main Company' | 'Purchase order 2*' | 'Store 01'  | 'L/Green'   | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '300'       | 'Main Company' | 'Purchase order 2*' | 'Store 01'  | '36/Yellow' | '*'       | '*'             |
		| ''                                   | ''            | ''       | ''          | ''             | ''                  | ''          | ''          | ''        | ''              |
		| 'Register  "Order balance"'          | ''            | ''       | ''          | ''             | ''                  | ''          | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                  | ''          | ''          | ''        | ''              |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Store'        | 'Order'             | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '100'       | 'Store 01'     | 'Purchase order 2*' | 'M/White'   | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '200'       | 'Store 01'     | 'Purchase order 2*' | 'L/Green'   | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '300'       | 'Store 01'     | 'Purchase order 2*' | '36/Yellow' | '*'         | ''        | ''              |
	И я закрыл все окна клиентского приложения

Сценарий: _0170020 проверка отмены проводок при распроведении Purchase Order
	* Выбор Purchase order
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '2'      |
	* Распроведение документа и проверка отмены проводок
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		И табличный документ "ResultTable" не содержит значения:
		| Register  "Goods receipt schedule" |
		| Register  "Order balance" |
		И я закрыл все окна клиентского приложения
	* Проведение документа и проверка проводок
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '2'      |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Purchase order 2*'                  | ''            | ''       | ''          | ''             | ''                  | ''          | ''          | ''        | ''              |
		| 'Document registrations records'     | ''            | ''       | ''          | ''             | ''                  | ''          | ''          | ''        | ''              |
		| 'Register  "Goods receipt schedule"' | ''            | ''       | ''          | ''             | ''                  | ''          | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                  | ''          | ''          | ''        | 'Attributes'    |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'             | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                   | 'Receipt'     | '*'      | '100'       | 'Main Company' | 'Purchase order 2*' | 'Store 01'  | 'M/White'   | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '200'       | 'Main Company' | 'Purchase order 2*' | 'Store 01'  | 'L/Green'   | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '300'       | 'Main Company' | 'Purchase order 2*' | 'Store 01'  | '36/Yellow' | '*'       | '*'             |
		| ''                                   | ''            | ''       | ''          | ''             | ''                  | ''          | ''          | ''        | ''              |
		| 'Register  "Order balance"'          | ''            | ''       | ''          | ''             | ''                  | ''          | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                  | ''          | ''          | ''        | ''              |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Store'        | 'Order'             | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '100'       | 'Store 01'     | 'Purchase order 2*' | 'M/White'   | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '200'       | 'Store 01'     | 'Purchase order 2*' | 'L/Green'   | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '300'       | 'Store 01'     | 'Purchase order 2*' | '36/Yellow' | '*'         | ''        | ''              |
	И я закрыл все окна клиентского приложения



Сценарий: _016502 проверка подключения к документу Internal Supply Request Отчета по движениям
	* Открытие списка документов Internal Supply Request
		И я открываю навигационную ссылку "e1cib/list/Document.InternalSupplyRequest"
	* Проверка вывода отчета о движениях по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Internal supply request 1*'     | ''            | ''       | ''          | ''           | ''                           | ''          | ''        |
		| 'Document registrations records' | ''            | ''       | ''          | ''           | ''                           | ''          | ''        |
		| 'Register  "Order balance"'      | ''            | ''       | ''          | ''           | ''                           | ''          | ''        |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                           | ''          | ''        |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Order'                      | 'Item key'  | 'Row key' |
		| ''                               | 'Receipt'     | '*'      | '10'        | 'Store 01'   | 'Internal supply request 1*' | '36/Yellow' | '*'       |
		| ''                               | 'Receipt'     | '*'      | '20'        | 'Store 01'   | 'Internal supply request 1*' | '38/Black'  | '*'       |
		| ''                               | 'Receipt'     | '*'      | '25'        | 'Store 01'   | 'Internal supply request 1*' | '36/Red'    | '*'       |
		И я закрыл все окна клиентского приложения
	* Проверка вывода отчета о движениях из документа
		И я открываю навигационную ссылку "e1cib/list/Document.InternalSupplyRequest"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Internal supply request 1*'     | ''            | ''       | ''          | ''           | ''                           | ''          | ''        |
		| 'Document registrations records' | ''            | ''       | ''          | ''           | ''                           | ''          | ''        |
		| 'Register  "Order balance"'      | ''            | ''       | ''          | ''           | ''                           | ''          | ''        |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                           | ''          | ''        |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Order'                      | 'Item key'  | 'Row key' |
		| ''                               | 'Receipt'     | '*'      | '10'        | 'Store 01'   | 'Internal supply request 1*' | '36/Yellow' | '*'       |
		| ''                               | 'Receipt'     | '*'      | '20'        | 'Store 01'   | 'Internal supply request 1*' | '38/Black'  | '*'       |
		| ''                               | 'Receipt'     | '*'      | '25'        | 'Store 01'   | 'Internal supply request 1*' | '36/Red'    | '*'       |
		И я закрыл все окна клиентского приложения

Сценарий: _0170021 проверка отмены проводок при распроведении Internal Supply Request
	* Открытие списка документов Internal Supply Request
		И я открываю навигационную ссылку "e1cib/list/Document.InternalSupplyRequest"
	* Проверка вывода отчета о движениях по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
	* Распроведение документа и проверка отмены проводок
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		И табличный документ "ResultTable" не содержит значения:
			| Register  "Order balance" |
		И я закрыл все окна клиентского приложения
	* Проведение документа и проверка проводок
		И я открываю навигационную ссылку "e1cib/list/Document.InternalSupplyRequest"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Internal supply request 1*'     | ''            | ''       | ''          | ''           | ''                           | ''          | ''        |
		| 'Document registrations records' | ''            | ''       | ''          | ''           | ''                           | ''          | ''        |
		| 'Register  "Order balance"'      | ''            | ''       | ''          | ''           | ''                           | ''          | ''        |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                           | ''          | ''        |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Order'                      | 'Item key'  | 'Row key' |
		| ''                               | 'Receipt'     | '*'      | '10'        | 'Store 01'   | 'Internal supply request 1*' | '36/Yellow' | '*'       |
		| ''                               | 'Receipt'     | '*'      | '20'        | 'Store 01'   | 'Internal supply request 1*' | '38/Black'  | '*'       |
		| ''                               | 'Receipt'     | '*'      | '25'        | 'Store 01'   | 'Internal supply request 1*' | '36/Red'    | '*'       |
		И я закрыл все окна клиентского приложения




Сценарий: _018019 проверка подключения к документу Purchase Invoice Отчета по движениям
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
	И я проверяю вывод отчета по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Purchase invoice 1*'                  | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Document registrations records'       | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Inventory balance"'        | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Company'      | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Main Company' | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Main Company' | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Main Company' | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Purchase turnovers"'       | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'          | ''                    | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | 'Quantity'  | 'Amount'        | 'Net amount'   | 'Company'             | 'Purchase invoice'    | 'Currency'          | 'Item key'           | 'Row key'                 | 'Currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '3 424,66'      | '2 902,25'     | 'Main Company'        | 'Purchase invoice 1*' | 'USD'               | 'M/White'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | 'M/White'            | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | 'M/White'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | 'M/White'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '7 191,78'      | '6 094,73'     | 'Main Company'        | 'Purchase invoice 1*' | 'USD'               | 'L/Green'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | 'L/Green'            | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | 'L/Green'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | 'L/Green'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '12 842,47'     | '10 883,45'    | 'Main Company'        | 'Purchase invoice 1*' | 'USD'               | '36/Yellow'          | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | '36/Yellow'          | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | '36/Yellow'          | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | '36/Yellow'          | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'          | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'          | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | 'Attributes'           |
		| ''                                     | ''            | 'Amount'    | 'Manual amount' | 'Net amount'   | 'Document'            | 'Tax'                 | 'Analytics'         | 'Tax rate'           | 'Include to total amount' | 'Row key'                  | 'Currency'             | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                     | '*'           | '522,41'    | '522,41'        | '2 902,25'     | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '1 097,05'  | '1 097,05'      | '6 094,73'     | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '1 959,02'  | '1 959,02'      | '10 883,45'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Accounts statement"'               | ''                    | ''                    | ''                    | ''               | ''                                             | ''                                             | ''                                     | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| ''                                             | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                             | ''                                             | 'Dimensions'                           | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| ''                                             | ''                    | ''                    | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers'                       | 'Transaction AR'                               | 'Company'                              | 'Partner'                              | 'Legal name'                           | 'Basis document'                       | 'Currency'             | ''                         | ''                     |
		| ''                                             | 'Receipt'             | '*'                   | ''                    | '137 000'        | ''                                             | ''                                             | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'                    | 'Purchase invoice 1*'                  | 'TRY'                  | ''                         | ''                     |
		| ''                                             | ''                    | ''                    | ''                    | ''               | ''                                             | ''                                             | ''                                     | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| 'Register  "Stock reservation"'        | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Store 01'     | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Store 01'     | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Store 01'     | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'      | 'Legal name'          | 'Currency'            | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '137 000'       | 'Main Company' | 'Company Ferron BP'   | 'TRY'                 | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Goods receipt schedule"'   | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | 'Attributes'              | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Company'      | 'Order'               | 'Store'               | 'Item key'          | 'Row key'            | 'Delivery date'           | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '100'           | 'Main Company' | 'Purchase order 2*'   | 'Store 01'            | 'M/White'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '200'           | 'Main Company' | 'Purchase order 2*'   | 'Store 01'            | 'L/Green'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '300'           | 'Main Company' | 'Purchase order 2*'   | 'Store 01'            | '36/Yellow'         | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Partner AP transactions"'  | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'      | 'Basis document'      | 'Partner'             | 'Legal name'        | 'Agreement'          | 'Currency'                | 'Currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '23 458,9'      | 'Main Company' | 'Purchase invoice 1*' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'USD'                     | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | 'Purchase invoice 1*' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | 'Purchase invoice 1*' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | 'Purchase invoice 1*' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Order balance"'            | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Order'               | 'Item key'            | 'Row key'           | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '100'           | 'Store 01'     | 'Purchase order 2*'   | 'M/White'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '200'           | 'Store 01'     | 'Purchase order 2*'   | 'L/Green'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '300'           | 'Store 01'     | 'Purchase order 2*'   | '36/Yellow'           | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Stock balance"'            | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Store 01'     | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Store 01'     | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Store 01'     | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
	И я проверяю вывод отчета по выбранному документу
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Purchase invoice 1*'                  | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Document registrations records'       | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Inventory balance"'        | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Company'      | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Main Company' | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Main Company' | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Main Company' | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Purchase turnovers"'       | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'          | ''                    | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | 'Quantity'  | 'Amount'        | 'Net amount'   | 'Company'             | 'Purchase invoice'    | 'Currency'          | 'Item key'           | 'Row key'                 | 'Currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '3 424,66'      | '2 902,25'     | 'Main Company'        | 'Purchase invoice 1*' | 'USD'               | 'M/White'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | 'M/White'            | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | 'M/White'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | 'M/White'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '7 191,78'      | '6 094,73'     | 'Main Company'        | 'Purchase invoice 1*' | 'USD'               | 'L/Green'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | 'L/Green'            | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | 'L/Green'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | 'L/Green'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '12 842,47'     | '10 883,45'    | 'Main Company'        | 'Purchase invoice 1*' | 'USD'               | '36/Yellow'          | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | '36/Yellow'          | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | '36/Yellow'          | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | '36/Yellow'          | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'          | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'          | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | 'Attributes'           |
		| ''                                     | ''            | 'Amount'    | 'Manual amount' | 'Net amount'   | 'Document'            | 'Tax'                 | 'Analytics'         | 'Tax rate'           | 'Include to total amount' | 'Row key'                  | 'Currency'             | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                     | '*'           | '522,41'    | '522,41'        | '2 902,25'     | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '1 097,05'  | '1 097,05'      | '6 094,73'     | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '1 959,02'  | '1 959,02'      | '10 883,45'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Accounts statement"'               | ''                    | ''                    | ''                    | ''               | ''                                             | ''                                             | ''                                     | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| ''                                             | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                             | ''                                             | 'Dimensions'                           | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| ''                                             | ''                    | ''                    | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers'                       | 'Transaction AR'                               | 'Company'                              | 'Partner'                              | 'Legal name'                           | 'Basis document'                       | 'Currency'             | ''                         | ''                     |
		| ''                                             | 'Receipt'             | '*'                   | ''                    | '137 000'        | ''                                             | ''                                             | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'                    | 'Purchase invoice 1*'                  | 'TRY'                  | ''                         | ''                     |
		| ''                                             | ''                    | ''                    | ''                    | ''               | ''                                             | ''                                             | ''                                     | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| 'Register  "Stock reservation"'        | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Store 01'     | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Store 01'     | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Store 01'     | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'      | 'Legal name'          | 'Currency'            | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '137 000'       | 'Main Company' | 'Company Ferron BP'   | 'TRY'                 | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Goods receipt schedule"'   | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | 'Attributes'              | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Company'      | 'Order'               | 'Store'               | 'Item key'          | 'Row key'            | 'Delivery date'           | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '100'           | 'Main Company' | 'Purchase order 2*'   | 'Store 01'            | 'M/White'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '200'           | 'Main Company' | 'Purchase order 2*'   | 'Store 01'            | 'L/Green'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '300'           | 'Main Company' | 'Purchase order 2*'   | 'Store 01'            | '36/Yellow'         | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Partner AP transactions"'  | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'      | 'Basis document'      | 'Partner'             | 'Legal name'        | 'Agreement'          | 'Currency'                | 'Currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '23 458,9'      | 'Main Company' | 'Purchase invoice 1*' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'USD'                     | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | 'Purchase invoice 1*' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | 'Purchase invoice 1*' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | 'Purchase invoice 1*' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Order balance"'            | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Order'               | 'Item key'            | 'Row key'           | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '100'           | 'Store 01'     | 'Purchase order 2*'   | 'M/White'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '200'           | 'Store 01'     | 'Purchase order 2*'   | 'L/Green'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '300'           | 'Store 01'     | 'Purchase order 2*'   | '36/Yellow'           | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Stock balance"'            | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Store 01'     | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Store 01'     | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Store 01'     | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
	И я закрыл все окна клиентского приложения

Сценарий: _01801901 проверка отмены проводок при распроведении Purchase invoice
	* Открытие списка документов Purchase invoice
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
	* Проверка вывода отчета о движениях по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
	* Распроведение документа и проверка отмены проводок
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		И табличный документ "ResultTable" не содержит значения:
			| Register  "Purchase turnovers" |
			| 'Register  "Inventory balance"'        |
			| 'Register  "Taxes turnovers"'          |
			| 'Register  "Stock reservation"'        |
			| 'Register  "Reconciliation statement"' |
		И я закрыл все окна клиентского приложения
	* Проведение документа и проверка проводок
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Purchase invoice 1*'                  | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Document registrations records'       | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Inventory balance"'        | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Company'      | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Main Company' | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Main Company' | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Main Company' | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Purchase turnovers"'       | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'          | ''                    | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | 'Quantity'  | 'Amount'        | 'Net amount'   | 'Company'             | 'Purchase invoice'    | 'Currency'          | 'Item key'           | 'Row key'                 | 'Currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '3 424,66'      | '2 902,25'     | 'Main Company'        | 'Purchase invoice 1*' | 'USD'               | 'M/White'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | 'M/White'            | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | 'M/White'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | 'M/White'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '7 191,78'      | '6 094,73'     | 'Main Company'        | 'Purchase invoice 1*' | 'USD'               | 'L/Green'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | 'L/Green'            | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | 'L/Green'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | 'L/Green'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '12 842,47'     | '10 883,45'    | 'Main Company'        | 'Purchase invoice 1*' | 'USD'               | '36/Yellow'          | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | '36/Yellow'          | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | '36/Yellow'          | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | 'Purchase invoice 1*' | 'TRY'               | '36/Yellow'          | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'          | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'          | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | 'Attributes'           |
		| ''                                     | ''            | 'Amount'    | 'Manual amount' | 'Net amount'   | 'Document'            | 'Tax'                 | 'Analytics'         | 'Tax rate'           | 'Include to total amount' | 'Row key'                  | 'Currency'             | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                     | '*'           | '522,41'    | '522,41'        | '2 902,25'     | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '1 097,05'  | '1 097,05'      | '6 094,73'     | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '1 959,02'  | '1 959,02'      | '10 883,45'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | 'Purchase invoice 1*' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Accounts statement"'               | ''                    | ''                    | ''                    | ''               | ''                                             | ''                                             | ''                                     | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| ''                                             | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                             | ''                                             | 'Dimensions'                           | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| ''                                             | ''                    | ''                    | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers'                       | 'Transaction AR'                               | 'Company'                              | 'Partner'                              | 'Legal name'                           | 'Basis document'                       | 'Currency'             | ''                         | ''                     |
		| ''                                             | 'Receipt'             | '*'                   | ''                    | '137 000'        | ''                                             | ''                                             | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'                    | 'Purchase invoice 1*'                  | 'TRY'                  | ''                         | ''                     |
		| ''                                             | ''                    | ''                    | ''                    | ''               | ''                                             | ''                                             | ''                                     | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| 'Register  "Stock reservation"'        | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Store 01'     | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Store 01'     | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Store 01'     | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'      | 'Legal name'          | 'Currency'            | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '137 000'       | 'Main Company' | 'Company Ferron BP'   | 'TRY'                 | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Goods receipt schedule"'   | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | 'Attributes'              | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Company'      | 'Order'               | 'Store'               | 'Item key'          | 'Row key'            | 'Delivery date'           | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '100'           | 'Main Company' | 'Purchase order 2*'   | 'Store 01'            | 'M/White'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '200'           | 'Main Company' | 'Purchase order 2*'   | 'Store 01'            | 'L/Green'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '300'           | 'Main Company' | 'Purchase order 2*'   | 'Store 01'            | '36/Yellow'         | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Partner AP transactions"'  | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'      | 'Basis document'      | 'Partner'             | 'Legal name'        | 'Agreement'          | 'Currency'                | 'Currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '23 458,9'      | 'Main Company' | 'Purchase invoice 1*' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'USD'                     | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | 'Purchase invoice 1*' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | 'Purchase invoice 1*' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | 'Purchase invoice 1*' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Order balance"'            | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Order'               | 'Item key'            | 'Row key'           | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '100'           | 'Store 01'     | 'Purchase order 2*'   | 'M/White'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '200'           | 'Store 01'     | 'Purchase order 2*'   | 'L/Green'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '300'           | 'Store 01'     | 'Purchase order 2*'   | '36/Yellow'           | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Stock balance"'            | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Store 01'     | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Store 01'     | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Store 01'     | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		И я закрыл все окна клиентского приложения






Сценарий: _022011 проверка подключения к документу PurchaseReturnOrder Отчета по движениям
	И я открываю навигационную ссылку "e1cib/list/Document.PurchaseReturnOrder"
	И я проверяю вывод отчета по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Purchase return order 1*'       | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Document registrations records' | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Purchase turnovers"' | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | 'Dimensions'               | ''                    | ''         | ''         | ''        | ''                         | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Company'                  | 'Purchase invoice'    | 'Currency' | 'Item key' | 'Row key' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                               | '*'           | '-2'        | '-451,98'   | ''           | 'Main Company'             | 'Purchase invoice 2*' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'           | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | ''           | 'Main Company'             | 'Purchase invoice 2*' | 'USD'      | 'L/Green'  | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | ''           | 'Main Company'             | 'Purchase invoice 2*' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | ''           | 'Main Company'             | 'Purchase invoice 2*' | 'USD'      | 'L/Green'  | '*'       | 'USD'                      | 'No'                   |
		| ''                               | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'  | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Item key'                 | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '2'         | 'Store 02'   | 'L/Green'                  | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Item key'                 | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Expense'     | '*'         | '2'         | 'Store 02'   | 'L/Green'                  | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'      | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Order'                    | 'Item key'            | 'Row key'  | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '2'         | 'Store 02'   | 'Purchase return order 1*' | 'L/Green'             | '*'        | ''         | ''        | ''                         | ''                     |
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.PurchaseReturnOrder"
	И я проверяю вывод отчета по выбранному документу
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Purchase return order 1*'       | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Document registrations records' | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Purchase turnovers"' | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | 'Dimensions'               | ''                    | ''         | ''         | ''        | ''                         | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Company'                  | 'Purchase invoice'    | 'Currency' | 'Item key' | 'Row key' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                               | '*'           | '-2'        | '-451,98'   | ''           | 'Main Company'             | 'Purchase invoice 2*' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'           | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | ''           | 'Main Company'             | 'Purchase invoice 2*' | 'USD'      | 'L/Green'  | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | ''           | 'Main Company'             | 'Purchase invoice 2*' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | ''           | 'Main Company'             | 'Purchase invoice 2*' | 'USD'      | 'L/Green'  | '*'       | 'USD'                      | 'No'                   |
		| ''                               | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'  | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Item key'                 | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '2'         | 'Store 02'   | 'L/Green'                  | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Item key'                 | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Expense'     | '*'         | '2'         | 'Store 02'   | 'L/Green'                  | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'      | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Order'                    | 'Item key'            | 'Row key'  | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '2'         | 'Store 02'   | 'Purchase return order 1*' | 'L/Green'             | '*'        | ''         | ''        | ''                         | ''                     |
	И я закрыл все окна клиентского приложения

Сценарий: _02201101 проверка отмены проводок при распроведении Purchase Return Order
	* Открытие списка документов Purchase Return Order
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseReturnOrder"
	* Проверка вывода отчета о движениях по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
	* Распроведение документа и проверка отмены проводок
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		И табличный документ "ResultTable" не содержит значения:
			| 'Register  "Purchase turnovers"' |
			| 'Register  "Order reservation"'  |
			| 'Register  "Stock reservation"'  |
			| 'Register  "Order balance"'      |
		И я закрыл все окна клиентского приложения
	* Проведение документа и проверка проводок
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseReturnOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Purchase return order 1*'       | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Document registrations records' | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Purchase turnovers"' | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | 'Dimensions'               | ''                    | ''         | ''         | ''        | ''                         | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Company'                  | 'Purchase invoice'    | 'Currency' | 'Item key' | 'Row key' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                               | '*'           | '-2'        | '-451,98'   | ''           | 'Main Company'             | 'Purchase invoice 2*' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'           | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | ''           | 'Main Company'             | 'Purchase invoice 2*' | 'USD'      | 'L/Green'  | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | ''           | 'Main Company'             | 'Purchase invoice 2*' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | ''           | 'Main Company'             | 'Purchase invoice 2*' | 'USD'      | 'L/Green'  | '*'       | 'USD'                      | 'No'                   |
		| ''                               | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'  | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Item key'                 | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '2'         | 'Store 02'   | 'L/Green'                  | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Item key'                 | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Expense'     | '*'         | '2'         | 'Store 02'   | 'L/Green'                  | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'      | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Order'                    | 'Item key'            | 'Row key'  | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '2'         | 'Store 02'   | 'Purchase return order 1*' | 'L/Green'             | '*'        | ''         | ''        | ''                         | ''                     |
		И я закрыл все окна клиентского приложения






Сценарий: _022336 проверка подключения к документу Purchase Return Отчета по движениям
	И я открываю навигационную ссылку "e1cib/list/Document.PurchaseReturn"
	И я проверяю вывод отчета по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Purchase return 1*'                    | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Document registrations records'        | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"'   | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | ''          | 'Amount'    | 'Company'      | 'Basis document'           | 'Partner'   | 'Legal name'        | 'Agreement'          | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'USD'                      | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '451,98'    | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Purchase return turnovers"' | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Purchase invoice'         | 'Currency'  | 'Item key'          | 'Row key'            | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | '*'           | '-2'        | '-451,98'   | 'Main Company' | 'Purchase invoice 2*'      | 'TRY'       | 'L/Green'           | '*'                  | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | 'Purchase invoice 2*'      | 'USD'       | 'L/Green'           | '*'                  | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | 'Purchase invoice 2*'      | 'USD'       | 'L/Green'           | '*'                  | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | 'Purchase invoice 2*'      | 'USD'       | 'L/Green'           | '*'                  | 'USD'                      | 'No'                       | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Inventory balance"'         | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Company'      | 'Item key'                 | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Main Company' | 'L/Green'                  | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Goods in transit outgoing"' | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Shipment basis'           | 'Item key'  | 'Row key'           | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '2'         | 'Store 02'     | 'Purchase return 1*'       | 'L/Green'   | '*'                 | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Order reservation"'         | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'                 | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Store 02'     | 'L/Green'                  | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'              | ''                    | ''                    | ''                    | ''               | ''                                                  | ''               | ''                                     | ''                                     | ''                         | ''                         | ''                     |
		| ''                                            | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                                  | ''               | 'Dimensions'                           | ''                                     | ''                         | ''                         | ''                     |
		| ''                                            | ''                    | ''                    | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers'                            | 'Transaction AR' | 'Company'                              | 'Partner'                              | 'Legal name'               | 'Basis document'           | 'Currency'             |
		| ''                                            | 'Receipt'             | '*'                   | ''                    | '-80'            | ''                                                  | ''               | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'        | ''                         | 'USD'                  |
		| ''                                            | ''                    | ''                    | ''                    | ''               | ''                                                  | ''               | ''                                     | ''                                     | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Amount'    | 'Company'      | 'Legal name'               | 'Currency'  | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | 'Company Ferron BP'        | 'USD'       | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Order balance"'             | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'                    | 'Item key'  | 'Row key'           | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Store 02'     | 'Purchase return order 1*' | 'L/Green'   | '*'                 | ''                   | ''                         | ''                         | ''                     |
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.PurchaseReturn"
	И я проверяю вывод отчета по выбранному документу
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Purchase return 1*'                    | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Document registrations records'        | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"'   | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | ''          | 'Amount'    | 'Company'      | 'Basis document'           | 'Partner'   | 'Legal name'        | 'Agreement'          | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'USD'                      | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '451,98'    | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Purchase return turnovers"' | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Purchase invoice'         | 'Currency'  | 'Item key'          | 'Row key'            | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | '*'           | '-2'        | '-451,98'   | 'Main Company' | 'Purchase invoice 2*'      | 'TRY'       | 'L/Green'           | '*'                  | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | 'Purchase invoice 2*'      | 'USD'       | 'L/Green'           | '*'                  | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | 'Purchase invoice 2*'      | 'USD'       | 'L/Green'           | '*'                  | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | 'Purchase invoice 2*'      | 'USD'       | 'L/Green'           | '*'                  | 'USD'                      | 'No'                       | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Inventory balance"'         | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Company'      | 'Item key'                 | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Main Company' | 'L/Green'                  | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Goods in transit outgoing"' | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Shipment basis'           | 'Item key'  | 'Row key'           | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '2'         | 'Store 02'     | 'Purchase return 1*'       | 'L/Green'   | '*'                 | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Order reservation"'         | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'                 | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Store 02'     | 'L/Green'                  | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'              | ''                    | ''                    | ''                    | ''               | ''                                                  | ''               | ''                                     | ''                                     | ''                         | ''                         | ''                     |
		| ''                                            | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                                  | ''               | 'Dimensions'                           | ''                                     | ''                         | ''                         | ''                     |
		| ''                                            | ''                    | ''                    | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers'                            | 'Transaction AR' | 'Company'                              | 'Partner'                              | 'Legal name'               | 'Basis document'           | 'Currency'             |
		| ''                                            | 'Receipt'             | '*'                   | ''                    | '-80'            | ''                                                  | ''               | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'        | ''                         | 'USD'                  |
		| ''                                            | ''                    | ''                    | ''                    | ''               | ''                                                  | ''               | ''                                     | ''                                     | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Amount'    | 'Company'      | 'Legal name'               | 'Currency'  | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | 'Company Ferron BP'        | 'USD'       | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Order balance"'             | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'                    | 'Item key'  | 'Row key'           | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Store 02'     | 'Purchase return order 1*' | 'L/Green'   | '*'                 | ''                   | ''                         | ''                         | ''                     |
	И я закрыл все окна клиентского приложения


Сценарий: _02233601 проверка отмены проводок при распроведении Purchase Return
	* Открытие списка документов Purchase Return Order
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseReturn"
	* Проверка вывода отчета о движениях по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
	* Распроведение документа и проверка отмены проводок
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		И табличный документ "ResultTable" не содержит значения:
			| 'Register  "Partner AR transactions"'   |
			| 'Register  "Inventory balance"'         |
			| 'Register  "Goods in transit outgoing"' |
			| 'Register  "Order reservation"'         |
			| 'Register  "Reconciliation statement"'  |
			| 'Register  "Order balance"'             |
		И я закрыл все окна клиентского приложения
	* Проведение документа и проверка проводок
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseReturn"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Purchase return 1*'                    | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Document registrations records'        | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"'   | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | ''          | 'Amount'    | 'Company'      | 'Basis document'           | 'Partner'   | 'Legal name'        | 'Agreement'          | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'USD'                      | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '451,98'    | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Purchase return turnovers"' | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Purchase invoice'         | 'Currency'  | 'Item key'          | 'Row key'            | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | '*'           | '-2'        | '-451,98'   | 'Main Company' | 'Purchase invoice 2*'      | 'TRY'       | 'L/Green'           | '*'                  | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | 'Purchase invoice 2*'      | 'USD'       | 'L/Green'           | '*'                  | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | 'Purchase invoice 2*'      | 'USD'       | 'L/Green'           | '*'                  | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | 'Purchase invoice 2*'      | 'USD'       | 'L/Green'           | '*'                  | 'USD'                      | 'No'                       | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Inventory balance"'         | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Company'      | 'Item key'                 | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Main Company' | 'L/Green'                  | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Goods in transit outgoing"' | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Shipment basis'           | 'Item key'  | 'Row key'           | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '2'         | 'Store 02'     | 'Purchase return 1*'       | 'L/Green'   | '*'                 | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Order reservation"'         | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'                 | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Store 02'     | 'L/Green'                  | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'              | ''                    | ''                    | ''                    | ''               | ''                                                  | ''               | ''                                     | ''                                     | ''                         | ''                         | ''                     |
		| ''                                            | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                                  | ''               | 'Dimensions'                           | ''                                     | ''                         | ''                         | ''                     |
		| ''                                            | ''                    | ''                    | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers'                            | 'Transaction AR' | 'Company'                              | 'Partner'                              | 'Legal name'               | 'Basis document'           | 'Currency'             |
		| ''                                            | 'Receipt'             | '*'                   | ''                    | '-80'            | ''                                                  | ''               | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'        | ''                         | 'USD'                  |
		| ''                                            | ''                    | ''                    | ''                    | ''               | ''                                                  | ''               | ''                                     | ''                                     | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Amount'    | 'Company'      | 'Legal name'               | 'Currency'  | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | 'Company Ferron BP'        | 'USD'       | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Order balance"'             | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'                    | 'Item key'  | 'Row key'           | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Store 02'     | 'Purchase return order 1*' | 'L/Green'   | '*'                 | ''                   | ''                         | ''                         | ''                     |
		И я закрыл все окна клиентского приложения






Сценарий: _021048 проверка подключения к документу InventoryTransfer Отчета по движениям
	И я открываю навигационную ссылку "e1cib/list/Document.InventoryTransfer"
	И я проверяю вывод отчета по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Inventory transfer 1*'                 | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Transfer order balance"'    | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store sender' | 'Store receiver'        | 'Order'                         | 'Item key' | 'Row key' |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'     | 'Store 02'              | 'Inventory transfer order 201*' | 'S/Yellow' | '*'       |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 01'     | 'Store 02'              | 'Inventory transfer order 201*' | 'M/White'  | '*'       |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'         | 'Item key'                      | 'Row key'  | ''        |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'     | 'Inventory transfer 1*' | 'S/Yellow'                      | '*'        | ''        |
		| ''                                      | 'Receipt'     | '*'      | '50'        | 'Store 02'     | 'Inventory transfer 1*' | 'M/White'                       | '*'        | ''        |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'              | ''                              | ''         | ''        |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'     | 'S/Yellow'              | ''                              | ''         | ''        |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 01'     | 'M/White'               | ''                              | ''         | ''        |
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.InventoryTransfer"
	И я проверяю вывод отчета по выбранному документу
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Inventory transfer 1*'                 | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Transfer order balance"'    | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store sender' | 'Store receiver'        | 'Order'                         | 'Item key' | 'Row key' |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'     | 'Store 02'              | 'Inventory transfer order 201*' | 'S/Yellow' | '*'       |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 01'     | 'Store 02'              | 'Inventory transfer order 201*' | 'M/White'  | '*'       |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'         | 'Item key'                      | 'Row key'  | ''        |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'     | 'Inventory transfer 1*' | 'S/Yellow'                      | '*'        | ''        |
		| ''                                      | 'Receipt'     | '*'      | '50'        | 'Store 02'     | 'Inventory transfer 1*' | 'M/White'                       | '*'        | ''        |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'              | ''                              | ''         | ''        |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'     | 'S/Yellow'              | ''                              | ''         | ''        |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 01'     | 'M/White'               | ''                              | ''         | ''        |
	И я закрыл все окна клиентского приложения



Сценарий: _02104801 проверка отмены проводок при распроведении InventoryTransfer
	* Открытие списка документов InventoryTransfer
		И я открываю навигационную ссылку "e1cib/list/Document.InventoryTransfer"
	* Проверка вывода отчета о движениях по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
	* Распроведение документа и проверка отмены проводок
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		И табличный документ "ResultTable" не содержит значения:
			| 'Register  "Transfer order balance"'    |
			| 'Register  "Goods in transit incoming"' |
			| 'Register  "Stock balance"'             |
		И я закрыл все окна клиентского приложения
	* Проведение документа и проверка проводок
		И я открываю навигационную ссылку "e1cib/list/Document.InventoryTransfer"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Inventory transfer 1*'                 | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Transfer order balance"'    | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store sender' | 'Store receiver'        | 'Order'                         | 'Item key' | 'Row key' |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'     | 'Store 02'              | 'Inventory transfer order 201*' | 'S/Yellow' | '*'       |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 01'     | 'Store 02'              | 'Inventory transfer order 201*' | 'M/White'  | '*'       |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'         | 'Item key'                      | 'Row key'  | ''        |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'     | 'Inventory transfer 1*' | 'S/Yellow'                      | '*'        | ''        |
		| ''                                      | 'Receipt'     | '*'      | '50'        | 'Store 02'     | 'Inventory transfer 1*' | 'M/White'                       | '*'        | ''        |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'              | ''                              | ''         | ''        |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'     | 'S/Yellow'              | ''                              | ''         | ''        |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 01'     | 'M/White'               | ''                              | ''         | ''        |
		И я закрыл все окна клиентского приложения



Сценарий: _024043 проверка подключения к документу Sales Invoice Отчета по движениям
	И я открываю навигационную ссылку "e1cib/list/Document.SalesInvoice"
	И я проверяю вывод отчета по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales invoice 1*'                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"'        | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | 'Attributes'               | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Amount'        | 'Company'       | 'Basis document'    | 'Partner'      | 'Legal name'        | 'Agreement'             | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation'     | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '744,86'        | 'Main Company'  | 'Sales invoice 1*'  | 'Ferron BP'    | 'Company Ferron BP' | 'Basic Agreements, TRY' | 'USD'                      | 'Reporting currency'       | 'No'                       | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'         | 'Main Company'  | 'Sales invoice 1*'  | 'Ferron BP'    | 'Company Ferron BP' | 'Basic Agreements, TRY' | 'TRY'                      | 'en descriptions is empty' | 'No'                       | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'         | 'Main Company'  | 'Sales invoice 1*'  | 'Ferron BP'    | 'Company Ferron BP' | 'Basic Agreements, TRY' | 'TRY'                      | 'Local currency'           | 'No'                       | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'         | 'Main Company'  | 'Sales invoice 1*'  | 'Ferron BP'    | 'Company Ferron BP' | 'Basic Agreements, TRY' | 'TRY'                      | 'TRY'                      | 'No'                       | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Inventory balance"'              | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Company'       | 'Item key'          | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'             | 'Main Company'  | '36/Yellow'         | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Main Company'  | 'L/Green'           | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Store'         | 'Item key'          | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'             | 'Store 01'      | '36/Yellow'         | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Store 01'      | 'L/Green'           | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'                | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''              | ''              | 'Dimensions'        | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Amount'    | 'Manual amount' | 'Net amount'    | 'Document'          | 'Tax'          | 'Analytics'         | 'Tax rate'              | 'Include to total amount'  | 'Row key'                  | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '41,79'     | '41,79'         | '232,18'        | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '71,83'     | '71,83'         | '399,06'        | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'        | '1 355,93'      | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'        | '1 355,93'      | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'        | '1 355,93'      | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'        | '2 330,51'      | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'        | '2 330,51'      | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'        | '2 330,51'      | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'             | ''                    | ''                    | ''                    | ''               | ''                                          | ''               | ''                                          | ''                                     | ''                         | ''                                     | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                          | ''               | 'Dimensions'                                | ''                                     | ''                         | ''                                     | ''                         | ''                         | ''                     |
		| ''                                           | ''                    | ''                    | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers'                    | 'Transaction AR' | 'Company'                                   | 'Partner'                              | 'Legal name'               | 'Basis document'                       | 'Currency'                 | ''                         | ''                     |
		| ''                                           | 'Receipt'             | '*'                   | ''                    | ''               | ''                                          | '4 350'          | 'Main Company'                              | 'Ferron BP'                            | 'Company Ferron BP'        | 'Sales invoice 1*'                     | 'TRY'                      | ''                         | ''                     |
		| ''                                           | ''                    | ''                    | ''                    | ''               | ''                                          | ''               | ''                                          | ''                                     | ''                         | ''                                     | ''                         | ''                         | ''                     |
		| 'Register  "Sales turnovers"'                | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''              | ''              | ''                  | 'Dimensions'   | ''                  | ''                      | ''                         | ''                         | ''                         | 'Attributes'               | ''                     |
		| ''                                           | ''            | 'Quantity'  | 'Amount'        | 'Net amount'    | 'Offers amount'     | 'Company'      | 'Sales invoice'     | 'Currency'              | 'Item key'                 | 'Row key'                  | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                           | '*'           | '4'         | '273,97'        | '232,18'        | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'USD'                   | '36/Yellow'                | '*'                        | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                           | '*'           | '4'         | '1 600'         | '1 355,93'      | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'TRY'                   | '36/Yellow'                | '*'                        | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                           | '*'           | '4'         | '1 600'         | '1 355,93'      | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'TRY'                   | '36/Yellow'                | '*'                        | 'Local currency'           | 'No'                       | ''                     |
		| ''                                           | '*'           | '4'         | '1 600'         | '1 355,93'      | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'TRY'                   | '36/Yellow'                | '*'                        | 'TRY'                      | 'No'                       | ''                     |
		| ''                                           | '*'           | '5'         | '470,89'        | '399,06'        | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'USD'                   | 'L/Green'                  | '*'                        | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                           | '*'           | '5'         | '2 750'         | '2 330,51'      | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'TRY'                   | 'L/Green'                  | '*'                        | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                           | '*'           | '5'         | '2 750'         | '2 330,51'      | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'TRY'                   | 'L/Green'                  | '*'                        | 'Local currency'           | 'No'                       | ''                     |
		| ''                                           | '*'           | '5'         | '2 750'         | '2 330,51'      | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'TRY'                   | 'L/Green'                  | '*'                        | 'TRY'                      | 'No'                       | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'       | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Amount'        | 'Company'       | 'Legal name'        | 'Currency'     | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'         | 'Main Company'  | 'Company Ferron BP' | 'TRY'          | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Revenues turnovers"'             | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | 'Dimensions'    | ''              | ''                  | ''             | ''                  | ''                      | ''                         | 'Attributes'               | ''                         | ''                         | ''                     |
		| ''                                           | ''            | 'Amount'    | 'Company'       | 'Business unit' | 'Revenue type'      | 'Item key'     | 'Currency'          | 'Additional analytic'   | 'Currency movement type'   | 'Deferred calculation'     | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '232,18'    | 'Main Company'  | ''              | ''                  | '36/Yellow'    | 'USD'               | ''                      | 'Reporting currency'       | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '399,06'    | 'Main Company'  | ''              | ''                  | 'L/Green'      | 'USD'               | ''                      | 'Reporting currency'       | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'  | ''              | ''                  | '36/Yellow'    | 'TRY'               | ''                      | 'en descriptions is empty' | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'  | ''              | ''                  | '36/Yellow'    | 'TRY'               | ''                      | 'Local currency'           | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'  | ''              | ''                  | '36/Yellow'    | 'TRY'               | ''                      | 'TRY'                      | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'  | ''              | ''                  | 'L/Green'      | 'TRY'               | ''                      | 'en descriptions is empty' | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'  | ''              | ''                  | 'L/Green'      | 'TRY'               | ''                      | 'Local currency'           | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'  | ''              | ''                  | 'L/Green'      | 'TRY'               | ''                      | 'TRY'                      | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Store'         | 'Order'             | 'Item key'     | 'Row key'           | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'             | 'Store 01'      | 'Sales order 1*'    | '36/Yellow'    | '*'                 | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Store 01'      | 'Sales order 1*'    | 'L/Green'      | '*'                 | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Stock balance"'                  | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Store'         | 'Item key'          | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'             | 'Store 01'      | '36/Yellow'         | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Store 01'      | 'L/Green'           | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | 'Attributes'               | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Company'       | 'Order'             | 'Store'        | 'Item key'          | 'Row key'               | 'Delivery date'            | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'             | 'Main Company'  | 'Sales order 1*'    | 'Store 01'     | '36/Yellow'         | '*'                     | '*'                        | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Main Company'  | 'Sales order 1*'    | 'Store 01'     | 'L/Green'           | '*'                     | '*'                        | ''                         | ''                         | ''                         | ''                     |

	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.SalesInvoice"
	И я проверяю вывод отчета по выбранному документу
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales invoice 1*'                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"'        | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | 'Attributes'               | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Amount'        | 'Company'       | 'Basis document'    | 'Partner'      | 'Legal name'        | 'Agreement'             | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation'     | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '744,86'        | 'Main Company'  | 'Sales invoice 1*'  | 'Ferron BP'    | 'Company Ferron BP' | 'Basic Agreements, TRY' | 'USD'                      | 'Reporting currency'       | 'No'                       | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'         | 'Main Company'  | 'Sales invoice 1*'  | 'Ferron BP'    | 'Company Ferron BP' | 'Basic Agreements, TRY' | 'TRY'                      | 'en descriptions is empty' | 'No'                       | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'         | 'Main Company'  | 'Sales invoice 1*'  | 'Ferron BP'    | 'Company Ferron BP' | 'Basic Agreements, TRY' | 'TRY'                      | 'Local currency'           | 'No'                       | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'         | 'Main Company'  | 'Sales invoice 1*'  | 'Ferron BP'    | 'Company Ferron BP' | 'Basic Agreements, TRY' | 'TRY'                      | 'TRY'                      | 'No'                       | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Inventory balance"'              | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Company'       | 'Item key'          | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'             | 'Main Company'  | '36/Yellow'         | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Main Company'  | 'L/Green'           | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Store'         | 'Item key'          | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'             | 'Store 01'      | '36/Yellow'         | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Store 01'      | 'L/Green'           | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'                | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''              | ''              | 'Dimensions'        | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Amount'    | 'Manual amount' | 'Net amount'    | 'Document'          | 'Tax'          | 'Analytics'         | 'Tax rate'              | 'Include to total amount'  | 'Row key'                  | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '41,79'     | '41,79'         | '232,18'        | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '71,83'     | '71,83'         | '399,06'        | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'        | '1 355,93'      | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'        | '1 355,93'      | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'        | '1 355,93'      | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'        | '2 330,51'      | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'        | '2 330,51'      | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'        | '2 330,51'      | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'             | ''                    | ''                    | ''                    | ''               | ''                                          | ''               | ''                                          | ''                                     | ''                         | ''                                     | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                          | ''               | 'Dimensions'                                | ''                                     | ''                         | ''                                     | ''                         | ''                         | ''                     |
		| ''                                           | ''                    | ''                    | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers'                    | 'Transaction AR' | 'Company'                                   | 'Partner'                              | 'Legal name'               | 'Basis document'                       | 'Currency'                 | ''                         | ''                     |
		| ''                                           | 'Receipt'             | '*'                   | ''                    | ''               | ''                                          | '4 350'          | 'Main Company'                              | 'Ferron BP'                            | 'Company Ferron BP'        | 'Sales invoice 1*'                     | 'TRY'                      | ''                         | ''                     |
		| ''                                           | ''                    | ''                    | ''                    | ''               | ''                                          | ''               | ''                                          | ''                                     | ''                         | ''                                     | ''                         | ''                         | ''                     |
		| 'Register  "Sales turnovers"'                | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''              | ''              | ''                  | 'Dimensions'   | ''                  | ''                      | ''                         | ''                         | ''                         | 'Attributes'               | ''                     |
		| ''                                           | ''            | 'Quantity'  | 'Amount'        | 'Net amount'    | 'Offers amount'     | 'Company'      | 'Sales invoice'     | 'Currency'              | 'Item key'                 | 'Row key'                  | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                           | '*'           | '4'         | '273,97'        | '232,18'        | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'USD'                   | '36/Yellow'                | '*'                        | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                           | '*'           | '4'         | '1 600'         | '1 355,93'      | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'TRY'                   | '36/Yellow'                | '*'                        | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                           | '*'           | '4'         | '1 600'         | '1 355,93'      | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'TRY'                   | '36/Yellow'                | '*'                        | 'Local currency'           | 'No'                       | ''                     |
		| ''                                           | '*'           | '4'         | '1 600'         | '1 355,93'      | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'TRY'                   | '36/Yellow'                | '*'                        | 'TRY'                      | 'No'                       | ''                     |
		| ''                                           | '*'           | '5'         | '470,89'        | '399,06'        | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'USD'                   | 'L/Green'                  | '*'                        | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                           | '*'           | '5'         | '2 750'         | '2 330,51'      | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'TRY'                   | 'L/Green'                  | '*'                        | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                           | '*'           | '5'         | '2 750'         | '2 330,51'      | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'TRY'                   | 'L/Green'                  | '*'                        | 'Local currency'           | 'No'                       | ''                     |
		| ''                                           | '*'           | '5'         | '2 750'         | '2 330,51'      | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'TRY'                   | 'L/Green'                  | '*'                        | 'TRY'                      | 'No'                       | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'       | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Amount'        | 'Company'       | 'Legal name'        | 'Currency'     | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'         | 'Main Company'  | 'Company Ferron BP' | 'TRY'          | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Revenues turnovers"'             | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | 'Dimensions'    | ''              | ''                  | ''             | ''                  | ''                      | ''                         | 'Attributes'               | ''                         | ''                         | ''                     |
		| ''                                           | ''            | 'Amount'    | 'Company'       | 'Business unit' | 'Revenue type'      | 'Item key'     | 'Currency'          | 'Additional analytic'   | 'Currency movement type'   | 'Deferred calculation'     | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '232,18'    | 'Main Company'  | ''              | ''                  | '36/Yellow'    | 'USD'               | ''                      | 'Reporting currency'       | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '399,06'    | 'Main Company'  | ''              | ''                  | 'L/Green'      | 'USD'               | ''                      | 'Reporting currency'       | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'  | ''              | ''                  | '36/Yellow'    | 'TRY'               | ''                      | 'en descriptions is empty' | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'  | ''              | ''                  | '36/Yellow'    | 'TRY'               | ''                      | 'Local currency'           | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'  | ''              | ''                  | '36/Yellow'    | 'TRY'               | ''                      | 'TRY'                      | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'  | ''              | ''                  | 'L/Green'      | 'TRY'               | ''                      | 'en descriptions is empty' | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'  | ''              | ''                  | 'L/Green'      | 'TRY'               | ''                      | 'Local currency'           | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'  | ''              | ''                  | 'L/Green'      | 'TRY'               | ''                      | 'TRY'                      | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Store'         | 'Order'             | 'Item key'     | 'Row key'           | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'             | 'Store 01'      | 'Sales order 1*'    | '36/Yellow'    | '*'                 | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Store 01'      | 'Sales order 1*'    | 'L/Green'      | '*'                 | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Stock balance"'                  | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Store'         | 'Item key'          | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'             | 'Store 01'      | '36/Yellow'         | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Store 01'      | 'L/Green'           | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | 'Attributes'               | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Company'       | 'Order'             | 'Store'        | 'Item key'          | 'Row key'               | 'Delivery date'            | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'             | 'Main Company'  | 'Sales order 1*'    | 'Store 01'     | '36/Yellow'         | '*'                     | '*'                        | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Main Company'  | 'Sales order 1*'    | 'Store 01'     | 'L/Green'           | '*'                     | '*'                        | ''                         | ''                         | ''                         | ''                     |

	И я закрыл все окна клиентского приложения


Сценарий: __02404301 проверка отмены проводок при распроведении SalesInvoice
	* Открытие списка документов SalesInvoice
		И я открываю навигационную ссылку "e1cib/list/Document.SalesInvoice"
	* Проверка вывода отчета о движениях по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
	* Распроведение документа и проверка отмены проводок
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		И табличный документ "ResultTable" не содержит значения:
			| 'Register  "Partner AR transactions"'        |
			| 'Register  "Inventory balance"'              |
			| 'Register  "Order reservation"'              |
			| 'Register  "Taxes turnovers"'                |
			| 'Register  "Sales turnovers"'                |
			| 'Register  "Reconciliation statement"'       |
			| 'Register  "Order balance"'                  |
		И я закрыл все окна клиентского приложения
	* Проведение документа и проверка проводок
		И я открываю навигационную ссылку "e1cib/list/Document.SalesInvoice"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales invoice 1*'                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"'        | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | 'Attributes'               | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Amount'        | 'Company'       | 'Basis document'    | 'Partner'      | 'Legal name'        | 'Agreement'             | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation'     | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '744,86'        | 'Main Company'  | 'Sales invoice 1*'  | 'Ferron BP'    | 'Company Ferron BP' | 'Basic Agreements, TRY' | 'USD'                      | 'Reporting currency'       | 'No'                       | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'         | 'Main Company'  | 'Sales invoice 1*'  | 'Ferron BP'    | 'Company Ferron BP' | 'Basic Agreements, TRY' | 'TRY'                      | 'en descriptions is empty' | 'No'                       | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'         | 'Main Company'  | 'Sales invoice 1*'  | 'Ferron BP'    | 'Company Ferron BP' | 'Basic Agreements, TRY' | 'TRY'                      | 'Local currency'           | 'No'                       | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'         | 'Main Company'  | 'Sales invoice 1*'  | 'Ferron BP'    | 'Company Ferron BP' | 'Basic Agreements, TRY' | 'TRY'                      | 'TRY'                      | 'No'                       | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Inventory balance"'              | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Company'       | 'Item key'          | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'             | 'Main Company'  | '36/Yellow'         | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Main Company'  | 'L/Green'           | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Store'         | 'Item key'          | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'             | 'Store 01'      | '36/Yellow'         | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Store 01'      | 'L/Green'           | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'                | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''              | ''              | 'Dimensions'        | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Amount'    | 'Manual amount' | 'Net amount'    | 'Document'          | 'Tax'          | 'Analytics'         | 'Tax rate'              | 'Include to total amount'  | 'Row key'                  | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '41,79'     | '41,79'         | '232,18'        | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '71,83'     | '71,83'         | '399,06'        | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'        | '1 355,93'      | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'        | '1 355,93'      | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'        | '1 355,93'      | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'        | '2 330,51'      | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'        | '2 330,51'      | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'        | '2 330,51'      | 'Sales invoice 1*'  | 'VAT'          | ''                  | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'             | ''                    | ''                    | ''                    | ''               | ''                                          | ''               | ''                                          | ''                                     | ''                         | ''                                     | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                          | ''               | 'Dimensions'                                | ''                                     | ''                         | ''                                     | ''                         | ''                         | ''                     |
		| ''                                           | ''                    | ''                    | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers'                    | 'Transaction AR' | 'Company'                                   | 'Partner'                              | 'Legal name'               | 'Basis document'                       | 'Currency'                 | ''                         | ''                     |
		| ''                                           | 'Receipt'             | '*'                   | ''                    | ''               | ''                                          | '4 350'          | 'Main Company'                              | 'Ferron BP'                            | 'Company Ferron BP'        | 'Sales invoice 1*'                     | 'TRY'                      | ''                         | ''                     |
		| ''                                           | ''                    | ''                    | ''                    | ''               | ''                                          | ''               | ''                                          | ''                                     | ''                         | ''                                     | ''                         | ''                         | ''                     |
		| 'Register  "Sales turnovers"'                | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''              | ''              | ''                  | 'Dimensions'   | ''                  | ''                      | ''                         | ''                         | ''                         | 'Attributes'               | ''                     |
		| ''                                           | ''            | 'Quantity'  | 'Amount'        | 'Net amount'    | 'Offers amount'     | 'Company'      | 'Sales invoice'     | 'Currency'              | 'Item key'                 | 'Row key'                  | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                           | '*'           | '4'         | '273,97'        | '232,18'        | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'USD'                   | '36/Yellow'                | '*'                        | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                           | '*'           | '4'         | '1 600'         | '1 355,93'      | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'TRY'                   | '36/Yellow'                | '*'                        | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                           | '*'           | '4'         | '1 600'         | '1 355,93'      | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'TRY'                   | '36/Yellow'                | '*'                        | 'Local currency'           | 'No'                       | ''                     |
		| ''                                           | '*'           | '4'         | '1 600'         | '1 355,93'      | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'TRY'                   | '36/Yellow'                | '*'                        | 'TRY'                      | 'No'                       | ''                     |
		| ''                                           | '*'           | '5'         | '470,89'        | '399,06'        | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'USD'                   | 'L/Green'                  | '*'                        | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                           | '*'           | '5'         | '2 750'         | '2 330,51'      | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'TRY'                   | 'L/Green'                  | '*'                        | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                           | '*'           | '5'         | '2 750'         | '2 330,51'      | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'TRY'                   | 'L/Green'                  | '*'                        | 'Local currency'           | 'No'                       | ''                     |
		| ''                                           | '*'           | '5'         | '2 750'         | '2 330,51'      | ''                  | 'Main Company' | 'Sales invoice 1*'  | 'TRY'                   | 'L/Green'                  | '*'                        | 'TRY'                      | 'No'                       | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'       | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Amount'        | 'Company'       | 'Legal name'        | 'Currency'     | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'         | 'Main Company'  | 'Company Ferron BP' | 'TRY'          | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Revenues turnovers"'             | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | 'Dimensions'    | ''              | ''                  | ''             | ''                  | ''                      | ''                         | 'Attributes'               | ''                         | ''                         | ''                     |
		| ''                                           | ''            | 'Amount'    | 'Company'       | 'Business unit' | 'Revenue type'      | 'Item key'     | 'Currency'          | 'Additional analytic'   | 'Currency movement type'   | 'Deferred calculation'     | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '232,18'    | 'Main Company'  | ''              | ''                  | '36/Yellow'    | 'USD'               | ''                      | 'Reporting currency'       | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '399,06'    | 'Main Company'  | ''              | ''                  | 'L/Green'      | 'USD'               | ''                      | 'Reporting currency'       | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'  | ''              | ''                  | '36/Yellow'    | 'TRY'               | ''                      | 'en descriptions is empty' | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'  | ''              | ''                  | '36/Yellow'    | 'TRY'               | ''                      | 'Local currency'           | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'  | ''              | ''                  | '36/Yellow'    | 'TRY'               | ''                      | 'TRY'                      | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'  | ''              | ''                  | 'L/Green'      | 'TRY'               | ''                      | 'en descriptions is empty' | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'  | ''              | ''                  | 'L/Green'      | 'TRY'               | ''                      | 'Local currency'           | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'  | ''              | ''                  | 'L/Green'      | 'TRY'               | ''                      | 'TRY'                      | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Store'         | 'Order'             | 'Item key'     | 'Row key'           | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'             | 'Store 01'      | 'Sales order 1*'    | '36/Yellow'    | '*'                 | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Store 01'      | 'Sales order 1*'    | 'L/Green'      | '*'                 | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Stock balance"'                  | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Store'         | 'Item key'          | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'             | 'Store 01'      | '36/Yellow'         | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Store 01'      | 'L/Green'           | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''              | ''              | ''                  | ''             | ''                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                  | ''             | ''                  | ''                      | 'Attributes'               | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Company'       | 'Order'             | 'Store'        | 'Item key'          | 'Row key'               | 'Delivery date'            | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'             | 'Main Company'  | 'Sales order 1*'    | 'Store 01'     | '36/Yellow'         | '*'                     | '*'                        | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Main Company'  | 'Sales order 1*'    | 'Store 01'     | 'L/Green'           | '*'                     | '*'                        | ''                         | ''                         | ''                         | ''                     |
		И я закрыл все окна клиентского приложения






Сценарий: _028013 проверка подключения к документу Sales Return Order Отчета по движениям
	И я открываю навигационную ссылку "e1cib/list/Document.SalesReturnOrder"
	И я проверяю вывод отчета по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales return order 1*'          | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Document registrations records' | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Sales turnovers"'    | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | ''                      | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Offers amount'         | 'Company'      | 'Sales invoice'    | 'Currency' | 'Item key' | 'Row key' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | 'Sales invoice 2*' | 'TRY'      | 'L/Green'  | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | 'Sales invoice 2*' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'           | 'No'                   |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | 'Sales invoice 2*' | 'TRY'      | 'L/Green'  | '*'       | 'TRY'                      | 'No'                   |
		| ''                               | '*'           | '-1'        | '-94,18'    | ''           | ''                      | 'Main Company' | 'Sales invoice 2*' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                               | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'      | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Order'                 | 'Item key'     | 'Row key'          | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '1'         | 'Store 02'   | 'Sales return order 1*' | 'L/Green'      | '*'                | ''         | ''         | ''        | ''                         | ''                     |
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.SalesReturnOrder"
	И я проверяю вывод отчета по выбранному документу
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales return order 1*'          | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Document registrations records' | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Sales turnovers"'    | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | ''                      | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Offers amount'         | 'Company'      | 'Sales invoice'    | 'Currency' | 'Item key' | 'Row key' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | 'Sales invoice 2*' | 'TRY'      | 'L/Green'  | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | 'Sales invoice 2*' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'           | 'No'                   |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | 'Sales invoice 2*' | 'TRY'      | 'L/Green'  | '*'       | 'TRY'                      | 'No'                   |
		| ''                               | '*'           | '-1'        | '-94,18'    | ''           | ''                      | 'Main Company' | 'Sales invoice 2*' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                               | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'      | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Order'                 | 'Item key'     | 'Row key'          | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '1'         | 'Store 02'   | 'Sales return order 1*' | 'L/Green'      | '*'                | ''         | ''         | ''        | ''                         | ''                     |
	И я закрыл все окна клиентского приложения


Сценарий: _02801301 проверка отмены проводок при распроведении Sales Return Order
	* Открытие списка документов Sales Return Order
		И я открываю навигационную ссылку "e1cib/list/Document.SalesReturnOrder"
	* Проверка вывода отчета о движениях по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
	* Распроведение документа и проверка отмены проводок
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		И табличный документ "ResultTable" не содержит значения:
			| 'Register  "Sales turnovers"'    |
			| 'Register  "Order balance"'      |
		И я закрыл все окна клиентского приложения
	* Проведение документа и проверка проводок
		И я открываю навигационную ссылку "e1cib/list/Document.SalesReturnOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales return order 1*'          | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Document registrations records' | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Sales turnovers"'    | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | ''                      | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Offers amount'         | 'Company'      | 'Sales invoice'    | 'Currency' | 'Item key' | 'Row key' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | 'Sales invoice 2*' | 'TRY'      | 'L/Green'  | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | 'Sales invoice 2*' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'           | 'No'                   |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | 'Sales invoice 2*' | 'TRY'      | 'L/Green'  | '*'       | 'TRY'                      | 'No'                   |
		| ''                               | '*'           | '-1'        | '-94,18'    | ''           | ''                      | 'Main Company' | 'Sales invoice 2*' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                               | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'      | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Order'                 | 'Item key'     | 'Row key'          | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '1'         | 'Store 02'   | 'Sales return order 1*' | 'L/Green'      | '*'                | ''         | ''         | ''        | ''                         | ''                     |
		И я закрыл все окна клиентского приложения






Сценарий: _028811 проверка подключения к документу Shipment Confirmation Отчета по движениям
	И я открываю навигационную ссылку "e1cib/list/Document.ShipmentConfirmation"
	И я проверяю вывод отчета по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '95'      |
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Shipment confirmation 95*'                  | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Document registrations records'             | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Goods in transit outgoing"'      | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'        | 'Shipment basis'   | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'     | 'Sales invoice 2*' | 'L/Green'   | '*'         | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Store 02'     | 'Sales invoice 2*' | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Stock balance"'                  | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'         | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'     | 'L/Green'          | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Store 02'     | '36/Yellow'        | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | 'Attributes'    |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'            | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Main Company' | 'Sales invoice 2*' | 'Store 02'  | 'L/Green'   | '*'       | '*'             |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Main Company' | 'Sales invoice 2*' | 'Store 02'  | '36/Yellow' | '*'       | '*'             |
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.ShipmentConfirmation"
	И я проверяю вывод отчета по выбранному документу
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '95'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Shipment confirmation 95*'                  | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Document registrations records'             | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Goods in transit outgoing"'      | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'        | 'Shipment basis'   | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'     | 'Sales invoice 2*' | 'L/Green'   | '*'         | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Store 02'     | 'Sales invoice 2*' | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Stock balance"'                  | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'         | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'     | 'L/Green'          | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Store 02'     | '36/Yellow'        | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | 'Attributes'    |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'            | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Main Company' | 'Sales invoice 2*' | 'Store 02'  | 'L/Green'   | '*'       | '*'             |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Main Company' | 'Sales invoice 2*' | 'Store 02'  | '36/Yellow' | '*'       | '*'             |
	И я закрыл все окна клиентского приложения


Сценарий: _02881101 проверка отмены проводок при распроведении Shipment confirmation
	* Открытие списка документов Shipment confirmation
		И я открываю навигационную ссылку "e1cib/list/Document.ShipmentConfirmation"
	* Проверка вывода отчета о движениях по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '95'      |
	* Распроведение документа и проверка отмены проводок
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		И табличный документ "ResultTable" не содержит значения:
			| 'Register  "Goods in transit outgoing"'      |
			| 'Register  "Stock balance"'                  |
			| 'Register  "Shipment confirmation schedule"' |
		И я закрыл все окна клиентского приложения
	* Проведение документа и проверка проводок
		И я открываю навигационную ссылку "e1cib/list/Document.ShipmentConfirmation"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '95'      |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Shipment confirmation 95*'                  | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Document registrations records'             | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Goods in transit outgoing"'      | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'        | 'Shipment basis'   | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'     | 'Sales invoice 2*' | 'L/Green'   | '*'         | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Store 02'     | 'Sales invoice 2*' | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Stock balance"'                  | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'         | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'     | 'L/Green'          | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Store 02'     | '36/Yellow'        | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | 'Attributes'    |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'            | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Main Company' | 'Sales invoice 2*' | 'Store 02'  | 'L/Green'   | '*'       | '*'             |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Main Company' | 'Sales invoice 2*' | 'Store 02'  | '36/Yellow' | '*'       | '*'             |
		И я закрыл все окна клиентского приложения





Сценарий: _028905 проверка подключения к документу Goods Receipt Отчета по движениям
	И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
	И я проверяю вывод отчета по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '106'      |
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Goods receipt 106*'                    | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'       | 'Item key' | 'Row key'  | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '500'       | 'Store 02'     | 'Purchase invoice 2*' | 'L/Green'  | '*'        | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'            | ''         | ''         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '500'       | 'Store 02'     | 'L/Green'             | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Goods receipt schedule"'    | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | 'Attributes'    |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'               | 'Store'    | 'Item key' | 'Row key' | 'Delivery date' |
		| ''                                      | 'Expense'     | '*'      | '500'       | 'Main Company' | 'Purchase invoice 2*' | 'Store 02' | 'L/Green'  | '*'       | '*'             |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'            | ''         | ''         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '500'       | 'Store 02'     | 'L/Green'             | ''         | ''         | ''        | ''              |


	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
	И я проверяю вывод отчета по выбранному документу
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '106'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Goods receipt 106*'                    | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'       | 'Item key' | 'Row key'  | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '500'       | 'Store 02'     | 'Purchase invoice 2*' | 'L/Green'  | '*'        | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'            | ''         | ''         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '500'       | 'Store 02'     | 'L/Green'             | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Goods receipt schedule"'    | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | 'Attributes'    |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'               | 'Store'    | 'Item key' | 'Row key' | 'Delivery date' |
		| ''                                      | 'Expense'     | '*'      | '500'       | 'Main Company' | 'Purchase invoice 2*' | 'Store 02' | 'L/Green'  | '*'       | '*'             |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'            | ''         | ''         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '500'       | 'Store 02'     | 'L/Green'             | ''         | ''         | ''        | ''              |


	И я закрыл все окна клиентского приложения


Сценарий: _02890501 проверка отмены проводок при распроведении Goods receipt
	* Открытие списка документов Goods receipt
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
	* Проверка вывода отчета о движениях по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '106'      |
	* Распроведение документа и проверка отмены проводок
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		И табличный документ "ResultTable" не содержит значения:
			| 'Register  "Goods in transit incoming"' |
			| 'Register  "Stock reservation"'         |
			| 'Register  "Goods receipt schedule"'    |
			| 'Register  "Stock balance"'             |
		И я закрыл все окна клиентского приложения
	* Проведение документа и проверка проводок
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '106'      |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Goods receipt 106*'                    | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'       | 'Item key' | 'Row key'  | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '500'       | 'Store 02'     | 'Purchase invoice 2*' | 'L/Green'  | '*'        | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'            | ''         | ''         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '500'       | 'Store 02'     | 'L/Green'             | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Goods receipt schedule"'    | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | 'Attributes'    |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'               | 'Store'    | 'Item key' | 'Row key' | 'Delivery date' |
		| ''                                      | 'Expense'     | '*'      | '500'       | 'Main Company' | 'Purchase invoice 2*' | 'Store 02' | 'L/Green'  | '*'       | '*'             |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'            | ''         | ''         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '500'       | 'Store 02'     | 'L/Green'             | ''         | ''         | ''        | ''              |
		И я закрыл все окна клиентского приложения






Сценарий: _029519 проверка подключения к документу Bundling Отчета по движениям
	И я открываю навигационную ссылку "e1cib/list/Document.Bundling"
	И я проверяю вывод отчета по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Bundling 1*'                    | ''            | ''          | ''                              | ''           | ''                              |
		| 'Document registrations records' | ''            | ''          | ''                              | ''           | ''                              |
		| 'Register  "Bundle contents"'    | ''            | ''          | ''                              | ''           | ''                              |
		| ''                               | 'Period'      | 'Resources' | 'Dimensions'                    | ''           | ''                              |
		| ''                               | ''            | 'Quantity'  | 'Item key bundle'               | 'Item key'   | ''                              |
		| ''                               | '*'           | '1'         | 'Bound Dress+Shirt/Dress+Shirt' | 'XS/Blue'    | ''                              |
		| ''                               | '*'           | '1'         | 'Bound Dress+Shirt/Dress+Shirt' | '36/Red'     | ''                              |
		| ''                               | ''            | ''          | ''                              | ''           | ''                              |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''                              | ''           | ''                              |
		| ''                               | 'Record type' | 'Period'    | 'Resources'                     | 'Dimensions' | ''                              |
		| ''                               | ''            | ''          | 'Quantity'                      | 'Store'      | 'Item key'                      |
		| ''                               | 'Receipt'     | '*'         | '10'                            | 'Store 01'   | 'Bound Dress+Shirt/Dress+Shirt' |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | 'XS/Blue'                       |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | '36/Red'                        |
		| ''                               | ''            | ''          | ''                              | ''           | ''                              |
		| 'Register  "Stock balance"'      | ''            | ''          | ''                              | ''           | ''                              |
		| ''                               | 'Record type' | 'Period'    | 'Resources'                     | 'Dimensions' | ''                              |
		| ''                               | ''            | ''          | 'Quantity'                      | 'Store'      | 'Item key'                      |
		| ''                               | 'Receipt'     | '*'         | '10'                            | 'Store 01'   | 'Bound Dress+Shirt/Dress+Shirt' |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | 'XS/Blue'                       |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | '36/Red'                        |

	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.Bundling"
	И я проверяю вывод отчета по выбранному документу
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Bundling 1*'                    | ''            | ''          | ''                              | ''           | ''                              |
		| 'Document registrations records' | ''            | ''          | ''                              | ''           | ''                              |
		| 'Register  "Bundle contents"'    | ''            | ''          | ''                              | ''           | ''                              |
		| ''                               | 'Period'      | 'Resources' | 'Dimensions'                    | ''           | ''                              |
		| ''                               | ''            | 'Quantity'  | 'Item key bundle'               | 'Item key'   | ''                              |
		| ''                               | '*'           | '1'         | 'Bound Dress+Shirt/Dress+Shirt' | 'XS/Blue'    | ''                              |
		| ''                               | '*'           | '1'         | 'Bound Dress+Shirt/Dress+Shirt' | '36/Red'     | ''                              |
		| ''                               | ''            | ''          | ''                              | ''           | ''                              |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''                              | ''           | ''                              |
		| ''                               | 'Record type' | 'Period'    | 'Resources'                     | 'Dimensions' | ''                              |
		| ''                               | ''            | ''          | 'Quantity'                      | 'Store'      | 'Item key'                      |
		| ''                               | 'Receipt'     | '*'         | '10'                            | 'Store 01'   | 'Bound Dress+Shirt/Dress+Shirt' |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | 'XS/Blue'                       |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | '36/Red'                        |
		| ''                               | ''            | ''          | ''                              | ''           | ''                              |
		| 'Register  "Stock balance"'      | ''            | ''          | ''                              | ''           | ''                              |
		| ''                               | 'Record type' | 'Period'    | 'Resources'                     | 'Dimensions' | ''                              |
		| ''                               | ''            | ''          | 'Quantity'                      | 'Store'      | 'Item key'                      |
		| ''                               | 'Receipt'     | '*'         | '10'                            | 'Store 01'   | 'Bound Dress+Shirt/Dress+Shirt' |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | 'XS/Blue'                       |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | '36/Red'                        |

	И я закрыл все окна клиентского приложения


Сценарий: _02951901 проверка отмены проводок при распроведении Bundling
	* Открытие списка документов Bundling
		И я открываю навигационную ссылку "e1cib/list/Document.Bundling"
	* Проверка вывода отчета о движениях по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
	* Распроведение документа и проверка отмены проводок
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		И табличный документ "ResultTable" не содержит значения:
			| 'Register  "Bundle contents"'    |
			| 'Register  "Stock reservation"'  |
			| 'Register  "Stock balance"'      |
		И я закрыл все окна клиентского приложения
	* Проведение документа и проверка проводок
		И я открываю навигационную ссылку "e1cib/list/Document.Bundling"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Bundling 1*'                    | ''            | ''          | ''                              | ''           | ''                              |
		| 'Document registrations records' | ''            | ''          | ''                              | ''           | ''                              |
		| 'Register  "Bundle contents"'    | ''            | ''          | ''                              | ''           | ''                              |
		| ''                               | 'Period'      | 'Resources' | 'Dimensions'                    | ''           | ''                              |
		| ''                               | ''            | 'Quantity'  | 'Item key bundle'               | 'Item key'   | ''                              |
		| ''                               | '*'           | '1'         | 'Bound Dress+Shirt/Dress+Shirt' | 'XS/Blue'    | ''                              |
		| ''                               | '*'           | '1'         | 'Bound Dress+Shirt/Dress+Shirt' | '36/Red'     | ''                              |
		| ''                               | ''            | ''          | ''                              | ''           | ''                              |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''                              | ''           | ''                              |
		| ''                               | 'Record type' | 'Period'    | 'Resources'                     | 'Dimensions' | ''                              |
		| ''                               | ''            | ''          | 'Quantity'                      | 'Store'      | 'Item key'                      |
		| ''                               | 'Receipt'     | '*'         | '10'                            | 'Store 01'   | 'Bound Dress+Shirt/Dress+Shirt' |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | 'XS/Blue'                       |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | '36/Red'                        |
		| ''                               | ''            | ''          | ''                              | ''           | ''                              |
		| 'Register  "Stock balance"'      | ''            | ''          | ''                              | ''           | ''                              |
		| ''                               | 'Record type' | 'Period'    | 'Resources'                     | 'Dimensions' | ''                              |
		| ''                               | ''            | ''          | 'Quantity'                      | 'Store'      | 'Item key'                      |
		| ''                               | 'Receipt'     | '*'         | '10'                            | 'Store 01'   | 'Bound Dress+Shirt/Dress+Shirt' |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | 'XS/Blue'                       |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | '36/Red'                        |
		И я закрыл все окна клиентского приложения








Сценарий: _029612 проверка подключения к документу Unbundling Отчета по движениям
	И я открываю навигационную ссылку "e1cib/list/Document.Unbundling"
	И я проверяю вывод отчета по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Unbundling 1*'                  | ''            | ''       | ''          | ''           | ''          |
		| 'Document registrations records' | ''            | ''       | ''          | ''           | ''          |
		| 'Register  "Stock reservation"'  | ''            | ''       | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'S/Yellow'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'L/Green'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'M/Brown'   |
		| ''                               | 'Expense'     | '*'      | '2'         | 'Store 01'   | 'Dress/A-8' |
		| ''                               | ''            | ''       | ''          | ''           | ''          |
		| 'Register  "Stock balance"'      | ''            | ''       | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'S/Yellow'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'L/Green'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'M/Brown'   |
		| ''                               | 'Expense'     | '*'      | '2'         | 'Store 01'   | 'Dress/A-8' |

	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.Unbundling"
	И я проверяю вывод отчета по выбранному документу
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Unbundling 1*'                  | ''            | ''       | ''          | ''           | ''          |
		| 'Document registrations records' | ''            | ''       | ''          | ''           | ''          |
		| 'Register  "Stock reservation"'  | ''            | ''       | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'S/Yellow'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'L/Green'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'M/Brown'   |
		| ''                               | 'Expense'     | '*'      | '2'         | 'Store 01'   | 'Dress/A-8' |
		| ''                               | ''            | ''       | ''          | ''           | ''          |
		| 'Register  "Stock balance"'      | ''            | ''       | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'S/Yellow'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'L/Green'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'M/Brown'   |
		| ''                               | 'Expense'     | '*'      | '2'         | 'Store 01'   | 'Dress/A-8' |

	И я закрыл все окна клиентского приложения

Сценарий: _02961201 проверка отмены проводок при распроведении Unbundling
	* Открытие списка документов Unbundling
		И я открываю навигационную ссылку "e1cib/list/Document.Unbundling"
	* Проверка вывода отчета о движениях по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
	* Распроведение документа и проверка отмены проводок
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		И табличный документ "ResultTable" не содержит значения:
			| 'Register  "Stock reservation"'  |
			| 'Register  "Stock balance"'      |
		И я закрыл все окна клиентского приложения
	* Проведение документа и проверка проводок
		И я открываю навигационную ссылку "e1cib/list/Document.Unbundling"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Unbundling 1*'                  | ''            | ''       | ''          | ''           | ''          |
		| 'Document registrations records' | ''            | ''       | ''          | ''           | ''          |
		| 'Register  "Stock reservation"'  | ''            | ''       | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'S/Yellow'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'L/Green'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'M/Brown'   |
		| ''                               | 'Expense'     | '*'      | '2'         | 'Store 01'   | 'Dress/A-8' |
		| ''                               | ''            | ''       | ''          | ''           | ''          |
		| 'Register  "Stock balance"'      | ''            | ''       | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'S/Yellow'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'L/Green'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'M/Brown'   |
		| ''                               | 'Expense'     | '*'      | '2'         | 'Store 01'   | 'Dress/A-8' |
		И я закрыл все окна клиентского приложения




Сценарий: _023023 проверка подключения к документу Sales Order Отчета по движениям
	И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
	И я проверяю вывод отчета по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales order 1*'                             | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'       | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4'         | 'Store 01'     | '36/Yellow'      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 01'     | 'L/Green'        | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'       | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'         | 'Store 01'     | '36/Yellow'      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'         | 'Store 01'     | 'L/Green'        | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Sales order'    | 'Currency'  | 'Item key'  | 'Row key' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '4'         | '273,97'    | 'Main Company' | 'Sales order 1*' | 'USD'       | '36/Yellow' | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | '36/Yellow' | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | '36/Yellow' | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | '36/Yellow' | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '5'         | '470,89'    | 'Main Company' | 'Sales order 1*' | 'USD'       | 'L/Green'   | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | 'L/Green'   | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | 'L/Green'   | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | 'L/Green'   | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'          | 'Item key'  | 'Row key'   | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4'         | 'Store 01'     | 'Sales order 1*' | '36/Yellow' | '*'         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 01'     | 'Sales order 1*' | 'L/Green'   | '*'         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'          | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4'         | 'Main Company' | 'Sales order 1*' | 'Store 01'  | '36/Yellow' | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Main Company' | 'Sales order 1*' | 'Store 01'  | 'L/Green'   | '*'       | '*'                        | ''                     |
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
	И я проверяю вывод отчета по выбранному документу
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales order 1*'                             | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'       | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4'         | 'Store 01'     | '36/Yellow'      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 01'     | 'L/Green'        | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'       | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'         | 'Store 01'     | '36/Yellow'      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'         | 'Store 01'     | 'L/Green'        | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Sales order'    | 'Currency'  | 'Item key'  | 'Row key' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '4'         | '273,97'    | 'Main Company' | 'Sales order 1*' | 'USD'       | '36/Yellow' | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | '36/Yellow' | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | '36/Yellow' | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | '36/Yellow' | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '5'         | '470,89'    | 'Main Company' | 'Sales order 1*' | 'USD'       | 'L/Green'   | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | 'L/Green'   | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | 'L/Green'   | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | 'L/Green'   | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'          | 'Item key'  | 'Row key'   | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4'         | 'Store 01'     | 'Sales order 1*' | '36/Yellow' | '*'         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 01'     | 'Sales order 1*' | 'L/Green'   | '*'         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'          | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4'         | 'Main Company' | 'Sales order 1*' | 'Store 01'  | '36/Yellow' | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Main Company' | 'Sales order 1*' | 'Store 01'  | 'L/Green'   | '*'       | '*'                        | ''                     |
	И я закрыл все окна клиентского приложения








