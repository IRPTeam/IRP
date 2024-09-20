
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Documents - Save
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows

Scenario: Save item Documents "Additional accrual" (AdditionalAccrual)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents AdditionalAccrual" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents AdditionalAccrual" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents AdditionalAccrual" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents AdditionalAccrual" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents AdditionalAccrual" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments AdditionalAccrual" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents AdditionalAccrual" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments AdditionalAccrual" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents AdditionalAccrual" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents AdditionalAccrual" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents AdditionalAccrual" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents AdditionalAccrual" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents AdditionalAccrual" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents AdditionalAccrual" exception

Scenario: Save item Documents "Additional cost allocation" (AdditionalCostAllocation)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents AdditionalCostAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents AdditionalCostAllocation" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents AdditionalCostAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents AdditionalCostAllocation" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents AdditionalCostAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments AdditionalCostAllocation" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents AdditionalCostAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments AdditionalCostAllocation" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents AdditionalCostAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents AdditionalCostAllocation" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents AdditionalCostAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents AdditionalCostAllocation" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents AdditionalCostAllocation" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents AdditionalCostAllocation" exception

Scenario: Save item Documents "Additional deduction" (AdditionalDeduction)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents AdditionalDeduction" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents AdditionalDeduction" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents AdditionalDeduction" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents AdditionalDeduction" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents AdditionalDeduction" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments AdditionalDeduction" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents AdditionalDeduction" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments AdditionalDeduction" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents AdditionalDeduction" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents AdditionalDeduction" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents AdditionalDeduction" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents AdditionalDeduction" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents AdditionalDeduction" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents AdditionalDeduction" exception

Scenario: Save item Documents "Additional revenue allocation" (AdditionalRevenueAllocation)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents AdditionalRevenueAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents AdditionalRevenueAllocation" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents AdditionalRevenueAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents AdditionalRevenueAllocation" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents AdditionalRevenueAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments AdditionalRevenueAllocation" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents AdditionalRevenueAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments AdditionalRevenueAllocation" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents AdditionalRevenueAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents AdditionalRevenueAllocation" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents AdditionalRevenueAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents AdditionalRevenueAllocation" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents AdditionalRevenueAllocation" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents AdditionalRevenueAllocation" exception

Scenario: Save item Documents "Bank payment" (BankPayment)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents BankPayment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents BankPayment" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents BankPayment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents BankPayment" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents BankPayment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments BankPayment" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents BankPayment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments BankPayment" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents BankPayment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents BankPayment" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents BankPayment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents BankPayment" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents BankPayment" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents BankPayment" exception

Scenario: Save item Documents "Bank receipt" (BankReceipt)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents BankReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents BankReceipt" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents BankReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents BankReceipt" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents BankReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments BankReceipt" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents BankReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments BankReceipt" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents BankReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents BankReceipt" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents BankReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents BankReceipt" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents BankReceipt" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents BankReceipt" exception

Scenario: Save item Documents "Batch reallocate incoming" (BatchReallocateIncoming)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents BatchReallocateIncoming" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents BatchReallocateIncoming" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents BatchReallocateIncoming" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents BatchReallocateIncoming" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents BatchReallocateIncoming" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments BatchReallocateIncoming" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents BatchReallocateIncoming" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments BatchReallocateIncoming" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents BatchReallocateIncoming" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents BatchReallocateIncoming" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents BatchReallocateIncoming" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents BatchReallocateIncoming" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents BatchReallocateIncoming" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents BatchReallocateIncoming" exception

Scenario: Save item Documents "Batch reallocate outgoing" (BatchReallocateOutgoing)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents BatchReallocateOutgoing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents BatchReallocateOutgoing" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents BatchReallocateOutgoing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents BatchReallocateOutgoing" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents BatchReallocateOutgoing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments BatchReallocateOutgoing" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents BatchReallocateOutgoing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments BatchReallocateOutgoing" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents BatchReallocateOutgoing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents BatchReallocateOutgoing" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents BatchReallocateOutgoing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents BatchReallocateOutgoing" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents BatchReallocateOutgoing" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents BatchReallocateOutgoing" exception

Scenario: Save item Documents "Bundling" (Bundling)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents Bundling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents Bundling" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents Bundling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents Bundling" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents Bundling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments Bundling" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents Bundling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments Bundling" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents Bundling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents Bundling" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents Bundling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents Bundling" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents Bundling" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents Bundling" exception

Scenario: Save item Documents "Calculation deserved vacations" (CalculationDeservedVacations)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents CalculationDeservedVacations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents CalculationDeservedVacations" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents CalculationDeservedVacations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents CalculationDeservedVacations" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents CalculationDeservedVacations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments CalculationDeservedVacations" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents CalculationDeservedVacations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments CalculationDeservedVacations" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents CalculationDeservedVacations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents CalculationDeservedVacations" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents CalculationDeservedVacations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents CalculationDeservedVacations" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents CalculationDeservedVacations" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents CalculationDeservedVacations" exception

Scenario: Save item Documents "Calculation movement costs" (CalculationMovementCosts)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents CalculationMovementCosts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents CalculationMovementCosts" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents CalculationMovementCosts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents CalculationMovementCosts" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents CalculationMovementCosts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments CalculationMovementCosts" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents CalculationMovementCosts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments CalculationMovementCosts" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents CalculationMovementCosts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents CalculationMovementCosts" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents CalculationMovementCosts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents CalculationMovementCosts" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents CalculationMovementCosts" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents CalculationMovementCosts" exception

