#language: ru
@tree
@Positive

Функционал: заполнение банковских чеков

Как тестировщик
Я хочу проверить заполнение формы Cheque bond transaction
Для удобства работы


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _2020001 создание тестовых данных для проверки заполнения Cheque bond transaction
	* Создание чека и его пометка на удаление
		* Открытие формы справочника
			И я открываю навигационную ссылку 'e1cib/list/Catalog.ChequeBonds'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Создание входящего чека
			И в поле 'Cheque No' я ввожу текст 'Partner cheque 101'
			И в поле 'Cheque serial No' я ввожу текст 'AN'
			И из выпадающего списка "Type" я выбираю точное значение 'Partner cheque'
			И в поле "Due date" я ввожу конец текущего месяца
			И я нажимаю кнопку выбора у поля "Currency"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Amount' я ввожу текст '10 000,00'
			И я нажимаю на кнопку 'Save and close'
		* Пометка созданного чека на удаление
			И я открываю навигационную ссылку 'e1cib/list/Catalog.ChequeBonds'
			И в таблице "List" я перехожу к строке:
			| 'Amount'    | 'Cheque No'          |
			| '10 000,00' | 'Partner cheque 101' |
			И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuSetDeletionMark'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в таблице "List" я перехожу к строке:
			| 'Amount'    | 'Cheque No'          |
			| '10 000,00' | 'Partner cheque 101' |
	* Создание ещё одного партнерского чека
		* Открытие формы справочника
			И я открываю навигационную ссылку 'e1cib/list/Catalog.ChequeBonds'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Создание входящего чека
			И в поле 'Cheque No' я ввожу текст 'Partner cheque 102'
			И в поле 'Cheque serial No' я ввожу текст 'AN'
			И из выпадающего списка "Type" я выбираю точное значение 'Partner cheque'
			И в поле "Due date" я ввожу конец текущего месяца
			И я нажимаю кнопку выбора у поля "Currency"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Amount' я ввожу текст '15 000,00'
			И я нажимаю на кнопку 'Save and close'
	* Создание Cheque bond transaction на изменение статуса чека Partner cheque 1
		* Открытие формы документа ChequeBondTransaction
			И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение основных реквизитов
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
		* Добавление чеков в табличную часть
			И в таблице "ChequeBonds" я нажимаю на кнопку с именем 'ChequeBondsAdd'
			И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Cheque"
			И в таблице "List" я перехожу к строке:
				| 'Amount'   | 'Cheque No'        |
				| '2 000,00' | 'Partner cheque 1' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ChequeBonds" я активизирую поле "New status"
			И в таблице "ChequeBonds" из выпадающего списка "New status" я выбираю точное значение '02. GiveToBankAsAssurance'
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
		* Изменение номера
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '2'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '11'
			И я нажимаю на кнопку 'Post and close'
		* Проверка создания
			Тогда таблица "List" содержит строки
			| 'Number' |
			| '11'      |
	* Создание чека выданного поставщику
		* Открытие формы справочника
			И я открываю навигационную ссылку 'e1cib/list/Catalog.ChequeBonds'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Создание исходящего чека
			И в поле 'Cheque No' я ввожу текст 'Own cheque 2'
			И в поле 'Cheque serial No' я ввожу текст 'AL'
			И из выпадающего списка "Type" я выбираю точное значение 'Own cheque'
			И в поле "Due date" я ввожу конец текущего месяца
			И я нажимаю кнопку выбора у поля "Currency"
			И в таблице "List" я перехожу к строке:
				| 'Code' |
				| 'TRY'  |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Amount' я ввожу текст '10 000,00'
			И я нажимаю на кнопку 'Save and close'

Сценарий: _2020001 проверка отбора по собственным компаниям в документе Cheque bond transaction
	* Открытие формы документа ChequeBondTransaction
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Проверка фильтра
		Когда проверяю работу фильтра по собственной Company в Cheque bond transaction
		И я закрыл все окна клиентского приложения

