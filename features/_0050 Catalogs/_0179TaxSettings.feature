#language: ru
@tree
@Positive
@TestExtDataProc

Функционал: filling in tax rates

As an owner
I want to filling in tax rates
For tax accounting


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.

Сценарий: _017901 connection of tax calculation Plugin sessing TaxCalculateVAT_TR
	* Opening a form to add Plugin sessing
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ExternalDataProc'
	* Addition of Plugin sessing for calculating Tax types for Turkey (VAT)
		И я нажимаю на кнопку с именем 'FormCreate'
		И я буду выбирать внешний файл "#workingDir#\DataProcessor\TaxCalculateVAT_TR.epf"
		И я нажимаю на кнопку с именем "FormAddExtDataProc"
		И в поле 'Path to plugin for test' я ввожу текст ''
		И в поле 'Name' я ввожу текст 'TaxCalculateVAT_TR'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'TaxCalculateVAT_TR'
		И в поле 'TR' я ввожу текст 'TaxCalculateVAT_TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Plugins (create)' в течение 10 секунд
	* Checking added processing
		Тогда я проверяю наличие элемента справочника "ExternalDataProc" со значением поля "Description_en" "TaxCalculateVAT_TR"	


Сценарий: _017902 filling in catalog 'Tax types'
	* Opening a tax creation form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Taxes'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling VAT settings
		И в поле 'ENG' я ввожу текст 'VAT'
		И я нажимаю кнопку выбора у поля "Plugins"
		И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'TaxCalculateVAT_TR' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "TaxRates" я нажимаю на кнопку с именем 'TaxRatesAdd'
		И в таблице "TaxRates" я нажимаю кнопку выбора у реквизита "Tax rate"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '8%'          |
		И в таблице "List" я выбираю текущую строку
		И в таблице "TaxRates" я завершаю редактирование строки
		И в таблице "TaxRates" я нажимаю на кнопку с именем 'TaxRatesAdd'
		И в таблице "TaxRates" я нажимаю кнопку выбора у реквизита "Tax rate"
		И в таблице "List" я перехожу к строке:
			| 'Description' | 'Reference' |
			| '18%'         | '18%'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "TaxRates" я завершаю редактирование строки
		И в таблице "TaxRates" я нажимаю на кнопку с именем 'TaxRatesAdd'
		И в таблице "TaxRates" я нажимаю кнопку выбора у реквизита "Tax rate"
		И в таблице "List" я перехожу к строке:
			| 'Description' | 'Reference' |
			| '0%'          | '0%'        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "TaxRates" я завершаю редактирование строки
		И в таблице "TaxRates" я нажимаю на кнопку с именем 'TaxRatesAdd'
		И в таблице "TaxRates" я нажимаю кнопку выбора у реквизита "Tax rate"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Without VAT' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Use documents"
		И в таблице "TaxRates" я завершаю редактирование строки
		И в таблице "UseDocuments" я нажимаю на кнопку с именем 'UseDocumentsAdd'
		И в таблице "UseDocuments" из выпадающего списка "Document name" я выбираю точное значение 'Sales order'
		И в таблице "UseDocuments" я завершаю редактирование строки
		И в таблице "UseDocuments" я нажимаю на кнопку с именем 'UseDocumentsAdd'
		И в таблице "UseDocuments" из выпадающего списка "Document name" я выбираю точное значение 'Sales invoice'
		И в таблице "UseDocuments" я завершаю редактирование строки
		И в таблице "UseDocuments" я нажимаю на кнопку с именем 'UseDocumentsAdd'
		И в таблице "UseDocuments" из выпадающего списка "Document name" я выбираю точное значение 'Purchase order'
		И в таблице "UseDocuments" я завершаю редактирование строки
		И в таблице "UseDocuments" я нажимаю на кнопку с именем 'UseDocumentsAdd'
		И в таблице "UseDocuments" из выпадающего списка "Document name" я выбираю точное значение 'Purchase invoice'
		И в таблице "UseDocuments" я завершаю редактирование строки
		И в таблице "UseDocuments" я нажимаю на кнопку с именем 'UseDocumentsAdd'
		И в таблице "UseDocuments" из выпадающего списка "Document name" я выбираю точное значение 'Cash expense'
		И в таблице "UseDocuments" я завершаю редактирование строки
		И в таблице "UseDocuments" я нажимаю на кнопку с именем 'UseDocumentsAdd'
		И в таблице "UseDocuments" из выпадающего списка "Document name" я выбираю точное значение 'Cash revenue'
		И в таблице "UseDocuments" я завершаю редактирование строки
		И в таблице "UseDocuments" я нажимаю на кнопку с именем 'UseDocumentsAdd'
		И в таблице "UseDocuments" из выпадающего списка "Document name" я выбираю точное значение 'Cash revenue'
		И в таблице "UseDocuments" я завершаю редактирование строки
		И в таблице "UseDocuments" я нажимаю на кнопку с именем 'UseDocumentsAdd'
		И в таблице "UseDocuments" из выпадающего списка "Document name" я выбираю точное значение 'Purchase return'
		И в таблице "UseDocuments" я завершаю редактирование строки
		И в таблице "UseDocuments" я нажимаю на кнопку с именем 'UseDocumentsAdd'
		И в таблице "UseDocuments" из выпадающего списка "Document name" я выбираю точное значение 'Purchase return order'
		И в таблице "UseDocuments" я завершаю редактирование строки
		И в таблице "UseDocuments" я нажимаю на кнопку с именем 'UseDocumentsAdd'
		И в таблице "UseDocuments" из выпадающего списка "Document name" я выбираю точное значение 'Sales return order'
		И в таблице "UseDocuments" я завершаю редактирование строки
		И в таблице "UseDocuments" я нажимаю на кнопку с именем 'UseDocumentsAdd'
		И в таблице "UseDocuments" из выпадающего списка "Document name" я выбираю точное значение 'Sales return'
		И в таблице "UseDocuments" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save'
		И я нажимаю на кнопку 'Settings'
		И я нажимаю на кнопку 'Ok'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Tax rate settings'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Period' я ввожу текст '01.10.2019'
		И из выпадающего списка "Tax rate" я выбираю точное значение '18%'
		И я нажимаю на кнопку 'Save and close'
		И я закрыл все окна клиентского приложения
	* Opening a tax creation form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Taxes'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in Sales Tax rate settings
		И в поле 'ENG' я ввожу текст 'SalesTax'
		И я нажимаю кнопку выбора у поля "Plugins"
		И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'TaxCalculateVAT_TR' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "TaxRates" я нажимаю на кнопку с именем 'TaxRatesAdd'
		И в таблице "TaxRates" я нажимаю кнопку выбора у реквизита "Tax rate"
		И в таблице "List" я перехожу к строке:
			| 'Description' | 'Reference' |
			| '1%'          | '1%'        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "TaxRates" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save'
		И я нажимаю на кнопку 'Settings'
		И я нажимаю на кнопку 'Ok'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Tax rate settings'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'Period' я ввожу текст '01.10.2019'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Tax rate" я выбираю точное значение '1%'
		И я нажимаю на кнопку 'Save and close'
		И я закрыл все окна клиентского приложения
	* Checking the creation of Taxes catalog elements
		Тогда я проверяю наличие элемента справочника "Taxes" со значением поля "Description_en" "SalesTax"
		Тогда я проверяю наличие элемента справочника "Taxes" со значением поля "Description_en" "VAT"



Сценарий: _017903 company tax compliance
	* Opening the form of your own company
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Companies'
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Filling in Sales Tax rate settings
		И я перехожу к закладке "Tax types"
		И в таблице "CompanyTaxes" я нажимаю на кнопку с именем 'CompanyTaxesAdd'
		И я нажимаю кнопку выбора у поля "Tax"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Tax"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'SalesTax'    |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Period' я ввожу текст '01.10.2019'
		И я устанавливаю флаг 'Use'
		И в поле 'Priority' я ввожу текст '2'
	* Filling settings by VAT
		И в таблице "CompanyTaxes" я нажимаю на кнопку с именем 'CompanyTaxesAdd'
		И в поле 'Period' я ввожу текст '01.10.2019'
		И я нажимаю кнопку выбора у поля "Tax"
		И в таблице "List" я перехожу к строке:
			| 'Description' | 'Reference' |
			| 'VAT'         | 'VAT'       |
		И в таблице "List" я выбираю текущую строку
		И я устанавливаю флаг 'Use'
		И в поле 'Priority' я ввожу текст '1'
		И я нажимаю на кнопку 'Save and close'
		И я закрыл все окна клиентского приложения