Scenario: Save item Documents "Cash expense" (CashExpense)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents CashExpense" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents CashExpense" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents CashExpense" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents CashExpense" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents CashExpense" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments CashExpense" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents CashExpense" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments CashExpense" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents CashExpense" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents CashExpense" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents CashExpense" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents CashExpense" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents CashExpense" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents CashExpense" exception

Scenario: Save item Documents "Cash payment" (CashPayment)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents CashPayment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents CashPayment" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents CashPayment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents CashPayment" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents CashPayment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments CashPayment" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents CashPayment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments CashPayment" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents CashPayment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents CashPayment" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents CashPayment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents CashPayment" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents CashPayment" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents CashPayment" exception

Scenario: Save item Documents "Cash receipt" (CashReceipt)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents CashReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents CashReceipt" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents CashReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents CashReceipt" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents CashReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments CashReceipt" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents CashReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments CashReceipt" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents CashReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents CashReceipt" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents CashReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents CashReceipt" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents CashReceipt" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents CashReceipt" exception

Scenario: Save item Documents "Cash revenue" (CashRevenue)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents CashRevenue" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents CashRevenue" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents CashRevenue" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents CashRevenue" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents CashRevenue" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments CashRevenue" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents CashRevenue" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments CashRevenue" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents CashRevenue" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents CashRevenue" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents CashRevenue" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents CashRevenue" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents CashRevenue" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents CashRevenue" exception

Scenario: Save item Documents "Cash statement" (CashStatement)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents CashStatement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents CashStatement" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents CashStatement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents CashStatement" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents CashStatement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments CashStatement" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents CashStatement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments CashStatement" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents CashStatement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents CashStatement" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents CashStatement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents CashStatement" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents CashStatement" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents CashStatement" exception

Scenario: Save item Documents "Cash transfer order" (CashTransferOrder)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents CashTransferOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents CashTransferOrder" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents CashTransferOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents CashTransferOrder" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents CashTransferOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments CashTransferOrder" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents CashTransferOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments CashTransferOrder" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents CashTransferOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents CashTransferOrder" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents CashTransferOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents CashTransferOrder" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents CashTransferOrder" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents CashTransferOrder" exception

Scenario: Save item Documents "Cheque bond transaction" (ChequeBondTransaction)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents ChequeBondTransaction" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents ChequeBondTransaction" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents ChequeBondTransaction" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents ChequeBondTransaction" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents ChequeBondTransaction" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments ChequeBondTransaction" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents ChequeBondTransaction" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments ChequeBondTransaction" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents ChequeBondTransaction" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents ChequeBondTransaction" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents ChequeBondTransaction" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents ChequeBondTransaction" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents ChequeBondTransaction" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents ChequeBondTransaction" exception

Scenario: Save item Documents "Cheque bond transaction item" (ChequeBondTransactionItem)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents ChequeBondTransactionItem" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents ChequeBondTransactionItem" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents ChequeBondTransactionItem" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents ChequeBondTransactionItem" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents ChequeBondTransactionItem" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments ChequeBondTransactionItem" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents ChequeBondTransactionItem" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments ChequeBondTransactionItem" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents ChequeBondTransactionItem" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents ChequeBondTransactionItem" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents ChequeBondTransactionItem" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents ChequeBondTransactionItem" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents ChequeBondTransactionItem" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents ChequeBondTransactionItem" exception

Scenario: Save item Documents "Commissioning of fixed asset" (CommissioningOfFixedAsset)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents CommissioningOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents CommissioningOfFixedAsset" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents CommissioningOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents CommissioningOfFixedAsset" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents CommissioningOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments CommissioningOfFixedAsset" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents CommissioningOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments CommissioningOfFixedAsset" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents CommissioningOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents CommissioningOfFixedAsset" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents CommissioningOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents CommissioningOfFixedAsset" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents CommissioningOfFixedAsset" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents CommissioningOfFixedAsset" exception

Scenario: Save item Documents "Consolidated retail sales" (ConsolidatedRetailSales)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents ConsolidatedRetailSales" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents ConsolidatedRetailSales" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents ConsolidatedRetailSales" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents ConsolidatedRetailSales" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents ConsolidatedRetailSales" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments ConsolidatedRetailSales" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents ConsolidatedRetailSales" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments ConsolidatedRetailSales" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents ConsolidatedRetailSales" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents ConsolidatedRetailSales" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents ConsolidatedRetailSales" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents ConsolidatedRetailSales" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents ConsolidatedRetailSales" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents ConsolidatedRetailSales" exception

Scenario: Save item Documents "Credit note" (CreditNote)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents CreditNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents CreditNote" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents CreditNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents CreditNote" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents CreditNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments CreditNote" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents CreditNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments CreditNote" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents CreditNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents CreditNote" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents CreditNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents CreditNote" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents CreditNote" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents CreditNote" exception

Scenario: Save item Documents "Customers advances closing" (CustomersAdvancesClosing)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents CustomersAdvancesClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents CustomersAdvancesClosing" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents CustomersAdvancesClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents CustomersAdvancesClosing" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents CustomersAdvancesClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments CustomersAdvancesClosing" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents CustomersAdvancesClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments CustomersAdvancesClosing" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents CustomersAdvancesClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents CustomersAdvancesClosing" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents CustomersAdvancesClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents CustomersAdvancesClosing" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents CustomersAdvancesClosing" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents CustomersAdvancesClosing" exception

Scenario: Save item Documents "Debit note" (DebitNote)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents DebitNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents DebitNote" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents DebitNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents DebitNote" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents DebitNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments DebitNote" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents DebitNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments DebitNote" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents DebitNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents DebitNote" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents DebitNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents DebitNote" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents DebitNote" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents DebitNote" exception

