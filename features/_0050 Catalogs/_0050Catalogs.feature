#language: ru
@tree
@Positive
@Test


Функционал: filling in catalogs

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий
	И Я устанавливаю в константу "ShowBetaTesting" значение "True"
	И Я устанавливаю в константу "ShowAlfaTestingSaas" значение "True"
	И Я устанавливаю в константу "UseItemKey" значение "True"
	И Я устанавливаю в константу "UseCompanies" значение "True"



Сценарий: _005010 filling in the "Countries" catalog
	* Clearing the Countries catalog
		И    Я закрыл все окна клиентского приложения
		И я удаляю все элементы Справочника "Countries"
		И в базе нет элементов Справочника "Countries"
	* Opening the Country creation form
		И я открываю навигационную ссылку "e1cib/list/Catalog.Countries"
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
	* Data Filling - Turkey
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Turkey'
		И в поле 'TR' я ввожу текст 'Turkey TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		Тогда В базе появился хотя бы один элемент справочника "Countries"
	* Data Filling - Ukraine and Kazakhstan
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Ukraine'
		И в поле с именем 'Description_tr' я ввожу текст 'Ukraine TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Kazakhstan'
		И в поле с именем 'Description_tr' я ввожу текст 'Kazakhstan TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Checking for added countries in the catalog
		Тогда я проверяю наличие элемента справочника "Countries" со значением поля "Description_en" "Turkey"
		Тогда я проверяю наличие элемента справочника "Countries" со значением поля "Description_tr" "Turkey TR"
		Тогда я проверяю наличие элемента справочника "Countries" со значением поля "Description_en" "Kazakhstan"
		Тогда я проверяю наличие элемента справочника "Countries" со значением поля "Description_en" "Ukraine"



Сценарий: _005011 filling in the "Currencies" catalog
	* Clearing the Currencies catalog
		И я удаляю все элементы Справочника "Currencies"
		И в базе нет элементов Справочника "Currencies"
	* Opening the Currency creation form
		И я открываю навигационную ссылку "e1cib/list/Catalog.Currencies"
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
	* Creating currencies: Turkish lira, American dollar, Euro, Ukraine Hryvnia
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Turkish lira'
		И в поле с именем 'Description_tr' я ввожу текст 'Turkish lira'
		И я нажимаю на кнопку 'Ok'
		И в поле 'Symbol' я ввожу текст 'TL'
		И в поле 'Code' я ввожу текст 'TRY'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'American dollar'
		И в поле с именем 'Description_tr' я ввожу текст 'American dollar'
		И я нажимаю на кнопку 'Ok'
		И в поле 'Symbol' я ввожу текст '$'
		И в поле 'Code' я ввожу текст 'USD'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Euro'
		И в поле с именем 'Description_tr' я ввожу текст 'Euro'
		И я нажимаю на кнопку 'Ok'
		И в поле 'Symbol' я ввожу текст '€'
		И в поле 'Code' я ввожу текст 'EUR'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Ukraine Hryvnia'
		И в поле с именем 'Description_tr' я ввожу текст 'Ukraine Hryvnia'
		И я нажимаю на кнопку 'Ok'
		И в поле 'Symbol' я ввожу текст '₴'
		И в поле 'Code' я ввожу текст 'UAH'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Checking for added currencies in the catalog
		Тогда В базе появился хотя бы один элемент справочника "Currencies"
		Тогда я проверяю наличие элемента справочника "Currencies" со значением поля "Description_en" "Turkish lira"
		Тогда я проверяю наличие элемента справочника "Currencies" со значением поля "Description_tr" "Turkish lira"
		Тогда я проверяю наличие элемента справочника "Currencies" со значением поля "Description_en" "American dollar"
		Тогда я проверяю наличие элемента справочника "Currencies" со значением поля "Description_en" "Euro"
		Тогда я проверяю наличие элемента справочника "Currencies" со значением поля "Description_en" "Ukraine Hryvnia"


Сценарий: _005012 create integration settings to load the currency rate (without external data processing connected)
	* Creating a setting to download the Forex Seling course (tcmb.gov.tr)
		И я открываю навигационную ссылку "e1cib/list/Catalog.IntegrationSettings"
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'Description' я ввожу текст 'Forex Seling'
		И в поле 'Unique ID' я ввожу текст 'ForexSeling'
		И я нажимаю на кнопку 'Save'
		И из выпадающего списка "Integration type" я выбираю точное значение 'Currency rates'
		И я нажимаю кнопку выбора у поля "External data proc"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'ExternalTCMBGovTr' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	* Creating a setting to download the Forex Buying course (tcmb.gov.tr)
		И я открываю навигационную ссылку "e1cib/list/Catalog.IntegrationSettings"
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'Description' я ввожу текст 'Forex Buying'
		И в поле 'Unique ID' я ввожу текст 'ForexBuying'
		И я нажимаю на кнопку 'Save'
		И из выпадающего списка "Integration type" я выбираю точное значение 'Currency rates'
		И я нажимаю кнопку выбора у поля "External data proc"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'ExternalTCMBGovTr' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	* Creating a setting to download the course (bank.gov.ua)
		И я открываю навигационную ссылку "e1cib/list/Catalog.IntegrationSettings"
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'Description' я ввожу текст 'Bank UA'
		И в поле 'Unique ID' я ввожу текст 'BankUA'
		И я нажимаю на кнопку 'Save'
		И из выпадающего списка "Integration type" я выбираю точное значение 'Currency rates'
		И я нажимаю кнопку выбора у поля "External data proc"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'ExternalBankUa' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10



