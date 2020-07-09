#language: ru
@ExportScenarios
@IgnoreOnCIMainBuild
@tree

Функционал: экспортные сценарии

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: проверяю фильтр по собственным компаниям
	И я нажимаю на кнопку с именем 'FormCreate'
	Check the filter by отбору собственной компании
		И я нажимаю кнопку выбора у поля "Company"
		Тогда таблица "List" стала равной:
		| Description  |
		| Main Company |
		И я нажимаю на кнопку с именем 'FormChoose'
		И Пауза 2
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я проверяю фильтр при вводе по строке
		И Пауза 2
		И в поле 'Company' я ввожу текст 'Company Kalipso'
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Currency"
		Тогда открылось окно "Companies"
		Тогда таблица "List" не содержит строки:
			| Description  |
			| Company Kalipso |
		И я нажимаю на кнопку с именем 'FormChoose'
		Когда Проверяю шаги на Исключение:
			|'И     элемент формы с именем "Company" стал равен 'Company Kalipso''|
	И я закрыл все окна клиентского приложения

Сценарий: проверяю фильтр по собственным компаниям в Cash transfer order
	И я нажимаю на кнопку с именем 'FormCreate'
	Check the filter by отбору собственной компании
		И я нажимаю кнопку выбора у поля "Company"
		Тогда таблица "List" стала равной:
		| Description  |
		| Main Company |
		И я нажимаю на кнопку с именем 'FormChoose'
		И Пауза 2
		И     элемент формы с именем "Company" стал равен 'Main Company'
	И я проверяю фильтр при вводе по строке
		И Пауза 2
		И в поле 'Company' я ввожу текст 'Company Kalipso'
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Sender"
		Тогда открылось окно "Companies"
		Тогда таблица "List" не содержит строки:
			| Description  |
			| Company Kalipso |
		И я нажимаю на кнопку с именем 'FormChoose'
		Когда Проверяю шаги на Исключение:
			|'И     элемент формы с именем "Company" стал равен 'Company Kalipso''|
	И я закрыл все окна клиентского приложения

Сценарий: проверяю фильтр по банковским счетам (выбор кассы недоступен) + заполнение валюты из банковского счета
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Company"
	И я нажимаю на кнопку с именем 'FormChoose'
	Check the filter by банковским счетам
		И я нажимаю кнопку выбора у поля "Account"
		И я запоминаю количество строк таблицы "List" как "QS"
		Тогда переменная "QS" имеет значение 3
		Тогда таблица "List" содержит строки:
			| Description         |
			| Bank account, TRY |
			| Bank account, USD |
			| Bank account, EUR |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Account" стал равен 'Bank account, TRY'
	И я проверяю заполнение валюты
		И     элемент формы с именем "Currency" стал равен 'TRY'
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| Description         |
			| Bank account, USD |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Currency" стал равен 'USD'
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| Description         |
			| Bank account, EUR |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Currency" стал равен 'EUR'
	И я проверяю фильтр при вводе по строке
		И Пауза 2
		И в поле 'Account' я ввожу текст 'Cash desk №1'
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Currency"
		Тогда таблица "List" не содержит строки:
			| Description  |
			| Cash desk №1 |
		И я нажимаю на кнопку с именем 'FormChoose'
		Когда Проверяю шаги на Исключение:
			|'И     элемент формы с именем "CashAccount" стал равен 'Cash desk №1''|
	И Я закрыл все окна клиентского приложения