Scenario: Save item Documents "Decommissioning of fixed asset" (DecommissioningOfFixedAsset)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents DecommissioningOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents DecommissioningOfFixedAsset" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents DecommissioningOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents DecommissioningOfFixedAsset" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents DecommissioningOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments DecommissioningOfFixedAsset" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents DecommissioningOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments DecommissioningOfFixedAsset" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents DecommissioningOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents DecommissioningOfFixedAsset" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents DecommissioningOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents DecommissioningOfFixedAsset" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents DecommissioningOfFixedAsset" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents DecommissioningOfFixedAsset" exception

Scenario: Save item Documents "Depreciation calculation" (DepreciationCalculation)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents DepreciationCalculation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents DepreciationCalculation" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents DepreciationCalculation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents DepreciationCalculation" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents DepreciationCalculation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments DepreciationCalculation" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents DepreciationCalculation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments DepreciationCalculation" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents DepreciationCalculation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents DepreciationCalculation" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents DepreciationCalculation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents DepreciationCalculation" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents DepreciationCalculation" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents DepreciationCalculation" exception

Scenario: Save item Documents "Employee cash advance" (EmployeeCashAdvance)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents EmployeeCashAdvance" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents EmployeeCashAdvance" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents EmployeeCashAdvance" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents EmployeeCashAdvance" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents EmployeeCashAdvance" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments EmployeeCashAdvance" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents EmployeeCashAdvance" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments EmployeeCashAdvance" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents EmployeeCashAdvance" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents EmployeeCashAdvance" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents EmployeeCashAdvance" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents EmployeeCashAdvance" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents EmployeeCashAdvance" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents EmployeeCashAdvance" exception

Scenario: Save item Documents "Employee firing" (EmployeeFiring)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents EmployeeFiring" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents EmployeeFiring" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents EmployeeFiring" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents EmployeeFiring" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents EmployeeFiring" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments EmployeeFiring" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents EmployeeFiring" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments EmployeeFiring" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents EmployeeFiring" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents EmployeeFiring" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents EmployeeFiring" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents EmployeeFiring" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents EmployeeFiring" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents EmployeeFiring" exception

Scenario: Save item Documents "Employee hiring" (EmployeeHiring)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents EmployeeHiring" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents EmployeeHiring" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents EmployeeHiring" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents EmployeeHiring" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents EmployeeHiring" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments EmployeeHiring" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents EmployeeHiring" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments EmployeeHiring" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents EmployeeHiring" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents EmployeeHiring" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents EmployeeHiring" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents EmployeeHiring" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents EmployeeHiring" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents EmployeeHiring" exception

Scenario: Save item Documents "Employee sick leave" (EmployeeSickLeave)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents EmployeeSickLeave" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents EmployeeSickLeave" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents EmployeeSickLeave" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents EmployeeSickLeave" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents EmployeeSickLeave" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments EmployeeSickLeave" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents EmployeeSickLeave" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments EmployeeSickLeave" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents EmployeeSickLeave" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents EmployeeSickLeave" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents EmployeeSickLeave" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents EmployeeSickLeave" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents EmployeeSickLeave" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents EmployeeSickLeave" exception

Scenario: Save item Documents "Employee transfer" (EmployeeTransfer)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents EmployeeTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents EmployeeTransfer" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents EmployeeTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents EmployeeTransfer" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents EmployeeTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments EmployeeTransfer" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents EmployeeTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments EmployeeTransfer" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents EmployeeTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents EmployeeTransfer" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents EmployeeTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents EmployeeTransfer" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents EmployeeTransfer" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents EmployeeTransfer" exception

Scenario: Save item Documents "Employee vacation" (EmployeeVacation)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents EmployeeVacation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents EmployeeVacation" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents EmployeeVacation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents EmployeeVacation" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents EmployeeVacation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments EmployeeVacation" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents EmployeeVacation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments EmployeeVacation" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents EmployeeVacation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents EmployeeVacation" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents EmployeeVacation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents EmployeeVacation" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents EmployeeVacation" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents EmployeeVacation" exception

Scenario: Save item Documents "Fixed asset transfer" (FixedAssetTransfer)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents FixedAssetTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents FixedAssetTransfer" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents FixedAssetTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents FixedAssetTransfer" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents FixedAssetTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments FixedAssetTransfer" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents FixedAssetTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments FixedAssetTransfer" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents FixedAssetTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents FixedAssetTransfer" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents FixedAssetTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents FixedAssetTransfer" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents FixedAssetTransfer" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents FixedAssetTransfer" exception

Scenario: Save item Documents "Foreign currency revaluation" (ForeignCurrencyRevaluation)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents ForeignCurrencyRevaluation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents ForeignCurrencyRevaluation" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents ForeignCurrencyRevaluation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents ForeignCurrencyRevaluation" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents ForeignCurrencyRevaluation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments ForeignCurrencyRevaluation" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents ForeignCurrencyRevaluation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments ForeignCurrencyRevaluation" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents ForeignCurrencyRevaluation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents ForeignCurrencyRevaluation" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents ForeignCurrencyRevaluation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents ForeignCurrencyRevaluation" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents ForeignCurrencyRevaluation" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents ForeignCurrencyRevaluation" exception

Scenario: Save item Documents "Goods receipt" (GoodsReceipt)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents GoodsReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents GoodsReceipt" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents GoodsReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents GoodsReceipt" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents GoodsReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments GoodsReceipt" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents GoodsReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments GoodsReceipt" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents GoodsReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents GoodsReceipt" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents GoodsReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents GoodsReceipt" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents GoodsReceipt" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents GoodsReceipt" exception

