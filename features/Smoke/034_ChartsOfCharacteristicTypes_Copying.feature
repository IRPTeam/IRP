
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Charts of characteristic types - Copying
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows

Scenario: Copying item Charts of characteristic types "Accounting extra dimensions" (AccountingExtraDimensionTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM ChartOfCharacteristicTypes.AccountingExtraDimensionTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Charts of characteristic types AccountingExtraDimensionTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Charts of characteristic types AccountingExtraDimensionTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Charts of characteristic types AccountingExtraDimensionTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Charts of characteristic types AccountingExtraDimensionTypes" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Charts of characteristic types AccountingExtraDimensionTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Charts of characteristic types AccountingExtraDimensionTypes" exception

Scenario: Copying item group Charts of characteristic types "Additional attribute types" (AddAttributeAndProperty)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM ChartOfCharacteristicTypes.AddAttributeAndProperty AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And CurrentDataSource.IsFolder";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item group Charts of characteristic types AddAttributeAndProperty" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item group Charts of characteristic types AddAttributeAndProperty" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item group Charts of characteristic types AddAttributeAndProperty" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item group Charts of characteristic types AddAttributeAndProperty" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item group Charts of characteristic types AddAttributeAndProperty" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item group Charts of characteristic types AddAttributeAndProperty" exception

Scenario: Copying item Charts of characteristic types "Additional attribute types" (AddAttributeAndProperty)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM ChartOfCharacteristicTypes.AddAttributeAndProperty AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And Not CurrentDataSource.IsFolder";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Charts of characteristic types AddAttributeAndProperty" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Charts of characteristic types AddAttributeAndProperty" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Charts of characteristic types AddAttributeAndProperty" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Charts of characteristic types AddAttributeAndProperty" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Charts of characteristic types AddAttributeAndProperty" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Charts of characteristic types AddAttributeAndProperty" exception

Scenario: Copying item Charts of characteristic types "Multi currency movement types" (CurrencyMovementType)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM ChartOfCharacteristicTypes.CurrencyMovementType AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Charts of characteristic types CurrencyMovementType" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Charts of characteristic types CurrencyMovementType" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Charts of characteristic types CurrencyMovementType" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Charts of characteristic types CurrencyMovementType" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Charts of characteristic types CurrencyMovementType" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Charts of characteristic types CurrencyMovementType" exception

Scenario: Copying item Charts of characteristic types "Custom user settings" (CustomUserSettings)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM ChartOfCharacteristicTypes.CustomUserSettings AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Charts of characteristic types CustomUserSettings" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Charts of characteristic types CustomUserSettings" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Charts of characteristic types CustomUserSettings" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Charts of characteristic types CustomUserSettings" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Charts of characteristic types CustomUserSettings" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Charts of characteristic types CustomUserSettings" exception

Scenario: Copying item Charts of characteristic types "Contact info types" (IDInfoTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM ChartOfCharacteristicTypes.IDInfoTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Charts of characteristic types IDInfoTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Charts of characteristic types IDInfoTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Create a new item by copying
			Then '$ЗаголовокФормы$' window is opened
			If 'FormCopy'  attribute is present on the form Then
				And I click the button named 'FormCopy'
				If the warning is displayed then
					Then I raise "Failed to copy an existing item Charts of characteristic types IDInfoTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to copy an existing item Charts of characteristic types IDInfoTypes" exception
				And I save form header as 'ЗаголовокФормы'  variable

		* Save a new item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite'attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save new item Charts of characteristic types IDInfoTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save new item Charts of characteristic types IDInfoTypes" exception
