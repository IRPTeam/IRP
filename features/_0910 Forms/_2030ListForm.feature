#language: ru
@tree
@Positive

Функционал: проверка отображения списков элементов справочников по которым стоят отборы



Контекст: 
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий
	
Сценарий: _0203001 проверка фильтров в справочнике соглашений
	* Проверка наличия данных
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		Тогда таблица "List" содержит строки:
		| 'Description'                             |
		| 'Basic Partner terms, TRY'                   |
		| 'Vendor Ferron, TRY'                      |
		И я закрыл все окна клиентского приложения
	* Проверка фильтра по соглашениям с клиентами в разделе продаж
		* Открытие списка
			И В панели разделов я выбираю 'Sales - A/R'
			И В панели функций я выбираю 'Customer Partner terms'
		* Проверка фильтра
			Тогда таблица "List" не содержит строки:
			| 'Description'                             |
			| 'Vendor Ferron, TRY'                      |
			Тогда таблица "List" содержит строки:
			| 'Description'                             |
			| 'Basic Partner terms, TRY'                   |
	* Проверка фильтра по соглашениям с клиентами в разделе закупок
		* Открытие списка
			Когда В панели разделов я выбираю 'Purchase  - A/P'
			И В панели функций я выбираю 'Vendor Partner terms'
		* Проверка фильтра
			Тогда таблица "List" содержит строки:
			| 'Description'                             |
			| 'Vendor Ferron, TRY'                      |
			Тогда таблица "List" не содержит строки:
			| 'Description'                             |
			| 'Basic Partner terms, TRY'                   |
	И я закрыл все окна клиентского приложения

Сценарий: _0203002 проверка фильтров в справочнике партнеров
	* Проверка наличия данных
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		Тогда таблица "List" содержит строки:
			| 'Description'      |
			| 'Ferron BP'        |
			| 'Kalipso'          |
			| 'Nicoletta'        |
			| 'Veritas'          |
		И я закрыл все окна клиентского приложения
	* Проверка фильтра по клиентам в разделе продаж
		* Открытие списка
			И В панели разделов я выбираю 'Sales - A/R'
			И В панели функций я выбираю 'Customers'
		* Проверка фильтра по клиентам
			Тогда таблица "List" не содержит строки:
			| 'Description'      |
			| 'Veritas'          |
			Тогда таблица "List" содержит строки:
			| 'Description'      |
			| 'Ferron BP'        |
			| 'Kalipso'          |
			| 'Nicoletta'        |
		* Проверка фильтра по клиентам которые являются поставщиками
			И я устанавливаю флаг 'Vendor'
			Тогда таблица "List" не содержит строки:
			| 'Description'      |
			| 'Kalipso'          |
		И я закрыл все окна клиентского приложения
	* Проверка фильтра по поставщикам в разделе закупок
		* Открытие списка
			Когда В панели разделов я выбираю 'Purchase  - A/P'
			И В панели функций я выбираю 'Vendors'
		* Проверка фильтра по поставщикам
			Тогда таблица "List" содержит строки:
			| 'Description'      |
			| 'Ferron BP'        |
			| 'Veritas'          |
			| 'Nicoletta'        |
			Тогда таблица "List" не содержит строки:
			| 'Description'      |
			| 'Kalipso'          |
		* Проверка фильтра по поставщикам которые являются клиентами
			И я устанавливаю флаг 'Customer'
			Тогда таблица "List" не содержит строки:
			| 'Description'      |
			| 'Veritas'          |
		И я закрыл все окна клиентского приложения
	* Проверка отборов в общем правочнике партнеров
		* Open catalog
			И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		* Проверка отбора по клиентам
			И я устанавливаю флаг 'Customer'
			Тогда таблица "List" содержит строки:
			| 'Description'      |
			| 'Ferron BP'        |
			| 'Kalipso'          |
			| 'Nicoletta'        |
			Тогда таблица "List" не содержит строки:
			| 'Description'      |
			| 'Veritas'          |
		* Проверка отбора по поставщикам
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
		* Проверка отбора по сотрудникам
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
		* Проверка отбора по конкурентам
			И я устанавливаю флаг 'Opponent'
			И я снимаю флаг 'Employee'
			Тогда в таблице "List" количество строк "равно" 0
		И я закрыл все окна клиентского приложения





Сценарий: _0203003 проверка фильтров в справочнике Cash/Bank accounts
	* Проверка наличия данных
		И я открываю навигационную ссылку 'e1cib/list/Catalog.CashAccounts'
		Тогда таблица "List" содержит строки:
			| 'Description'      |
			| 'Cash desk №1'     |
			| 'Cash desk №2'     |
			| 'Transit Main'     |
			| 'Transit Second'   |
			| 'Bank account, TRY'|
			| 'Bank account, USD'|
	* Проверка фильтра по кассам
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
	* Проверка фильтра по банковским счетам
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
	* Проверка фильтра по транзитным счетам
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
	* Проверка сброса фильтра
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


