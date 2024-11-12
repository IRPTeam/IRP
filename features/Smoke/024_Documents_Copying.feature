
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Documents - Copying
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows

Scenario: Copying item Documents "Additional accrual" (AdditionalAccrual)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.AdditionalAccrual AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents AdditionalAccrual" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents AdditionalAccrual" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents AdditionalAccrual" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents AdditionalAccrual" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents AdditionalAccrual" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents AdditionalAccrual" exception

Scenario: Copying item Documents "Additional cost allocation" (AdditionalCostAllocation)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.AdditionalCostAllocation AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents AdditionalCostAllocation" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents AdditionalCostAllocation" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents AdditionalCostAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents AdditionalCostAllocation" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents AdditionalCostAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents AdditionalCostAllocation" exception

Scenario: Copying item Documents "Additional deduction" (AdditionalDeduction)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.AdditionalDeduction AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents AdditionalDeduction" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents AdditionalDeduction" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents AdditionalDeduction" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents AdditionalDeduction" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents AdditionalDeduction" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents AdditionalDeduction" exception

Scenario: Copying item Documents "Additional revenue allocation" (AdditionalRevenueAllocation)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.AdditionalRevenueAllocation AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents AdditionalRevenueAllocation" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents AdditionalRevenueAllocation" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents AdditionalRevenueAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents AdditionalRevenueAllocation" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents AdditionalRevenueAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents AdditionalRevenueAllocation" exception

Scenario: Copying item Documents "Bank payment" (BankPayment)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.BankPayment AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents BankPayment" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents BankPayment" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents BankPayment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents BankPayment" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents BankPayment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents BankPayment" exception

Scenario: Copying item Documents "Bank receipt" (BankReceipt)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.BankReceipt AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents BankReceipt" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents BankReceipt" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents BankReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents BankReceipt" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents BankReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents BankReceipt" exception

Scenario: Copying item Documents "Batch reallocate incoming" (BatchReallocateIncoming)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.BatchReallocateIncoming AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents BatchReallocateIncoming" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents BatchReallocateIncoming" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents BatchReallocateIncoming" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents BatchReallocateIncoming" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents BatchReallocateIncoming" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents BatchReallocateIncoming" exception

Scenario: Copying item Documents "Batch reallocate outgoing" (BatchReallocateOutgoing)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.BatchReallocateOutgoing AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents BatchReallocateOutgoing" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents BatchReallocateOutgoing" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents BatchReallocateOutgoing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents BatchReallocateOutgoing" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents BatchReallocateOutgoing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents BatchReallocateOutgoing" exception

Scenario: Copying item Documents "Bundling" (Bundling)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.Bundling AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents Bundling" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents Bundling" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents Bundling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents Bundling" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents Bundling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents Bundling" exception

Scenario: Copying item Documents "Calculation deserved vacations" (CalculationDeservedVacations)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.CalculationDeservedVacations AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents CalculationDeservedVacations" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents CalculationDeservedVacations" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents CalculationDeservedVacations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents CalculationDeservedVacations" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents CalculationDeservedVacations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents CalculationDeservedVacations" exception

Scenario: Copying item Documents "Calculation movement costs" (CalculationMovementCosts)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.CalculationMovementCosts AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents CalculationMovementCosts" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents CalculationMovementCosts" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents CalculationMovementCosts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents CalculationMovementCosts" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents CalculationMovementCosts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents CalculationMovementCosts" exception

Scenario: Copying item Documents "Cash expense" (CashExpense)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.CashExpense AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents CashExpense" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents CashExpense" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents CashExpense" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents CashExpense" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents CashExpense" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents CashExpense" exception

Scenario: Copying item Documents "Cash payment" (CashPayment)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.CashPayment AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents CashPayment" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents CashPayment" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents CashPayment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents CashPayment" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents CashPayment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents CashPayment" exception

Scenario: Copying item Documents "Cash receipt" (CashReceipt)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.CashReceipt AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents CashReceipt" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents CashReceipt" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents CashReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents CashReceipt" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents CashReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents CashReceipt" exception

Scenario: Copying item Documents "Cash revenue" (CashRevenue)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.CashRevenue AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents CashRevenue" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents CashRevenue" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents CashRevenue" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents CashRevenue" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents CashRevenue" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents CashRevenue" exception

