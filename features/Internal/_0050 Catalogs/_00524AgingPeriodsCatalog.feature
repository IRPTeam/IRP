#language: en
@tree
@Positive
@CompanyCatalogs

Feature: filling in Aging periods catalog

As an owner
I want the aging buckets to be validated when I describe them
To be sure that customers and vendors debts are split without gaps and overlaps

Background:
	Given I open new TestClient session or connect the existing one


Scenario: _005240 filling in the "Aging periods" catalog
	When set True value to the constant
	And I close all client application windows
	* Create an element with correct overdue and future periods
		Given I open hyperlink "e1cib/list/Catalog.AgingPeriods"
		And I click the button named "FormCreate"
		And I input "Standard buckets" text in the field named "Description_en"
		And I click the button named "OverduePeriodsAdd"
		And I input "1" text in the field named "OverduePeriodsFromDays"
		And I input "30" text in the field named "OverduePeriodsToDays"
		And I click the button named "OverduePeriodsAdd"
		And I input "31" text in the field named "OverduePeriodsFromDays"
		And I input "60" text in the field named "OverduePeriodsToDays"
		And I click the button named "OverduePeriodsAdd"
		And I input "61" text in the field named "OverduePeriodsFromDays"
		And I input "0" text in the field named "OverduePeriodsToDays"
		And I click the button named "FuturePeriodsAdd"
		And I input "0" text in the field named "FuturePeriodsFromDays"
		And I input "7" text in the field named "FuturePeriodsToDays"
		And I click the button named "FuturePeriodsAdd"
		And I input "8" text in the field named "FuturePeriodsFromDays"
		And I input "0" text in the field named "FuturePeriodsToDays"
		And I click "Save and close" button
	* The element is saved with both tabular sections
		And I go to line in "List" table
			| 'Description'      |
			| 'Standard buckets' |
		And I select current line in "List" table
		Then "OverduePeriods" table became equal
			| '#' | 'From days' | 'To days' |
			| '1' | '1'         | '30'      |
			| '2' | '31'        | '60'      |
			| '3' | '61'        | ''        |
		And "FuturePeriods" table became equal
			| '#' | 'From days' | 'To days' |
			| '1' | ''          | '7'       |
			| '2' | '8'         | ''        |
	And I close all client application windows


Scenario: _005241 check preparation
	When check preparation


Scenario: _005242 check overlap of the previous period is rejected
	And I close all client application windows
	* Second period starts before the previous one ends
		Given I open hyperlink "e1cib/list/Catalog.AgingPeriods"
		And I click the button named "FormCreate"
		And I input "Overlap check" text in the field named "Description_en"
		And I click the button named "OverduePeriodsAdd"
		And I input "1" text in the field named "OverduePeriodsFromDays"
		And I input "30" text in the field named "OverduePeriodsToDays"
		And I click the button named "OverduePeriodsAdd"
		And I input "30" text in the field named "OverduePeriodsFromDays"
		And I input "60" text in the field named "OverduePeriodsToDays"
		And I click the button named "OverduePeriodsAdd"
		And I input "61" text in the field named "OverduePeriodsFromDays"
		And I input "0" text in the field named "OverduePeriodsToDays"
		And I click "Save" button
	* Overlap is reported
		Then I wait that in user messages the "Overlap with the previous period was detected" substring will appear in 5 seconds
	And I close all client application windows


Scenario: _005243 check gap with the previous period is rejected
	And I close all client application windows
	* Second period starts two days after the previous one ends
		Given I open hyperlink "e1cib/list/Catalog.AgingPeriods"
		And I click the button named "FormCreate"
		And I input "Gap check" text in the field named "Description_en"
		And I click the button named "OverduePeriodsAdd"
		And I input "1" text in the field named "OverduePeriodsFromDays"
		And I input "30" text in the field named "OverduePeriodsToDays"
		And I click the button named "OverduePeriodsAdd"
		And I input "32" text in the field named "OverduePeriodsFromDays"
		And I input "0" text in the field named "OverduePeriodsToDays"
		And I click "Save" button
	* Gap is reported
		Then I wait that in user messages the "Gap with the previous period was detected" substring will appear in 5 seconds
	And I close all client application windows


Scenario: _005244 check from days greater than to days is rejected
	And I close all client application windows
	* A middle period is reversed
		Given I open hyperlink "e1cib/list/Catalog.AgingPeriods"
		And I click the button named "FormCreate"
		And I input "Reversed range check" text in the field named "Description_en"
		And I click the button named "OverduePeriodsAdd"
		And I input "1" text in the field named "OverduePeriodsFromDays"
		And I input "49" text in the field named "OverduePeriodsToDays"
		And I click the button named "OverduePeriodsAdd"
		And I input "50" text in the field named "OverduePeriodsFromDays"
		And I input "40" text in the field named "OverduePeriodsToDays"
		And I click the button named "OverduePeriodsAdd"
		And I input "51" text in the field named "OverduePeriodsFromDays"
		And I input "0" text in the field named "OverduePeriodsToDays"
		And I click "Save" button
	* The reversed range is reported with both numbers
		Then I wait that in user messages the "From days [50] more than to days[40]" substring will appear in 5 seconds
	And I close all client application windows


Scenario: _005245 check the last period must end with zero
	And I close all client application windows
	* The last period has a finite end
		Given I open hyperlink "e1cib/list/Catalog.AgingPeriods"
		And I click the button named "FormCreate"
		And I input "Last line check" text in the field named "Description_en"
		And I click the button named "OverduePeriodsAdd"
		And I input "1" text in the field named "OverduePeriodsFromDays"
		And I input "30" text in the field named "OverduePeriodsToDays"
		And I click the button named "OverduePeriodsAdd"
		And I input "31" text in the field named "OverduePeriodsFromDays"
		And I input "60" text in the field named "OverduePeriodsToDays"
		And I click "Save" button
	* The open ended last period is required
		Then I wait that in user messages the "Last line should contain 0 in to days" substring will appear in 5 seconds
	And I close all client application windows