Сценарий: проверяю фильтр по кассам (выбор банка недоступен)
	И я нажимаю на кнопку с именем 'FormCreate'
	Check the filter by банковским счетам
		И я нажимаю кнопку выбора у поля "Company"
		И я нажимаю на кнопку с именем 'FormChoose'
		И я нажимаю кнопку выбора у поля "Cash account"
		И я запоминаю количество строк таблицы "List" как "QS"
		Тогда переменная "QS" имеет значение 3
		Тогда таблица "List" содержит строки:
			| Description         |
			| Cash desk №1 |
			| Cash desk №2 |
			| Cash desk №3 |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "CashAccount" стал равен 'Cash desk №1'
	И я проверяю фильтр при вводе по строке
		И Пауза 2
		И в поле 'Cash account' я ввожу текст 'Bank account, TRY'
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Currency"
		Тогда таблица "List" не содержит строки:
			| Description  |
			| Bank account, TRY |
		И я нажимаю на кнопку с именем 'FormChoose'
		Когда Проверяю шаги на Исключение:
			|'И     элемент формы с именем "CashAccount" стал равен 'Bank account, TRY''|
	И Я закрыл все окна клиентского приложения

Сценарий: проверяю ввод Description
	И я нажимаю на кнопку с именем 'FormCreate'
	И я ввожу Description
		И я нажимаю на гиперссылку "Description"
		И в поле 'Text' я ввожу текст 'Test Description'
		И я нажимаю на кнопку 'OK'
		И     элемент формы с именем "Description" стал равен 'Test Description'
	И Я закрыл все окна клиентского приложения

Сценарий: проверяю выбор вида операции в документах оплаты
	И я нажимаю на кнопку с именем 'FormCreate'
	И я выбираю вид операции
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
		И     элемент формы с именем "TransactionType" стал равен 'Payment to the vendor'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
		И     элемент формы с именем "TransactionType" стал равен 'Currency exchange'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		И     элемент формы с именем "TransactionType" стал равен 'Cash transfer order'
	И Я закрыл все окна клиентского приложения

Сценарий: проверяю выбор вида операции в документах поступления оплаты
	И я нажимаю на кнопку с именем 'FormCreate'
	И я выбираю вид операции
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
		И     элемент формы с именем "TransactionType" стал равен 'Payment from customer'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
		И     элемент формы с именем "TransactionType" стал равен 'Currency exchange'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
		И     элемент формы с именем "TransactionType" стал равен 'Cash transfer order'
	И Я закрыл все окна клиентского приложения

Сценарий: проверяю фильтр по контрагенту в табличной части в документах оплаты
	# when selecting a partner, only its legal names should be available on the selection list
	И я нажимаю на кнопку с именем 'FormCreate'
	И я заполняю данные по партнеру
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ferron BP   |
		И в таблице "List" я выбираю текущую строку
	Check the filter by контрагенту
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payee"
		И я запоминаю количество строк таблицы "List" как "QS"
		Тогда переменная "QS" имеет значение 1
		Тогда таблица "List" содержит строки:
		| Description       |
		| Company Ferron BP |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к следующему реквизиту
		И Пауза 2
		И     таблица "PaymentList" содержит строки:
		| Partner   | Payee             |
		| Ferron BP | Company Ferron BP |
	И Я закрыл все окна клиентского приложения

Сценарий: проверяю фильтр по контрагенту в табличной части в документах поступления оплаты
	# when selecting a partner, only its legal names should be available on the selection list
	И я нажимаю на кнопку с именем 'FormCreate'
	И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
	И я заполняю данные по партнеру
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ferron BP   |
		И в таблице "List" я выбираю текущую строку
	Check the filter by контрагенту
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payer"
		И я запоминаю количество строк таблицы "List" как "QS"
		Тогда переменная "QS" имеет значение 1
		Тогда таблица "List" содержит строки:
		| Description       |
		| Company Ferron BP |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к следующему реквизиту
		И Пауза 2
		И     таблица "PaymentList" содержит строки:
		| Partner   | Payer             |
		| Ferron BP | Company Ferron BP |
	И Я закрыл все окна клиентского приложения