Scenario: Copying item Documents "Cash statement" (CashStatement)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.CashStatement AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents CashStatement" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents CashStatement" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents CashStatement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents CashStatement" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents CashStatement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents CashStatement" exception

Scenario: Copying item Documents "Cash transfer order" (CashTransferOrder)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.CashTransferOrder AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents CashTransferOrder" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents CashTransferOrder" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents CashTransferOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents CashTransferOrder" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents CashTransferOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents CashTransferOrder" exception

Scenario: Copying item Documents "Cheque bond transaction" (ChequeBondTransaction)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.ChequeBondTransaction AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents ChequeBondTransaction" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents ChequeBondTransaction" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents ChequeBondTransaction" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents ChequeBondTransaction" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents ChequeBondTransaction" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents ChequeBondTransaction" exception

Scenario: Copying item Documents "Cheque bond transaction item" (ChequeBondTransactionItem)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.ChequeBondTransactionItem AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents ChequeBondTransactionItem" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents ChequeBondTransactionItem" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents ChequeBondTransactionItem" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents ChequeBondTransactionItem" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents ChequeBondTransactionItem" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents ChequeBondTransactionItem" exception

Scenario: Copying item Documents "Commissioning of fixed asset" (CommissioningOfFixedAsset)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.CommissioningOfFixedAsset AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents CommissioningOfFixedAsset" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents CommissioningOfFixedAsset" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents CommissioningOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents CommissioningOfFixedAsset" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents CommissioningOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents CommissioningOfFixedAsset" exception

Scenario: Copying item Documents "Consolidated retail sales" (ConsolidatedRetailSales)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.ConsolidatedRetailSales AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents ConsolidatedRetailSales" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents ConsolidatedRetailSales" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents ConsolidatedRetailSales" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents ConsolidatedRetailSales" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents ConsolidatedRetailSales" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents ConsolidatedRetailSales" exception

Scenario: Copying item Documents "Credit note" (CreditNote)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.CreditNote AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents CreditNote" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents CreditNote" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents CreditNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents CreditNote" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents CreditNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents CreditNote" exception

Scenario: Copying item Documents "Customers advances closing" (CustomersAdvancesClosing)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.CustomersAdvancesClosing AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents CustomersAdvancesClosing" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents CustomersAdvancesClosing" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents CustomersAdvancesClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents CustomersAdvancesClosing" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents CustomersAdvancesClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents CustomersAdvancesClosing" exception

Scenario: Copying item Documents "Debit note" (DebitNote)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.DebitNote AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents DebitNote" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents DebitNote" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents DebitNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents DebitNote" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents DebitNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents DebitNote" exception

Scenario: Copying item Documents "Decommissioning of fixed asset" (DecommissioningOfFixedAsset)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.DecommissioningOfFixedAsset AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents DecommissioningOfFixedAsset" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents DecommissioningOfFixedAsset" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents DecommissioningOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents DecommissioningOfFixedAsset" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents DecommissioningOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents DecommissioningOfFixedAsset" exception

Scenario: Copying item Documents "Depreciation calculation" (DepreciationCalculation)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.DepreciationCalculation AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents DepreciationCalculation" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents DepreciationCalculation" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents DepreciationCalculation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents DepreciationCalculation" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents DepreciationCalculation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents DepreciationCalculation" exception

Scenario: Copying item Documents "Employee cash advance" (EmployeeCashAdvance)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.EmployeeCashAdvance AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents EmployeeCashAdvance" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents EmployeeCashAdvance" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents EmployeeCashAdvance" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents EmployeeCashAdvance" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents EmployeeCashAdvance" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents EmployeeCashAdvance" exception

Scenario: Copying item Documents "Employee firing" (EmployeeFiring)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.EmployeeFiring AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents EmployeeFiring" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents EmployeeFiring" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents EmployeeFiring" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents EmployeeFiring" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents EmployeeFiring" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents EmployeeFiring" exception

Scenario: Copying item Documents "Employee hiring" (EmployeeHiring)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.EmployeeHiring AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents EmployeeHiring" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents EmployeeHiring" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents EmployeeHiring" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents EmployeeHiring" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents EmployeeHiring" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents EmployeeHiring" exception

Scenario: Copying item Documents "Employee sick leave" (EmployeeSickLeave)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.EmployeeSickLeave AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents EmployeeSickLeave" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents EmployeeSickLeave" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents EmployeeSickLeave" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents EmployeeSickLeave" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents EmployeeSickLeave" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents EmployeeSickLeave" exception

