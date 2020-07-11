#language: ru
@tree
@Positive
Функционал: form Reconcilation statement

As an accountant
I want to create a Reconcilation statement
For reconciliation of settlements

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.



Сценарий: _060004 check that the Reconcilation statement document is connected to the status system
	* Creating statuses for the document Reconciliation Statement
		И я открываю навигационную ссылку "e1cib/list/Catalog.ObjectStatuses"
		И в таблице "List" я разворачиваю строку:
			| 'Description'    |
			| 'Objects status history' |
		И в таблице "List" я перехожу к строке:
			| Predefined data item name |
			| ReconciliationStatement                |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Reconciliation statement'
		И в поле 'TR' я ввожу текст 'Reconciliation statement TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
		* Adding status "Send"
			И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'Reconciliation statement' |
			И я нажимаю на кнопку с именем 'FormCreate'
			И я устанавливаю флаг 'Set by default'
			И я нажимаю на кнопку открытия поля с именем "Description_en"
			И в поле 'ENG' я ввожу текст 'Send'
			И в поле 'TR' я ввожу текст 'Send TR'
			И я нажимаю на кнопку 'Ok'
			И я нажимаю на кнопку 'Save and close'
			И Пауза 2
		* Adding status "Approved"
			И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'Reconciliation statement' |
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю на кнопку открытия поля с именем "Description_en"
			И в поле 'ENG' я ввожу текст 'Approved'
			И в поле 'TR' я ввожу текст 'Approved TR'
			И я нажимаю на кнопку 'Ok'
			И я нажимаю на кнопку 'Save and close'
			И Пауза 2
	* Check if they are filled out in the document Reconciliation Statement
		И я открываю навигационную ссылку "e1cib/list/Document.ReconciliationStatement"
		И я нажимаю на кнопку с именем 'FormCreate'
		И     элемент формы с именем "Status" стал равен 'Send'
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И Я закрыл все окна клиентского приложения

Сценарий: _060005 availability of Currency, Begin and End period field in Reconcilation statement
	И я открываю навигационную ссылку "e1cib/list/Document.ReconciliationStatement"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Currency"
	И в таблице "List" я перехожу к строке:
		| 'Code' | 'Description'  |
		| 'TRY'  | 'Turkish lira' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Begin period"
	И в поле 'Begin period' я ввожу текст '01.09.2019'
	И в поле 'End period' я ввожу текст   '30.09.2019'
	И     у элемента формы с именем "BeginPeriod" текст редактирования стал равен '01.09.2019'
	И     у элемента формы с именем "EndPeriod" текст редактирования стал равен '30.09.2019'
	И     элемент формы с именем "Currency" стал равен 'TRY'









	