Сценарий: _2020002 проверка автоматического заполнения Legal name (у партнера только одно Legal name) в документе Cheque bond transaction
	* Открытие формы документа ChequeBondTransaction
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Добавление партнера с одним Legal name
		И в таблице "ChequeBonds" я нажимаю на кнопку с именем 'ChequeBondsAdd'
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита с именем "ChequeBondsPartner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
	* Проверка заполнения Legal name
		И     таблица "ChequeBonds" содержит строки:
		| 'Legal name' | 'Partner' |
		| 'DFC'        | 'DFC'     |
		| 'DFC'        | 'DFC'     |
		И я закрыл все окна клиентского приложения

Сценарий: _2020003 проверка автоматического заполнения Partner (у Legal name только один партнер) в документе Cheque bond transaction
	* Открытие формы документа ChequeBondTransaction
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Добавление партнера с одним Legal name
		И в таблице "ChequeBonds" я нажимаю на кнопку с именем 'ChequeBondsAdd'
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
	* Проверка заполнения Legal name
		И     таблица "ChequeBonds" содержит строки:
		| 'Legal name' | 'Partner' |
		| 'DFC'        | 'DFC'     |
		И я закрыл все окна клиентского приложения

Сценарий: _2020004 проверка автоматического заполнения Agreement (у партнера только одно соглашение) в документе Cheque bond transaction
	* Создание тестовых данных
		# Удаление партнера DFC из всех сегментов и создание индивидуального соглашения
			И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'DFC'         |
			И в таблице "List" я выбираю текущую строку
			И В текущем окне я нажимаю кнопку командного интерфейса 'Partner segments'
			И в таблице 'List' я удаляю строку
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И В текущем окне я нажимаю кнопку командного интерфейса 'Agreements'
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст 'Agreement DFC'
			И я меняю значение переключателя 'Type' на 'Customer'
			И я меняю значение переключателя 'AP-AR posting detail' на 'By documents'
			И в поле 'Number' я ввожу текст '121'
			И я нажимаю кнопку выбора у поля "Currency movement type"
			И в таблице "List" я перехожу к строке:
				| 'Currency' | 'Type'      |
				| 'TRY'      | 'Agreement' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Price type"
			И в таблице "List" я перехожу к строке:
				| 'Currency' | 'Description'             |
				| 'TRY'      | 'Basic Price without VAT' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Start using' я ввожу текст '01.01.2019'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
	* Открытие формы документа ChequeBondTransaction
			И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
			И я нажимаю на кнопку с именем 'FormCreate'
	* Добавление партнера с одним соглашением
			И в таблице "ChequeBonds" я нажимаю на кнопку с именем 'ChequeBondsAdd'
			И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'DFC'         |
			И в таблице "List" я выбираю текущую строку
	* Проверка заполнения соглашения
			И     таблица "ChequeBonds" содержит строки:
				| 'Partner' | 'Agreement'     |
				| 'DFC'     | 'Agreement DFC' |
			И я закрыл все окна клиентского приложения

Сценарий: _2020005 проверка отбора только доступных для партнера соглашений в документе Cheque bond transaction
	* Открытие формы документа ChequeBondTransaction
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Добавление партнера с одним соглашением
		И в таблице "ChequeBonds" я нажимаю на кнопку с именем 'ChequeBondsAdd'
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
	* Проверка доступности для выбора только одного соглашения
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Agreement"
		Тогда таблица "List" стала равной:
			| 'Description'   |
			| 'Agreement DFC' |
		И я закрыл все окна клиентского приложения

Сценарий: _2020006 проверка на очистку поля соглашения после перевыбора партнера (выбранного соглашения у нового партнера нет)
	* Открытие формы документа ChequeBondTransaction
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Добавление партнера с одним соглашением
		И в таблице "ChequeBonds" я нажимаю на кнопку с именем 'ChequeBondsAdd'
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
	* Заполнение соглашения
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Agreement DFC' |
		И в таблице "List" я выбираю текущую строку
	* Перевыбор партнера 
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Big foot'         |
		И в таблице "List" я выбираю текущую строку
	* Проверка очистки поля Agreement
		И     таблица "ChequeBonds" содержит строки:
			| 'Partner'  | 'Agreement' |
			| 'Big foot' | ''          |
		И я закрыл все окна клиентского приложения
		
