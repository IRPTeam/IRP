#language: ru
@tree
@Positive
Функционал: check the cleaning of fields in forms of directories with switches (the drawing of the form depends on the switch)



Контекст:
    Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: check the clearing of values ​​when changing the type of account in the Cash / Bank accounts catalog
    * Открытие формы элемента справочника
        И я открываю навигационную ссылку "e1cib/list/Catalog.CashAccounts"
        И я нажимаю на кнопку с именем 'FormCreate'
    * Filling in the details of the documentдля Bank account
        И я меняю значение переключателя 'Type' на 'Bank'
        И в поле 'TR' я ввожу текст 'Test Bank'
        И я нажимаю кнопку выбора у поля "Company"
        И в таблице "List" я перехожу к строке:
            | 'Description'  |
            | 'Main Company TR' |
        И в таблице "List" я выбираю текущую строку
        И в поле 'Number' я ввожу текст '12345'
        И в поле 'Bank name' я ввожу текст '1234'
        И я нажимаю кнопку выбора у поля "Transit account"
        И в таблице "List" я перехожу к строке:
            | 'Description'    |
            | 'Transit Second' |
        И в таблице "List" я выбираю текущую строку
        И я нажимаю кнопку выбора у поля с именем "Currency"
        И в таблице "List" я перехожу к строке:
            | 'Code' | 'Description'     |
            | 'USD'  | 'American dollar' |
        И в таблице "List" я активизирую поле "Description"
        И в таблице "List" я выбираю текущую строку
    * Проверка заполненности реквизитов
        Тогда элемент формы с именем "Type" стал равен 'Bank'
        И     элемент формы с именем "Company" стал равен 'Main Company TR'
        И     элемент формы с именем "Number" стал равен '12345'
        И     элемент формы с именем "BankName" стал равен '1234'
        И     элемент формы с именем "TransitAccount" стал равен 'Transit Second'
        И     элемент формы с именем "Description_tr" стал равен 'Test Bank'
        И     элемент формы с именем "CurrencyType" стал равен 'Fixed'
        И     элемент формы с именем "Currency" стал равен 'USD'
    * Переключение типа на Cash и потом обратно на Bank и проверка очистки заполненных реквизитов
        И я меняю значение переключателя 'Type' на 'Cash'
        И я меняю значение переключателя 'Type' на 'Bank'
        Тогда элемент формы с именем "Type" стал равен 'Bank'
        И     элемент формы с именем "Company" стал равен 'Main Company TR'
        И     элемент формы с именем "Number" стал равен ''
        И     элемент формы с именем "BankName" стал равен ''
        И     элемент формы с именем "TransitAccount" стал равен ''
        И     элемент формы с именем "CurrencyType" стал равен 'Fixed'
        И     элемент формы с именем "Currency" стал равен ''
    * Filling in the details of the documentпо Cash
        И я меняю значение переключателя 'Type' на 'Cash'
        И я меняю значение переключателя с именем 'CurrencyType' на 'Fixed'
        И я нажимаю кнопку выбора у поля с именем "Currency"
        И в таблице "List" я перехожу к строке:
            | 'Code' | 'Description' |
            | 'EUR'  | 'Euro'        |
        И в таблице "List" я активизирую поле "Description"
        И в таблице "List" я выбираю текущую строку
    * Проверка сброса при переключении на Transit и обратно на Cash
        И я меняю значение переключателя 'Type' на 'Transit'
        И я меняю значение переключателя 'Type' на 'Cash'
        И     элемент формы с именем "CurrencyType" стал равен 'Multi'
        И я закрыл все окна клиентского приложения