Scenario: Copying item Documents "Employee transfer" (EmployeeTransfer)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.EmployeeTransfer AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents EmployeeTransfer" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents EmployeeTransfer" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents EmployeeTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents EmployeeTransfer" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents EmployeeTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents EmployeeTransfer" exception

Scenario: Copying item Documents "Employee vacation" (EmployeeVacation)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.EmployeeVacation AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents EmployeeVacation" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents EmployeeVacation" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents EmployeeVacation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents EmployeeVacation" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents EmployeeVacation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents EmployeeVacation" exception

Scenario: Copying item Documents "Fixed asset transfer" (FixedAssetTransfer)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.FixedAssetTransfer AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents FixedAssetTransfer" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents FixedAssetTransfer" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents FixedAssetTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents FixedAssetTransfer" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents FixedAssetTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents FixedAssetTransfer" exception

Scenario: Copying item Documents "Foreign currency revaluation" (ForeignCurrencyRevaluation)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.ForeignCurrencyRevaluation AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents ForeignCurrencyRevaluation" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents ForeignCurrencyRevaluation" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents ForeignCurrencyRevaluation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents ForeignCurrencyRevaluation" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents ForeignCurrencyRevaluation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents ForeignCurrencyRevaluation" exception

Scenario: Copying item Documents "Goods receipt" (GoodsReceipt)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.GoodsReceipt AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents GoodsReceipt" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents GoodsReceipt" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents GoodsReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents GoodsReceipt" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents GoodsReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents GoodsReceipt" exception

Scenario: Copying item Documents "Incoming payment order" (IncomingPaymentOrder)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.IncomingPaymentOrder AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents IncomingPaymentOrder" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents IncomingPaymentOrder" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents IncomingPaymentOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents IncomingPaymentOrder" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents IncomingPaymentOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents IncomingPaymentOrder" exception

Scenario: Copying item Documents "Internal supply request" (InternalSupplyRequest)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.InternalSupplyRequest AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents InternalSupplyRequest" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents InternalSupplyRequest" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents InternalSupplyRequest" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents InternalSupplyRequest" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents InternalSupplyRequest" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents InternalSupplyRequest" exception

Scenario: Copying item Documents "Inventory transfer" (InventoryTransfer)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.InventoryTransfer AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents InventoryTransfer" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents InventoryTransfer" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents InventoryTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents InventoryTransfer" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents InventoryTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents InventoryTransfer" exception

Scenario: Copying item Documents "Inventory transfer order" (InventoryTransferOrder)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.InventoryTransferOrder AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents InventoryTransferOrder" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents InventoryTransferOrder" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents InventoryTransferOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents InventoryTransferOrder" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents InventoryTransferOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents InventoryTransferOrder" exception

Scenario: Copying item Documents "Item stock adjustment" (ItemStockAdjustment)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.ItemStockAdjustment AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents ItemStockAdjustment" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents ItemStockAdjustment" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents ItemStockAdjustment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents ItemStockAdjustment" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents ItemStockAdjustment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents ItemStockAdjustment" exception

Scenario: Copying item Documents "Journal entry" (JournalEntry)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.JournalEntry AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark ";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents JournalEntry" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents JournalEntry" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents JournalEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents JournalEntry" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents JournalEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents JournalEntry" exception

Scenario: Copying item Documents "Labeling" (Labeling)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.Labeling AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents Labeling" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents Labeling" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents Labeling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents Labeling" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents Labeling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents Labeling" exception

Scenario: Copying item Documents "Manual register entry" (ManualRegisterEntry)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.ManualRegisterEntry AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents ManualRegisterEntry" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents ManualRegisterEntry" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents ManualRegisterEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents ManualRegisterEntry" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents ManualRegisterEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents ManualRegisterEntry" exception

Scenario: Copying item Documents "Modernization of fixed asset" (ModernizationOfFixedAsset)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.ModernizationOfFixedAsset AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents ModernizationOfFixedAsset" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents ModernizationOfFixedAsset" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents ModernizationOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents ModernizationOfFixedAsset" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents ModernizationOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents ModernizationOfFixedAsset" exception