Сценарий: проверяю фильтр по партнеру в табличной части в документах оплаты
	# when selecting a legal name, only its partners should be available on the partner selection list
	И я нажимаю на кнопку с именем 'FormCreate'
	И я заполняю данные по контрагенту
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payee"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Company Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
	Check the filter by партнеру
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И я запоминаю количество строк таблицы "List" как "QS"
		Тогда переменная "QS" имеет значение 1
		Тогда таблица "List" содержит строки:
		| Description     |
		| Ferron BP       |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к следующему реквизиту
		И     таблица "PaymentList" содержит строки:
		| Partner   | Payee             |
		| Ferron BP | Company Ferron BP |
	И Я закрыл все окна клиентского приложения

Сценарий: проверяю фильтр по партнеру в табличной части в документах поступления оплаты
	# when selecting a legal name, only its partners should be available on the partner selection list
	И я нажимаю на кнопку с именем 'FormCreate'
	И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
	И я заполняю данные по контрагенту
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payer"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Company Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
	Check the filter by партнеру
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И я запоминаю количество строк таблицы "List" как "QS"
		Тогда переменная "QS" имеет значение 1
		Тогда таблица "List" содержит строки:
		| Description     |
		| Ferron BP       |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к следующему реквизиту
		И     таблица "PaymentList" содержит строки:
		| Partner   | Payer             |
		| Ferron BP | Company Ferron BP |
	И Я закрыл все окна клиентского приложения

Сценарий: проверяю фильтр по документам-основания в документах оплаты
	И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
	И в таблице "List" я перехожу к строке:
		| 'Description'           |
		| 'Basic Partner terms, TRY' |
	И в таблице "List" я выбираю текущую строку
	Check the filter by документам основания
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		И Пауза 2
		Тогда таблица "List" не содержит строки:
			| Legal name      | Partner |
			| Company Kalipso | Kalipso |
		И я закрываю текущее окно
	И я проверяю фильтр ещё по документам по партнеру Kalipso
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И В таблице "PaymentList" я нажимаю кнопку очистить у поля с именем "PaymentListPayee"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Kalipso   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payee"
		Тогда таблица "List" содержит строки:
			| Description       |
			| Company Kalipso |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
			| Partner   | Payee             |
			| Kalipso | Company Kalipso |
	Check the filter by документам основания
		И в таблице "PaymentList" я перехожу к строке:
			| Partner | Payee           |
			| Kalipso | Company Kalipso |
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
		И в таблице "List" я перехожу к строке:
		| 'Description'           | 'Kind'    |
		| 'Basic Partner terms, TRY' | 'Regular' |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
		И я перехожу к следующему реквизиту
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Тогда таблица "List" не содержит строки:
			| Legal name        | Partner   |
			| Company Ferron BP | Ferron BP |
	И Я закрыл все окна клиентского приложения


Сценарий: проверяю фильтр по документам-основания в документах поступления оплаты
# нужно исправить
	И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
	И в таблице "List" я перехожу к строке:
		| 'Description'           |
		| 'Basic Partner terms, TRY' |
	И в таблице "List" я выбираю текущую строку
	Check the filter by документам основания
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Тогда таблица "List" не содержит строки:
			| Legal name      | Partner |
			| Company Kalipso | Kalipso |
		# И я закрываю текущее окно
	И я проверяю фильтр ещё по документам по партнеру Kalipso
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Kalipso   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payer"
		Тогда таблица "List" содержит строки:
			| Description       |
			| Company Kalipso |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
			| Partner   | Payer             |
			| Kalipso | Company Kalipso |
	Check the filter by документам основания
		И в таблице "PaymentList" я перехожу к строке:
			| Partner | Payer           |
			| Kalipso | Company Kalipso |
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		Тогда таблица "List" не содержит строки:
			|Legal name        | Partner   |
			| Company Ferron BP | Ferron BP |
	И Я закрыл все окна клиентского приложения

