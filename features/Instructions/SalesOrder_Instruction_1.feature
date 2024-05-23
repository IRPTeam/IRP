#language: en

@tree

Functionality: Sales Order Instruction - Satış siparişi

Partner - Партнер - Cari hesap - field for filling partner/client name -поле для заполнения имени партнера/клиента - müşteri adı için doldurma alanı
Legal name - Контрагент  - Fatura hesabi - field for filling Legal Name of partner/client - поле для заполнения юридического названия партнера/клиента - müşterinin yasal adı için doldurma alanı
Partner term - Соглашение - Sözleşme - field for filling agreement of terms of sales, if the partner has only one term then it's filled in automatically - поле для заполнения соглашения о продажах; если у партнера есть только одно соглашение, то оно заполняется автоматически - Satış şartları sözleşme için doldurma alanı, eğer ortağın sadece bir sözleşmesi varsa, otomatik olarak doldurulur
Company - Организация - Şİrket - field for filling own company name - поле для заполнения названия вашей компании - Kendi şirketinizin adı için doldurma alanı 
Store -	Склад - Depo - field for filling shipment warehouse - поле для заполнения склада для отгрузки - Sevkiyat deposu için doldurma alanı

Partner item - Номенклатура партнера - Cari hesap malzemesi - field for filling Partner's Item's name if necessary - поле для заполнения названия товара партнера, если необходимо - Cari hesap malzemesini doldurma alanı
Item - Номенклатура - Malzeme - field for filling Item - поле для заполнения номенклатуры - Malzeme doldurma alanı
Item key - Характеристика - Varyant - field for filling Item key if necessary, if not it's filled in automatically - поле для заполнения характеристики, если необходимо; если нет, то заполняется автоматически - varsa varyant doldurma alanı, yoksa otomatik olarak doldurulur
Procurment method - Метод закупки - Tedarik şekli -  Procurment method field is filled in automatically, also can be changed manually as: stock, purchase, no reserve, incoming reserve - поле для заполнения метода закупки, заполняется автоматически, также может быть изменено вручную на: склад, покупка, без резерва, приходящий резерв - Tedarik şekli alanı otomatik olarak doldurulur, ayrıca manuel olarak değiştirilebilir: stok, satın alma, rezerv yok, gelen rezerv
Quantity - Количество - Miktar - field for filling Quantity of item - поле для заполнения количества товара - miktar doldurma alanı
Unit - Единица измерения - Birim - Unit field is filled in automatically - поле для заполнения единицы измерения, заполняется автоматически - birim alanı, otomatik doldurulur
Price Type - Тип цены - Fiyat Tipi - Price Type field is filled in automatically - поле для заполнения типа цены, заполняется автоматически - Fiyat tipi alanı, otomatik doldurulur
Price - Цена - Fiyat - field for filling price of an item - поле для заполнения цены товара - fiyat alanı
VAT - НДС - KDV - VAT field for filling VAT of item is filled in automatically - поле для заполнения НДС товара, заполняется автоматически - KDV alanı, otomatik doldurulur
Offers amount - Сумма скидки - Iskonto tutar field for filling in an offer amount if necessary- поле для заполнения суммы скидки, если необходимо - Iskonto tutar alanı, otomatik doldurulur
Dont calculate row - Не рассчитывать строку - Satırı hesaplama - field for canceling automatic calculation of Tax Amount, Net Amount,Total Amount. And activates manual entry of Amounts - поле для отмены автоматического расчета суммы налога, чистой суммы, общей суммы и активирует ручного ввода сумм- KDV Tutarı, Net Tutar, Toplam Tutarın otomatik hesaplanmasını iptal etme alanı, tutarların manuel girişini etkinleştirir
Tax Amount -Сумма НДС - KDV Tutarı - Tax Amount field is calculated automatically - поле для расчета суммы налога - KDV hesaplama alanı
Net Amount - Сумма без НДС - Net Tutar - Net Amount field is calculated automatically - поле для расчета чистой суммы без НДС, заполняется автоматическиого - Net tutar hesaplama alanı
Total Amount - Итого - Toplam tutar - Total Amount field is calculated automatically - поле для автоматического расчета общей суммы - toplam tutar hesaplama alanı
Store -	Склад - Depo - Store field is calculated automatically  - поле для заполнения склада, заполняется автоматическиого - depo doldurma alanı, otomatik doldurulur
Reservation date - Дата резервации - Rezerv tarihi- field to enter reservation date if an item procurment method is incoming reserve - поле для заполнения даты резервации, если метод закупки товара - приходящий резерв - rezerv tarihi doldurma alanı, tedarik tipi gelen rezerv ise
Delivery date - Дата доставки - Teslim tarihi - field to enter delivery date - поле для заполнения даты доставки - teslim tarihi doldurma alanı
Profit loss center - Центр прибыли и убытков - Kar/Zarar merkezi - field to fill the profit loss center	- поле для заполнения центра прибыли и убытков - kar/zarar merkezi doldurma alanı
Revenue type - Тип дохода -	Gelir tipi - field to fill the revenue type - поле для заполнения типа дохода - gelir tipidoldurma alanı
Detail - Детали - Detay -field to enter the additional information for related item - поле для заполнения дополнительной информации по связанному товару - malzeme ile ilgili detay doldurma alani
Cancel - Отмена - Iptal - field to register canceled sales item -  - поле для регистрации отмененного товара - Iptal belirtme alanı
Cancel reason - Причина отмены - Iptal Sebebi - field to fill the reason of cancelation - поле для заполнения причины отмены - Iptal Sebebi doldurma alanı
Sales person - Продавец - Satış - field to fill sales person of current Sales Order - поле для заполнения продавца, ответственного за текущий заказ - satış personelini doldurma alanı