Сценарий: _2020007 проверка фильтра по чекам в форме выбора 'Cheque bonds' в зависимости от выбранной валюты (перевыбор) и разделения чеков по Partners/Own
	* Открытие формы документа ChequeBondTransaction
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Выбор валюты USD и проверка отсутствия чеков в списке выбора с валютой TRY
		* Выбор валюты
			И я нажимаю кнопку выбора у поля с именем "Currency"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'     |
				| 'USD'  | 'American dollar' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ChequeBonds" я нажимаю на кнопку 'Fill cheques'
		* Проверка того, что в форме выбора нет чеков
			И я меняю значение переключателя 'ChequeBondType' на 'Partner'
			Тогда в таблице "List" количество строк "равно" 0
			И я меняю значение переключателя 'ChequeBondType' на 'Own'
			Тогда в таблице "List" количество строк "равно" 0
			И Я закрываю окно 'Cheque bonds'
	* Проверка того, что в форме выбора отображаются чеки с валютой TRY после перевыбора и разделение чеков на Partners/Own
		* Выбор валюты
			И я нажимаю кнопку выбора у поля с именем "Currency"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			И в таблице "List" я выбираю текущую строку
		* Проверка того, что в форме выбора отображаются чеки
			И в таблице "ChequeBonds" я нажимаю на кнопку 'Fill cheques'
			И я меняю значение переключателя 'ChequeBondType' на 'Partner'
			Тогда таблица "List" содержит строки:
				| 'Cheque No'        | 'Currency' |
				| 'Partner cheque 1' | 'TRY'      |
			Тогда таблица "List" не содержит строки
				| 'Cheque No'    | 'Currency' |
				| 'Own cheque 1' | 'TRY'      |
			И я меняю значение переключателя 'ChequeBondType' на 'Own'
			Тогда таблица "List" содержит строки
				| 'Cheque No'    | 'Currency' |
				| 'Own cheque 1' | 'TRY'      |
			Тогда таблица "List" не содержит строки:
				| 'Cheque No'        | 'Currency' |
				| 'Partner cheque 1' | 'TRY'      |
			И Я закрываю окно 'Cheque bonds'
	И я закрыл все окна клиентского приложения

Сценарий: _2020008 неотображения помеченных на удаление чеков в форме выбора 'Cheque bonds'
	* Открытие формы документа ChequeBondTransaction
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Выбор валюты TRY
		И я нажимаю кнопку выбора у поля с именем "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' |
			| 'TRY'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я нажимаю на кнопку 'Fill cheques'
	* Проверка что помеченный на удаление чек в списке выбора не отображается
		И я меняю значение переключателя 'ChequeBondType' на 'Partner'
		Тогда таблица "List" не содержит строки:
			| 'Cheque No'          | 'Currency' |
			| 'Partner cheque 101' | 'TRY'      |
	И я закрыл все окна клиентского приложения

Сценарий: _2020009 проверка отбора чеков по статусам в форме выбора 'Cheque bonds'
	* Открытие формы документа ChequeBondTransaction
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Выбор валюты TRY
		И я нажимаю кнопку выбора у поля с именем "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' |
			| 'TRY'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я нажимаю на кнопку 'Fill cheques'
	* Проверка отбора по статусам
		Когда открылось окно 'Cheque bonds'
		И я меняю значение переключателя 'ChequeBondType' на 'Own'
		И я устанавливаю флаг 'StatusCheck'
		И я нажимаю кнопку выбора у поля с именем "StatusSelection"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '02. Payed'   |
		И в таблице "List" я выбираю текущую строку
		Тогда таблица "List" не содержит строки
			| 'Cheque No'    | 'Currency' |
			| 'Own cheque 1' | 'TRY'      |
		И я меняю значение переключателя 'ChequeBondType' на 'Partner'
		И я устанавливаю флаг 'StatusCheck'
		И я нажимаю кнопку выбора у поля с именем "StatusSelection"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '02. GiveToBankAsAssurance'   |
		И в таблице "List" я выбираю текущую строку
		Тогда таблица "List" содержит строки:
		| 'Cheque No'        | 'Status'                    | 'Type'           |
		| 'Partner cheque 1' | '02. GiveToBankAsAssurance' | 'Partner cheque' |
		Тогда таблица "List" не содержит строки:
		| 'Cheque No'          | 'Status'                    | 'Type'           |
		| 'Partner cheque 102' | ''                          | 'Partner cheque' |
	* Проверка сброса фильтра отбора по статусам
		И я снимаю флаг 'StatusCheck'
		Тогда таблица "List" содержит строки:
		| 'Cheque No'          | 'Status'                    |
		| 'Partner cheque 1'   | '02. GiveToBankAsAssurance' |
		| 'Partner cheque 102' | ''                          |
	И я закрыл все окна клиентского приложения
		