Сценарий: _005013 filling in the "Companies" catalog
	* Clearing the Companies catalog
		И я удаляю все элементы Справочника "Companies"
		И в базе нет элементов Справочника "Companies"
	* Opening the form for filling in
		И я открываю навигационную ссылку "e1cib/list/Catalog.Companies"
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
	* Filling in company information
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Main Company'
		И в поле с именем 'Description_tr' я ввожу текст 'Main Company TR'
		И я нажимаю на кнопку 'Ok'
		И в поле с именем 'Country' я ввожу текст 'Turkey'
		И я устанавливаю флаг 'Our'
		И я нажимаю на кнопку 'Save'
	* Filling in currency information (Local currency and Reporting currency)
		И я перехожу к закладке "Currencies"
		* Creation and addition of Local currency
			И в таблице "Currencies" я нажимаю на кнопку с именем 'CurrenciesAdd'
			И в таблице "Currencies" я нажимаю кнопку выбора у реквизита "Movement type"
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст 'Local currency'
			И я нажимаю кнопку выбора у поля "Currency"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Source"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Forex Seling' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Type" я выбираю точное значение 'Legal'
			И я нажимаю на кнопку 'Save and close'
			И Пауза 5
			И я нажимаю на кнопку с именем 'FormChoose'
			И в таблице "Currencies" я завершаю редактирование строки
		* Creation and addition of Reporting currency
			И в таблице "Currencies" я нажимаю на кнопку с именем 'CurrenciesAdd'
			И в таблице "Currencies" я нажимаю кнопку выбора у реквизита "Movement type"
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Currency"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'     |
				| 'USD'  | 'American dollar' |
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Source"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Forex Seling' |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Type" я выбираю точное значение 'Reporting'
			И в поле 'ENG' я ввожу текст 'Reporting currency'
			И я нажимаю на кнопку 'Save and close'
			И Пауза 5
			И я нажимаю на кнопку с именем 'FormChoose'
			И в таблице "Currencies" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	* Checking the availability of the created company in the catalog
		Тогда В базе появился хотя бы один элемент справочника "Companies"
		Тогда я проверяю наличие элемента справочника "Companies" со значением поля "Description_en" "Main Company" 
		Тогда я проверяю наличие элемента справочника "Companies" со значением поля "Description_tr" "Main Company TR"


Сценарий: _005017 creation Movement Type for agreement currencies
	* Opening charts of characteristic types - Currency movement
		И я открываю навигационную ссылку "e1cib/list/ChartOfCharacteristicTypes.CurrencyMovementType"
	* Create currency for agreements - TRY
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'TRY'
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Source"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Forex Seling' |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Type" я выбираю точное значение 'Agreement'
		И я нажимаю на кнопку 'Save and close'
	* Create currency for agreements - EUR
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'EUR'
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description' |
			| 'EUR'  | 'Euro'        |
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Source"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Forex Seling' |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Type" я выбираю точное значение 'Agreement'
		И я нажимаю на кнопку 'Save and close'
	* Create currency for agreements - USD
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'USD'
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Source"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Forex Seling' |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Type" я выбираю точное значение 'Agreement'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5


Сценарий: _005014 filling in the "Units" catalog
	* Clearing the Units catalog
		И я удаляю все элементы Справочника "Units"
		И в базе нет элементов Справочника "Units"
	* Opening the form for filling in "Units"
		И я открываю навигационную ссылку "e1cib/list/Catalog.Units"
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
	* Creating a unit of measurement 'pcs'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'pcs'
		И в поле с именем 'Description_tr' я ввожу текст 'adet'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Create a unit of measurement for 4 pcs packaging
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля с именем "BasisUnit"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'box (4 pcs)'
		И в поле с именем 'Description_tr' я ввожу текст 'box (4 adet)'
		И я нажимаю на кнопку 'Ok'
		И в поле с именем 'Quantity' я ввожу текст '4'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Create a unit of measurement for 8 pcs packaging
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля с именем "BasisUnit"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'box (8 pcs)'
		И в поле с именем 'Description_tr' я ввожу текст 'box (8 adet)'
		И я нажимаю на кнопку 'Ok'
		И в поле с именем 'Quantity' я ввожу текст '8'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Create a unit of measurement for 16 pcs packaging
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля с именем "BasisUnit"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'box (16 pcs)'
		И в поле с именем 'Description_tr' я ввожу текст 'box (16 adet)'
		И я нажимаю на кнопку 'Ok'
		И в поле с именем 'Quantity' я ввожу текст '16'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Checking for created elements
		Тогда В базе появился хотя бы один элемент справочника "Units"
		Тогда я проверяю наличие элемента справочника "Units" со значением поля "Description_en" "pcs"  
		Тогда я проверяю наличие элемента справочника "Units" со значением поля "Description_tr" "adet"
		Тогда я проверяю наличие элемента справочника "Units" со значением поля "Description_en" "box (4 pcs)"
		Тогда я проверяю наличие элемента справочника "Units" со значением поля "Description_en" "box (8 pcs)"
		Тогда я проверяю наличие элемента справочника "Units" со значением поля "Description_en" "box (16 pcs)"