Scenario: Sales Order Instruction
* To place an order you need to create a document Sales Order, open a Sales Orders from Sales - A/R subsystem
	When in sections panel I select "Sales - A/R"
	And in functions panel I select "Sales orders"
* To creat new document click on "Create" button
	And I click the button named "FormCreate"
* New document form will open
	Then "Sales order (create)" window is opened
* In the new document you need to fill in the basic details, first choose the Partner Name
	And I click Choice button of the field named "Partner"
	Then "Partners" window is opened
	And I activate field named "Description" in "List" table
	And I go to line in "List" table
		| 'Description'                  |
		| 'Customer 1 (3 partner terms)' |		
	And I select current line in "List" table
* The Legal Name filled in automatically
	Then the form attribute named "LegalName" became equal to "Client 1"
* Next, choose the Agreement
	And I click Choice button of the field named "Agreement"
	And I go to line in "List" table
		| 'Description'                                             |
		| 'Partner term with customer (by document + credit limit)' |
	And I select current line in "List" table
* The Company and Store fields filled in automatically
	Then the form attribute named "Company" became equal to "Own company 2"
	Then the form attribute named "Store" became equal to "Store 1 (with balance control)"
* Next you need to fill in the Items in table, first choose the Item	
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I activate field named "ItemListItem" in "ItemList" table
	And I select current line in "ItemList" table
	And I click choice button of the attribute named "ItemListItem" in "ItemList" table
	Then "Items" window is opened
	And I activate field named "Description" in "List" table
	And I go to line in "List" table
		| 'Description'        |
		| 'Item with item key' |
	And I select current line in "List" table
* And the Item key if necessary
	And I activate field named "ItemListItemKey" in "ItemList" table
	And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
	Then "Item keys" window is opened
	And I activate field named "Item" in "List" table
	And I go to line in "List" table
		| 'Item key'  |
		| 'S/Color 1' |
	And I select current line in "List" table
* The Procurement method, Unit, Price Type, Price, VAT, Store field filled in automatically
	And "ItemList" table became equal
		| 'Procurement method' | 'Quantity' | 'Unit' | 'Price type' | 'Price'  | 'VAT' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'                          |
		| 'Stock'              | '1,000'    | 'pcs'  | 'Wholesale'  | '190,00' | '20%' | '31,67'      | '158,33'     | '190,00'       | 'Store 1 (with balance control)' |
* Enter the quantity of item and all other VAT, NET, Total amounts calculated automatically
	And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
	And I finish line editing in "ItemList" table
	And "ItemList" table became equal
		| 'Item'               | 'Item key'  | 'Procurement method' | 'Quantity' | 'Unit' | 'Price type' | 'Price'  | 'VAT' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'                          |
		| 'Item with item key' | 'S/Color 1' | 'Stock'              | '10,000'   | 'pcs'  | 'Wholesale'  | '190,00' | '20%' | '316,67'     | '1 583,33'   | '1 900,00'     | 'Store 1 (with balance control)' |

