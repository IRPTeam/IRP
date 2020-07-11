#language: ru
@Positive
@Discount
@SpecialOffersMaxInRow
@tree


Функционал: range discount

As a sales manager
I want to check the calculation and order of applying the range discount (applied to the string manually, summed up with other discounts).
So that the range discount is calculated correctly


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.
# For each product, a discount is given in the form of a percentage (e.g. Product A from 2 to 5%, Product B from 3 to 7%). 
# A sales rep can set a discount from the specified range in a sales order himself

Сценарий: _033401 preparation
	Когда change the Discount Price 2 manual
	Когда change the manual setting of the Discount Price 1 discount.
	Когда move the discount 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms to the group Maximum
	Когда move the discount 4+1 Dress and Trousers, Discount on Basic Partner terms to the group Maximum
	Когда move the discount All items 5+1, Discount on Basic Partner terms to the group Maximum
	Когда change manually setting All items 5+1, Discount on Basic Partner terms
	Когда  move the Discount Price 1 to Maximum 
	Когда change manually setting 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms
	Когда change manually setting 4+1 Dress and Trousers, Discount on Basic Partner terms


Сценарий: _033402 range discount calculation by line 
	# Trousers - 5-7%, Dress XS/Blue - 3-10%, Dress S/Yellow - 4-8%
	Когда creating an order for Ferron BP Basic Partner term, TRY (Dress -10 and Trousers - 5)
	* Calculate range discount for Trousers - 6%
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'      |
			| 'Trousers'     |
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                               |
			| 'Range Discount Basic (Trousers)' |
		И в таблице "Offers" я активизирую поле "∑"
		И в таблице "Offers" я выбираю текущую строку
		И в поле с именем "PercentNumber" я ввожу текст "6"
		И я нажимаю на кнопку с именем "FormOk"
		И я нажимаю на кнопку с именем "FormOK"
		И Пауза 2
	* Calculate range discount for Dress - 5%
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'      |
			| 'Dress' |
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                               |
			| 'Range Discount Basic (Dress)' |
		И в таблице "Offers" я активизирую поле "∑"
		И в таблице "Offers" я выбираю текущую строку
		И в поле с именем "PercentNumber" я ввожу текст "5"
		И я нажимаю на кнопку с именем "FormOk"
		И я нажимаю на кнопку с именем "FormOK"
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount'    |
		| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | '260,00'        | 'pcs'  | '4 940,00'        |
		| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '5,000'  | '120,00'        | 'pcs'  | '1 880,00'        |
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку "Post and close"
		И таблица 'List' содержит строки
		| 'Partner'    | 'Σ'     |
		| 'Ferron BP'  |  '6 820,00'|
	

Сценарий: _033403 check of the minimum percentage of the range discount by lines
# Trousers - 5-7%, Dress XS/Blue - 3-10%, Dress S/Yellow - 4-8%
		Когда creating an order for Ferron BP Basic Partner term, TRY (Dress -10 and Trousers - 5)
		* Calculate range discount for Trousers - 4%
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'      |
				| 'Trousers' |
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
			И в таблице "Offers" я перехожу к строке:
				| 'Presentation'                               |
				| 'Range Discount Basic (Trousers)' |
			И в таблице "Offers" я активизирую поле "∑"
			И в таблице "Offers" я выбираю текущую строку
			И в поле с именем "PercentNumber" я ввожу текст "5"
			И я нажимаю на кнопку с именем "FormOk"
			И я нажимаю на кнопку с именем "FormOK"
			И Пауза 2
		* Calculate range discount for Dress - 3%
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'      |
				| 'Dress' |
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
			И в таблице "Offers" я перехожу к строке:
				| 'Presentation'                               |
				| 'Range Discount Basic (Dress)' |
			И в таблице "Offers" я активизирую поле "∑"
			И в таблице "Offers" я выбираю текущую строку
			И в поле с именем "PercentNumber" я ввожу текст "3"
			И я нажимаю на кнопку с именем "FormOk"
			И я нажимаю на кнопку с именем "FormOK"
			И Пауза 2
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit'| 'Total amount'    |
				| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | '156,00'        | 'pcs' | '5 044,00'        |
				| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '5,000'  | '100,00'        | 'pcs' | '1 900,00'        |
			И в таблице "ItemList" я нажимаю на кнопку '% Offers'
			И я нажимаю на кнопку 'OK'
			И я нажимаю на кнопку "Post and close"
			И таблица 'List' содержит строки
				| 'Partner'    | 'Σ'     |
				| 'Ferron BP'  |  '6 944,00'|
		

