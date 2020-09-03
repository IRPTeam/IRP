#language: en
@tree
@Positive
@Group1
@Test2

Feature: filling in catalogs Items

              As an owner
              I want to fill out items information
To further use it when reflecting in the program of business processes

        Background:
            Given I open new TestClient session or connect the existing one


# All indivisible packages of the same product are wound up using Specification with type Set. Then a separate Item key is created for the product, in which the necessary set is specified.
# and a price is set on it. It's the Set that's stored on the remains. In order to break it up you need to run the Unbandling document
# For the simple accounting of goods in the packages of documents (the remnants are stored pieces) usedItem units of measurement pcs. For each product, a different Unit is specified
# like pcs consisting of 6 pieces, 10 pieces, etc. # In this case, the price of the order gets as the price of a piece. There's pcs going through the registers, too. 



        Scenario: _005110 filling in the "UI groups" catalog
# Catalog "UI group" is designed to create groups of additional attributes for the items. Also provides for the location of the group on the item's form (right or left)
	* Opening the UI groups creation form 
            Given I open hyperlink "e1cib/list/Catalog.InterfaceGroups"
              And I click the button named "FormCreate"
	* Creating UI groups: Product information, Accounting information, Purchase and production 
              And I click Open button of the field named "Description_en"
              And I input "Product information" text in the field named "Description_en"
              And I input "Product information TR" text in the field named "Description_tr"
              And I click "Ok" button
              And I click "Save and close" button
              And I wait "UI groups (create)" window closing in 5 seconds
              And I click the button named "FormCreate"
              And I click Open button of the field named "Description_en"
              And I input "Accounting information" text in the field named "Description_en"
              And I input "Accounting information TR" text in the field named "Description_tr"
              And I click "Ok" button
              And I change the radio button named "FormPosition" value to "Right"
              And I click "Save and close" button
              And I wait "UI groups (create)" window closing in 5 seconds
              And I click the button named "FormCreate"
              And I click Open button of the field named "Description_en"
              And I input "Purchase and production" text in the field named "Description_en"
              And I input "Purchase and production TR" text in the field named "Description_tr"
              And I click "Ok" button
              And I click "Save and close" button
              And I wait "UI groups (create)" window closing in 5 seconds
	* Check for added UI groups in the catalog 
             Then I check for the "InterfaceGroups" catalog element with the "Description_en" "Product information"
             Then I check for the "InterfaceGroups" catalog element with the "Description_tr" "Product information TR"
             Then I check for the "InterfaceGroups" catalog element with the "Description_en" "Accounting information"
             Then I check for the "InterfaceGroups" catalog element with the "Description_tr" "Accounting information TR"
             Then I check for the "InterfaceGroups" catalog element with the "Description_en" "Purchase and production"
             Then I check for the "InterfaceGroups" catalog element with the "Description_tr" "Purchase and production TR"


        Scenario: _005111 filling in the "Add attribute and property" catalog
	* Opening the Add attribute and property creation form 
            Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
              And I click the button named "FormCreate"
              And Delay 5
	* Creating additional attribute Type
              And I click Choice button of the field named "ValueType"
              And Delay 2
              And I go to line in "*" table
                  | ''       |
                  | 'String' |
              And I click the button named "OK"
              And I click Open button of the field named "Description_en"
              And I input "Type" text in the field named "Description_en"
              And I input "Type TR" text in the field named "Description_tr"
              And I click "Ok" button
              And I click the button named "FormWrite"
              And I input "V123445" text in the field named "UniqueID"
              And I click the button named "FormWriteAndClose"
	* Creating additional attribute Brand
              And I click the button named "FormCreate"
              And Delay 5
              And I click Choice button of the field named "ValueType"
              And Delay 2
              And I go to line in "" table
                  | ''                           |
                  | 'Additional attribute value' |
              And I click the button named "OK"
              And I click Open button of the field named "Description_en"
              And I input "Brand" text in the field named "Description_en"
              And I input "Brand TR" text in the field named "Description_tr"
              And I click "Ok" button
              And I click the button named "FormWrite"
              And I input "V123446" text in the field named "UniqueID"
              And I click the button named "FormWriteAndClose"
	* Creating additional attribute producer 
              And I click the button named "FormCreate"
              And Delay 5
              And I click Choice button of the field named "ValueType"
              And Delay 2
              And I go to line in "" table
                  | ''                           |
                  | 'Additional attribute value' |
              And I click the button named "OK"
              And I click Open button of the field named "Description_en"
              And I input "Producer" text in the field named "Description_en"
              And I input "Producer TR" text in the field named "Description_tr"
              And I click "Ok" button
              And I click the button named "FormWrite"
              And I input "V123447" text in the field named "UniqueID"
              And I click the button named "FormWriteAndClose"
	* Creating additional attribute Size
              And I click the button named "FormCreate"
              And Delay 5
              And I click Choice button of the field named "ValueType"
              And Delay 2
              And I go to line in "" table
                  | ''                           |
                  | 'Additional attribute value' |
              And I click the button named "OK"
              And I click Open button of the field named "Description_en"
              And I input "Size" text in the field named "Description_en"
              And I input "Size TR" text in the field named "Description_tr"
              And I click "Ok" button
              And I click the button named "FormWrite"
              And I input "Size1" text in the field named "UniqueID"
              And I click the button named "FormWriteAndClose"
	* Creating additional attribute Color
              And I click the button named "FormCreate"
              And Delay 5
              And I click Choice button of the field named "ValueType"
              And Delay 2
              And I go to line in "" table
                  | ''                           |
                  | 'Additional attribute value' |
              And I click the button named "OK"
              And I click Open button of the field named "Description_en"
              And I input "Color" text in the field named "Description_en"
              And I input "Color TR" text in the field named "Description_tr"
              And I click "Ok" button
              And I click the button named "FormWrite"
              And I input "Color1" text in the field named "UniqueID"
              And I click the button named "FormWriteAndClose"
	* Creating additional property article
              And I click the button named "FormCreate"
              And Delay 5
              And I click Choice button of the field named "ValueType"
              And Delay 2
              And I go to line in "" table
                  | ''       |
                  | 'String' |
              And I select current line in "" table
              And I click the button named "OK"
              And I click Open button of the field named "Description_en"
              And I input "Article" text in the field named "Description_en"
              And I input "Article TR" text in the field named "Description_tr"
              And I click "Ok" button
              And I click the button named "FormWrite"
              And I input "V123448" text in the field named "UniqueID"
              And I click the button named "FormWriteAndClose"
	* Creating additional property country of consignment
              And I click the button named "FormCreate"
              And Delay 5
              And I click Choice button of the field named "ValueType"
              And Delay 2
              And I go to line in "" table
                  | ''                           |
                  | 'Additional attribute value' |
              And I click the button named "OK"
              And I click Open button of the field named "Description_en"
              And I input "Country of consignment" text in the field named "Description_en"
              And I input "Country of consignment TR" text in the field named "Description_tr"
              And I click "Ok" button
              And I click the button named "FormWrite"
              And I input "V123449" text in the field named "UniqueID"
              And I click the button named "FormWriteAndClose"
	* Creating additional property season
              And I click the button named "FormCreate"
              And Delay 5
              And I click Choice button of the field named "ValueType"
              And Delay 2
              And I go to line in "" table
                  | ''                           |
                  | 'Additional attribute value' |
              And I click the button named "OK"
              And I click Open button of the field named "Description_en"
              And I input "Season" text in the field named "Description_en"
              And I input "Season TR" text in the field named "Description_tr"
              And I click "Ok" button
              And I click the button named "FormWrite"
              And I input "V123450" text in the field named "UniqueID"
              And I click the button named "FormWriteAndClose"
              And I wait "Add attribute and property (create) *" window closing in 20 seconds