Scenario: Save item Documents "Incoming payment order" (IncomingPaymentOrder)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents IncomingPaymentOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents IncomingPaymentOrder" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents IncomingPaymentOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents IncomingPaymentOrder" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents IncomingPaymentOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments IncomingPaymentOrder" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents IncomingPaymentOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments IncomingPaymentOrder" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents IncomingPaymentOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents IncomingPaymentOrder" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents IncomingPaymentOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents IncomingPaymentOrder" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents IncomingPaymentOrder" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents IncomingPaymentOrder" exception

Scenario: Save item Documents "Internal supply request" (InternalSupplyRequest)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents InternalSupplyRequest" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents InternalSupplyRequest" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents InternalSupplyRequest" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents InternalSupplyRequest" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents InternalSupplyRequest" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments InternalSupplyRequest" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents InternalSupplyRequest" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments InternalSupplyRequest" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents InternalSupplyRequest" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents InternalSupplyRequest" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents InternalSupplyRequest" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents InternalSupplyRequest" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents InternalSupplyRequest" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents InternalSupplyRequest" exception

Scenario: Save item Documents "Inventory transfer" (InventoryTransfer)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents InventoryTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents InventoryTransfer" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents InventoryTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents InventoryTransfer" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents InventoryTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments InventoryTransfer" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents InventoryTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments InventoryTransfer" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents InventoryTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents InventoryTransfer" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents InventoryTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents InventoryTransfer" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents InventoryTransfer" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents InventoryTransfer" exception

Scenario: Save item Documents "Inventory transfer order" (InventoryTransferOrder)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents InventoryTransferOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents InventoryTransferOrder" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents InventoryTransferOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents InventoryTransferOrder" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents InventoryTransferOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments InventoryTransferOrder" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents InventoryTransferOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments InventoryTransferOrder" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents InventoryTransferOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents InventoryTransferOrder" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents InventoryTransferOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents InventoryTransferOrder" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents InventoryTransferOrder" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents InventoryTransferOrder" exception

Scenario: Save item Documents "Item stock adjustment" (ItemStockAdjustment)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents ItemStockAdjustment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents ItemStockAdjustment" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents ItemStockAdjustment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents ItemStockAdjustment" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents ItemStockAdjustment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments ItemStockAdjustment" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents ItemStockAdjustment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments ItemStockAdjustment" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents ItemStockAdjustment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents ItemStockAdjustment" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents ItemStockAdjustment" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents ItemStockAdjustment" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents ItemStockAdjustment" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents ItemStockAdjustment" exception

Scenario: Save item Documents "Journal entry" (JournalEntry)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents JournalEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents JournalEntry" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents JournalEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents JournalEntry" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents JournalEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments JournalEntry" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents JournalEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments JournalEntry" exception

Scenario: Save item Documents "Labeling" (Labeling)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents Labeling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents Labeling" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents Labeling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents Labeling" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents Labeling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments Labeling" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents Labeling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments Labeling" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents Labeling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents Labeling" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents Labeling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents Labeling" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents Labeling" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents Labeling" exception

Scenario: Save item Documents "Manual register entry" (ManualRegisterEntry)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents ManualRegisterEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents ManualRegisterEntry" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents ManualRegisterEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents ManualRegisterEntry" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents ManualRegisterEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments ManualRegisterEntry" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents ManualRegisterEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments ManualRegisterEntry" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents ManualRegisterEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents ManualRegisterEntry" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents ManualRegisterEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents ManualRegisterEntry" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents ManualRegisterEntry" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents ManualRegisterEntry" exception

Scenario: Save item Documents "Modernization of fixed asset" (ModernizationOfFixedAsset)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents ModernizationOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents ModernizationOfFixedAsset" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents ModernizationOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents ModernizationOfFixedAsset" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents ModernizationOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments ModernizationOfFixedAsset" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents ModernizationOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments ModernizationOfFixedAsset" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents ModernizationOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents ModernizationOfFixedAsset" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents ModernizationOfFixedAsset" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents ModernizationOfFixedAsset" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents ModernizationOfFixedAsset" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents ModernizationOfFixedAsset" exception

Scenario: Save item Documents "Money transfer" (MoneyTransfer)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents MoneyTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents MoneyTransfer" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents MoneyTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents MoneyTransfer" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents MoneyTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments MoneyTransfer" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents MoneyTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments MoneyTransfer" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents MoneyTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents MoneyTransfer" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents MoneyTransfer" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents MoneyTransfer" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents MoneyTransfer" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents MoneyTransfer" exception

Scenario: Save item Documents "Opening entry" (OpeningEntry)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents OpeningEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents OpeningEntry" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents OpeningEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents OpeningEntry" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents OpeningEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments OpeningEntry" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents OpeningEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments OpeningEntry" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents OpeningEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents OpeningEntry" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents OpeningEntry" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents OpeningEntry" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents OpeningEntry" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents OpeningEntry" exception

Scenario: Save item Documents "Outgoing payment order" (OutgoingPaymentOrder)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents OutgoingPaymentOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents OutgoingPaymentOrder" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents OutgoingPaymentOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents OutgoingPaymentOrder" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents OutgoingPaymentOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments OutgoingPaymentOrder" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents OutgoingPaymentOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments OutgoingPaymentOrder" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents OutgoingPaymentOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents OutgoingPaymentOrder" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents OutgoingPaymentOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents OutgoingPaymentOrder" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents OutgoingPaymentOrder" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents OutgoingPaymentOrder" exception

