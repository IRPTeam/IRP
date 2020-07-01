#language: ru
@tree
@Positive


Функционал: filling in exchange rates in registers

As an accountant
I want to fill out the exchange rate
To use multi-currency accounting

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _006101 filling in exchange rates in registers
* Opening of register CurrencyRates
	И я открываю навигационную ссылку 'e1cib/list/InformationRegister.CurrencyRates'
	И я удаляю все записи РегистрСведений "CurrencyRates"
* Filling the lira to euro rate
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Currency from"
	И в таблице "List" я перехожу к строке:
		| Code |
		| TRY  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Currency to"
	И в таблице "List" я перехожу к строке:
		| Code |
		| EUR  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Source"
	И в таблице "List" я перехожу к строке:
		| Description    |
		| Forex Seling |
	И в таблице "List" я выбираю текущую строку
	И в поле 'Multiplicity' я ввожу текст '1'
	И в поле 'Rate' я ввожу текст '6,54'
	И в поле 'Period' я ввожу текст '21.06.2019 17:40:13'
	И я нажимаю на кнопку 'Save and close'
* Filling the lira to USD rate
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Currency from"
	И в таблице "List" я перехожу к строке:
		| Code |
		| TRY  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Currency to"
	И в таблице "List" я перехожу к строке:
		| Code |
		| USD  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Source"
	И в таблице "List" я перехожу к строке:
		| Description    |
		| Forex Seling |
	И в таблице "List" я выбираю текущую строку
	И в поле 'Multiplicity' я ввожу текст '1'
	И в поле 'Rate' я ввожу текст '5,84'
	И в поле 'Period' я ввожу текст '21.06.2019 17:40:13'
	И я нажимаю на кнопку 'Save and close'
* Filling the lira to lira rate
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Currency from"
	И в таблице "List" я перехожу к строке:
		| Code |
		| TRY  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Currency to"
	И в таблице "List" я перехожу к строке:
		| Code |
		| TRY  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Source"
	И в таблице "List" я перехожу к строке:
		| Description    |
		| Forex Seling |
	И в таблице "List" я выбираю текущую строку
	И в поле 'Multiplicity' я ввожу текст '1'
	И в поле 'Rate' я ввожу текст '1'
	И в поле 'Period' я ввожу текст '01.01.2019 17:40:13'
	И я нажимаю на кнопку 'Save and close'
* Filling the USD to euro rate
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Currency from"
	И в таблице "List" я перехожу к строке:
		| Code |
		| USD  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Currency to"
	И в таблице "List" я перехожу к строке:
		| Code |
		| EUR  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Source"
	И в таблице "List" я перехожу к строке:
		| Description    |
		| Forex Seling |
	И в таблице "List" я выбираю текущую строку
	И в поле 'Multiplicity' я ввожу текст '1'
	И в поле 'Rate' я ввожу текст '0,8900'
	И в поле 'Period' я ввожу текст '21.06.2019 17:40:13'
	И я нажимаю на кнопку 'Save and close'
* Filling the USD to lira rate
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Currency from"
	И в таблице "List" я перехожу к строке:
		| Code |
		| USD  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Currency to"
	И в таблице "List" я перехожу к строке:
		| Code |
		| TRY  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Source"
	И в таблице "List" я перехожу к строке:
		| Description    |
		| Forex Seling |
	И в таблице "List" я выбираю текущую строку
	И в поле 'Multiplicity' я ввожу текст '1'
	И в поле 'Rate' я ввожу текст '0,1770'
	И в поле 'Period' я ввожу текст '21.06.2019 17:40:13'
	И я нажимаю на кнопку 'Save and close'
	