Сценарий: проверяю выбор типа документа-основания в документах поступления оплаты
	И я нажимаю на кнопку с именем 'FormCreate'
	И я проверяю выбор вида документа-основания
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		# temporarily
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		# temporarily
		# Тогда таблица "List" содержит строки:
		# | Reference                                    |
		# | Purchase invoice*                            |
		# | Sales return*                                |
		Тогда таблица "List" не содержит строки:
		| Reference                                    |
		| Sales invoice*                               |
		| Purchase return*                             |
	И Я закрыл все окна клиентского приложения

Сценарий: проверяю выбор типа документа-основания в документах оплаты
	И я нажимаю на кнопку с именем 'FormCreate'
	И я проверяю выбор вида документа-основания
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		# temporarily
		Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		# temporarily
		Тогда таблица "List" не содержит строки:
		| Reference                                    |
		| Purchase invoice*                            |
		| Sales return*                                |
		# Тогда таблица "List" содержит строки:
		# | Reference                                    |
		# | Sales invoice*                               |
		# | Purchase return*                             |
	И Я закрыл все окна клиентского приложения
	
Сценарий: проверяю выбор валюты в банковском платежном документе в случае если валюта указана в счете
# поменять валюту в таком случае нельзя (документы: Bank payment, Bank reciept)
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Account"
	И в таблице "List" я перехожу к строке:
			| Description    |
			| Bank account, TRY |
	И в таблице "List" я выбираю текущую строку
	И     элемент формы с именем "Currency" стал равен 'TRY'
	И я меняю валюту с лиры на доллар
		И я нажимаю кнопку выбора у поля с именем "Currency"
		И в таблице "List" я перехожу к строке:
			| Code | Description     |
			| USD  | American dollar |
		И в таблице "List" я выбираю текущую строку
	И я проверяю, что валюта документа осталась лира
		И     элемент формы с именем "Currency" стал равен 'USD'
		И     элемент формы с именем "Account" стал равен ''
	И Я закрыл все окна клиентского приложения

Сценарий: проверяю выбор валюты в кассовом платежном документе в случае если валюта указана в счете
# поменять валюту в таком случае нельзя (документы: Cash payment, Cash reciept)
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Cash account"
	И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №4 |
	И в таблице "List" я выбираю текущую строку
	И     элемент формы с именем "Currency" стал равен 'TRY'
	И я меняю валюту с лиры на доллар
		И я нажимаю кнопку выбора у поля с именем "Currency"
		И в таблице "List" я перехожу к строке:
			| Code | Description     |
			| USD  | American dollar |
		И в таблице "List" я выбираю текущую строку
	И я проверяю, что валюта документа стала USD при этом поле Cash desk очистилось
		И     элемент формы с именем "Currency" стал равен 'USD'
		И     элемент формы с именем "CashAccount" стал равен ''
	И Я закрыл все окна клиентского приложения


Сценарий: создаю временную кассу Cash desk №4 со строго фиксированной валютой (лиры)
	И я открываю навигационную ссылку "e1cib/list/Catalog.CashAccounts"
	И Пауза 2
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле с именем 'Description_en' я ввожу текст 'Cash desk №4'
	И в поле с именем 'Description_tr' я ввожу текст 'Cash desk №4 TR'
	И я нажимаю на кнопку 'Ok'
	Тогда элемент формы с именем "Type" стал равен 'Cash'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
	И в таблице "List" я выбираю текущую строку
	И я меняю значение переключателя с именем 'CurrencyType' на 'Fixed'
	И я нажимаю кнопку выбора у поля с именем "Currency"
	И в таблице "List" я перехожу к строке:
		| Code | Description  |
		| TRY  | Turkish lira |
	И в таблице "List" я выбираю текущую строку
	И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	И Пауза 5
	Тогда В базе появился хотя бы один элемент справочника "CashAccounts"
	Тогда я проверяю наличие элемента справочника "CashAccounts" со значением поля "Description_en" "Cash desk №4"  
	Тогда я проверяю наличие элемента справочника "CashAccounts" со значением поля "Description_tr" "Cash desk №4 TR" 