Scenario: Save item Documents "Payroll" (Payroll)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents Payroll" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents Payroll" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents Payroll" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents Payroll" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents Payroll" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments Payroll" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents Payroll" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments Payroll" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents Payroll" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents Payroll" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents Payroll" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents Payroll" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents Payroll" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents Payroll" exception

Scenario: Save item Documents "Physical count by location" (PhysicalCountByLocation)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents PhysicalCountByLocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents PhysicalCountByLocation" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents PhysicalCountByLocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents PhysicalCountByLocation" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents PhysicalCountByLocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments PhysicalCountByLocation" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents PhysicalCountByLocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments PhysicalCountByLocation" exception

Scenario: Save item Documents "Physical inventory" (PhysicalInventory)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents PhysicalInventory" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents PhysicalInventory" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents PhysicalInventory" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents PhysicalInventory" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents PhysicalInventory" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments PhysicalInventory" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents PhysicalInventory" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments PhysicalInventory" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents PhysicalInventory" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents PhysicalInventory" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents PhysicalInventory" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents PhysicalInventory" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents PhysicalInventory" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents PhysicalInventory" exception

Scenario: Save item Documents "Planned receipt reservation" (PlannedReceiptReservation)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents PlannedReceiptReservation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents PlannedReceiptReservation" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents PlannedReceiptReservation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents PlannedReceiptReservation" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents PlannedReceiptReservation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments PlannedReceiptReservation" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents PlannedReceiptReservation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments PlannedReceiptReservation" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents PlannedReceiptReservation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents PlannedReceiptReservation" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents PlannedReceiptReservation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents PlannedReceiptReservation" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents PlannedReceiptReservation" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents PlannedReceiptReservation" exception

Scenario: Save item Documents "Price list" (PriceList)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents PriceList" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents PriceList" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents PriceList" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents PriceList" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents PriceList" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments PriceList" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents PriceList" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments PriceList" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents PriceList" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents PriceList" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents PriceList" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents PriceList" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents PriceList" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents PriceList" exception

Scenario: Save item Documents "Production" (Production)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents Production" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents Production" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents Production" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents Production" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents Production" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments Production" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents Production" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments Production" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents Production" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents Production" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents Production" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents Production" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents Production" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents Production" exception

Scenario: Save item Documents "Production costs allocation" (ProductionCostsAllocation)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents ProductionCostsAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents ProductionCostsAllocation" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents ProductionCostsAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents ProductionCostsAllocation" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents ProductionCostsAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments ProductionCostsAllocation" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents ProductionCostsAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments ProductionCostsAllocation" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents ProductionCostsAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents ProductionCostsAllocation" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents ProductionCostsAllocation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents ProductionCostsAllocation" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents ProductionCostsAllocation" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents ProductionCostsAllocation" exception

Scenario: Save item Documents "Production planning" (ProductionPlanning)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents ProductionPlanning" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents ProductionPlanning" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents ProductionPlanning" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents ProductionPlanning" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents ProductionPlanning" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments ProductionPlanning" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents ProductionPlanning" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments ProductionPlanning" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents ProductionPlanning" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents ProductionPlanning" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents ProductionPlanning" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents ProductionPlanning" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents ProductionPlanning" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents ProductionPlanning" exception

Scenario: Save item Documents "Production planning closing" (ProductionPlanningClosing)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents ProductionPlanningClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents ProductionPlanningClosing" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents ProductionPlanningClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents ProductionPlanningClosing" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents ProductionPlanningClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments ProductionPlanningClosing" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents ProductionPlanningClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments ProductionPlanningClosing" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents ProductionPlanningClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents ProductionPlanningClosing" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents ProductionPlanningClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents ProductionPlanningClosing" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents ProductionPlanningClosing" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents ProductionPlanningClosing" exception

Scenario: Save item Documents "Production planning correction" (ProductionPlanningCorrection)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents ProductionPlanningCorrection" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents ProductionPlanningCorrection" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents ProductionPlanningCorrection" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents ProductionPlanningCorrection" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents ProductionPlanningCorrection" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments ProductionPlanningCorrection" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents ProductionPlanningCorrection" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments ProductionPlanningCorrection" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents ProductionPlanningCorrection" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents ProductionPlanningCorrection" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents ProductionPlanningCorrection" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents ProductionPlanningCorrection" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents ProductionPlanningCorrection" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents ProductionPlanningCorrection" exception

Scenario: Save item Documents "Purchase invoice" (PurchaseInvoice)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents PurchaseInvoice" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents PurchaseInvoice" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents PurchaseInvoice" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents PurchaseInvoice" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents PurchaseInvoice" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments PurchaseInvoice" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents PurchaseInvoice" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments PurchaseInvoice" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents PurchaseInvoice" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents PurchaseInvoice" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents PurchaseInvoice" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents PurchaseInvoice" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents PurchaseInvoice" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents PurchaseInvoice" exception

Scenario: Save item Documents "Purchase order" (PurchaseOrder)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents PurchaseOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents PurchaseOrder" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents PurchaseOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents PurchaseOrder" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents PurchaseOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments PurchaseOrder" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents PurchaseOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments PurchaseOrder" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents PurchaseOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents PurchaseOrder" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents PurchaseOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents PurchaseOrder" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents PurchaseOrder" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents PurchaseOrder" exception

Scenario: Save item Documents "Purchase order closing" (PurchaseOrderClosing)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents PurchaseOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents PurchaseOrderClosing" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents PurchaseOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents PurchaseOrderClosing" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents PurchaseOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments PurchaseOrderClosing" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents PurchaseOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments PurchaseOrderClosing" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents PurchaseOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents PurchaseOrderClosing" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents PurchaseOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents PurchaseOrderClosing" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents PurchaseOrderClosing" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents PurchaseOrderClosing" exception