Сценарий: _2020010 проверка удаления выбранных чеков в форме выбора 'Cheque bonds'
	* Открытие формы документа ChequeBondTransaction
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Выбор валюты TRY
		И я нажимаю кнопку выбора у поля с именем "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' |
			| 'TRY'  |
		И в таблице "List" я выбираю текущую строку
	* Открытие формы выбора чеков и проверка удаления добавленных чеков
		И в таблице "ChequeBonds" я нажимаю на кнопку 'Fill cheques'
		И я меняю значение переключателя 'ChequeBondType' на 'Partner'
		И в таблице "List" я перехожу к строке:
			| 'Amount'    | 'Cheque No'          |
			| '15 000,00' | 'Partner cheque 102' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "List" я перехожу к строке:
			| 'Amount'   | 'Cheque No'        |
			| '2 000,00' | 'Partner cheque 1' |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PickedCheckBonds" содержит строки:
			| 'Cheque No'          | 'Cheque serial No' | 'Amount'    | 'Type'           | 'Currency' |
			| 'Partner cheque 102' | 'AN'               | '15 000,00' | 'Partner cheque' | 'TRY'      |
			| 'Partner cheque 1'   | 'AA'               | '2 000,00'  | 'Partner cheque' | 'TRY'      |
		И в таблице "PickedCheckBonds" я перехожу к строке:
			| 'Amount'   | 'Cheque No'        | 'Cheque serial No' | 'Currency' | 'Type'           |
			| '2 000,00' | 'Partner cheque 1' | 'AA'               | 'TRY'      | 'Partner cheque' |
		И в таблице "PickedCheckBonds" я активизирую поле с именем "PickedCheckBondsChequeBondType"
		И в таблице 'PickedCheckBonds' я удаляю строку
		И     таблица "PickedCheckBonds" не содержит строки:
			| 'Cheque No'          | 'Cheque serial No' | 'Amount'    | 'Type'           | 'Currency' |
			| 'Partner cheque 1'   | 'AA'               | '2 000,00'  | 'Partner cheque' | 'TRY'      |
	И я закрыл все окна клиентского приложения

Сценарий: _2020011 проверка фильтра по действующим соглашениям в зависимости от даты Cheque bond transaction
	* Создание Cheque bond transaction на изменение статуса чека Partner cheque 1
		* Открытие формы документа ChequeBondTransaction
			И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение основных реквизитов
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
		* Добавление чеков в табличную часть
			И в таблице "ChequeBonds" я нажимаю на кнопку с именем 'ChequeBondsAdd'
			И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Cheque"
			И в таблице "List" я перехожу к строке:
				| 'Amount'   | 'Cheque No'        |
				| '2 000,00' | 'Partner cheque 1' |
			И в таблице "List" я выбираю текущую строку
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
				| 'Agreement DFC' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ChequeBonds" я завершаю редактирование строки
		* Проверка доступных соглашений при перевыборе даты
			И я перехожу к закладке "Other"
			И в поле 'Date' я ввожу текст '17.01.2016  0:00:00'
			И я перехожу к закладке "Cheques"
			И в таблице "ChequeBonds" я активизирую поле "Legal name"
			И в таблице "ChequeBonds" я активизирую поле "Agreement"
			И в таблице "ChequeBonds" я выбираю текущую строку
			И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Agreement"
			Тогда в таблице "List" количество строк "равно" 0
		И я закрыл все окна клиентского приложения

