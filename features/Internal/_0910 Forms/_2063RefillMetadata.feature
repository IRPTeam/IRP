#language: en
@tree
@Positive
@Forms
Feature: refill Configuration metadata keeps settings

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _206300 preparation
	* Auto filling Configuration metadata catalog
		When auto filling Configuration metadata catalog
	* Create test bank term
		Given I open hyperlink "e1cib/list/Catalog.BankTerms"
		If "List" table does not contain lines Then
			| 'Description'    |
			| 'RefillT01'      |
			And I click the button named "FormCreate"
			And I click Open button of "ENG" field
			And I input "RefillT01" text in "RU" field
			And I input "RefillT01" text in "TR" field
			And I input "RefillT01" text in "ENG" field
			And I click "Ok" button
			And I click "Save and close" button
			And "List" table contains lines
				| 'Description'     |
				| 'RefillT01'       |
		And I close all client application windows
	* Set settings on Bank terms metadata item
		Given I open hyperlink "e1cib/list/Catalog.ConfigurationMetadata"
		And I click "List" button
		And I go to line in "List" table
			| 'Description'    |
			| 'Bank terms'     |
		And I select current line in "List" table
		And I set checkbox "Check description duplicate"
		And I move to "Attributes" tab
		And I go to line in "AttributesTree" table
			| 'Description'    |
			| 'Percent'        |
		And I set "Hidden" checkbox in "AttributesTree" table
		And I finish line editing in "AttributesTree" table
		And I click "Save and close" button
		And I close all client application windows

Scenario: _2063001 check preparation
	When check preparation

# IRP-884: repeated "Refill metadata" used to mark all catalog items Unused,
# so their settings silently stopped applying. With the fix a second refill
# must not touch active items at all.
Scenario: _206301 check repeated Refill metadata preserves Configuration metadata settings
	And I close all client application windows
	* Refill metadata again
		When auto filling Configuration metadata catalog
	* Check settings survived on Bank terms item
		Given I open hyperlink "e1cib/list/Catalog.ConfigurationMetadata"
		And I click "List" button
		And I go to line in "List" table
			| 'Description'    |
			| 'Bank terms'     |
		And I select current line in "List" table
		Then the form attribute named "CheckDescriptionDuplicate" became equal to "Yes"
		Then the form attribute named "Unused" became equal to "No"
		And I move to "Attributes" tab
		And "AttributesTree" table contains lines
			| 'Description'  | 'Hidden' |
			| 'Percent'      | 'Yes'    |
		And I close all client application windows
	* Check duplicate control still works after refill
		Given I open hyperlink "e1cib/list/Catalog.BankTerms"
		And I click the button named "FormCreate"
		And I input "RefillT01" text in "ENG" field
		And I click "Save and close" button
		Then I wait that in user messages the 'Description (en) "RefillT01" is already in use.' substring will appear in "10" seconds
		And I close all client application windows

# IRP-884: an item wrongly marked Unused must be restored by Refill metadata
# (Unused = False) and its settings must stay intact.
Scenario: _206302 check Refill metadata restores Unused Configuration metadata item
	And I close all client application windows
	* Mark Bank terms metadata item as Unused
		Given I open hyperlink "e1cib/list/Catalog.ConfigurationMetadata"
		And I click "List" button
		And I go to line in "List" table
			| 'Description'    |
			| 'Bank terms'     |
		And I select current line in "List" table
		And I set checkbox "Unused"
		And I click "Save and close" button
		And I close all client application windows
	* Refill metadata
		When auto filling Configuration metadata catalog
	* Check item restored
		Given I open hyperlink "e1cib/list/Catalog.ConfigurationMetadata"
		And I click "List" button
		And I go to line in "List" table
			| 'Description'    |
			| 'Bank terms'     |
		And I select current line in "List" table
		Then the form attribute named "Unused" became equal to "No"
		Then the form attribute named "CheckDescriptionDuplicate" became equal to "Yes"
		And I close all client application windows