Scenario: Save item Documents "Purchase return" (PurchaseReturn)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents PurchaseReturn" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents PurchaseReturn" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents PurchaseReturn" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents PurchaseReturn" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents PurchaseReturn" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments PurchaseReturn" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents PurchaseReturn" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments PurchaseReturn" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents PurchaseReturn" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents PurchaseReturn" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents PurchaseReturn" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents PurchaseReturn" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents PurchaseReturn" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents PurchaseReturn" exception

Scenario: Save item Documents "Purchase return order" (PurchaseReturnOrder)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents PurchaseReturnOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents PurchaseReturnOrder" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents PurchaseReturnOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents PurchaseReturnOrder" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents PurchaseReturnOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments PurchaseReturnOrder" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents PurchaseReturnOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments PurchaseReturnOrder" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents PurchaseReturnOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents PurchaseReturnOrder" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents PurchaseReturnOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents PurchaseReturnOrder" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents PurchaseReturnOrder" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents PurchaseReturnOrder" exception

Scenario: Save item Documents "Reconciliation statement" (ReconciliationStatement)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents ReconciliationStatement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents ReconciliationStatement" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents ReconciliationStatement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents ReconciliationStatement" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents ReconciliationStatement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments ReconciliationStatement" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents ReconciliationStatement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments ReconciliationStatement" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents ReconciliationStatement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents ReconciliationStatement" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents ReconciliationStatement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents ReconciliationStatement" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents ReconciliationStatement" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents ReconciliationStatement" exception

Scenario: Save item Documents "Retail goods receipt" (RetailGoodsReceipt)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents RetailGoodsReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents RetailGoodsReceipt" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents RetailGoodsReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents RetailGoodsReceipt" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents RetailGoodsReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments RetailGoodsReceipt" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents RetailGoodsReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments RetailGoodsReceipt" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents RetailGoodsReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents RetailGoodsReceipt" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents RetailGoodsReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents RetailGoodsReceipt" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents RetailGoodsReceipt" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents RetailGoodsReceipt" exception

Scenario: Save item Documents "Retail receipt correction" (RetailReceiptCorrection)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents RetailReceiptCorrection" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents RetailReceiptCorrection" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents RetailReceiptCorrection" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents RetailReceiptCorrection" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents RetailReceiptCorrection" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments RetailReceiptCorrection" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents RetailReceiptCorrection" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments RetailReceiptCorrection" exception

Scenario: Save item Documents "Retail return receipt" (RetailReturnReceipt)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents RetailReturnReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents RetailReturnReceipt" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents RetailReturnReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents RetailReturnReceipt" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents RetailReturnReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments RetailReturnReceipt" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents RetailReturnReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments RetailReturnReceipt" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents RetailReturnReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents RetailReturnReceipt" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents RetailReturnReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents RetailReturnReceipt" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents RetailReturnReceipt" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents RetailReturnReceipt" exception

Scenario: Save item Documents "Retail sales receipt" (RetailSalesReceipt)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents RetailSalesReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents RetailSalesReceipt" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents RetailSalesReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents RetailSalesReceipt" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents RetailSalesReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments RetailSalesReceipt" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents RetailSalesReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments RetailSalesReceipt" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents RetailSalesReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents RetailSalesReceipt" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents RetailSalesReceipt" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents RetailSalesReceipt" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents RetailSalesReceipt" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents RetailSalesReceipt" exception

Scenario: Save item Documents "Retail shipment confirmation" (RetailShipmentConfirmation)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents RetailShipmentConfirmation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents RetailShipmentConfirmation" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents RetailShipmentConfirmation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents RetailShipmentConfirmation" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents RetailShipmentConfirmation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments RetailShipmentConfirmation" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents RetailShipmentConfirmation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments RetailShipmentConfirmation" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents RetailShipmentConfirmation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents RetailShipmentConfirmation" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents RetailShipmentConfirmation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents RetailShipmentConfirmation" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents RetailShipmentConfirmation" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents RetailShipmentConfirmation" exception

Scenario: Save item Documents "Sales invoice" (SalesInvoice)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents SalesInvoice" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents SalesInvoice" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents SalesInvoice" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents SalesInvoice" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents SalesInvoice" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments SalesInvoice" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents SalesInvoice" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments SalesInvoice" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents SalesInvoice" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents SalesInvoice" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents SalesInvoice" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents SalesInvoice" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents SalesInvoice" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents SalesInvoice" exception

Scenario: Save item Documents "Sales order" (SalesOrder)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT	TOP 1 SalesOrderList.Ref FROM Document.SalesOrder AS SalesOrderList LEFT JOIN Document.SalesOrderClosing AS SalesOrderClosing ON SalesOrderClosing.SalesOrder = SalesOrderList.Ref AND SalesOrderClosing.Posted Where SalesOrderClosing.Ref IS NULL AND SalesOrderList.Ref.Posted";'	|
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
				Then I raise "Could not open existing item Documents SalesOrder" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents SalesOrder" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents SalesOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents SalesOrder" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents SalesOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents SalesOrder" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents SalesOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments SalesOrder" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents SalesOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments SalesOrder" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents SalesOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents SalesOrder" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents SalesOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents SalesOrder" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents SalesOrder" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents SalesOrder" exception

Scenario: Save item Documents "Sales order closing" (SalesOrderClosing)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.SalesOrderClosing AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
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
				Then I raise "Could not open existing item Documents SalesOrderClosing" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents SalesOrderClosing" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents SalesOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents SalesOrderClosing" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents SalesOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents SalesOrderClosing" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents SalesOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments SalesOrderClosing" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents SalesOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments SalesOrderClosing" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents SalesOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents SalesOrderClosing" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents SalesOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents SalesOrderClosing" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents SalesOrderClosing" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents SalesOrderClosing" exception