Сценарий: _2020012 проверка ввода статусов чеков по строке
	* Открытие формы документа ChequeBondTransaction
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение данных и выбор чека
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
		И в таблице "ChequeBonds" я нажимаю на кнопку с именем 'ChequeBondsAdd'
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Cheque"
		И в таблице "List" я перехожу к строке:
			| 'Amount'   | 'Cheque No'        | 'Cheque serial No' |
			| '2 000,00' | 'Partner cheque 1' | 'AA'               |
		И в таблице "List" я выбираю текущую строку
	* Проверка заполнения статусов при вводе по строке
		И в таблице "ChequeBonds" я активизирую поле "New status"
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "New status"
		И в таблице "ChequeBonds" из выпадающего списка "New status" я выбираю по строке '03'
		И     таблица "ChequeBonds" содержит строки:
			| 'Cheque'           | 'Status'                    | 'New status'          |
			| 'Partner cheque 1' | '02. GiveToBankAsAssurance' | '03. PaymentReceived' |
		И в таблице "ChequeBonds" из выпадающего списка "New status" я выбираю по строке '04'
		И     таблица "ChequeBonds" содержит строки:
			| 'Cheque'           | 'Status'                    | 'New status'          |
			| 'Partner cheque 1' | '02. GiveToBankAsAssurance' | '04. Protested' |
		И в таблице "ChequeBonds" из выпадающего списка "New status" я выбираю по строке 're'
		И     таблица "ChequeBonds" содержит строки:
			| 'Cheque'           | 'Status'                    | 'New status'          |
			| 'Partner cheque 1' | '02. GiveToBankAsAssurance' | '03. PaymentReceived' |
		И в таблице "ChequeBonds" из выпадающего списка "New status" я выбираю по строке '03'
		И     таблица "ChequeBonds" содержит строки:
			| 'Cheque'           | 'Status'                    | 'New status'          |
			| 'Partner cheque 1' | '02. GiveToBankAsAssurance' | '03. PaymentReceived' |
		И в таблице "ChequeBonds" я завершаю редактирование строки
		И в таблице "ChequeBonds" из выпадающего списка "New status" я выбираю по строке '03'
		И     таблица "ChequeBonds" содержит строки:
			| 'Cheque'           | 'Status'                    | 'New status'          |
			| 'Partner cheque 1' | '02. GiveToBankAsAssurance' | '03. PaymentReceived' |
		И в таблице "ChequeBonds" я завершаю редактирование строки
		И я закрыл все окна клиентского приложения