Сценарий: _005015 filling in the "AccessGroups" catalog
	* Clearing the Access groups catalog
		И я удаляю все элементы Справочника "AccessGroups"
		И в базе нет элементов Справочника "AccessGroups"
	* Opening the form for filling in AccessGroups
		И я открываю навигационную ссылку "e1cib/list/Catalog.AccessGroups"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
	* Data Filling - Admin
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Admin'
		И в поле с именем 'Description_tr' я ввожу текст 'Admin TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Checking for created AccessGroups
		Тогда В базе появился хотя бы один элемент справочника "AccessGroups"
		Тогда я проверяю наличие элемента справочника "AccessGroups" со значением поля "Description_en" "Admin"  
		Тогда я проверяю наличие элемента справочника "AccessGroups" со значением поля "Description_tr" "Admin TR"

Сценарий: _005016 filling in the "AccessProfiles" catalog
	* Clearing the Access profile catalog
		И я удаляю все элементы Справочника "AccessProfiles"
		И в базе нет элементов Справочника "AccessProfiles"
	* Opening the form for filling in AccessProfiles
		И я открываю навигационную ссылку "e1cib/list/Catalog.AccessProfiles"
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
	* Data Filling - Admin
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Admin'
		И в поле с именем 'Description_tr' я ввожу текст 'Admin TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем 'RolesUpdateRoles'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Checking for created Access profiles
		Тогда В базе появился хотя бы один элемент справочника "AccessProfiles"
		Тогда я проверяю наличие элемента справочника "AccessProfiles" со значением поля "Description_en" "Admin"  
		Тогда я проверяю наличие элемента справочника "AccessProfiles" со значением поля "Description_tr" "Admin TR"




Сценарий: _005018 filling in the "Cash accounts" catalog
	* Clearing the Cash accounts catalog
		И я удаляю все элементы Справочника "CashAccounts"
		И в базе нет элементов Справочника "CashAccounts"
	* Opening the form for filling in Accounts
		И я открываю навигационную ссылку "e1cib/list/Catalog.CashAccounts"
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
	* Create and check the creation of cash account: Cash desk №1, Cash desk №2, Cash desk №3
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Cash desk №1'
		И в поле с именем 'Description_tr' я ввожу текст 'Cash desk №1 TR'
		И я нажимаю на кнопку 'Ok'
		Тогда элемент формы с именем "Type" стал равен 'Cash'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		Тогда В базе появился хотя бы один элемент справочника "CashAccounts"
		Тогда я проверяю наличие элемента справочника "CashAccounts" со значением поля "Description_en" "Cash desk №1"  
		Тогда я проверяю наличие элемента справочника "CashAccounts" со значением поля "Description_tr" "Cash desk №1 TR" 
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Cash desk №2'
		И в поле с именем 'Description_tr' я ввожу текст 'Cash desk №2 TR'
		И я нажимаю на кнопку 'Ok'
		Тогда элемент формы с именем "Type" стал равен 'Cash'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		Тогда я проверяю наличие элемента справочника "CashAccounts" со значением поля "Description_en" "Cash desk №2"  
		Тогда я проверяю наличие элемента справочника "CashAccounts" со значением поля "Description_tr" "Cash desk №2 TR" 
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Cash desk №3'
		И в поле с именем 'Description_tr' я ввожу текст 'Cash desk №3 TR'
		И я нажимаю на кнопку 'Ok'
		Тогда элемент формы с именем "Type" стал равен 'Cash'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		Тогда я проверяю наличие элемента справочника "CashAccounts" со значением поля "Description_en" "Cash desk №3"  
		Тогда я проверяю наличие элемента справочника "CashAccounts" со значением поля "Description_tr" "Cash desk №3 TR" 
	* Create and check the creation of bank account: Bank account TRY, Bank account USD, Bank account EUR
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Bank account, TRY'
		И в поле с именем 'Description_tr' я ввожу текст 'Bank account, TRY TR'
		И я нажимаю на кнопку 'Ok'
		И я меняю значение переключателя с именем "Type" на 'Bank'
		И в поле 'Number' я ввожу текст '112000000018'
		И в поле 'Bank name' я ввожу текст 'OTP'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Currency"
		И в таблице "List" я перехожу к строке:
			| Code | Description  |
			| TRY  | Turkish lira |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		Тогда я проверяю наличие элемента справочника "CashAccounts" со значением поля "Description_en" "Bank account, TRY"  
		Тогда я проверяю наличие элемента справочника "CashAccounts" со значением поля "Description_tr" "Bank account, TRY TR" 
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Bank account, USD'
		И в поле с именем 'Description_tr' я ввожу текст 'Bank account, USD TR'
		И я нажимаю на кнопку 'Ok'
		И я меняю значение переключателя с именем "Type" на 'Bank'
		И в поле 'Number' я ввожу текст '112000000019'
		И в поле 'Bank name' я ввожу текст 'OTP'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Currency"
		И в таблице "List" я перехожу к строке:
			| Code | Description     |
			| USD  | American dollar |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		Тогда я проверяю наличие элемента справочника "CashAccounts" со значением поля "Description_en" "Bank account, USD"  
		Тогда я проверяю наличие элемента справочника "CashAccounts" со значением поля "Description_tr" "Bank account, USD TR" 
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Bank account, EUR'
		И в поле с именем 'Description_tr' я ввожу текст 'Bank account, EUR TR'
		И я нажимаю на кнопку 'Ok'
		И я меняю значение переключателя с именем "Type" на 'Bank'
		И в поле 'Number' я ввожу текст '112000000020'
		И в поле 'Bank name' я ввожу текст 'OTP'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Currency"
		И в таблице "List" я перехожу к строке:
			| Code | Description |
			| EUR  | Euro        |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		Тогда я проверяю наличие элемента справочника "CashAccounts" со значением поля "Description_en" "Bank account, EUR"  
		Тогда я проверяю наличие элемента справочника "CashAccounts" со значением поля "Description_tr" "Bank account, EUR TR"
	* Create Transit bank account
		* Create Transit Main
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю на кнопку открытия поля с именем "Description_en"
			И в поле с именем 'Description_en' я ввожу текст 'Transit Main'
			И в поле с именем 'Description_tr' я ввожу текст 'Transit Main'
			И я нажимаю на кнопку 'Ok'
			И я меняю значение переключателя с именем "Type" на 'Transit'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
			И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
			И Пауза 5
			Тогда я проверяю наличие элемента справочника "CashAccounts" со значением поля "Description_en" "Transit Main"
		* Create Transit Second
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю на кнопку открытия поля с именем "Description_en"
			И в поле с именем 'Description_en' я ввожу текст 'Transit Second'
			И в поле с именем 'Description_tr' я ввожу текст 'Transit Second'
			И я нажимаю на кнопку 'Ok'
			И я меняю значение переключателя с именем "Type" на 'Transit'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
			И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
			И Пауза 5
			Тогда я проверяю наличие элемента справочника "CashAccounts" со значением поля "Description_en" "Transit Second"
	* Filling Transit account in the Bank account, TRY
		И я открываю навигационную ссылку 'e1cib/list/Catalog.CashAccounts'
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Bank account, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Transit account"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Transit Main' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
	* Filling Transit account in the Bank account, USD
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Bank account, USD' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Transit account"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Transit Second' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'