Scenario: Save item Documents "Sales report from trade agent" (SalesReportFromTradeAgent)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents SalesReportFromTradeAgent" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents SalesReportFromTradeAgent" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents SalesReportFromTradeAgent" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents SalesReportFromTradeAgent" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents SalesReportFromTradeAgent" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments SalesReportFromTradeAgent" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents SalesReportFromTradeAgent" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments SalesReportFromTradeAgent" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents SalesReportFromTradeAgent" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents SalesReportFromTradeAgent" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents SalesReportFromTradeAgent" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents SalesReportFromTradeAgent" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents SalesReportFromTradeAgent" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents SalesReportFromTradeAgent" exception

Scenario: Save item Documents "Sales report to consignor" (SalesReportToConsignor)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents SalesReportToConsignor" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents SalesReportToConsignor" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents SalesReportToConsignor" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents SalesReportToConsignor" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents SalesReportToConsignor" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments SalesReportToConsignor" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents SalesReportToConsignor" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments SalesReportToConsignor" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents SalesReportToConsignor" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents SalesReportToConsignor" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents SalesReportToConsignor" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents SalesReportToConsignor" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents SalesReportToConsignor" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents SalesReportToConsignor" exception

Scenario: Save item Documents "Sales return" (SalesReturn)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents SalesReturn" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents SalesReturn" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents SalesReturn" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents SalesReturn" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents SalesReturn" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments SalesReturn" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents SalesReturn" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments SalesReturn" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents SalesReturn" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents SalesReturn" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents SalesReturn" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents SalesReturn" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents SalesReturn" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents SalesReturn" exception

Scenario: Save item Documents "Loading" (SDR_Loading)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Document.SDR_Loading AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And CurrentDataSource.Posted";'	|
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
				Then I raise "Could not open existing item Documents SDR_Loading" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Documents SDR_Loading" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents SDR_Loading" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents SDR_Loading" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents SDR_Loading" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents SDR_Loading" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents SDR_Loading" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments SDR_Loading" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents SDR_Loading" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments SDR_Loading" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents SDR_Loading" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents SDR_Loading" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents SDR_Loading" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents SDR_Loading" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents SDR_Loading" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents SDR_Loading" exception

Scenario: Save item Documents "Sales return order" (SalesReturnOrder)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents SalesReturnOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents SalesReturnOrder" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents SalesReturnOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents SalesReturnOrder" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents SalesReturnOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments SalesReturnOrder" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents SalesReturnOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments SalesReturnOrder" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents SalesReturnOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents SalesReturnOrder" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents SalesReturnOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents SalesReturnOrder" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents SalesReturnOrder" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents SalesReturnOrder" exception

Scenario: Save item Documents "Shipment confirmation" (ShipmentConfirmation)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents ShipmentConfirmation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents ShipmentConfirmation" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents ShipmentConfirmation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents ShipmentConfirmation" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents ShipmentConfirmation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments ShipmentConfirmation" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents ShipmentConfirmation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments ShipmentConfirmation" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents ShipmentConfirmation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents ShipmentConfirmation" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents ShipmentConfirmation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents ShipmentConfirmation" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents ShipmentConfirmation" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents ShipmentConfirmation" exception

Scenario: Save item Documents "Stock adjustment as surplus" (StockAdjustmentAsSurplus)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents StockAdjustmentAsSurplus" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents StockAdjustmentAsSurplus" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents StockAdjustmentAsSurplus" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents StockAdjustmentAsSurplus" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents StockAdjustmentAsSurplus" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments StockAdjustmentAsSurplus" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents StockAdjustmentAsSurplus" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments StockAdjustmentAsSurplus" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents StockAdjustmentAsSurplus" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents StockAdjustmentAsSurplus" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents StockAdjustmentAsSurplus" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents StockAdjustmentAsSurplus" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents StockAdjustmentAsSurplus" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents StockAdjustmentAsSurplus" exception

Scenario: Save item Documents "Stock adjustment as write-off" (StockAdjustmentAsWriteOff)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents StockAdjustmentAsWriteOff" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents StockAdjustmentAsWriteOff" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents StockAdjustmentAsWriteOff" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents StockAdjustmentAsWriteOff" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents StockAdjustmentAsWriteOff" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments StockAdjustmentAsWriteOff" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents StockAdjustmentAsWriteOff" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments StockAdjustmentAsWriteOff" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents StockAdjustmentAsWriteOff" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents StockAdjustmentAsWriteOff" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents StockAdjustmentAsWriteOff" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents StockAdjustmentAsWriteOff" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents StockAdjustmentAsWriteOff" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents StockAdjustmentAsWriteOff" exception

Scenario: Save item Documents "Time sheet" (TimeSheet)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents TimeSheet" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents TimeSheet" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents TimeSheet" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents TimeSheet" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents TimeSheet" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments TimeSheet" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents TimeSheet" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments TimeSheet" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents TimeSheet" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents TimeSheet" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents TimeSheet" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents TimeSheet" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents TimeSheet" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents TimeSheet" exception

Scenario: Save item Documents "Unbundling" (Unbundling)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents Unbundling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents Unbundling" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents Unbundling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents Unbundling" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents Unbundling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments Unbundling" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents Unbundling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments Unbundling" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents Unbundling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents Unbundling" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents Unbundling" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents Unbundling" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents Unbundling" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents Unbundling" exception