Сценарий: _2020013 проверка отбора документов оснований для распределения суммы чека выданного поставщику
	* Проверка наличия sales invoice 3000
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		Тогда таблица "List" содержит строки:
		| 'Number'          |
		| '1'  |
		И я закрыл все окна клиентского приложения
	* Открытие формы документа ChequeBondTransaction
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Выбор валюты TRY
		И я нажимаю кнопку выбора у поля с именем "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' |
			| 'TRY'  |
		И в таблице "List" я выбираю текущую строку
	* Добавление чека
		И в таблице "ChequeBonds" я нажимаю на кнопку 'Fill cheques'
		И в таблице "List" я перехожу к строке:
			| 'Cheque No'    | 
			| 'Own cheque 2' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Transfer to document'
		И в таблице "ChequeBonds" я перехожу к строке:
			| 'Amount'    | 'Cheque'       | 'Currency' | 'New status'         |
			| '10 000,00' | 'Own cheque 2' | 'TRY'      | '01. GivenToPartner' |
		И в таблице "ChequeBonds" я активизирую поле "Partner"
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я активизирую поле "Agreement"
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я активизирую поле "Legal name"
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Company Ferron BP' |
		И в таблице "List" я выбираю текущую строку
	* Заполнение документа для распределения
		И в таблице "PaymentList" я нажимаю на кнопку 'Fill'
		Тогда открылось окно 'Select basis documents in Cheque bond transaction'
		И в таблице "DocumentsList" я перехожу к строке:
			| 'Currency' | 'Document amount' |
			| 'TRY'      | '137 000'         |
		И в таблице "DocumentsList" я выбираю текущую строку
		И в таблице "PickedDocuments" в поле 'Amount balance' я ввожу текст '9 000,00'
		И в таблице "PickedDocuments" я завершаю редактирование строки
		И в таблице "DocumentsList" я нажимаю на кнопку 'Transfer to document'
	* Заполнение Cash account
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Cash account"
		Тогда открылось окно 'Cash accounts'
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Проведение ChequeBondTransaction и проверка движений
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Cheque bond transaction *'             | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| 'Document registrations records'        | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Cheque bond statuses"'      | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources'          | 'Dimensions'   | 'Attributes'     | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | 'Status'             | 'Cheque'       | 'Author'         | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | '*'           | '01. GivenToPartner' | 'Own cheque 2' | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| 'Own cheque 2'                          | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Planing cash transactions"' | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources'          | 'Dimensions'   | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | 'Amount'             | 'Company'      | 'Basis document' | 'Account'             | 'Currency'          | 'Cash flow direction' | 'Partner'            | 'Legal name'               | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'           | '1 712,33'           | 'Main Company' | 'Own cheque 2'   | 'Bank account, TRY'   | 'USD'               | 'Outgoing'            | 'Ferron BP'          | 'Company Ferron BP'        | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'           | '10 000'             | 'Main Company' | 'Own cheque 2'   | 'Bank account, TRY'   | 'TRY'               | 'Outgoing'            | 'Ferron BP'          | 'Company Ferron BP'        | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'           | '10 000'             | 'Main Company' | 'Own cheque 2'   | 'Bank account, TRY'   | 'TRY'               | 'Outgoing'            | 'Ferron BP'          | 'Company Ferron BP'        | 'Local currency'           | 'No'                   |
		| ''                                      | '*'           | '10 000'             | 'Main Company' | 'Own cheque 2'   | 'Bank account, TRY'   | 'TRY'               | 'Outgoing'            | 'Ferron BP'          | 'Company Ferron BP'        | 'TRY'                      | 'No'                   |
		| ''                                      | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'                       | ''                    | ''                    | ''                    | ''               | ''                                             | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                                     | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                             | ''                  | 'Dimensions'          | ''                   | ''                         | ''                         | ''                     |
		| ''                                                     | ''                    | ''                    | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers'                       | 'Transaction AR'    | 'Company'             | 'Partner'            | 'Legal name'               | 'Basis document'           | 'Currency'             |
		| ''                                                     | 'Receipt'             | '*'                   | ''                    | ''               | '-1 000'                                       | ''                  | 'Main Company'        | 'Ferron BP'          | 'Company Ferron BP'        | ''                         | 'TRY'                  |
		| ''                                                     | 'Receipt'             | '*'                   | '1 000'               | ''               | ''                                             | ''                  | 'Main Company'        | 'Ferron BP'          | 'Company Ferron BP'        | ''                         | 'TRY'                  |
		| ''                                                     | 'Expense'             | '*'                   | ''                    | '9 000'          | ''                                             | ''                  | 'Main Company'        | 'Ferron BP'          | 'Company Ferron BP'        | 'Purchase invoice 1*'      | 'TRY'                  |
		| ''                                                     | ''                    | ''                    | ''                    | ''               | ''                                             | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Cheque bond balance"'       | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'             | 'Resources'    | 'Dimensions'     | ''                    | ''                  | ''                    | ''                   | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | ''                   | 'Amount'       | 'Company'        | 'Cheque'              | 'Partner'           | 'Legal name'          | 'Currency'           | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '1 712,33'     | 'Main Company'   | 'Own cheque 2'        | 'Ferron BP'         | 'Company Ferron BP'   | 'USD'                | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '10 000'       | 'Main Company'   | 'Own cheque 2'        | 'Ferron BP'         | 'Company Ferron BP'   | 'TRY'                | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '10 000'       | 'Main Company'   | 'Own cheque 2'        | 'Ferron BP'         | 'Company Ferron BP'   | 'TRY'                | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '10 000'       | 'Main Company'   | 'Own cheque 2'        | 'Ferron BP'         | 'Company Ferron BP'   | 'TRY'                | 'TRY'                      | 'No'                       | ''                     |
		| ''                                      | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'             | 'Resources'    | 'Dimensions'     | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                   | 'Amount'       | 'Company'        | 'Legal name'          | 'Currency'          | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '10 000'       | 'Main Company'   | 'Company Ferron BP'   | 'TRY'               | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Advance to suppliers"'      | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'             | 'Resources'    | 'Dimensions'     | ''                    | ''                  | ''                    | ''                   | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | ''                   | 'Amount'       | 'Company'        | 'Partner'             | 'Legal name'        | 'Currency'            | 'Payment document'   | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '171,23'       | 'Main Company'   | 'Ferron BP'           | 'Company Ferron BP' | 'USD'                 | 'Own cheque 2'       | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '1 000'        | 'Main Company'   | 'Ferron BP'           | 'Company Ferron BP' | 'TRY'                 | 'Own cheque 2'       | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '1 000'        | 'Main Company'   | 'Ferron BP'           | 'Company Ferron BP' | 'TRY'                 | 'Own cheque 2'       | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Partner AP transactions"'   | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'             | 'Resources'    | 'Dimensions'     | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | ''                   | 'Amount'       | 'Company'        | 'Basis document'      | 'Partner'           | 'Legal name'          | 'Agreement'          | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                      | 'Expense'     | '*'                  | '1 541,1'      | 'Main Company'   | 'Purchase invoice 1*' | 'Ferron BP'         | 'Company Ferron BP'   | 'Vendor Ferron, TRY' | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                      | 'Expense'     | '*'                  | '9 000'        | 'Main Company'   | 'Purchase invoice 1*' | 'Ferron BP'         | 'Company Ferron BP'   | 'Vendor Ferron, TRY' | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                      | 'Expense'     | '*'                  | '9 000'        | 'Main Company'   | 'Purchase invoice 1*' | 'Ferron BP'         | 'Company Ferron BP'   | 'Vendor Ferron, TRY' | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                      | 'Expense'     | '*'                  | '9 000'        | 'Main Company'   | 'Purchase invoice 1*' | 'Ferron BP'         | 'Company Ferron BP'   | 'Vendor Ferron, TRY' | 'TRY'                      | 'TRY'                      | 'No'                   |
		И Я закрыл все окна клиентского приложения