Scenario: Copying item Documents "Money transfer" (MoneyTransfer)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.MoneyTransfer AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents MoneyTransfer" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents MoneyTransfer" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents MoneyTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents MoneyTransfer" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents MoneyTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents MoneyTransfer" exception

Scenario: Copying item Documents "Opening entry" (OpeningEntry)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.OpeningEntry AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents OpeningEntry" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents OpeningEntry" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents OpeningEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents OpeningEntry" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents OpeningEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents OpeningEntry" exception

Scenario: Copying item Documents "Outgoing payment order" (OutgoingPaymentOrder)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.OutgoingPaymentOrder AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents OutgoingPaymentOrder" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents OutgoingPaymentOrder" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents OutgoingPaymentOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents OutgoingPaymentOrder" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents OutgoingPaymentOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents OutgoingPaymentOrder" exception

Scenario: Copying item Documents "Payroll" (Payroll)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.Payroll AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents Payroll" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents Payroll" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents Payroll" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents Payroll" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents Payroll" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents Payroll" exception

Scenario: Copying item Documents "Physical count by location" (PhysicalCountByLocation)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.PhysicalCountByLocation AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark ";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents PhysicalCountByLocation" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents PhysicalCountByLocation" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents PhysicalCountByLocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents PhysicalCountByLocation" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents PhysicalCountByLocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents PhysicalCountByLocation" exception

Scenario: Copying item Documents "Physical inventory" (PhysicalInventory)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.PhysicalInventory AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents PhysicalInventory" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents PhysicalInventory" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents PhysicalInventory" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents PhysicalInventory" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents PhysicalInventory" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents PhysicalInventory" exception

Scenario: Copying item Documents "Planned receipt reservation" (PlannedReceiptReservation)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.PlannedReceiptReservation AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents PlannedReceiptReservation" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents PlannedReceiptReservation" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents PlannedReceiptReservation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents PlannedReceiptReservation" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents PlannedReceiptReservation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents PlannedReceiptReservation" exception

Scenario: Copying item Documents "Price list" (PriceList)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.PriceList AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents PriceList" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents PriceList" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents PriceList" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents PriceList" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents PriceList" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents PriceList" exception

Scenario: Copying item Documents "Production" (Production)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.Production AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents Production" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents Production" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents Production" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents Production" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents Production" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents Production" exception

Scenario: Copying item Documents "Production costs allocation" (ProductionCostsAllocation)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.ProductionCostsAllocation AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents ProductionCostsAllocation" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents ProductionCostsAllocation" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents ProductionCostsAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents ProductionCostsAllocation" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents ProductionCostsAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents ProductionCostsAllocation" exception

Scenario: Copying item Documents "Production planning" (ProductionPlanning)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.ProductionPlanning AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents ProductionPlanning" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents ProductionPlanning" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents ProductionPlanning" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents ProductionPlanning" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents ProductionPlanning" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents ProductionPlanning" exception

Scenario: Copying item Documents "Production planning closing" (ProductionPlanningClosing)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.ProductionPlanningClosing AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents ProductionPlanningClosing" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents ProductionPlanningClosing" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents ProductionPlanningClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents ProductionPlanningClosing" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents ProductionPlanningClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents ProductionPlanningClosing" exception

Scenario: Copying item Documents "Production planning correction" (ProductionPlanningCorrection)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.ProductionPlanningCorrection AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents ProductionPlanningCorrection" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents ProductionPlanningCorrection" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents ProductionPlanningCorrection" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents ProductionPlanningCorrection" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents ProductionPlanningCorrection" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents ProductionPlanningCorrection" exception

Scenario: Copying item Documents "Purchase invoice" (PurchaseInvoice)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.PurchaseInvoice AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents PurchaseInvoice" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents PurchaseInvoice" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents PurchaseInvoice" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents PurchaseInvoice" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents PurchaseInvoice" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents PurchaseInvoice" exception

Scenario: Copying item Documents "Purchase order" (PurchaseOrder)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.PurchaseOrder AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents PurchaseOrder" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents PurchaseOrder" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents PurchaseOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents PurchaseOrder" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents PurchaseOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents PurchaseOrder" exception

Scenario: Copying item Documents "Purchase order closing" (PurchaseOrderClosing)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.PurchaseOrderClosing AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents PurchaseOrderClosing" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents PurchaseOrderClosing" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents PurchaseOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents PurchaseOrderClosing" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents PurchaseOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents PurchaseOrderClosing" exception