Сценарий: _005022 filling in the "Partners" catalog
	* Clearing the Partners catalog
		И я удаляю все элементы Справочника "Partners"
		И в базе нет элементов Справочника "Partners"
	* Opening the form for filling in Partners
		И я открываю навигационную ссылку "e1cib/list/Catalog.Partners"
		И Пауза 2
	* Create partners: Ferron BP, Kalipso, Manager B, Lomaniti
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Ferron BP'
		И в поле с именем 'Description_tr' я ввожу текст 'Ferron BP TR'
		И я нажимаю на кнопку 'Ok'
		И я устанавливаю флаг с именем 'Customer'
		И я устанавливаю флаг с именем 'Vendor'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		Тогда В базе появился хотя бы один элемент справочника "Partners"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Kalipso'
		И в поле с именем 'Description_tr' я ввожу текст 'Kalipso TR'
		И я нажимаю на кнопку 'Ok'
		И я устанавливаю флаг с именем 'Customer'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Manager B'
		И в поле с именем 'Description_tr' я ввожу текст 'Manager B TR'
		И я нажимаю на кнопку 'Ok'
		И я устанавливаю флаг с именем 'Customer'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Lomaniti'
		И в поле с именем 'Description_tr' я ввожу текст 'Lomaniti TR'
		И я нажимаю на кнопку 'Ok'
		И я устанавливаю флаг с именем 'Customer'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	* Checking for created partners
		Тогда я проверяю наличие элемента справочника "Partners" со значением поля "Description_en" "Ferron BP"  
		Тогда я проверяю наличие элемента справочника "Partners" со значением поля "Description_tr" "Ferron BP TR"
		Тогда я проверяю наличие элемента справочника "Partners" со значением поля "Description_en" "Kalipso"
		Тогда я проверяю наличие элемента справочника "Partners" со значением поля "Description_en" "Manager B"
		И Пауза 2
		Тогда я проверяю наличие элемента справочника "Partners" со значением поля "Description_en" "Lomaniti"

Сценарий: _005023 filling in the "Partner segments" catalog
	* Clearing the PartnerSegments catalog
		И я удаляю все элементы Справочника "PartnerSegments"
		И в базе нет элементов Справочника "PartnerSegments"
	* Opening the form for filling in Partner segments
		И я открываю навигационную ссылку "e1cib/list/Catalog.PartnerSegments"
		И Пауза 2
	* Сreate segments: Retail, Dealer
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Retail'
		И в поле с именем 'Description_tr' я ввожу текст 'Retail TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 2
		Тогда В базе появился хотя бы один элемент справочника "PartnerSegments"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Dealer'
		И в поле с именем 'Description_tr' я ввожу текст 'Dealer TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 2
	* Checking for created Partner Segments
		Тогда я проверяю наличие элемента справочника "PartnerSegments" со значением поля "Description_en" "Dealer"  
		Тогда я проверяю наличие элемента справочника "PartnerSegments" со значением поля "Description_tr" "Dealer TR"
		Тогда я проверяю наличие элемента справочника "PartnerSegments" со значением поля "Description_tr" "Retail TR"
		Тогда я проверяю наличие элемента справочника "PartnerSegments" со значением поля "Description_en" "Retail" 

Сценарий: _005024 filling in the "Payment schedules" catalog 
	* Clearing the Payment schedules catalog
		И я удаляю все элементы Справочника "PaymentSchedules"
		И в базе нет элементов Справочника "PaymentSchedules"
	* Opening a form and creating Payment schedules
		И я открываю навигационную ссылку "e1cib/list/Catalog.PaymentSchedules"
		Когда создаю элемент справочника с наименованием Test
	* Checking for created Payment schedules
		Тогда В базе появился хотя бы один элемент справочника "PaymentSchedules"
		Тогда я проверяю наличие элемента справочника "PaymentSchedules" со значением поля "Description_en" "Test ENG"  
		Тогда я проверяю наличие элемента справочника "PaymentSchedules" со значением поля "Description_tr" "Test TR"
	* Deletion of created elements 
		И я удаляю все элементы Справочника "PaymentSchedules"


