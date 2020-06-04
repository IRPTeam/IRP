#language: ru
@Positive
@Block4
@IgnoreOnCIMainBuild


Функционал: проверка загрузки данных из json

Как тестировщик
Я хочу проверить перенос данных
Чтобы убедиться в работе механизма обмена

Контекст:
    И Я устанавливаю в константу "ShowBetaTesting" значение "True"
    Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _000110 создание настройки External systems

    И я открываю навигационную ссылку "e1cib/list/Catalog.ExternalSystems"
    И я нажимаю на кнопку с именем 'FormCreate'
    И в поле с именем 'Description' я ввожу текст 'Test System'
    И я устанавливаю флаг с именем 'UseExternalId' 
    И в поле с именем 'Name' я ввожу текст 'extsys'
    И я нажимаю на кнопку с именем 'FormWriteAndClose'
    И я жду закрытия окна 'External systems (create)' в течение 20 секунд
    Тогда я проверяю наличие элемента справочника "ExternalSystems" с наименованием "Test System"

Сценарий: _000111 загрузка json из макета "ItemTypes"

    Тогда я проверяю наличие элемента справочника "ExternalSystems" с наименованием "Test System"
    И я отправляю json из макета "ItemTypes"
    Тогда я проверяю наличие элемента справочника "ItemTypes" со значением поля Description Eng "Commercial"
    Тогда я проверяю наличие элемента справочника "ItemTypes" со значением поля Description Eng "Non Commercial"
    

Сценарий: _000112 загрузка json из макета "Units"
    И я отправляю json из макета "Unit"
    Тогда я проверяю наличие элемента справочника "Units" со значением поля Description Eng "Test 001"
    

Сценарий: _000113 загрузка json из макета "Items"
    Тогда я проверяю наличие элемента справочника "ExternalSystems" с наименованием "Test System"
    И я отправляю json из макета "Items"
    Тогда я проверяю наличие элемента справочника "Items" со значением поля Description Eng "B7817AA Description"
    Тогда я проверяю наличие элемента справочника "Items" со значением поля Description Eng "B7817AZ Description"
    И я отправляю json из макета "ItemKeys"
    

# Сценарий: _000114 загрузка json из макета "PriceList"
#     Тогда я проверяю наличие элемента справочника "ExternalSystems" с наименованием "Test System"
#     И я отправляю json из макета "PriceList"
#     Тогда я проверяю наличие документа 'PriceList' по номеру '2' и дате '20171011093328'
#     Тогда я проверяю наличие документа 'PriceList' по номеру '1' и дате '20180301160517'
    

# Сценарий: _000115 загрузка json из макета "PriceTypes"
#     И я отправляю json из макета "PriceTypes"
#     И Пауза 5
#     Тогда я проверяю наличие элемента справочника "PriceTypes" со значением поля Description Eng "Retail"
#     Тогда я проверяю наличие элемента справочника "PriceTypes" со значением поля Description Eng "Discount"
    

# Сценарий: _000116 загрузка json из макета "PricesPackage" 
#     И я отправляю json из макета "PricesPackage"
#     Тогда я проверяю наличие элемента информационного регистра "PricesByItemKeys" по значению поля PriceType.Description_en "Retail"
#     Тогда я проверяю наличие элемента информационного регистра "PricesByItemKeys" по значению поля PriceType.Description_en "Discount"
    

Сценарий: _000117 загрузка json из макета "Segment" 
    И я отправляю json из макета "Segment"
    Тогда я проверяю наличие элемента справочника "ItemSegments" со значением поля Description Eng "Sale autum"
    # И я удаляю все элементы справочника "ItemSegments"

Сценарий: _000118 загрузка json из макета "ItemSegments"
    И я отправляю json из макета "ItemSegments"
    Тогда я проверяю наличие элемента информационного регистра "ItemSegments" по значению поля Segment.Description_en "Sale autum"
    # И я удаляю все элементы информационного регистра "ItemSegments"