Сценарий: _2020014 проверка очистки чеков из документа Cheque bond transaction при изменении валюты
	* Открытие формы документа ChequeBondTransaction
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Выбор валюты TRY
		И я нажимаю кнопку выбора у поля с именем "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' |
			| 'TRY'  |
		И в таблице "List" я выбираю текущую строку
	* Добавление чека
		И в таблице "ChequeBonds" я нажимаю на кнопку 'Fill cheques'
		И в таблице "List" я перехожу к строке:
			| 'Cheque No'    | 
			| 'Own cheque 2' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Transfer to document'
		И в таблице "ChequeBonds" я перехожу к строке:
			| 'Amount'    | 'Cheque'       | 'Currency' |
			| '10 000,00' | 'Own cheque 2' | 'TRY'      |
		И в таблице "ChequeBonds" я активизирую поле "Partner"
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я активизирую поле "Agreement"
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я активизирую поле "Legal name"
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Company Ferron BP' |
		И в таблице "List" я выбираю текущую строку
	* Перевыбор валюты
		И я нажимаю кнопку выбора у поля с именем "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' |
			| 'USD'  |
		И в таблице "List" я выбираю текущую строку
	* Проверка того что валюта не перезаполниться если нажать No в окне-предупреждении
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'No'
		И     элемент формы с именем "Currency" стал равен 'TRY'
	* Проверка удаления чека из табличной части в случае перевыбора валюты
		И я нажимаю кнопку выбора у поля с именем "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' |
			| 'USD'  |
		И в таблице "List" я выбираю текущую строку
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		Тогда в таблице "ChequeBonds" количество строк "равно" 0
		И я закрыл все окна клиентского приложения