Сценарий: _005026 filling in the "Item segments" catalog 
	* Opening a form and creating Item segments
		И я открываю навигационную ссылку "e1cib/list/Catalog.ItemSegments"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Sale autum'
		И в поле с именем 'Description_tr' я ввожу текст 'Sale autum TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 2
	* Checking creation Item segments
		Тогда я проверяю наличие элемента справочника "ItemSegments" со значением поля "Description_en" "Sale autum"
		Тогда я проверяю наличие элемента справочника "ItemSegments" со значением поля "Description_tr" "Sale autum TR"



Сценарий: _005027 filling in the "Payment types" catalog  
	* Clearing the Payment types catalog
		И я удаляю все элементы Справочника "PaymentTypes"
		И в базе нет элементов Справочника "PaymentTypes"
	* Opening a form and creating Payment types
		И я открываю навигационную ссылку "e1cib/list/Catalog.PaymentTypes"
		Когда создаю элемент справочника с наименованием Test
		И Я закрываю текущее окно
	* Checking for created Payment types
		Тогда В базе появился хотя бы один элемент справочника "PaymentTypes"
		Тогда я проверяю наличие элемента справочника "PaymentTypes" со значением поля "Description_en" "Test ENG"  
		Тогда я проверяю наличие элемента справочника "PaymentTypes" со значением поля "Description_tr" "Test TR"
	* Deletion of created elements 
		И я удаляю все элементы Справочника "PaymentTypes"


Сценарий: _005028 filling in the "Price types" catalog  
	* Opening a form and creating customer prices Basic Price Types, Price USD, Discount Price TRY 1, Discount Price TRY 2, Basic Price without VAT, Discount 1 TRY without VAT, Discount 2 TRY without VAT
		И я открываю навигационную ссылку "e1cib/list/Catalog.PriceTypes"
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Basic Price Types'
		И в поле с именем 'Description_tr' я ввожу текст 'Basic Price Types TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| TRY  |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Price USD'
		И в поле с именем 'Description_tr' я ввожу текст 'Price USD TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| USD  |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Discount Price TRY 1'
		И в поле с именем 'Description_tr' я ввожу текст 'Discount Price TRY 1 TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| TRY  |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Discount Price TRY 2'
		И в поле с именем 'Description_tr' я ввожу текст 'Discount Price TRY 2 TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| TRY  |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Basic Price without VAT'
		И в поле с именем 'Description_tr' я ввожу текст 'Basic Price without VAT'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| TRY  |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Discount 1 TRY without VAT'
		И в поле с именем 'Description_tr' я ввожу текст 'Discount 1 TRY without VAT'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| TRY  |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Discount 2 TRY without VAT'
		И в поле с именем 'Description_tr' я ввожу текст 'Discount 2 TRY without VAT'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| TRY  |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	* Creating price types for vendors: Vendor price, TRY, Vendor price, USD, Vendor price, EUR
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Vendor price, TRY'
		И в поле с именем 'Description_tr' я ввожу текст 'Vendor price, TRY TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| TRY  |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Vendor price, USD'
		И в поле с именем 'Description_tr' я ввожу текст 'Vendor price, USD TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| USD  |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Vendor price, EUR'
		И в поле с именем 'Description_tr' я ввожу текст 'Vendor price, EUR TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| EUR  |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	* Checking for created price types
		Тогда я проверяю наличие элемента справочника "PriceTypes" со значением поля "Description_en" "Vendor price, TRY"
		Тогда я проверяю наличие элемента справочника "PriceTypes" со значением поля "Description_en" "Vendor price, USD"
		И Пауза 2
		Тогда я проверяю наличие элемента справочника "PriceTypes" со значением поля "Description_en" "Vendor price, EUR"
		И Пауза 2
		Тогда я проверяю наличие элемента справочника "PriceTypes" со значением поля "Description_en" "Basic Price Types"
		Тогда я проверяю наличие элемента справочника "PriceTypes" со значением поля "Description_tr" "Basic Price Types TR"
		И Пауза 2
		Тогда я проверяю наличие элемента справочника "PriceTypes" со значением поля "Description_en" "Price USD"
		И Пауза 2
		Тогда я проверяю наличие элемента справочника "PriceTypes" со значением поля "Description_en" "Discount Price TRY 1"
		Тогда я проверяю наличие элемента справочника "PriceTypes" со значением поля "Description_en" "Discount Price TRY 2"
		И Пауза 2
		Тогда я проверяю наличие элемента справочника "PriceTypes" со значением поля "Description_en" "Basic Price without VAT"
		И Пауза 2
		Тогда я проверяю наличие элемента справочника "PriceTypes" со значением поля "Description_en" "Discount 1 TRY without VAT"
		Тогда я проверяю наличие элемента справочника "PriceTypes" со значением поля "Description_en" "Discount 2 TRY without VAT"



