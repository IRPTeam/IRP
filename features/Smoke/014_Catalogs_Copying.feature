
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Catalogs - Copying
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows

Scenario: Copying item Catalogs "User access groups" (AccessGroups)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AccessGroups AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs AccessGroups" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs AccessGroups" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs AccessGroups" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs AccessGroups" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs AccessGroups" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs AccessGroups" exception

Scenario: Copying item Catalogs "Access key" (AccessKey)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AccessKey AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs AccessKey" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs AccessKey" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs AccessKey" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs AccessKey" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs AccessKey" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs AccessKey" exception

Scenario: Copying item Catalogs "User access profiles" (AccessProfiles)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AccessProfiles AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs AccessProfiles" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs AccessProfiles" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs AccessProfiles" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs AccessProfiles" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs AccessProfiles" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs AccessProfiles" exception

Scenario: Copying item group Catalogs "Accounting operations" (AccountingOperations)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AccountingOperations AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item group Catalogs AccountingOperations" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item group Catalogs AccountingOperations" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item group Catalogs AccountingOperations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item group Catalogs AccountingOperations" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item group Catalogs AccountingOperations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item group Catalogs AccountingOperations" exception

Scenario: Copying item Catalogs "Accounting operations" (AccountingOperations)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AccountingOperations AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And Not CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item Catalogs AccountingOperations" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs AccountingOperations" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs AccountingOperations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs AccountingOperations" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs AccountingOperations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs AccountingOperations" exception