Сценарий: _2020015 отмена проведения Cheque bond transaction и проверка отмены проводок Cheque bond items
	* Выбор нужного Cheque bond transaction
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'  |
	* Распроведение Cheque bond transaction и проверка отмены движений
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я нажимаю на кнопку 'Registrations report'
		Тогда открылось окно 'Document registrations report'
		И табличный документ "ResultTable" не содержит значения:
			| Register  "Cheque bond statuses" |
			| Register  "Planing cash transactions" |
			| Register  "Cheque bond balance" |
			| Register  "Reconciliation statement" |
			| Register  "Advance from customers" |
		И я закрываю текущее окно
	* Проведение Cheque bond transaction повторно и проверка движений
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'  |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я нажимаю на кнопку 'Registrations report'
		Тогда открылось окно 'Document registrations report'
		И табличный документ "ResultTable" содержит значения:
			| Register  "Cheque bond statuses" |
			| Register  "Planing cash transactions" |
			| Register  "Cheque bond balance" |
			| Register  "Reconciliation statement" |
			| Register  "Advance from customers" |
		И я закрываю текущее окно
	* Пометка на удаление Cheque bond transaction и проверка отмены движений
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'  |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuSetDeletionMark'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И я нажимаю на кнопку 'Registrations report'
		Тогда открылось окно 'Document registrations report'
		И табличный документ "ResultTable" не содержит значения:
			| Register  "Cheque bond statuses" |
			| Register  "Planing cash transactions" |
			| Register  "Cheque bond balance" |
			| Register  "Reconciliation statement" |
			| Register  "Advance from customers" |
		И я закрываю текущее окно
	* Проведение Cheque bond transaction повторно после пометки на удаление и проверка движений
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuSetDeletionMark'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		Тогда открылось окно 'Cheque bond transactions'
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я нажимаю на кнопку 'Registrations report'
		Тогда открылось окно 'Document registrations report'
		И табличный документ "ResultTable" содержит значения:
			| Register  "Cheque bond statuses" |
			| Register  "Planing cash transactions" |
			| Register  "Cheque bond balance" |
			| Register  "Reconciliation statement" |
			| Register  "Advance from customers" |
		И Я закрыл все окна клиентского приложения

Сценарий: _2020016 проверка очистки чеков из документа Cheque bond transaction при изменении компании
	* Открытие формы документа ChequeBondTransaction
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Выбор компании
		И я нажимаю кнопку выбора у поля с именем "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Main Company'  |
		И в таблице "List" я выбираю текущую строку
	* Выбор валюты TRY
		И я нажимаю кнопку выбора у поля с именем "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' |
			| 'TRY'  |
		И в таблице "List" я выбираю текущую строку
	* Добавление чека
		И в таблице "ChequeBonds" я нажимаю на кнопку 'Fill cheques'
		И в таблице "List" я перехожу к строке:
			| 'Cheque No'    | 
			| 'Own cheque 2' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Transfer to document'
		И в таблице "ChequeBonds" я перехожу к строке:
			| 'Amount'    | 'Cheque'       | 'Currency' |
			| '10 000,00' | 'Own cheque 2' | 'TRY'      |
		И в таблице "ChequeBonds" я активизирую поле "Partner"
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я активизирую поле "Agreement"
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ChequeBonds" я активизирую поле "Legal name"
		И в таблице "ChequeBonds" я нажимаю кнопку выбора у реквизита "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Company Ferron BP' |
		И в таблице "List" я выбираю текущую строку
	* Перевыбор компании
		И я нажимаю кнопку выбора у поля с именем "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Second Company'  |
		И в таблице "List" я выбираю текущую строку
	* Проверка того что компания не перезаполниться если нажать No в окне-предупреждении
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'No'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	* Проверка удаления чека из табличной части в случае перевыбора компании
		И я нажимаю кнопку выбора у поля с именем "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Second Company'  |
		И в таблице "List" я выбираю текущую строку
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		Тогда в таблице "ChequeBonds" количество строк "равно" 0
		И я закрыл все окна клиентского приложения
			