Сценарий: check clearing values ​​when changing the Ap-ar posting / Standard switch to Partner term
    * Открытие формы элемента справочника
        И я открываю навигационную ссылку "e1cib/list/Catalog.Agreements"
        И я нажимаю на кнопку с именем 'FormCreate'
    * Filling in the details of the documentдля соглашения с видом расчета по стандартным договорам
        И я меняю значение переключателя 'Kind' на 'Regular'
        И я нажимаю кнопку выбора у поля "Multi currency movement type"
        И в таблице "List" я перехожу к строке:
            | 'Description' |
            | 'EUR'         |
        И в таблице "List" я выбираю текущую строку
        И я меняю значение переключателя 'AP/AR posting detail' на 'By standard partner term'
        И я нажимаю кнопку выбора у поля "Standard Partner term"
        * Создание стандартного соглашения в евро
            И я нажимаю на кнопку с именем 'FormCreate'
            И в поле 'TR' я ввожу текст 'Standard, EUR'
            И я нажимаю на кнопку 'Save and close'
        И я нажимаю на кнопку с именем 'FormChoose'
        И я нажимаю кнопку выбора у поля "Price type"
        И в таблице "List" я перехожу к строке:
            | 'Description'       |
            | 'Basic Price Types TR' |
        И в таблице "List" я выбираю текущую строку
    * Check filling inреквизитов
        И     элемент формы с именем "CurrencyMovementType" стал равен 'EUR'
        И     элемент формы с именем "StandardPartner term" стал равен 'Standard, EUR'
        И     элемент формы с именем "PriceType" стал равен 'Basic Price Types TR'
    * Переключение переключателя Ap-ar posting на значение By Partner terms и проверка очистки поля StandardPartner term
        И я меняю значение переключателя 'AP/AR posting detail' на 'By partner terms'
        И     элемент формы с именем "StandardPartner term" стал равен ''
    * Check clearing fields при изменении переключателя на Standard
        И я меняю значение переключателя 'Kind' на 'Standard'
        И     элемент формы с именем "CurrencyMovementType" стал равен ''
        И     элемент формы с именем "PriceType" стал равен ''
        И я закрыл все окна клиентского приложения


Сценарий: check clearing the values ​​of Tax types and Multi currency movement type when changing the Our checkmark in Company
    * Открытие формы элемента справочника
        И я открываю навигационную ссылку "e1cib/list/Catalog.Companies"
        И я нажимаю на кнопку с именем 'FormCreate'
    * Установка галочки Our и заполнение Tax types и Multi currency movement type
        И в поле 'TR' я ввожу текст 'Test'
        И я устанавливаю флаг 'Our'
        * Заполнение Multi currency movement type
            И в таблице "Currencies" я нажимаю на кнопку с именем 'CurrenciesAdd'
            И в таблице "Currencies" я нажимаю кнопку выбора у реквизита "Movement type"
            И в таблице "List" я перехожу к строке:
                | 'Currency' | 'Deferred calculation' | 'Description'        | 'Reference'          | 'Source'       | 'Type'      |
                | 'USD'      | 'No'                   | 'Reporting currency' | 'Reporting currency' | 'Forex Seling' | 'Reporting' |
            И в таблице "List" я активизирую поле "Description"
            И в таблице "List" я выбираю текущую строку
            И в таблице "Currencies" я завершаю редактирование строки
            И таблица "Currencies" содержит строки:
                | 'Movement type'      | 'Type'      | 'Currency' | 'Source'       |
                | 'Reporting currency' | 'Reporting' | 'USD'      | 'Forex Seling' |
        * Заполнение Tax types
            И я перехожу к закладке "Tax types"
            И в таблице "CompanyTaxes" я нажимаю на кнопку с именем 'CompanyTax typesAdd'
            И в поле 'Period' я ввожу текст '01.10.2019'
            И в таблице "CompanyTax types" я активизирую поле "Tax"
            И в таблице "CompanyTax types" я нажимаю кнопку выбора у реквизита "Tax"
            И в таблице "List" я перехожу к строке:
                | 'Description' | 'Reference' |
                | 'VAT'         | 'VAT'       |
            И в таблице "List" я выбираю текущую строку
            И в таблице "CompanyTax types" я активизирую поле "Priority"
            И в таблице "CompanyTax types" в поле 'Priority' я ввожу текст '2'
            И в таблице "CompanyTax types" я завершаю редактирование строки
            И     таблица "CompanyTax types" содержит строки:
                | 'Use' | 'Tax' | 'Priority' |
                | 'Yes' | 'VAT' | '2'        |
        * Проверка очистки заполненных данных при снятии галочки Our
            И я перехожу к закладке "Info"
            И я снимаю флаг 'Our'
            И я нажимаю на кнопку 'Save'
            И я устанавливаю флаг 'Our'
            И таблица "Currencies" не содержит строки:
                | 'Movement type'      | 'Type'      | 'Currency' | 'Source'       |
                | 'Reporting currency' | 'Reporting' | 'USD'      | 'Forex Seling' |
            И     таблица "CompanyTax types" не содержит строки:
                | 'Use' | 'Tax' | 'Priority' |
                | 'Yes' | 'VAT' | '2'        |
            И я закрыл все окна клиентского приложения




