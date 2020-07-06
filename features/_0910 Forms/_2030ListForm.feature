#language: ru
@tree
@Positive

Функционал: checking the display of lists of catalogs elements for which there are selections



Контекст: 
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий
	
Сценарий: _0203001 check filters in the partner term catalog
	* Check for data availability
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		Тогда таблица "List" содержит строки:
		| 'Description'                             |
		| 'Basic Partner terms, TRY'                   |
		| 'Vendor Ferron, TRY'                      |
		И я закрыл все окна клиентского приложения
	* Filter check according to partner term with customers in the sales section
		* Open list form
			И В панели разделов я выбираю 'Sales - A/R'
			И В панели функций я выбираю 'Customer Partner terms'
		* Filter check
			Тогда таблица "List" не содержит строки:
			| 'Description'                             |
			| 'Vendor Ferron, TRY'                      |
			Тогда таблица "List" содержит строки:
			| 'Description'                             |
			| 'Basic Partner terms, TRY'                   |
	* Filter check according to partner term with vendors in the purchase section
		* Open list form
			Когда В панели разделов я выбираю 'Purchase  - A/P'
			И В панели функций я выбираю 'Vendor Partner terms'
		* Filter check
			Тогда таблица "List" содержит строки:
			| 'Description'                             |
			| 'Vendor Ferron, TRY'                      |
			Тогда таблица "List" не содержит строки:
			| 'Description'                             |
			| 'Basic Partner terms, TRY'                   |
	И я закрыл все окна клиентского приложения

Сценарий: _0203002 check filters in the partner catalog
	* Check for data availability
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		Тогда таблица "List" содержит строки:
			| 'Description'      |
			| 'Ferron BP'        |
			| 'Kalipso'          |
			| 'Nicoletta'        |
			| 'Veritas'          |
		И я закрыл все окна клиентского приложения
	* Filter check customers in the sales section
		* Open list form
			И В панели разделов я выбираю 'Sales - A/R'
			И В панели функций я выбираю 'Customers'
		* Check the selection by customer
			Тогда таблица "List" не содержит строки:
			| 'Description'      |
			| 'Veritas'          |
			Тогда таблица "List" содержит строки:
			| 'Description'      |
			| 'Ferron BP'        |
			| 'Kalipso'          |
			| 'Nicoletta'        |
		* Filter check customers who are suppliers also
			И я устанавливаю флаг 'Vendor'
			Тогда таблица "List" не содержит строки:
			| 'Description'      |
			| 'Kalipso'          |
		И я закрыл все окна клиентского приложения
	* Filter check customers in the purchase section
		* Open list form
			Когда В панели разделов я выбираю 'Purchase  - A/P'
			И В панели функций я выбираю 'Vendors'
		* Check the selection by vendors
			Тогда таблица "List" содержит строки:
			| 'Description'      |
			| 'Ferron BP'        |
			| 'Veritas'          |
			| 'Nicoletta'        |
			Тогда таблица "List" не содержит строки:
			| 'Description'      |
			| 'Kalipso'          |
		* Filter check по поставщикам которые являются клиентами
			И я устанавливаю флаг 'Customer'
			Тогда таблица "List" не содержит строки:
			| 'Description'      |
			| 'Veritas'          |
		И я закрыл все окна клиентского приложения
	* Check filters in the catalog Partners
		* Open catalog
			И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		* Check the selection by customer
			И я устанавливаю флаг 'Customer'
			Тогда таблица "List" содержит строки:
			| 'Description'      |
			| 'Ferron BP'        |
			| 'Kalipso'          |
			| 'Nicoletta'        |
			Тогда таблица "List" не содержит строки:
			| 'Description'      |
			| 'Veritas'          |
		* Check the selection by vendor
			И я снимаю флаг 'Customer'
			И я устанавливаю флаг 'Vendor'
			Тогда таблица "List" не содержит строки:
			| 'Description'      |
			| 'Kalipso'          |
			Тогда таблица "List" содержит строки:
			| 'Description'      |
			| 'Ferron BP'        |
			| 'Veritas'          |
			| 'Nicoletta'        |
		* Check the selection by employee
			И я снимаю флаг 'Vendor'
			И я устанавливаю флаг 'Employee'
			Тогда таблица "List" не содержит строки:
			| 'Description'      |
			| 'Ferron BP'        |
			| 'Kalipso'          |
			| 'Nicoletta'        |
			| 'Veritas'          |
			Тогда таблица "List" содержит строки:
			| 'Description'     |
			| 'Alexander Orlov' |
			| 'Anna Petrova'    |
			| 'David Romanov'   |
			| 'Arina Brown'     |
		* Check the selection by opponent
			И я устанавливаю флаг 'Opponent'
			И я снимаю флаг 'Employee'
			Тогда в таблице "List" количество строк "равно" 0
		И я закрыл все окна клиентского приложения





Сценарий: _0203003 check filters in the Cash/Bank accounts catalog
	* Check for data availability
		И я открываю навигационную ссылку 'e1cib/list/Catalog.CashAccounts'
		Тогда таблица "List" содержит строки:
			| 'Description'      |
			| 'Cash desk №1'     |
			| 'Cash desk №2'     |
			| 'Transit Main'     |
			| 'Transit Second'   |
			| 'Bank account, TRY'|
			| 'Bank account, USD'|
	* Check the selection by cash account
		И я меняю значение переключателя 'CashAccountTypeFilter' на 'Cash'
		Тогда таблица "List" содержит строки:
			| 'Description'      |
			| 'Cash desk №1'     |
			| 'Cash desk №2'     |
		Тогда таблица "List" не содержит строки:
			| 'Description'      |
			| 'Transit Main'     |
			| 'Transit Second'   |
			| 'Bank account, TRY'|
			| 'Bank account, USD'|
	* Check the selection by bank account
		И я меняю значение переключателя 'CashAccountTypeFilter' на 'Bank'
		Тогда таблица "List" содержит строки:
			| 'Description'      |
			| 'Bank account, TRY'|
			| 'Bank account, USD'|
		Тогда таблица "List" не содержит строки:
			| 'Description'      |
			| 'Transit Main'     |
			| 'Transit Second'   |
			| 'Cash desk №1'     |
			| 'Cash desk №2'     |
	* Check the selection by transit account
		И я меняю значение переключателя 'CashAccountTypeFilter' на 'Transit'
		Тогда таблица "List" содержит строки:
			| 'Description'      |
			| 'Transit Main'     |
			| 'Transit Second'   |
		Тогда таблица "List" не содержит строки:
			| 'Description'      |
			| 'Bank account, TRY'|
			| 'Bank account, USD'|
			| 'Cash desk №1'     |
			| 'Cash desk №2'     |
	* Filter reset check
		И я меняю значение переключателя 'CashAccountTypeFilter' на 'All'
		Тогда таблица "List" содержит строки:
			| 'Description'      |
			| 'Cash desk №1'     |
			| 'Cash desk №2'     |
			| 'Transit Main'     |
			| 'Transit Second'   |
			| 'Bank account, TRY'|
			| 'Bank account, USD'|
		И я закрыл все окна клиентского приложения