Сценарий: _033404 check of the maximum percentage of the range discount by lines
# Trousers - 5-7%, Dress XS/Blue - 3-10%, Dress S/Yellow - 4-8%
		Когда creating an order for Ferron BP Basic Partner term, TRY (Dress -10 and Trousers - 5)
		* Calculate range discount for Trousers - 8%
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'      |
				| 'Trousers' |
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
			И в таблице "Offers" я перехожу к строке:
				| 'Presentation'                               |
				| 'Range Discount Basic (Trousers)' |
			И в таблице "Offers" я активизирую поле "∑"
			И в таблице "Offers" я выбираю текущую строку
			И в поле с именем "PercentNumber" я ввожу текст "7"
			И я нажимаю на кнопку с именем "FormOk"
			И я нажимаю на кнопку с именем "FormOK"
			И Пауза 2
		* Calculate range discount for Dress - 10%
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'      |
				| 'Dress' |
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
			И в таблице "Offers" я перехожу к строке:
				| 'Presentation'                               |
				| 'Range Discount Basic (Dress)' |
			И в таблице "Offers" я активизирую поле "∑"
			И в таблице "Offers" я выбираю текущую строку
			И в поле с именем "PercentNumber" я ввожу текст "10"
			И я нажимаю на кнопку с именем "FormOk"
			И я нажимаю на кнопку с именем "FormOK"
			И Пауза 2
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount'    |
				| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | '520,00'        | 'pcs'  | '4 680,00'        |
				| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '5,000'  | '140,00'        | 'pcs'  | '1 860,00'        |
			И в таблице "ItemList" я нажимаю на кнопку '% Offers'
			И я нажимаю на кнопку 'OK'
			И я нажимаю на кнопку "Post and close"
			И таблица 'List' содержит строки
				| 'Partner'    | 'Σ'     |
				| 'Ferron BP'  |  '6 540,00'|
		

Сценарий: _033405 Range discount and Special price discount calculation 
	# Trousers - 5-7%, Dress XS/Blue - 3-10%, Dress S/Yellow - 4-8%
	Когда creating an order for Ferron BP Basic Partner term, TRY (Dress -10 and Trousers - 5)
	* Calculate range discount for Trousers - 7%
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'      |
			| 'Trousers' |
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                               |
			| 'Range Discount Basic (Trousers)' |
		И в таблице "Offers" я активизирую поле "∑"
		И в таблице "Offers" я выбираю текущую строку
		И в поле с именем "PercentNumber" я ввожу текст "7"
		И я нажимаю на кнопку с именем "FormOk"
		И я нажимаю на кнопку с именем "FormOK"
		И Пауза 2
	* Calculate Discount price 1
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                  |
			| 'Discount Price 1' |
		И в таблице "Offers" я активизирую поле "Is select"
		И в таблице "Offers" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
	* Check that the calculation is correct
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount' |
			| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | '260,00'        | 'pcs'  | '4 940,00'        |
			| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '5,000'  | '540,00'        | 'pcs'  | '1 460,00'        |
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку "Post and close"
		И таблица 'List' содержит строки
				| 'Partner'    | 'Σ'     |
				| 'Ferron BP'  |  '6 400,00'|


Сценарий: _033406 check the discount order Range discount and crowding out 2 price special offers
	# Trousers - 5-7%, Dress XS/Blue - 3-10%, Dress S/Yellow - 4-8%
	Когда  move the Discount Price 2 special offer to Maximum
	Когда creating an order for Ferron BP Basic Partner term, TRY (Dress -10 and Trousers - 5)
	* Calculate range discount for Trousers - 7%
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'      |
			| 'Trousers' |
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                               |
			| 'Range Discount Basic (Trousers)' |
		И в таблице "Offers" я активизирую поле "∑"
		И в таблице "Offers" я выбираю текущую строку
		И в поле с именем "PercentNumber" я ввожу текст "7"
		И я нажимаю на кнопку с именем "FormOk"
		И я нажимаю на кнопку с именем "FormOK"
		И Пауза 2
	* Calculate discount Discount price 1
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                  |
			| 'Discount Price 1' |
		И в таблице "Offers" я активизирую поле "Is select"
		И в таблице "Offers" я выбираю текущую строку
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                  |
			| 'Discount Price 2' |
		И в таблице "Offers" я активизирую поле "Is select"
		И в таблице "Offers" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
	* Check that the calculation is correct
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount'    |
			| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | '1 310,00'      | 'pcs'  | '3 890,00'        |
			| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '5,000'  | '725,00'        | 'pcs'  | '1 275,00'        |
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку "Post and close"
		И таблица 'List' содержит строки
				| 'Partner'    | 'Σ'     |
				| 'Ferron BP'  |  '5 165,00'|


Сценарий: _033407 range discount recalculation when the quantity of items in the order changes
	# Trousers - 5-7%, Dress XS/Blue - 3-10%, Dress S/Yellow - 4-8%
	Когда creating an order for Ferron BP Basic Partner term, TRY (Dress -10 and Trousers - 5)
	* Calculate range discount for Trousers - 7%
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'      |
			| 'Trousers' |
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                               |
			| 'Range Discount Basic (Trousers)' |
		И в таблице "Offers" я активизирую поле "∑"
		И в таблице "Offers" я выбираю текущую строку
		И в поле с именем "PercentNumber" я ввожу текст "7"
		И я нажимаю на кнопку с именем "FormOk"
		И я нажимаю на кнопку с именем "FormOK"
		И Пауза 2
	* Recalculation
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit'| 'Total amount'    |
			| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | ''              | 'pcs' | '5 200,00'        |
			| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '5,000'  | '140,00'        | 'pcs' | '1 860,00'        |
	* Сhange the quantity by Trousers by 30 pieces
		И в таблице "ItemList" я перехожу к строке:
		| 'Item'      |
		| 'Trousers' |
		И в таблице "ItemList" в поле 'Q' я ввожу текст '30,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Recalculation
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И я нажимаю на кнопку 'OK'
	* Check recalculation
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount'    |
		| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | ''              | 'pcs'  | '5 200,00'        |
		| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '30,000' | '140,00'        | 'pcs'  | '11 860,00'       |
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И таблица 'List' содержит строки
		| 'Partner'    | 'Σ'     |
		| 'Ferron BP'  |  '17 060,00'|


	


	







	