Сценарий: _005031 filling in the "Special offers" catalog
	* Clearing the Special offers catalog
		И я удаляю все элементы Справочника "SpecialOffers"
		И в базе нет элементов Справочника "SpecialOffers"
	* Opening a form and creating Special offers: Special Price
		И я открываю навигационную ссылку "e1cib/list/Catalog.SpecialOffers"
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Special Price'
		И в поле с именем 'Description_tr' я ввожу текст 'Special Price TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля "Special offer type"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "External data proc"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Special Price'
		И в поле с именем 'Description_tr' я ввожу текст 'Special Price'
		И я нажимаю на кнопку 'Ok'
		И в поле с именем 'Name' я ввожу текст 'Special Price'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И я жду закрытия окна 'External data proc (create)' в течение 20 секунд
		И я нажимаю на кнопку с именем 'FormChoose'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Special Price'
		И в поле с именем 'Description_tr' я ввожу текст 'Special Price'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormChoose'
		И в поле с именем 'Priority' я ввожу текст '2'
		И в поле с именем 'StartOf' я ввожу текст '03.12.2018  0:00:00'
		И в поле с именем 'EndOf' я ввожу текст '05.12.2018  0:00:00'
		И из выпадающего списка "Document type" я выбираю точное значение 'Sales'
		И я устанавливаю флаг с именем 'Manually'
		И я устанавливаю флаг с именем 'Launch'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 2
	* Checking creation
		Тогда я проверяю наличие элемента справочника "SpecialOffers" со значением поля "Description_en" "Special Price"  
		Тогда я проверяю наличие элемента справочника "SpecialOffers" со значением поля "Description_tr" "Special Price TR"
	* Deletion of created elements 
		И я удаляю все элементы Справочника "SpecialOffers"

Сценарий: _005032 filling in the "Stores" catalog
	* Clearing the Stores catalog
		И я удаляю все элементы Справочника "Stores"
		И в базе нет элементов Справочника "Stores"
	* Opening a form for creating Stores
		И я открываю навигационную ссылку "e1cib/list/Catalog.Stores"
		И Пауза 2
	* Create Store 01
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Store 01'
		И в поле с именем 'Description_tr' я ввожу текст 'Store 01 TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		Тогда В базе появился хотя бы один элемент справочника "Stores"
		И Пауза 2
	* Create Store 02
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Store 02'
		И в поле с именем 'Description_tr' я ввожу текст 'Store 02 TR'
		И я нажимаю на кнопку 'Ok'
		И я устанавливаю флаг с именем 'UseGoodsReceipt'
		И я устанавливаю флаг с именем 'UseShipmentConfirmation'
		И     элемент формы с именем "Transit" стал равен 'No'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Create Store 03
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Store 03'
		И в поле с именем 'Description_tr' я ввожу текст 'Store 03 TR'
		И я нажимаю на кнопку 'Ok'
		И я устанавливаю флаг с именем 'UseGoodsReceipt'
		И я устанавливаю флаг с именем 'UseShipmentConfirmation'
		И     элемент формы с именем "Transit" стал равен 'No'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Create Store 04
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Store 04'
		И в поле с именем 'Description_tr' я ввожу текст 'Store 04 TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Checking creation "Stores"
		Тогда я проверяю наличие элемента справочника "Stores" со значением поля "Description_en" "Store 01"  
		Тогда я проверяю наличие элемента справочника "Stores" со значением поля "Description_tr" "Store 01 TR"
		Тогда я проверяю наличие элемента справочника "Stores" со значением поля "Description_en" "Store 02"  
		Тогда я проверяю наличие элемента справочника "Stores" со значением поля "Description_en" "Store 03"
		Тогда я проверяю наличие элемента справочника "Stores" со значением поля "Description_en" "Store 04"

Сценарий: _005033 filling in the "Tax rates" catalog  
	* Clearing the Tax rates catalog
		И я удаляю все элементы Справочника "TaxRates"
		И в базе нет элементов Справочника "TaxRates"
	* Opening a form for creating Tax rates
		И я открываю навигационную ссылку "e1cib/list/Catalog.TaxRates"
		И Пауза 2
	* Create tax rate '8%'
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст '8%'
		И в поле с именем 'Description_tr' я ввожу текст '8% TR'
		И я нажимаю на кнопку 'Ok'
		И в поле с именем 'Rate' я ввожу текст '8,000000000000'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Create tax rate '18%'
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст '18%'
		И в поле с именем 'Description_tr' я ввожу текст '18% TR'
		И я нажимаю на кнопку 'Ok'
		И в поле 'Rate' я ввожу текст '18,000000000000'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Create tax rate 'Without VAT'
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Without VAT'
		И в поле с именем 'Description_tr' я ввожу текст 'Without VAT TR'
		И я нажимаю на кнопку 'Ok'
		И в поле с именем 'Rate' я ввожу текст '0,000000000000'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Create tax rate '0%'
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст '0%'
		И в поле с именем 'Description_tr' я ввожу текст '0%'
		И я нажимаю на кнопку 'Ok'
		И в поле с именем 'Rate' я ввожу текст '0,000000000000'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Create tax rate '1%'
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст '1%'
		И в поле с именем 'Description_tr' я ввожу текст '1%'
		И я нажимаю на кнопку 'Ok'
		И в поле с именем 'Rate' я ввожу текст '1,000000000000'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Checking creation tax rates
		Тогда В базе появился хотя бы один элемент справочника "TaxRates"
		Тогда я проверяю наличие элемента справочника "TaxRates" со значением поля "Description_en" "8%"  
		Тогда я проверяю наличие элемента справочника "TaxRates" со значением поля "Description_tr" "8% TR"
		Тогда я проверяю наличие элемента справочника "TaxRates" со значением поля "Description_en" "Without VAT"  
		Тогда я проверяю наличие элемента справочника "TaxRates" со значением поля "Description_en" "18%"
		Тогда я проверяю наличие элемента справочника "TaxRates" со значением поля "Description_en" "1%"