Scenario: _005246 check a period with both bounds equal to zero is rejected
	And I close all client application windows
	* The only period is 0 - 0
		Given I open hyperlink "e1cib/list/Catalog.AgingPeriods"
		And I click the button named "FormCreate"
		And I input "Zero bounds check" text in the field named "Description_en"
		And I click the button named "OverduePeriodsAdd"
		And I input "0" text in the field named "OverduePeriodsFromDays"
		And I input "0" text in the field named "OverduePeriodsToDays"
		And I click "Save" button
	* Zero bounds are reported
		Then I wait that in user messages the "From days and to days cannot be equal to zero" substring will appear in 5 seconds
	And I close all client application windows


Scenario: _005247 check a period with equal bounds is rejected
	And I close all client application windows
	* A one day bucket
		Given I open hyperlink "e1cib/list/Catalog.AgingPeriods"
		And I click the button named "FormCreate"
		And I input "Equal bounds check" text in the field named "Description_en"
		And I click the button named "OverduePeriodsAdd"
		And I input "5" text in the field named "OverduePeriodsFromDays"
		And I input "5" text in the field named "OverduePeriodsToDays"
		And I click the button named "OverduePeriodsAdd"
		And I input "6" text in the field named "OverduePeriodsFromDays"
		And I input "0" text in the field named "OverduePeriodsToDays"
		And I click "Save" button
	* Equal bounds are reported
		Then I wait that in user messages the "From days and to days cannot be equal" substring will appear in 5 seconds
	And I close all client application windows


Scenario: _005248 check the future periods are validated as well
	And I close all client application windows
	* Overdue periods are correct, future periods overlap
		Given I open hyperlink "e1cib/list/Catalog.AgingPeriods"
		And I click the button named "FormCreate"
		And I input "Future validation check" text in the field named "Description_en"
		And I click the button named "OverduePeriodsAdd"
		And I input "1" text in the field named "OverduePeriodsFromDays"
		And I input "0" text in the field named "OverduePeriodsToDays"
		And I click the button named "FuturePeriodsAdd"
		And I input "0" text in the field named "FuturePeriodsFromDays"
		And I input "7" text in the field named "FuturePeriodsToDays"
		And I click the button named "FuturePeriodsAdd"
		And I input "7" text in the field named "FuturePeriodsFromDays"
		And I input "0" text in the field named "FuturePeriodsToDays"
		And I click "Save" button
	* Overlap in the future periods is reported
		Then I wait that in user messages the "Overlap with the previous period was detected" substring will appear in 5 seconds
	And I close all client application windows


Scenario: _005249 check an element with only overdue periods is saved
	And I close all client application windows
	* Future periods are left empty on purpose
		Given I open hyperlink "e1cib/list/Catalog.AgingPeriods"
		And I click the button named "FormCreate"
		And I input "Overdue only" text in the field named "Description_en"
		And I click the button named "OverduePeriodsAdd"
		And I input "1" text in the field named "OverduePeriodsFromDays"
		And I input "0" text in the field named "OverduePeriodsToDays"
		And I click "Save and close" button
	* An empty tabular section does not break the validation
		And I go to line in "List" table
			| 'Description'  |
			| 'Overdue only' |
		And I select current line in "List" table
		Then the number of "FuturePeriods" table lines is "равно" "0"
	And I close all client application windows


Scenario: _005250 check the first overdue period must start from the first day
	And I close all client application windows
	* The first period starts from day 10, so debts overdue by 1 - 9 days belong to no bucket
		Given I open hyperlink "e1cib/list/Catalog.AgingPeriods"
		And I click the button named "FormCreate"
		And I input "Head gap check" text in the field named "Description_en"
		And I click the button named "OverduePeriodsAdd"
		And I input "10" text in the field named "OverduePeriodsFromDays"
		And I input "30" text in the field named "OverduePeriodsToDays"
		And I click the button named "OverduePeriodsAdd"
		And I input "31" text in the field named "OverduePeriodsFromDays"
		And I input "0" text in the field named "OverduePeriodsToDays"
		And I click "Save" button
	* The uncovered head of the range has to be reported
		Then I wait that in user messages the "Gap with the previous period was detected" substring will appear in 5 seconds
	And I close all client application windows


Scenario: _005251 check day zero cannot belong to both overdue and future periods
	And I close all client application windows
	* Both tabular sections start from day 0, so a document due today falls into two buckets
		Given I open hyperlink "e1cib/list/Catalog.AgingPeriods"
		And I click the button named "FormCreate"
		And I input "Day zero check" text in the field named "Description_en"
		And I click the button named "OverduePeriodsAdd"
		And I input "0" text in the field named "OverduePeriodsFromDays"
		And I input "30" text in the field named "OverduePeriodsToDays"
		And I click the button named "OverduePeriodsAdd"
		And I input "31" text in the field named "OverduePeriodsFromDays"
		And I input "0" text in the field named "OverduePeriodsToDays"
		And I click the button named "FuturePeriodsAdd"
		And I input "0" text in the field named "FuturePeriodsFromDays"
		And I input "7" text in the field named "FuturePeriodsToDays"
		And I click the button named "FuturePeriodsAdd"
		And I input "8" text in the field named "FuturePeriodsFromDays"
		And I input "0" text in the field named "FuturePeriodsToDays"
		And I click "Save" button
	* The overlap between the two tabular sections has to be reported
		Then I wait that in user messages the "cannot" substring will appear in 5 seconds
	And I close all client application windows