Scenario: Save item Documents "Vendors advances closing" (VendorsAdvancesClosing)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents VendorsAdvancesClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents VendorsAdvancesClosing" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents VendorsAdvancesClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents VendorsAdvancesClosing" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents VendorsAdvancesClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments VendorsAdvancesClosing" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents VendorsAdvancesClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments VendorsAdvancesClosing" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents VendorsAdvancesClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents VendorsAdvancesClosing" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents VendorsAdvancesClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents VendorsAdvancesClosing" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents VendorsAdvancesClosing" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents VendorsAdvancesClosing" exception

Scenario: Save item Documents "Visitor counter" (VisitorCounter)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents VisitorCounter" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents VisitorCounter" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents VisitorCounter" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents VisitorCounter" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents VisitorCounter" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments VisitorCounter" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents VisitorCounter" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments VisitorCounter" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents VisitorCounter" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents VisitorCounter" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents VisitorCounter" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents VisitorCounter" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents VisitorCounter" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents VisitorCounter" exception

Scenario: Save item Documents "Work order" (WorkOrder)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents WorkOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents WorkOrder" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents WorkOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents WorkOrder" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents WorkOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments WorkOrder" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents WorkOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments WorkOrder" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents WorkOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents WorkOrder" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents WorkOrder" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents WorkOrder" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents WorkOrder" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents WorkOrder" exception

Scenario: Save item Documents "Work order closing" (WorkOrderClosing)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents WorkOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents WorkOrderClosing" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents WorkOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents WorkOrderClosing" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents WorkOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments WorkOrderClosing" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents WorkOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments WorkOrderClosing" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents WorkOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents WorkOrderClosing" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents WorkOrderClosing" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents WorkOrderClosing" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents WorkOrderClosing" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents WorkOrderClosing" exception

Scenario: Save item Documents "Work sheet" (WorkSheet)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents WorkSheet" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents WorkSheet" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents WorkSheet" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents WorkSheet" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents WorkSheet" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments WorkSheet" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents WorkSheet" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments WorkSheet" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents WorkSheet" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents WorkSheet" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents WorkSheet" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents WorkSheet" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents WorkSheet" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents WorkSheet" exception

Scenario: Save item Documents "Debit/Credit note" (DebitCreditNote)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents DebitCreditNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents DebitCreditNote" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents DebitCreditNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents DebitCreditNote" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents DebitCreditNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments DebitCreditNote" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents DebitCreditNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments DebitCreditNote" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents DebitCreditNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents DebitCreditNote" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents DebitCreditNote" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents DebitCreditNote" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents DebitCreditNote" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents DebitCreditNote" exception

Scenario: Save item Documents "Expense accruals" (ExpenseAccruals)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents ExpenseAccruals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents ExpenseAccruals" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents ExpenseAccruals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents ExpenseAccruals" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents ExpenseAccruals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments ExpenseAccruals" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents ExpenseAccruals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments ExpenseAccruals" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents ExpenseAccruals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents ExpenseAccruals" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents ExpenseAccruals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents ExpenseAccruals" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents ExpenseAccruals" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents ExpenseAccruals" exception

Scenario: Save item Documents "Simple document" (Тесты_ДокументПростой)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents Тесты_ДокументПростой" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents Тесты_ДокументПростой" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents Тесты_ДокументПростой" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents Тесты_ДокументПростой" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents Тесты_ДокументПростой" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments Тесты_ДокументПростой" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents Тесты_ДокументПростой" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments Тесты_ДокументПростой" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents Тесты_ДокументПростой" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents Тесты_ДокументПростой" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents Тесты_ДокументПростой" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents Тесты_ДокументПростой" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents Тесты_ДокументПростой" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents Тесты_ДокументПростой" exception

Scenario: Save item Documents "Revenue accruals" (RevenueAccruals)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents RevenueAccruals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents RevenueAccruals" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents RevenueAccruals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents RevenueAccruals" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents RevenueAccruals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments RevenueAccruals" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents RevenueAccruals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments RevenueAccruals" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents RevenueAccruals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents RevenueAccruals" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents RevenueAccruals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents RevenueAccruals" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents RevenueAccruals" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents RevenueAccruals" exception

Scenario: Save item Documents "Outgoing message" (OutgoingMessage)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents OutgoingMessage" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents OutgoingMessage" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents OutgoingMessage" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents OutgoingMessage" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents OutgoingMessage" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments OutgoingMessage" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents OutgoingMessage" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments OutgoingMessage" exception

Scenario: Save item Documents "Taxes operation" (TaxesOperation)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Documents TaxesOperation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Documents TaxesOperation" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Documents TaxesOperation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Documents TaxesOperation" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Documents TaxesOperation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemDocuments TaxesOperation" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Documents TaxesOperation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemDocuments TaxesOperation" exception

		* Posting document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPost'  attribute is present on the form Then
				And I click the button named 'FormPost'
				If the warning is displayed then
					Then I raise "Failed to Posting document Documents TaxesOperation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Posting document Documents TaxesOperation" exception

		* Cancel Posting the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormUndoPosting' attribute is present on the form Then
				And I click the button named 'FormUndoPosting'
				If the warning is displayed then
					Then I raise "Failed to Cancel Posting the document Documents TaxesOperation" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Cancel Posting the document Documents TaxesOperation" exception

		* Posting and close the document
			Then '$ЗаголовокФормы$' window is opened
			If 'FormPostAndClose' attribute is present on the form Then
				And I click the button named 'FormPostAndClose'
				If the warning is displayed then
					Then I raise "Failed to Posting and close the document Documents TaxesOperation" exception
					If current form name is "ErrorWindow" Then
						Then I raise "Failed to Posting and close the document Documents TaxesOperation" exception