Scenario: Copying item Documents "Purchase return" (PurchaseReturn)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.PurchaseReturn AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents PurchaseReturn" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents PurchaseReturn" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents PurchaseReturn" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents PurchaseReturn" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents PurchaseReturn" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents PurchaseReturn" exception

Scenario: Copying item Documents "Purchase return order" (PurchaseReturnOrder)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.PurchaseReturnOrder AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents PurchaseReturnOrder" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents PurchaseReturnOrder" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents PurchaseReturnOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents PurchaseReturnOrder" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents PurchaseReturnOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents PurchaseReturnOrder" exception

Scenario: Copying item Documents "Reconciliation statement" (ReconciliationStatement)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.ReconciliationStatement AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents ReconciliationStatement" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents ReconciliationStatement" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents ReconciliationStatement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents ReconciliationStatement" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents ReconciliationStatement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents ReconciliationStatement" exception

Scenario: Copying item Documents "Retail goods receipt" (RetailGoodsReceipt)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.RetailGoodsReceipt AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents RetailGoodsReceipt" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents RetailGoodsReceipt" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents RetailGoodsReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents RetailGoodsReceipt" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents RetailGoodsReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents RetailGoodsReceipt" exception

Scenario: Copying item Documents "Retail receipt correction" (RetailReceiptCorrection)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.RetailReceiptCorrection AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark ";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents RetailReceiptCorrection" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents RetailReceiptCorrection" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents RetailReceiptCorrection" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents RetailReceiptCorrection" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents RetailReceiptCorrection" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents RetailReceiptCorrection" exception

Scenario: Copying item Documents "Retail return receipt" (RetailReturnReceipt)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.RetailReturnReceipt AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents RetailReturnReceipt" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents RetailReturnReceipt" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents RetailReturnReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents RetailReturnReceipt" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents RetailReturnReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents RetailReturnReceipt" exception

Scenario: Copying item Documents "Retail sales receipt" (RetailSalesReceipt)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.RetailSalesReceipt AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents RetailSalesReceipt" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents RetailSalesReceipt" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents RetailSalesReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents RetailSalesReceipt" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents RetailSalesReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents RetailSalesReceipt" exception

Scenario: Copying item Documents "Retail shipment confirmation" (RetailShipmentConfirmation)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.RetailShipmentConfirmation AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents RetailShipmentConfirmation" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents RetailShipmentConfirmation" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents RetailShipmentConfirmation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents RetailShipmentConfirmation" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents RetailShipmentConfirmation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents RetailShipmentConfirmation" exception

Scenario: Copying item Documents "Sales invoice" (SalesInvoice)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.SalesInvoice AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents SalesInvoice" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents SalesInvoice" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents SalesInvoice" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents SalesInvoice" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents SalesInvoice" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents SalesInvoice" exception


Scenario: Copying item Documents "Sales report from trade agent" (SalesReportFromTradeAgent)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.SalesReportFromTradeAgent AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents SalesReportFromTradeAgent" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents SalesReportFromTradeAgent" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents SalesReportFromTradeAgent" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents SalesReportFromTradeAgent" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents SalesReportFromTradeAgent" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents SalesReportFromTradeAgent" exception

Scenario: Copying item Documents "Sales report to consignor" (SalesReportToConsignor)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.SalesReportToConsignor AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents SalesReportToConsignor" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents SalesReportToConsignor" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents SalesReportToConsignor" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents SalesReportToConsignor" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents SalesReportToConsignor" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents SalesReportToConsignor" exception

Scenario: Copying item Documents "Sales return" (SalesReturn)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.SalesReturn AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents SalesReturn" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents SalesReturn" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents SalesReturn" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents SalesReturn" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents SalesReturn" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents SalesReturn" exception


Scenario: Copying item Documents "Sales return order" (SalesReturnOrder)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.SalesReturnOrder AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents SalesReturnOrder" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents SalesReturnOrder" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents SalesReturnOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents SalesReturnOrder" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents SalesReturnOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents SalesReturnOrder" exception

Scenario: Copying item Documents "Shipment confirmation" (ShipmentConfirmation)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.ShipmentConfirmation AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents ShipmentConfirmation" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents ShipmentConfirmation" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents ShipmentConfirmation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents ShipmentConfirmation" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents ShipmentConfirmation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents ShipmentConfirmation" exception