Scenario: Copying item Catalogs "Accrual and deduction types" (AccrualAndDeductionTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AccrualAndDeductionTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs AccrualAndDeductionTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs AccrualAndDeductionTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs AccrualAndDeductionTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs AccrualAndDeductionTypes" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs AccrualAndDeductionTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs AccrualAndDeductionTypes" exception

Scenario: Copying item Catalogs "Additional attribute sets" (AddAttributeAndPropertySets)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AddAttributeAndPropertySets AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs AddAttributeAndPropertySets" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs AddAttributeAndPropertySets" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs AddAttributeAndPropertySets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs AddAttributeAndPropertySets" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs AddAttributeAndPropertySets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs AddAttributeAndPropertySets" exception

Scenario: Copying item Catalogs "Additional attribute values" (AddAttributeAndPropertyValues)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AddAttributeAndPropertyValues AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs AddAttributeAndPropertyValues" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs AddAttributeAndPropertyValues" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs AddAttributeAndPropertyValues" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs AddAttributeAndPropertyValues" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs AddAttributeAndPropertyValues" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs AddAttributeAndPropertyValues" exception

Scenario: Copying item Catalogs "Addresses" (Addresses)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Addresses AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Addresses" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Addresses" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Addresses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Addresses" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Addresses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Addresses" exception


Scenario: Copying item Catalogs "Aging periods" (AgingPeriods)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AgingPeriods AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs AgingPeriods" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs AgingPeriods" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs AgingPeriods" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs AgingPeriods" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs AgingPeriods" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs AgingPeriods" exception

Scenario: Copying item Catalogs "Partner terms" (Agreements)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Agreements AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Agreements" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Agreements" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Agreements" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Agreements" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Agreements" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Agreements" exception

Scenario: Copying item Catalogs "Attached document settings" (AttachedDocumentSettings)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AttachedDocumentSettings AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs AttachedDocumentSettings" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs AttachedDocumentSettings" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs AttachedDocumentSettings" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs AttachedDocumentSettings" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs AttachedDocumentSettings" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs AttachedDocumentSettings" exception

Scenario: Copying item Catalogs "Bank terms" (BankTerms)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.BankTerms AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs BankTerms" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs BankTerms" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs BankTerms" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs BankTerms" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs BankTerms" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs BankTerms" exception

Scenario: Copying item Catalogs "Batches" (Batches)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Batches AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Batches" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Batches" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Batches" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Batches" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Batches" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Batches" exception

Scenario: Copying item Catalogs "Batch keys" (BatchKeys)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.BatchKeys AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs BatchKeys" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs BatchKeys" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs BatchKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs BatchKeys" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs BatchKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs BatchKeys" exception

Scenario: Copying item Catalogs "Bill of materials" (BillOfMaterials)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.BillOfMaterials AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs BillOfMaterials" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs BillOfMaterials" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs BillOfMaterials" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs BillOfMaterials" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs BillOfMaterials" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs BillOfMaterials" exception

Scenario: Copying item Catalogs "Business units" (BusinessUnits)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.BusinessUnits AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs BusinessUnits" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs BusinessUnits" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs BusinessUnits" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs BusinessUnits" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs BusinessUnits" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs BusinessUnits" exception

Scenario: Copying item Catalogs "Cancel/Return reasons" (CancelReturnReasons)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.CancelReturnReasons AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs CancelReturnReasons" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs CancelReturnReasons" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs CancelReturnReasons" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs CancelReturnReasons" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs CancelReturnReasons" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs CancelReturnReasons" exception

Scenario: Copying item Catalogs "Cash/Bank accounts" (CashAccounts)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.CashAccounts AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs CashAccounts" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs CashAccounts" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs CashAccounts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs CashAccounts" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs CashAccounts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs CashAccounts" exception

Scenario: Copying item Catalogs "Cash statement statuses" (CashStatementStatuses)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.CashStatementStatuses AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs CashStatementStatuses" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs CashStatementStatuses" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs CashStatementStatuses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs CashStatementStatuses" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs CashStatementStatuses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs CashStatementStatuses" exception

Scenario: Copying item Catalogs "Cheque bonds" (ChequeBonds)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ChequeBonds AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs ChequeBonds" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ChequeBonds" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs ChequeBonds" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs ChequeBonds" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs ChequeBonds" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs ChequeBonds" exception

Scenario: Copying item Catalogs "Companies" (Companies)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Companies AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Companies" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Companies" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Companies" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Companies" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Companies" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Companies" exception

Scenario: Copying item Catalogs "Configuration metadata" (ConfigurationMetadata)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ConfigurationMetadata AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs ConfigurationMetadata" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ConfigurationMetadata" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs ConfigurationMetadata" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs ConfigurationMetadata" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs ConfigurationMetadata" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs ConfigurationMetadata" exception

Scenario: Copying item Catalogs "Countries" (Countries)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Countries AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Countries" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Countries" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Countries" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Countries" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Countries" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Countries" exception

Scenario: Copying item Catalogs "Currencies" (Currencies)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Currencies AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Currencies" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Currencies" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Currencies" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Currencies" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Currencies" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Currencies" exception

Scenario: Copying item Catalogs "Multi currency movement sets" (CurrencyMovementSets)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.CurrencyMovementSets AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs CurrencyMovementSets" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs CurrencyMovementSets" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs CurrencyMovementSets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs CurrencyMovementSets" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs CurrencyMovementSets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs CurrencyMovementSets" exception

Scenario: Copying item Catalogs "Data areas" (DataAreas)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.DataAreas AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs DataAreas" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs DataAreas" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs DataAreas" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs DataAreas" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs DataAreas" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs DataAreas" exception

Scenario: Copying item Catalogs "Data base status" (DataBaseStatus)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.DataBaseStatus AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs DataBaseStatus" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs DataBaseStatus" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs DataBaseStatus" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs DataBaseStatus" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs DataBaseStatus" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs DataBaseStatus" exception

Scenario: Copying item group Catalogs "Data mapping items" (DataMappingItems)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.DataMappingItems AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item group Catalogs DataMappingItems" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item group Catalogs DataMappingItems" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item group Catalogs DataMappingItems" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item group Catalogs DataMappingItems" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item group Catalogs DataMappingItems" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item group Catalogs DataMappingItems" exception

Scenario: Copying item Catalogs "Data mapping items" (DataMappingItems)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.DataMappingItems AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And Not CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item Catalogs DataMappingItems" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs DataMappingItems" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs DataMappingItems" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs DataMappingItems" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs DataMappingItems" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs DataMappingItems" exception

Scenario: Copying item Catalogs "Depreciation schedules" (DepreciationSchedules)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.DepreciationSchedules AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs DepreciationSchedules" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs DepreciationSchedules" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs DepreciationSchedules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs DepreciationSchedules" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs DepreciationSchedules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs DepreciationSchedules" exception

Scenario: Copying item Catalogs "Employee positions" (EmployeePositions)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.EmployeePositions AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs EmployeePositions" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs EmployeePositions" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs EmployeePositions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs EmployeePositions" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs EmployeePositions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs EmployeePositions" exception

Scenario: Copying item Catalogs "Employee schedule" (EmployeeSchedule)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.EmployeeSchedule AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs EmployeeSchedule" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs EmployeeSchedule" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs EmployeeSchedule" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs EmployeeSchedule" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs EmployeeSchedule" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs EmployeeSchedule" exception

Scenario: Copying item Catalogs "Equipment drivers" (EquipmentDrivers)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.EquipmentDrivers AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs EquipmentDrivers" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs EquipmentDrivers" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs EquipmentDrivers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs EquipmentDrivers" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs EquipmentDrivers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs EquipmentDrivers" exception

Scenario: Copying item Catalogs "Expense and revenue types" (ExpenseAndRevenueTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ExpenseAndRevenueTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs ExpenseAndRevenueTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ExpenseAndRevenueTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs ExpenseAndRevenueTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs ExpenseAndRevenueTypes" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs ExpenseAndRevenueTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs ExpenseAndRevenueTypes" exception

Scenario: Copying item Catalogs "Extensions" (Extensions)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Extensions AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Extensions" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Extensions" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Extensions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Extensions" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Extensions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Extensions" exception

Scenario: Copying item group Catalogs "Plugins" (ExternalDataProc)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ExternalDataProc AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item group Catalogs ExternalDataProc" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item group Catalogs ExternalDataProc" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item group Catalogs ExternalDataProc" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item group Catalogs ExternalDataProc" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item group Catalogs ExternalDataProc" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item group Catalogs ExternalDataProc" exception

Scenario: Copying item Catalogs "Plugins" (ExternalDataProc)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ExternalDataProc AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And Not CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item Catalogs ExternalDataProc" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ExternalDataProc" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs ExternalDataProc" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs ExternalDataProc" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs ExternalDataProc" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs ExternalDataProc" exception

Scenario: Copying item group Catalogs "External functions" (ExternalFunctions)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ExternalFunctions AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item group Catalogs ExternalFunctions" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item group Catalogs ExternalFunctions" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item group Catalogs ExternalFunctions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item group Catalogs ExternalFunctions" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item group Catalogs ExternalFunctions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item group Catalogs ExternalFunctions" exception

Scenario: Copying item Catalogs "External functions" (ExternalFunctions)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ExternalFunctions AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And Not CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item Catalogs ExternalFunctions" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ExternalFunctions" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs ExternalFunctions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs ExternalFunctions" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs ExternalFunctions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs ExternalFunctions" exception

Scenario: Copying item Catalogs "Files" (Files)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Files AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Files" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Files" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Files" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Files" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Files" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Files" exception

Scenario: Copying item Catalogs "File storages info" (FileStoragesInfo)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.FileStoragesInfo AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs FileStoragesInfo" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs FileStoragesInfo" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs FileStoragesInfo" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs FileStoragesInfo" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs FileStoragesInfo" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs FileStoragesInfo" exception

Scenario: Copying item Catalogs "File storage volumes" (FileStorageVolumes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.FileStorageVolumes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs FileStorageVolumes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs FileStorageVolumes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs FileStorageVolumes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs FileStorageVolumes" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs FileStorageVolumes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs FileStorageVolumes" exception

Scenario: Copying item Catalogs "Filling templates" (FillingTemplates)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.FillingTemplates AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs FillingTemplates" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs FillingTemplates" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs FillingTemplates" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs FillingTemplates" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs FillingTemplates" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs FillingTemplates" exception

Scenario: Copying item Catalogs "Fixed assets" (FixedAssets)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.FixedAssets AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs FixedAssets" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs FixedAssets" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs FixedAssets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs FixedAssets" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs FixedAssets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs FixedAssets" exception

Scenario: Copying item Catalogs "Fixed assets ledger types" (FixedAssetsLedgerTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.FixedAssetsLedgerTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs FixedAssetsLedgerTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs FixedAssetsLedgerTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs FixedAssetsLedgerTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs FixedAssetsLedgerTypes" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs FixedAssetsLedgerTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs FixedAssetsLedgerTypes" exception

Scenario: Copying item Catalogs "Hardware" (Hardware)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Hardware AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Hardware" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Hardware" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Hardware" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Hardware" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Hardware" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Hardware" exception

Scenario: Copying item Catalogs "Addresses hierarchy" (IDInfoAddresses)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.IDInfoAddresses AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs IDInfoAddresses" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs IDInfoAddresses" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs IDInfoAddresses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs IDInfoAddresses" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs IDInfoAddresses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs IDInfoAddresses" exception

Scenario: Copying item Catalogs "Contact info sets" (IDInfoSets)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.IDInfoSets AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs IDInfoSets" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs IDInfoSets" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs IDInfoSets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs IDInfoSets" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs IDInfoSets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs IDInfoSets" exception

Scenario: Copying item Catalogs "Incoterms" (Incoterms)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Incoterms AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Incoterms" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Incoterms" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Incoterms" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Incoterms" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Incoterms" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Incoterms" exception

Scenario: Copying item Catalogs "Integration settings" (IntegrationSettings)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.IntegrationSettings AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs IntegrationSettings" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs IntegrationSettings" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs IntegrationSettings" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs IntegrationSettings" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs IntegrationSettings" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs IntegrationSettings" exception

Scenario: Copying item Catalogs "UI groups" (InterfaceGroups)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.InterfaceGroups AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs InterfaceGroups" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs InterfaceGroups" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs InterfaceGroups" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs InterfaceGroups" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs InterfaceGroups" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs InterfaceGroups" exception

Scenario: Copying item Catalogs "Item keys" (ItemKeys)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ItemKeys AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs ItemKeys" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ItemKeys" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs ItemKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs ItemKeys" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			* Change property
				And I click Select button of "Color" field
				And I go to line in "List" table
					| "Additional attribute" | "Description" |
					| "Color"                | "Color 3"     |
				And I select current line in "List" table				
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs ItemKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs ItemKeys" exception

Scenario: Copying item Catalogs "Items" (Items)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Items AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Items" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Items" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Items" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Items" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Items" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Items" exception

Scenario: Copying item Catalogs "Item segments" (ItemSegments)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ItemSegments AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs ItemSegments" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ItemSegments" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs ItemSegments" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs ItemSegments" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs ItemSegments" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs ItemSegments" exception

Scenario: Copying item group Catalogs "Item types" (ItemTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ItemTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item group Catalogs ItemTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item group Catalogs ItemTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item group Catalogs ItemTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item group Catalogs ItemTypes" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item group Catalogs ItemTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item group Catalogs ItemTypes" exception

Scenario: Copying item Catalogs "Item types" (ItemTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ItemTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And Not CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item Catalogs ItemTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ItemTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs ItemTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs ItemTypes" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs ItemTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs ItemTypes" exception

Scenario: Copying item Catalogs "Ledger types" (LedgerTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.LedgerTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs LedgerTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs LedgerTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs LedgerTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs LedgerTypes" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs LedgerTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs LedgerTypes" exception

Scenario: Copying item Catalogs "Ledger type variants" (LedgerTypeVariants)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.LedgerTypeVariants AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs LedgerTypeVariants" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs LedgerTypeVariants" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs LedgerTypeVariants" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs LedgerTypeVariants" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs LedgerTypeVariants" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs LedgerTypeVariants" exception

Scenario: Copying item Catalogs "Legal name contracts" (LegalNameContracts)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.LegalNameContracts AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs LegalNameContracts" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs LegalNameContracts" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs LegalNameContracts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs LegalNameContracts" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs LegalNameContracts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs LegalNameContracts" exception

Scenario: Copying item Catalogs "Lock data modification reasons" (LockDataModificationReasons)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.LockDataModificationReasons AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs LockDataModificationReasons" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs LockDataModificationReasons" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs LockDataModificationReasons" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs LockDataModificationReasons" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs LockDataModificationReasons" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs LockDataModificationReasons" exception

Scenario: Copying item Catalogs "Movement rules" (MovementRules)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.MovementRules AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs MovementRules" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs MovementRules" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs MovementRules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs MovementRules" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs MovementRules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs MovementRules" exception

Scenario: Copying item Catalogs "Object access keys" (ObjectAccessKeys)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ObjectAccessKeys AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs ObjectAccessKeys" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ObjectAccessKeys" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs ObjectAccessKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs ObjectAccessKeys" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs ObjectAccessKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs ObjectAccessKeys" exception

Scenario: Copying item group Catalogs "Objects statuses" (ObjectStatuses)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ObjectStatuses AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item group Catalogs ObjectStatuses" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item group Catalogs ObjectStatuses" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item group Catalogs ObjectStatuses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item group Catalogs ObjectStatuses" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item group Catalogs ObjectStatuses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item group Catalogs ObjectStatuses" exception

Scenario: Copying item Catalogs "Objects statuses" (ObjectStatuses)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ObjectStatuses AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And Not CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item Catalogs ObjectStatuses" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ObjectStatuses" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs ObjectStatuses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs ObjectStatuses" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs ObjectStatuses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs ObjectStatuses" exception

Scenario: Copying item Catalogs "Partner items" (PartnerItems)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PartnerItems AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PartnerItems" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PartnerItems" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs PartnerItems" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs PartnerItems" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs PartnerItems" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs PartnerItems" exception

Scenario: Copying item Catalogs "Partners" (Partners)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Partners AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Partners" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Partners" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Partners" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Partners" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Partners" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Partners" exception

Scenario: Copying item Catalogs "Partners bank accounts" (PartnersBankAccounts)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PartnersBankAccounts AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PartnersBankAccounts" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PartnersBankAccounts" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs PartnersBankAccounts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs PartnersBankAccounts" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs PartnersBankAccounts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs PartnersBankAccounts" exception

Scenario: Copying item Catalogs "Partner segments" (PartnerSegments)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PartnerSegments AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PartnerSegments" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PartnerSegments" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs PartnerSegments" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs PartnerSegments" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs PartnerSegments" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs PartnerSegments" exception

Scenario: Copying item Catalogs "Payment terms" (PaymentSchedules)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PaymentSchedules AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PaymentSchedules" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PaymentSchedules" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs PaymentSchedules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs PaymentSchedules" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs PaymentSchedules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs PaymentSchedules" exception

Scenario: Copying item Catalogs "Payment terminals" (PaymentTerminals)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PaymentTerminals AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PaymentTerminals" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PaymentTerminals" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs PaymentTerminals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs PaymentTerminals" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs PaymentTerminals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs PaymentTerminals" exception

Scenario: Copying item Catalogs "Payment types" (PaymentTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PaymentTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PaymentTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PaymentTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs PaymentTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs PaymentTypes" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs PaymentTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs PaymentTypes" exception

Scenario: Copying item Catalogs "Planning periods" (PlanningPeriods)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PlanningPeriods AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PlanningPeriods" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PlanningPeriods" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs PlanningPeriods" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs PlanningPeriods" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs PlanningPeriods" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs PlanningPeriods" exception

Scenario: Copying item Catalogs "Price keys" (PriceKeys)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PriceKeys AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PriceKeys" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PriceKeys" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs PriceKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs PriceKeys" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs PriceKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs PriceKeys" exception

Scenario: Copying item Catalogs "Price types" (PriceTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PriceTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PriceTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PriceTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs PriceTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs PriceTypes" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs PriceTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs PriceTypes" exception

Scenario: Copying item Catalogs "Print info" (PrintInfo)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PrintInfo AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PrintInfo" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PrintInfo" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs PrintInfo" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs PrintInfo" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs PrintInfo" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs PrintInfo" exception

Scenario: Copying item Catalogs "Print templates" (PrintTemplates)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PrintTemplates AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PrintTemplates" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PrintTemplates" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs PrintTemplates" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs PrintTemplates" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs PrintTemplates" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs PrintTemplates" exception

Scenario: Copying item Catalogs "Projects" (Projects)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Projects AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Projects" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Projects" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Projects" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Projects" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Projects" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Projects" exception

Scenario: Copying item Catalogs "Report options" (ReportOptions)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ReportOptions AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs ReportOptions" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ReportOptions" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs ReportOptions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs ReportOptions" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs ReportOptions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs ReportOptions" exception

Scenario: Copying item Catalogs "Retail customers" (RetailCustomers)
	And I close all client application windows
	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.RetailCustomers AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs RetailCustomers" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs RetailCustomers" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs RetailCustomers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs RetailCustomers" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			* Change code
				And I input "587897989634" text in the field named "Code"					
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs RetailCustomers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs RetailCustomers" exception

Scenario: Copying item Catalogs "Row IDs" (RowIDs)
		And I close all client application windows
	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.RowIDs AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs RowIDs" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs RowIDs" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs RowIDs" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs RowIDs" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs RowIDs" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs RowIDs" exception

Scenario: Copying item Catalogs "Salary calculation type" (SalaryCalculationType)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.SalaryCalculationType AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs SalaryCalculationType" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs SalaryCalculationType" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs SalaryCalculationType" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs SalaryCalculationType" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs SalaryCalculationType" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs SalaryCalculationType" exception

Scenario: Copying item Catalogs "Item serial/lot numbers" (SerialLotNumbers)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.SerialLotNumbers AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs SerialLotNumbers" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs SerialLotNumbers" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs SerialLotNumbers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs SerialLotNumbers" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs SerialLotNumbers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs SerialLotNumbers" exception

Scenario: Copying item Catalogs "Source of origins" (SourceOfOrigins)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.SourceOfOrigins AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs SourceOfOrigins" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs SourceOfOrigins" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs SourceOfOrigins" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs SourceOfOrigins" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs SourceOfOrigins" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs SourceOfOrigins" exception

Scenario: Copying item Catalogs "Special offer rules" (SpecialOfferRules)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.SpecialOfferRules AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs SpecialOfferRules" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs SpecialOfferRules" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs SpecialOfferRules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs SpecialOfferRules" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs SpecialOfferRules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs SpecialOfferRules" exception

Scenario: Copying item group Catalogs "Special offers" (SpecialOffers)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.SpecialOffers AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item group Catalogs SpecialOffers" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item group Catalogs SpecialOffers" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item group Catalogs SpecialOffers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item group Catalogs SpecialOffers" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item group Catalogs SpecialOffers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item group Catalogs SpecialOffers" exception

Scenario: Copying item Catalogs "Special offers" (SpecialOffers)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.SpecialOffers AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And Not CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item Catalogs SpecialOffers" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs SpecialOffers" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs SpecialOffers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs SpecialOffers" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs SpecialOffers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs SpecialOffers" exception

Scenario: Copying item Catalogs "Special offer types" (SpecialOfferTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.SpecialOfferTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs SpecialOfferTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs SpecialOfferTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs SpecialOfferTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs SpecialOfferTypes" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs SpecialOfferTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs SpecialOfferTypes" exception

Scenario: Copying item Catalogs "Specifications" (Specifications)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Specifications AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Specifications" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Specifications" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Specifications" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Specifications" exception
				And I save form header as 'ЗаголовокФормы'  variable
			And I close all client application windows
			

Scenario: Copying item Catalogs "Stores" (Stores)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Stores AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Stores" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Stores" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Stores" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Stores" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Stores" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Stores" exception

Scenario: Copying item Catalogs "Tax additional analytics" (TaxAnalytics)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.TaxAnalytics AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs TaxAnalytics" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs TaxAnalytics" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs TaxAnalytics" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs TaxAnalytics" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs TaxAnalytics" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs TaxAnalytics" exception

Scenario: Copying item Catalogs "Tax types" (Taxes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Taxes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Taxes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Taxes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Taxes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Taxes" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Taxes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Taxes" exception

Scenario: Copying item Catalogs "Tax rates" (TaxRates)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.TaxRates AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs TaxRates" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs TaxRates" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs TaxRates" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs TaxRates" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs TaxRates" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs TaxRates" exception


Scenario: Copying item Catalogs "Item units" (Units)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Units AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Units" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Units" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Units" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Units" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Units" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Units" exception

Scenario: Copying item Catalogs "Units of measurement" (UnitsOfMeasurement)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.UnitsOfMeasurement AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs UnitsOfMeasurement" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs UnitsOfMeasurement" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs UnitsOfMeasurement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs UnitsOfMeasurement" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs UnitsOfMeasurement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs UnitsOfMeasurement" exception

Scenario: Copying item Catalogs "User groups" (UserGroups)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.UserGroups AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs UserGroups" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs UserGroups" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs UserGroups" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs UserGroups" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs UserGroups" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs UserGroups" exception


Scenario: Copying item Catalogs "Vehicles" (Vehicles)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Vehicles AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Vehicles" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Vehicles" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Vehicles" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Vehicles" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Vehicles" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Vehicles" exception

Scenario: Copying item Catalogs "Vehicle types" (VehicleTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.VehicleTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs VehicleTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs VehicleTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs VehicleTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs VehicleTypes" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs VehicleTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs VehicleTypes" exception

Scenario: Copying item Catalogs "Workstations" (Workstations)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Workstations AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Workstations" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Workstations" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Workstations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Workstations" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Workstations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Workstations" exception

Scenario: Copying item Catalogs "Incoming messages (IAS)" (гкс_ВходящиеСообщенияRMQ)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.гкс_ВходящиеСообщенияRMQ AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs гкс_ВходящиеСообщенияRMQ" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs гкс_ВходящиеСообщенияRMQ" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs гкс_ВходящиеСообщенияRMQ" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs гкс_ВходящиеСообщенияRMQ" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs гкс_ВходящиеСообщенияRMQ" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs гкс_ВходящиеСообщенияRMQ" exception

Scenario: Copying item Catalogs "Tasks for processing the incoming message queue (IAS)" (гкс_ЗаданияОбработкиОчередиВходящихСообщенийRMQ)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.гкс_ЗаданияОбработкиОчередиВходящихСообщенийRMQ AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs гкс_ЗаданияОбработкиОчередиВходящихСообщенийRMQ" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs гкс_ЗаданияОбработкиОчередиВходящихСообщенийRMQ" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs гкс_ЗаданияОбработкиОчередиВходящихСообщенийRMQ" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs гкс_ЗаданияОбработкиОчередиВходящихСообщенийRMQ" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs гкс_ЗаданияОбработкиОчередиВходящихСообщенийRMQ" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs гкс_ЗаданияОбработкиОчередиВходящихСообщенийRMQ" exception

Scenario: Copying item Catalogs "XDTO data models (IAS)" (гкс_МоделиДанныхXDTO)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.гкс_МоделиДанныхXDTO AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs гкс_МоделиДанныхXDTO" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs гкс_МоделиДанныхXDTO" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs гкс_МоделиДанныхXDTO" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs гкс_МоделиДанныхXDTO" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs гкс_МоделиДанныхXDTO" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs гкс_МоделиДанныхXDTO" exception

Scenario: Copying item Catalogs "Queue for deferred formation of outgoing messages (IAS)" (гкс_ОчередьОтложенногоФормированияИсходящихСообщений)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.гкс_ОчередьОтложенногоФормированияИсходящихСообщений AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs гкс_ОчередьОтложенногоФормированияИсходящихСообщений" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs гкс_ОчередьОтложенногоФормированияИсходящихСообщений" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs гкс_ОчередьОтложенногоФормированияИсходящихСообщений" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs гкс_ОчередьОтложенногоФормированияИсходящихСообщений" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs гкс_ОчередьОтложенногоФормированияИсходящихСообщений" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs гкс_ОчередьОтложенногоФормированияИсходящихСообщений" exception

Scenario: Copying item Catalogs "RMQ data recipients (IAS)" (гкс_ПолучателиДанныхRMQ)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.гкс_ПолучателиДанныхRMQ AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs гкс_ПолучателиДанныхRMQ" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs гкс_ПолучателиДанныхRMQ" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs гкс_ПолучателиДанныхRMQ" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs гкс_ПолучателиДанныхRMQ" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs гкс_ПолучателиДанныхRMQ" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs гкс_ПолучателиДанныхRMQ" exception

Scenario: Copying item Catalogs "Event streams (IAS)" (гкс_ПотокиСобытий)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.гкс_ПотокиСобытий AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs гкс_ПотокиСобытий" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs гкс_ПотокиСобытий" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs гкс_ПотокиСобытий" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs гкс_ПотокиСобытий" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs гкс_ПотокиСобытий" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs гкс_ПотокиСобытий" exception

Scenario: Copying item Catalogs "Custom integration settings (IAS)" (гкс_ПроизвольныеНастройкиИнтеграций)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.гкс_ПроизвольныеНастройкиИнтеграций AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs гкс_ПроизвольныеНастройкиИнтеграций" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs гкс_ПроизвольныеНастройкиИнтеграций" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs гкс_ПроизвольныеНастройкиИнтеграций" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs гкс_ПроизвольныеНастройкиИнтеграций" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs гкс_ПроизвольныеНастройкиИнтеграций" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs гкс_ПроизвольныеНастройкиИнтеграций" exception

Scenario: Copying item Catalogs "Data exchange issue types (IAS)" (гкс_ТипыПроблемОбменаДанными)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.гкс_ТипыПроблемОбменаДанными AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs гкс_ТипыПроблемОбменаДанными" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs гкс_ТипыПроблемОбменаДанными" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs гкс_ТипыПроблемОбменаДанными" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs гкс_ТипыПроблемОбменаДанными" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs гкс_ТипыПроблемОбменаДанными" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs гкс_ТипыПроблемОбменаДанными" exception

Scenario: Copying item Catalogs "RMQ exchange points (IAS)" (гкс_ТочкиОбменаRMQ)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.гкс_ТочкиОбменаRMQ AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs гкс_ТочкиОбменаRMQ" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs гкс_ТочкиОбменаRMQ" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs гкс_ТочкиОбменаRMQ" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs гкс_ТочкиОбменаRMQ" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs гкс_ТочкиОбменаRMQ" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs гкс_ТочкиОбменаRMQ" exception

Scenario: Copying item Catalogs "Exchange participants (IAS)" (гкс_УчастникиОбменаRMQ)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.гкс_УчастникиОбменаRMQ AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs гкс_УчастникиОбменаRMQ" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs гкс_УчастникиОбменаRMQ" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs гкс_УчастникиОбменаRMQ" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs гкс_УчастникиОбменаRMQ" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs гкс_УчастникиОбменаRMQ" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs гкс_УчастникиОбменаRMQ" exception

Scenario: Copying item Catalogs "Exchange message formats (IAS)" (гкс_ФорматыОбменаИАС)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.гкс_ФорматыОбменаИАС AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs гкс_ФорматыОбменаИАС" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs гкс_ФорматыОбменаИАС" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs гкс_ФорматыОбменаИАС" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs гкс_ФорматыОбменаИАС" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs гкс_ФорматыОбменаИАС" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs гкс_ФорматыОбменаИАС" exception

Scenario: Copying item Catalogs "Message sending tasks (IAS)" (ЗаданияОтправкиИсходящихСообщений)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ЗаданияОтправкиИсходящихСообщений AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs ЗаданияОтправкиИсходящихСообщений" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ЗаданияОтправкиИсходящихСообщений" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs ЗаданияОтправкиИсходящихСообщений" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs ЗаданияОтправкиИсходящихСообщений" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs ЗаданияОтправкиИсходящихСообщений" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs ЗаданияОтправкиИсходящихСообщений" exception

Scenario: Copying item Catalogs "Outgoing messages (IAS)" (ИсходящиеСообщения)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ИсходящиеСообщения AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs ИсходящиеСообщения" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ИсходящиеСообщения" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs ИсходящиеСообщения" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs ИсходящиеСообщения" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs ИсходящиеСообщения" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs ИсходящиеСообщения" exception

Scenario: Copying item Catalogs "RMQ event handlers (IAS)" (ОбработчикиСобытийRMQ)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ОбработчикиСобытийRMQ AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs ОбработчикиСобытийRMQ" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ОбработчикиСобытийRMQ" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs ОбработчикиСобытийRMQ" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs ОбработчикиСобытийRMQ" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs ОбработчикиСобытийRMQ" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs ОбработчикиСобытийRMQ" exception

Scenario: Copying item Catalogs "Subscriptions to message queues (IAS)" (ПодпискиНаОчередиСообщений)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ПодпискиНаОчередиСообщений AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs ПодпискиНаОчередиСообщений" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ПодпискиНаОчередиСообщений" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs ПодпискиНаОчередиСообщений" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs ПодпискиНаОчередиСообщений" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs ПодпискиНаОчередиСообщений" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs ПодпискиНаОчередиСообщений" exception

Scenario: Copying item Catalogs "RMQ queue servers (IAS)" (СерверыОчередейRMQ)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.СерверыОчередейRMQ AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs СерверыОчередейRMQ" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs СерверыОчередейRMQ" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs СерверыОчередейRMQ" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs СерверыОчередейRMQ" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs СерверыОчередейRMQ" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs СерверыОчередейRMQ" exception

Scenario: Copying item Catalogs "Simple Catalog" (Тесты_СправочникПростой)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Тесты_СправочникПростой AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Тесты_СправочникПростой" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Тесты_СправочникПростой" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Тесты_СправочникПростой" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Тесты_СправочникПростой" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Тесты_СправочникПростой" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Тесты_СправочникПростой" exception

Scenario: Copying item group Catalogs "Mock service data" (Unit_MockServiceData)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Unit_MockServiceData AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item group Catalogs Unit_MockServiceData" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item group Catalogs Unit_MockServiceData" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item group Catalogs Unit_MockServiceData" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item group Catalogs Unit_MockServiceData" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item group Catalogs Unit_MockServiceData" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item group Catalogs Unit_MockServiceData" exception

Scenario: Copying item Catalogs "Mock service data" (Unit_MockServiceData)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Unit_MockServiceData AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And Not CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item Catalogs Unit_MockServiceData" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Unit_MockServiceData" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Unit_MockServiceData" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Unit_MockServiceData" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Unit_MockServiceData" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Unit_MockServiceData" exception

Scenario: Copying item Catalogs "Service exchange history" (Unit_ServiceExchangeHistory)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Unit_ServiceExchangeHistory AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Unit_ServiceExchangeHistory" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Unit_ServiceExchangeHistory" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Catalogs Unit_ServiceExchangeHistory" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Catalogs Unit_ServiceExchangeHistory" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Catalogs Unit_ServiceExchangeHistory" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Catalogs Unit_ServiceExchangeHistory" exception