Сценарий: _005038 filling in the "Company types" catalog  
	* Opening a form for creating Company types
		И я открываю навигационную ссылку "e1cib/list/Catalog.CompanyTypes"
	* Create company types: Entrepreneur, Legal entity, Private individual
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Entrepreneur'
		И в поле с именем 'Description_tr' я ввожу текст 'Entrepreneur TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Legal entity'
		И в поле с именем 'Description_tr' я ввожу текст 'Legal entity TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Private individual'
		И в поле с именем 'Description_tr' я ввожу текст 'Private individual TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	* Checking creation 
		Тогда я проверяю наличие элемента справочника "CompanyTypes" со значением поля "Description_en" "Entrepreneur"  
		Тогда я проверяю наличие элемента справочника "CompanyTypes" со значением поля "Description_en" "Legal entity"
		И Пауза 2
		Тогда я проверяю наличие элемента справочника "CompanyTypes" со значением поля "Description_en" "Private individual" 

Сценарий: _005039 filling in the status catalog for Inventory transfer order
	* Opening a form for creating Object statuses
		И я открываю навигационную ссылку "e1cib/list/Catalog.ObjectStatuses"
	* Filling the name for the predefined element InventoryTransferOrder
		И в таблице "List" я разворачиваю строку:
			| 'Description'    |
			| 'Object statuses' |
		И в таблице "List" я перехожу к строке:
			| Predefined data item name |
			| InventoryTransferOrder                |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Inventory transfer order'
		И в поле 'TR' я ввожу текст 'Inventory transfer order TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Adding status "Wait"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Inventory transfer order' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я устанавливаю флаг 'Set by default'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Wait'
		И в поле 'TR' я ввожу текст 'Wait TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Adding status "Approved"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Inventory transfer order' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я устанавливаю флаг 'Posting'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Approved'
		И в поле 'TR' я ввожу текст 'Approved TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Adding status "Send"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Inventory transfer order' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я устанавливаю флаг 'Posting'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Send'
		И в поле 'TR' я ввожу текст 'Send TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Adding status "Receive"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Inventory transfer order' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я устанавливаю флаг 'Posting'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Receive'
		И в поле 'TR' я ввожу текст 'Receive TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Я закрываю текущее окно

Сценарий: _005040 filling in the status catalog for Outgoing Payment Order
	* Opening a form for creating Object statuses
		И я открываю навигационную ссылку "e1cib/list/Catalog.ObjectStatuses"
	* Filling the name for the predefined element OutgoingPaymentOrder
		И в таблице "List" я разворачиваю строку:
			| 'Description'    |
			| 'Object statuses' |
		И в таблице "List" я перехожу к строке:
			| Predefined data item name |
			| OutgoingPaymentOrder                |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Outgoing payment order'
		И в поле 'TR' я ввожу текст 'Outgoing payment order TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Adding status "Wait"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Outgoing payment order' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я устанавливаю флаг 'Set by default'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Wait'
		И в поле 'TR' я ввожу текст 'Wait TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Adding status "Approved"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Outgoing payment order' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я устанавливаю флаг 'Posting'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Approved'
		И в поле 'TR' я ввожу текст 'Approved TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'

Сценарий: _005041 filling in the status catalog for Purchase return order
	* Opening a form for creating Object statuses
		И я открываю навигационную ссылку "e1cib/list/Catalog.ObjectStatuses"
	* Filling the name for the predefined element  PurchaseReturnOrder
		И в таблице "List" я разворачиваю строку:
			| 'Description'    |
			| 'Object statuses' |
		И в таблице "List" я перехожу к строке:
			| Predefined data item name |
			| PurchaseReturnOrder                |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Purchase return order'
		И в поле 'TR' я ввожу текст 'Purchase return order TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Adding status "Wait"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Purchase return order' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я устанавливаю флаг 'Set by default'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Wait'
		И в поле 'TR' я ввожу текст 'Wait TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Adding status "Approved"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Purchase return order' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я устанавливаю флаг 'Posting'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Approved'
		И в поле 'TR' я ввожу текст 'Approved TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'


Сценарий: _005042 filling in the status catalog for Purchase order
	* Opening a form for creating Object statuses
		И я открываю навигационную ссылку "e1cib/list/Catalog.ObjectStatuses"
	* Filling the name for the predefined element PurchaseOrder
		И в таблице "List" я разворачиваю строку:
			| 'Description'    |
			| 'Object statuses' |
		И в таблице "List" я перехожу к строке:
			| Predefined data item name |
			| PurchaseOrder                |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Purchase order'
		И в поле 'TR' я ввожу текст 'Purchase order TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Adding status "Wait"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Purchase order' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я устанавливаю флаг 'Set by default'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Wait'
		И в поле 'TR' я ввожу текст 'Wait TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Adding status "Approved"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Purchase order' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я устанавливаю флаг 'Posting'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Approved'
		И в поле 'TR' я ввожу текст 'Approved TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'

Сценарий: _005043 filling in the status catalog for Sales return order
	* Opening a form for creating Object statuses
		И я открываю навигационную ссылку "e1cib/list/Catalog.ObjectStatuses"
	* Filling the name for the predefined element  SalesReturnOrder
		И в таблице "List" я разворачиваю строку:
			| 'Description'    |
			| 'Object statuses' |
		И в таблице "List" я перехожу к строке:
			| Predefined data item name |
			| SalesReturnOrder                |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Sales return order'
		И в поле 'TR' я ввожу текст 'Sales return order TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Adding status "Wait"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Sales return order' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я устанавливаю флаг 'Set by default'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Wait'
		И в поле 'TR' я ввожу текст 'Wait TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Adding status "Approved"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Sales return order' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я устанавливаю флаг 'Posting'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Approved'
		И в поле 'TR' я ввожу текст 'Approved TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'