Scenario: Copying item Documents "Stock adjustment as surplus" (StockAdjustmentAsSurplus)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.StockAdjustmentAsSurplus AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents StockAdjustmentAsSurplus" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents StockAdjustmentAsSurplus" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents StockAdjustmentAsSurplus" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents StockAdjustmentAsSurplus" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents StockAdjustmentAsSurplus" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents StockAdjustmentAsSurplus" exception

Scenario: Copying item Documents "Stock adjustment as write-off" (StockAdjustmentAsWriteOff)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.StockAdjustmentAsWriteOff AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents StockAdjustmentAsWriteOff" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents StockAdjustmentAsWriteOff" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents StockAdjustmentAsWriteOff" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents StockAdjustmentAsWriteOff" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents StockAdjustmentAsWriteOff" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents StockAdjustmentAsWriteOff" exception

Scenario: Copying item Documents "Time sheet" (TimeSheet)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.TimeSheet AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents TimeSheet" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents TimeSheet" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents TimeSheet" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents TimeSheet" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents TimeSheet" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents TimeSheet" exception

Scenario: Copying item Documents "Unbundling" (Unbundling)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.Unbundling AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents Unbundling" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents Unbundling" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents Unbundling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents Unbundling" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents Unbundling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents Unbundling" exception

Scenario: Copying item Documents "Vendors advances closing" (VendorsAdvancesClosing)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.VendorsAdvancesClosing AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents VendorsAdvancesClosing" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents VendorsAdvancesClosing" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents VendorsAdvancesClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents VendorsAdvancesClosing" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents VendorsAdvancesClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents VendorsAdvancesClosing" exception

Scenario: Copying item Documents "Visitor counter" (VisitorCounter)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.VisitorCounter AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents VisitorCounter" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents VisitorCounter" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents VisitorCounter" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents VisitorCounter" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents VisitorCounter" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents VisitorCounter" exception

Scenario: Copying item Documents "Work order" (WorkOrder)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.WorkOrder AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents WorkOrder" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents WorkOrder" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents WorkOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents WorkOrder" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents WorkOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents WorkOrder" exception

Scenario: Copying item Documents "Work order closing" (WorkOrderClosing)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.WorkOrderClosing AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents WorkOrderClosing" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents WorkOrderClosing" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents WorkOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents WorkOrderClosing" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents WorkOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents WorkOrderClosing" exception

Scenario: Copying item Documents "Work sheet" (WorkSheet)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.WorkSheet AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents WorkSheet" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents WorkSheet" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents WorkSheet" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents WorkSheet" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents WorkSheet" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents WorkSheet" exception

Scenario: Copying item Documents "Debit/Credit note" (DebitCreditNote)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.DebitCreditNote AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents DebitCreditNote" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents DebitCreditNote" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents DebitCreditNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents DebitCreditNote" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents DebitCreditNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents DebitCreditNote" exception

Scenario: Copying item Documents "Expense accruals" (ExpenseAccruals)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.ExpenseAccruals AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents ExpenseAccruals" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents ExpenseAccruals" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents ExpenseAccruals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents ExpenseAccruals" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents ExpenseAccruals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents ExpenseAccruals" exception

Scenario: Copying item Documents "Simple document" (Тесты_ДокументПростой)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.Тесты_ДокументПростой AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents Тесты_ДокументПростой" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents Тесты_ДокументПростой" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents Тесты_ДокументПростой" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents Тесты_ДокументПростой" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents Тесты_ДокументПростой" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents Тесты_ДокументПростой" exception

Scenario: Copying item Documents "Revenue accruals" (RevenueAccruals)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.RevenueAccruals AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents RevenueAccruals" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents RevenueAccruals" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents RevenueAccruals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents RevenueAccruals" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents RevenueAccruals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents RevenueAccruals" exception

Scenario: Copying item Documents "Outgoing message" (OutgoingMessage)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.OutgoingMessage AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark ";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents OutgoingMessage" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents OutgoingMessage" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents OutgoingMessage" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents OutgoingMessage" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents OutgoingMessage" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents OutgoingMessage" exception

Scenario: Copying item Documents "Taxes operation" (TaxesOperation)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.TaxesOperation AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Documents TaxesOperation" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents TaxesOperation" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Documents TaxesOperation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Documents TaxesOperation" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Documents TaxesOperation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Documents TaxesOperation" exception