Сценарий: _000119 загрузка json из макета "AddAttributesAndProperties"   
    И я отправляю json из макета "AddAttributesAndProperties"
    Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Color"
    Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Size"
    

Сценарий: _000120 загрузка json из макета "AddProperties" 
    И я отправляю json из макета "AddProperties"
    Тогда я проверяю наличие элемента информационного регистра "AddProperties" по значению поля AddProperties.Description_en "Color"
    Тогда я проверяю наличие элемента информационного регистра "AddProperties" по значению поля AddProperties.Description_en "Size"

Сценарий: _000121 загрузка json из макета "AddBarcode" 
    И я отправляю json из макета "AddBarcode"
    Тогда я проверяю наличие элемента информационного регистра "Barcodes" по значению поля Barcode "1111111111111"
    Тогда я проверяю наличие элемента информационного регистра "Barcodes" по значению поля Barcode "2111111111111"
    # И я удаляю все элементы информационного регистра "Barcodes"

Сценарий: _000122 загрузка json из макета "SpecialOffers" 
    И я отправляю json из макета "SpecialOffers"
    Тогда я проверяю наличие элемента справочника "SpecialOffers" со значением поля Description Eng "001"
    Тогда я проверяю наличие элемента справочника "SpecialOffers" со значением поля Description Eng "002"
    Тогда я проверяю наличие элемента справочника "SpecialOffers" со значением поля Description Eng "003"
    И я отправляю json из макета "SpecialOffersParent"
    И я удаляю все элементы справочника "SpecialOffers"


Сценарий: _000123 загрузка json из макета "Company" 
    И я отправляю json из макета "Company"
    Тогда я проверяю наличие элемента справочника "Companies" со значением поля Description Eng "Test Company"
   Тогда я проверяю наличие элемента справочника "Companies" со значением поля Description TR "Company Test"
    И я удаляю все элементы справочника "Companies"
    
Сценарий: _000124 загрузка json из макета "Countries" 
    И я отправляю json из макета "Countries"
    Тогда я проверяю наличие элемента справочника "Countries" со значением поля Description Eng "ТУРЦИЯ"
    Тогда я проверяю наличие элемента справочника "Countries" со значением поля Description TR "TR - ТУРЦИЯ"
    И я удаляю все элементы справочника "Countries"

Сценарий: _000125 загрузка json из макета "Currencies"
    И я отправляю json из макета "Currencies"
    Тогда я проверяю наличие элемента справочника "Currencies" со значением поля Description Eng "Евро"
    Тогда я проверяю наличие элемента справочника "Currencies" со значением поля Description TR "EUR"
    И я удаляю все элементы справочника "Currencies"

Сценарий: _000126 загрузка json из макета "Partners"
    И я отправляю json из макета "Partners"
    Тогда я проверяю наличие элемента справочника "Partners" со значением поля Description Eng "Test Partner01"
    Тогда я проверяю наличие элемента справочника "Partners" со значением поля Description TR "Tr Partner01"
    И я удаляю все элементы справочника "Partners"

Сценарий: _000127 загрузка json из макета "TaxRates"
    И я отправляю json из макета "TaxRates"
    Тогда я проверяю наличие элемента справочника "TaxRates" со значением поля Description Eng "0%"
    И я удаляю все элементы справочника "TaxRates"

Сценарий: _000128 загрузка json из макета "Stores"
    И я отправляю json из макета "Stores"
    Тогда я проверяю наличие элемента справочника "Stores" со значением поля Description Eng "Test 002"

Сценарий: _000129 очистка созданных элементов
    И я удаляю все элементы справочника "Stores"
    И я удаляю все элементы справочника "ItemTypes"
    И я удаляю все элементы справочника "Units"
    И я удаляю все элементы справочника "Items"
    И я удаляю все документы "PriceList"
    # И я удаляю все элементы справочника "PriceTypes"
    И я удаляю все элементы справочника "ItemKeys"
    И я удаляю элементы плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Color"
    И я удаляю элементы плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Size"
    И я удаляю все элементы справочника "ItemSegments"