Сценарий: _005044 filling in the status catalog for Sales order
	* Opening a form for creating Object statuses
		И я открываю навигационную ссылку "e1cib/list/Catalog.ObjectStatuses"
	* Filling the name for the predefined element  SalesOrder
		И в таблице "List" я разворачиваю строку:
			| 'Description'    |
			| 'Object statuses' |
		И в таблице "List" я перехожу к строке:
			| Predefined data item name |
			| SalesOrder                |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Sales order'
		И в поле 'TR' я ввожу текст 'Sales order TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Adding status "Wait"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Sales order' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Wait'
		И в поле 'TR' я ввожу текст 'Wait TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Adding status "Approved"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Sales order' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я устанавливаю флаг 'Posting'
		И я устанавливаю флаг 'Set by default'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Approved'
		И в поле 'TR' я ввожу текст 'Approved TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Adding status "Done"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Sales order' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я устанавливаю флаг 'Posting'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Done'
		И в поле 'TR' я ввожу текст 'Done TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	И Я закрыл все окна клиентского приложения

Сценарий: _005045 check for clearing the UniqueID field when copying the status
	* Opening a form for creating Object statuses
		И я открываю навигационную ссылку "e1cib/list/Catalog.ObjectStatuses"
		И в таблице "List" я разворачиваю строку:
			| 'Description'    |
			| 'Object statuses' |
	* Copy status
		И в таблице "List" я разворачиваю строку:
			| 'Description' | 'Predefined data item name' |
			| 'Sales order' | 'SalesOrder'                |
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Wait'        |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuCopy'
	* Checking UniqueID field cleaning
		И     элемент формы с именем "UniqueID" стал равен ''
		И     элемент формы с именем "Description_en" стал равен 'Wait'
	И Я закрыл все окна клиентского приложения



Сценарий: _005046 заполнение Business units
	* Открытие формы создания Business units
		И я открываю навигационную ссылку "e1cib/list/Catalog.BusinessUnits"
	* Создание подразделения 'Front office'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Front office'
		И в поле 'TR' я ввожу текст 'Front office TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Создание подразделения 'Accountants office'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Accountants office'
		И в поле 'TR' я ввожу текст 'Accountants office TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Создание подразделения 'Distribution department'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Distribution department'
		И в поле 'TR' я ввожу текст 'Distribution department TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Создание подразделения 'Logistics department'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Logistics department'
		И в поле 'TR' я ввожу текст 'Logistics department TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Checking creation Business units
		Тогда я проверяю наличие элемента справочника "BusinessUnits" со значением поля "Description_en" "Front office"
		Тогда я проверяю наличие элемента справочника "BusinessUnits" со значением поля "Description_en" "Accountants office"
		И Пауза 2
		Тогда я проверяю наличие элемента справочника "BusinessUnits" со значением поля "Description_en" "Distribution department"
		И Пауза 2
		Тогда я проверяю наличие элемента справочника "BusinessUnits" со значением поля "Description_en" "Logistics department"

Сценарий: _005047 заполнение Expense type
	* Открытие формы создания Expense type
		И я открываю навигационную ссылку "e1cib/list/Catalog.ExpenseAndRevenueTypes"
	* Создание статьи 'Rent'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Rent'
		И в поле 'TR' я ввожу текст 'Rent TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Создание статьи  'Telephone communications'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Telephone communications'
		И в поле 'TR' я ввожу текст 'Telephone communications TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	И я создаю статью 'Fuel'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Fuel'
		И в поле 'TR' я ввожу текст 'Fuel TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Создание статьи  'Software'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Software'
		И в поле 'TR' я ввожу текст 'Software TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Создание статьи  'Delivery'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Delivery'
		И в поле 'TR' я ввожу текст 'Delivery TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Checking creation Expense type
		Тогда я проверяю наличие элемента справочника "ExpenseAndRevenueTypes" со значением поля "Description_en" "Rent"
		Тогда я проверяю наличие элемента справочника "ExpenseAndRevenueTypes" со значением поля "Description_en" "Telephone communications"
		Тогда я проверяю наличие элемента справочника "ExpenseAndRevenueTypes" со значением поля "Description_en" "Fuel"
		И Пауза 2
		Тогда я проверяю наличие элемента справочника "ExpenseAndRevenueTypes" со значением поля "Description_en" "Software"
		И Пауза 2
		Тогда я проверяю наличие элемента справочника "ExpenseAndRevenueTypes" со значением поля "Description_en" "Delivery"

Сценарий: _005048 filling in the "Item segments" catalog  "Tax analytics"
	* Открытие и заполнение формы Tax analytics
		И я открываю навигационную ссылку "e1cib/list/Catalog.TaxAnalytics"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Analytics 01'
		И в поле 'TR' я ввожу текст 'Analytics 01 TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения
		И Пауза 2
	* Checking for created  Tax analytics
		Тогда я проверяю наличие элемента справочника "TaxAnalytics" со значением поля "Description_en" "Analytics 01"  
		Тогда я проверяю наличие элемента справочника "TaxAnalytics" со значением поля "Description_tr" "Analytics 01 TR"


